#!/bin/bash

  
LISTA_VOLUMES="glpi_config glpi_documents glpi_plugins glpi_marketplace glpi_files_plugins glpi_backup glpi_db_log glpi_db_lib"


echo "======================="
echo "=== CRIANDO VOLUMES ==="
echo "======================="


for i in $LISTA_VOLUMES
do
    echo "CRIANDO VOLUME: $i"
    docker volume create $i > /dev/null 2>&1
done


echo "******************************"
echo "*** FINALIZANDO PREPARAÇÃO ***"
echo "******************************"