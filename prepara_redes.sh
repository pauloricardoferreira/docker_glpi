#!/bin/bash

LISTA_REDES="glpi"

echo "======================="
echo "=== CRIANDO REDES ==="
echo "======================="


for i in $LISTA_REDES
do
    echo "CRIANDO REDE: $i"
    docker network create $i > /dev/null 2>&1
done

echo "******************************"
echo "*** FINALIZANDO PREPARAÇÃO ***"
echo "******************************"