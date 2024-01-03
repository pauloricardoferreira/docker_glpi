# GLPI com Docker

<br>

## Documentação Oficial

- GLPI

  [Documentação Oficial](https://glpi-project.org/pt-br/documentacao/)

  [Git Hub GLPI](https://github.com/glpi-project/glpi)

  [Service Desk Brasil - Docker Hub GLPI](https://hub.docker.com/r/sdbrasil/glpi)

  [Servide Desk Brasil - Blog](https://blog.servicedeskbrasil.com.br/)

- Fusion Agent

  [Documentação Agente Fusion Inventory Linux](https://documentation.fusioninventory.org/FusionInventory_agent/installation/linux/deb/)

  [Documentação Agente Fusion Inventory Windows](https://documentation.fusioninventory.org/FusionInventory_agent/installation/windows/)

- Plugins
  
  [Git Hub Fusion Inventory](https://github.com/fusioninventory/fusioninventory-for-glpi)
  
  [Git Hub Fusion Inventory - Versões](https://github.com/fusioninventory/fusioninventory-for-glpi/releases)


## Instalação

- Antes de realizar o procedimento, certifiquese de que o Docker e Docker Compose esteja instalado na máquina e também as configurações dos arquivos abaixo


## Arquivos

- <b> docker-compose.yml ¹</b> -> Arquivo com o serviços GLPI e GLPIDB (Servidor MySql com Percona)
- <b> prepara_redes.sh </b> -> Cria a Rede Docker utilizado no projeto
- <b> prepara_volumes </b> -> Cria os Volumes Docker utilizado no projeto
- <b> plugins.sh ²</b> -> Baixa e Extrai os Plugins no volumne glpi_plugins
- <b> fusion_agent_linux.sh ³</b> -> Configura o Agente Fusion Inventory para Linux

<br>

## Ajustes Iniciais 

1 - <b> docker-compose.yml </b> 
<br>
Verificar as configuraões do Banco de Dados e Imagens

```yaml
    
    image: sdbrasil/glpi:10.0.11

    volumes:
      - glpi_config:/etc/glpi
      - glpi_documents:/var/lib/glpi/files/data-documents
      - glpi_plugins:/usr/share/glpi/plugins
      - glpi_marketplace:/usr/share/glpi/marketplace
      - glpi_files_plugins:/var/lib/glpi/files/_plugins
      - glpi_backup:/backup

    ----------------------------------

    image: percona/percona-server:8.0
    
    volumes:
      - glpi_db_log:/var/log/mysql
      - glpi_db_lib:/var/lib/mysql

    environment:
      - MYSQL_ROOT_PASSWORD=ADM@MySQL_GLP1
      - MYSQL_DATABASE=glpi
      - MYSQL_USER=glpi
      - MYSQL_PASSWORD=GLP1_MySQL@10

```

2 - <b> plugins.sh </b>
Para cada plugin, deve ser criado um procedimento de instalação e configuração caso necessário

Fusion Inventory Plugin -> Para cada versão do Plugin ha uma versão mínima e máxima suportada do GLPI que já esta documentada no arquivo <b> plugins.sh </b>, e deve ser ajustada a cada nova versão do GLPI 

3 - <b> fusion_agent_linux.sh </b>

Antes de executar, é necessário verificar a versão disponível e alterar a variavel `VERSAO_FUSUSION`

É possível verificar a versão em [Fusion Agent Versão](https://github.com/fusioninventory/fusioninventory-agent/releases).

A Atual é a versão 2.6


## Sequencia de Instalação

```bash
sh prepara.sh
sh prepara_volumes.sh
sh plugins.sh
docker compose up -d
sudo sh fusion_agent_linux
```

## Configuração Inicial do GLPI

Após a instalação e a inicialização do serviços, execute o comando abaixo para que seja realizada a instação do GLPI

Acesso o container com o comando abaixo
```bash
docker exec -it glpi-10 /bin/bash
```


Após acessar, execute o comando abaixo para que seja realizada a instalação e configuração inicial do GLPI
```bash
glpi-console glpi:database:install -L pt_BR -Hdb-glpi-10 -dglpi -uglpi -pGLP1_MySQL@10 --no-telemetry --force -n && mv /usr/share/glpi/install /usr/share/glpi/install_ori && rm -rf /var/log/glpi/* && chown -R apache:apache /usr/share/glpi/marketplace/ && chown -R apache:apache /var/lib/glpi/files && chown -R apache:apache /var/log/glpi && chown -R apache:apache /var/lib/glpi/files/data-documents
```

## Finalização

Após a reliação dos procedimentos, o GLPI deve estar disponivel no IP ou Nome do Domínio
