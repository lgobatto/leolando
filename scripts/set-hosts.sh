#!/bin/bash

# Definição de cores para mensagens
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
RESET='\033[0m'

echo -e "${BLUE}🔹 Configurando o arquivo /etc/hosts para acesso local ao projeto...${RESET}"

# Define o domínio baseado no nome do projeto no Lando
PROJECT_NAME=$(basename "$(pwd)")
DEFAULT_DOMAIN="${PROJECT_DOMAIN}"

# Pergunta ao usuário se deseja alterar o domínio
read -p "🔹 Domínio padrão detectado: ${DEFAULT_DOMAIN}. Deseja usar outro domínio? (s/N) " change_domain
if [[ "$change_domain" =~ ^[Ss]$ ]]; then
  read -p "Digite o novo domínio: " CUSTOM_DOMAIN
  DOMAIN=$CUSTOM_DOMAIN
else
  DOMAIN=$DEFAULT_DOMAIN
fi

# Endereço IP do Lando
LANDO_IP="127.0.0.1"

# Verifica se o domínio já existe no /etc/hosts
if grep -q "$DOMAIN" /etc/hosts; then
    echo -e "${YELLOW}⚠️ O domínio $DOMAIN já está configurado no /etc/hosts.${RESET}"
else
    # Adiciona a entrada ao arquivo /etc/hosts com permissão de administrador
    echo -e "${GREEN}✅ Adicionando $DOMAIN ao /etc/hosts...${RESET}"
    echo "$LANDO_IP  $DOMAIN" | sudo tee -a /etc/hosts > /dev/null

    # Verifica se foi adicionado corretamente
    if grep -q "$DOMAIN" /etc/hosts; then
        echo -e "${GREEN}🎉 Configuração concluída! Você pode acessar: http://$DOMAIN${RESET}"
    else
        echo -e "${RED}❌ Ocorreu um erro ao adicionar o domínio ao /etc/hosts.${RESET}"
    fi
fi
