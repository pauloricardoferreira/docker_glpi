#!/bin/sh


#Docs#
#GLPI# #https://glpi-project.org/pt-br/baixar/#
#FusionAgent# #https://documentation.fusioninventory.org/FusionInventory_agent/installation/source/#
#Docker GPLI# #https://www.aprendendolinux.com/implantando-o-glpi-em-2-minutos-com-o-docker/#
#Docker Githubhub GLPI# #https://github.com/AprendendoLinux/glpi#


VERSAO_FUSION=2.6
NOME_FUSION=fusioninventory-agent 
URL_BASE=https://github.com/fusioninventory/fusioninventory-agent/releases/download/$VERSAO_FUSION/


LISTA_PKG="$NOME_FUSION"_"$VERSAO_FUSION-1_all.deb $NOME_FUSION-task-collect_$VERSAO_FUSION-1_all.deb $NOME_FUSION-task-deploy_$VERSAO_FUSION-1_all.deb $NOME_FUSION-task-esx_$VERSAO_FUSION-1_all.deb $NOME_FUSION-task-network_$VERSAO_FUSION-1_all.deb"

download_arquivos(){
    for i in $LISTA_PKG
    do
        echo "Baixando Package $i"
        wget $URL_BASE$i -O /tmp/$i
    done
}

instalar_dependencias(){

    echo "Instalando Dependencias"

    apt -y install dmidecode hwdata ucf hdparm
    apt -y install perl libuniversal-require-perl libwww-perl libparse-edid-perl
    apt -y install libproc-daemon-perl libfile-which-perl libhttp-daemon-perl
    apt -y install libxml-treepp-perl libyaml-perl libnet-cups-perl libnet-ip-perl
    apt -y install libdigest-sha-perl libsocket-getaddrinfo-perl libtext-template-perl
    apt -y install libxml-xpath-perl libyaml-tiny-perl

    apt -y install libnet-snmp-perl libcrypt-des-perl libnet-nbname-perl

    apt -y install libdigest-hmac-perl

    apt -y install libfile-copy-recursive-perl libparallel-forkmanager-perl
}

instalar_agente(){

    for i in $LISTA_PKG
    do
        echo "Instalando Pacote $i"
        dpkg -i /tmp/$i
    done
}

#Original# = #server = http://server.domain.com/glpi/plugins/fusioninventory/
configurar_servico(){

    echo "server = http://localhost/plugins/fusioninventory/" > /etc/fusioninventory/conf.d/01_server.cfg
    echo "local = /tmp" >> /etc/fusioninventory/conf.d/01_server.cfg

    # CONFIG_ATUAL='#server = http:\/\/server.domain.com\/glpi\/plugins\/fusioninventory\/'
    # CONFIG_NOVO='server = http:\/\/localhost\/glpi\/plugins\/fusioninventory\/'

    # sudo sed -i "s/$CONFIG_ATUAL/$CONFIG_NOVO/i" /etc/fusioninventory/agent.cfg


    #Recarrega as configurações
    systemctl reload fusioninventory-agent

    #Reiniciar o processo
    systemctl restart fusioninventory-agent

    echo "Para forçar o primeiro envio execute o comando abaixo como Admonistrador"
    echo "sudo pkill -USR1 -f -P 1 fusioninventory-agent"

}

echo "Iniciando Configuração Fusioninventoy Agent para GLPI"
download_arquivos
instalar_dependencias
instalar_agente
configurar_servico

echo "Finalizando Configuração"