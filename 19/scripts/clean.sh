$!/bin/bash

$ORACLE_HOME/oui/bin/runInstaller -silent -detachHome ORACLE_HOME=$ORACLE_HOME -waitforcompletion

rm -rf /opt/oraInventory/*

