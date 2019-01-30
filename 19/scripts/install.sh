#!/usr/bin/sh

echo 'INSTALLER: Start'
STARTDATE=`date`
echo ''

# get up to date
#echo 'INSTALLER: Yum Upgrade All'
#yum upgrade -y
#yum reinstall -y glibc-common
echo ''


# fix locale warning
echo 'INSTALLER: Fix Locale Warning'
echo LANG=en_US.utf-8 >> /etc/environment
echo LC_ALL=en_US.utf-8 >> /etc/environment
echo 'INSTALLER: Locale set'
echo ''

# install Oracle Database prereq packages
echo 'INSTALLER: Oracle preinstall started...'
yum install dejavu-serif-fonts
yum install -y oracle-database-preinstall-18c
echo 'INSTALLER: Oracle preinstall complete'
echo ''

# set environment variables
echo 'INSTALLER: Environment variables set in .bashrc start'
echo "export ORACLE_BASE=$ORACLE_BASE" >> /home/oracle/.bashrc && \
echo "export ORACLE_HOME=$ORACLE_HOME" >> /home/oracle/.bashrc && \
echo "export ORACLE_SID=$ORACLE_SID" >> /home/oracle/.bashrc   && \
echo "export PATH=\$PATH:\$ORACLE_HOME/bin" >> /home/oracle/.bashrc
echo 'INSTALLER: Environment variables set complete'
echo ''

echo 'INSTALLER: Oracle directory creation start'
mkdir -p $ORACLE_BASE
chown oracle:oinstall -R $ORACLE_BASE
mkdir -p $ORACLE_HOME
chown oracle:oinstall -R $ORACLE_HOME
mkdir -p $ORACLE_BASE/oraInventory
chown oracle:oinstall -R $ORACLE_BASE/oraInventory
mkdir -p $ORACLE_BASE/oradata
chown oracle:oinstall -R $ORACLE_BASE/oradata
#usermod -g dba oracle

# Unzip Install Package
echo 'INSTALLER: Unzip Installation Package'
su -l oracle -c 'unzip /vagrant/19*.zip -d ${ORACLE_HOME}'

echo 'INSTALLER: Oracle software install start'
su -l oracle -c "/vagrant/scripts/go-dbinstall.sh"

$ORACLE_BASE/oraInventory/orainstRoot.sh
$ORACLE_HOME/root.sh

echo 'INSTALLER: Create CDB/PDB Start'
su -l oracle -c "/vagrant/scripts/go-dbcreate.sh"
echo 'INSTALLER: Create CDB/PDB Complete'

echo 'INSTALLER: Create Listener Start'
su -l oracle -c "netca -silent -responseFile /vagrant/ora-response/netca_typ.rsp"
echo 'INSTALLER: Create Listener Complete'

echo 'INSTALLER: Installation complete, check for errors, database should be ready to use!'
echo Start Time  : $STARTDATE
echo Finish Time : `date`
