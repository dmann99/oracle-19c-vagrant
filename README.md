# oracle-19-beta-vagrant
A vagrant box that provisions Oracle Database 19 Beta automatically, using Vagrant, the latest Oracle Linux 7 box and shell scripts. 

## Prerequisites
1. Install [Oracle VM VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](https://vagrantup.com/)

## Getting started
1. Clone this repository `git clone https://github.com/dmann99/oracle-19-beta-vagrant`
2. Change into version folder (19)
3. First time only (see #5): Download the Oracle Database 19 Beta binaries to this folder. 191000_Beta1_Linux-x86-64_db_home.zip
4. Run `vagrant up`
5. The first time you run this it will provision everything and may take a while. Ensure you have a good internet connection!
6. Connect to the database.
7. You can shut down the box via the usual `vagrant halt` and the start it up again via `vagrant up`.

## Connecting to Oracle
* Hostname: `localhost`
* Port: `1521`
* SID: `ORCLCDB`
* PDB: `ORCLPDB1`
* OEM port: `5500`
* All passwords are `password`

## Acknowledgements
Based on @dmann99's work here: https://github.com/dmann99/oracle-18c-vagrant
Based on @totalamateurhour's work here: https://github.com/totalamateurhour/oracle12.2-vagrant
Based on @steveswinsburg's work here: https://github.com/steveswinsburg/oracle12c-vagrant

## Other info

* If you need to, you can connect to the machine via `vagrant ssh`.
* You can `sudo su - oracle` to switch to the oracle user.
* The Oracle installation path is `/opt/oracle/` by default.
* On the guest OS, the directory `/vagrant` is a shared folder and maps to wherever you have this file checked out.

### Customization
You can customize your Oracle environment by amending the environment variables in the `Vagrantfile` file.
The following can be customized:
* `ORACLE_BASE`: `/opt/oracle/`
* `ORACLE_HOME`: `/opt/oracle/product/19.0.0/dbhome_1`
* `ORACLE_SID`: `ORCLCDB`
* `ORACLE_PDB`: `ORCLPDB1`
* `ORACLE_CHARACTERSET`: `AL32UTF8`

## Known issues
None.
