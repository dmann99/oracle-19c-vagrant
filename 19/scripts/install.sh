#!/usr/bin/sh

echo 'INSTALLER: Start'
STARTDATE=`date`
echo ''

# Get VM packages up to date
echo 'INSTALLER: Yum Upgrade All'
yum upgrade -y
echo ''


# fix locale warning
echo 'INSTALLER: Fix Locale Warning'
echo LANG=en_US.utf-8 >> /etc/environment
echo LC_ALL=en_US.utf-8 >> /etc/environment
echo ''

# install Oracle Database prereq packages
echo 'INSTALLER: Oracle preinstall .RPMs'
yum install dejavu-serif-fonts
yum install -y oracle-database-preinstall-18c
echo ''

# set environment variables
echo 'INSTALLER: Environment variables set in .bashrc'
echo "export ORACLE_BASE=$ORACLE_BASE" >> /home/oracle/.bashrc && \
echo "export ORACLE_HOME=$ORACLE_HOME" >> /home/oracle/.bashrc && \
echo "export ORACLE_SID=$ORACLE_SID" >> /home/oracle/.bashrc   && \
echo "export PATH=\$PATH:\$ORACLE_HOME/bin" >> /home/oracle/.bashrc
echo ''

echo 'INSTALLER: Oracle directory creation'
mkdir -p $ORACLE_BASE
chown oracle:oinstall -R $ORACLE_BASE
mkdir -p $ORACLE_HOME
chown oracle:oinstall -R $ORACLE_HOME
mkdir -p $ORACLE_INVENTORY
chown oracle:oinstall -R $ORACLE_INVENTORY
mkdir -p $ORACLE_BASE/oradata
chown oracle:oinstall -R $ORACLE_BASE/oradata
#usermod -g dba oracle
echo ''

# Extend Swap Space using /dev/sdb extra disk supplied with the VM
echo 'INSTALLER: Increasing Swap Space'
sfdisk /dev/sdb < /vagrant/scripts/sdb.layout
pvcreate /dev/sdb1
vgextend vg_main /dev/sdb1
lvextend /dev/vg_main/lv_swap /dev/sdb1
swapoff -v /dev/vg_main/lv_swap
mkswap /dev/vg_main/lv_swap
swapon -va
swapon -s
echo ''

# Unzip Install Package
echo 'INSTALLER: Unzip Installation Package'
su -l oracle -c 'unzip /vagrant/V978967*.zip -d ${ORACLE_HOME}'
su -l oracle -c 'unzip /vagrant/LINUX*18*.zip -d ${ORACLE_HOME}'
echo ''

echo 'INSTALLER: Oracle software install'
su -l oracle -c "/vagrant/scripts/go-dbinstall.sh"
$ORACLE_INVENTORY/orainstRoot.sh
$ORACLE_HOME/root.sh
echo ''

echo 'INSTALLER: Create CDB/PDB'
su -l oracle -c "/vagrant/scripts/go-dbcreate.sh"
su -l oracle -c "sqlplus / as sysdba <<EOF
   ALTER PLUGGABLE DATABASE $ORACLE_PDB SAVE STATE;
   exit;
EOF"
echo ''

echo 'INSTALLER: Create Listener'
echo 'INSTALLER: Listener install start'
su -l oracle -c "netca -silent -responseFile /vagrant/ora-response/netca_typ.rsp"
echo ''


echo 'INSTALLER: Oratab configure /etc/oratab'
sed '$s/N/Y/' /etc/oratab | sudo tee /etc/oratab > /dev/null

## configure systemd to start oracle instance on startup
#sudo cp /vagrant/scripts/oracle-rdbms.service /etc/systemd/system/
#sudo sed -i -e "s|###ORACLE_HOME###|$ORACLE_HOME|g" /etc/systemd/system/oracle-rdbms.service
#sudo systemctl daemon-reload
#sudo systemctl enable oracle-rdbms
#sudo systemctl start oracle-rdbms
#echo "INSTALLER: Created and enabled oracle-rdbms systemd's service"

echo 'INSTALLER: Installation complete'
echo Start Time  : $STARTDATE
echo Finish Time : `date`
