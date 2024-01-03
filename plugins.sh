#!/bin/sh

#Função para o Plugin Fusion Invnetory
fusion_inventory_plugin(){
    FUSION_INVENTORY=https://github.com/fusioninventory/fusioninventory-for-glpi/releases/download/glpi10.0.6%2B1.1/fusioninventory-10.0.6+1.1.zip

    echo "Baixando Plugin"
    wget $FUSION_INVENTORY -O /tmp/FUSION_PLUGIN.zip

    echo "Descompactando Plugin"
    sudo unzip -of /tmp/FUSION_PLUGIN.zip -d /var/lib/docker/volumes/glpi_plugins/_data/

    # para a versão atual do plugin, a versão máxima suportada do GLPI é 10.0.6
    # por este motivo é necessário o ajuste no arquivo de configuração do plugin
    # é alterado a versão máxima para algumas versões acima
    # pode ser que não fincione, e por este motivo é necessário realizar testes
    VER_MAX_GLPI_ATUAL="define('PLUGIN_FUSIONINVENTORY_GLPI_MAX_VERSION', .*"
    VER_MAX_GLPI_NOVO="define('PLUGIN_FUSIONINVENTORY_GLPI_MAX_VERSION', '10.0.12');"

    echo "Alterando a Versão Máxima Suportada"
    sudo sed -i "s/$VER_MAX_GLPI_ATUAL/$VER_MAX_GLPI_NOVO/g" /var/lib/docker/volumes/glpi_plugins/_data/fusioninventory/setup.php 
}

fusion_inventory_plugin