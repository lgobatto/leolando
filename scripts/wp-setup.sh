#!/bin/bash

source .env

# Definição de cores para mensagens
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
RESET='\033[0m'

echo -e "${YELLOW}🔹 Verificando se os arquivos do WordPress existem...${RESET}"

# Caminho correto do WordPress no contêiner
WP_PATH="/app"

# Se o WordPress ainda não foi baixado, fazemos o download
if [ ! -f "$WP_PATH/wp-config-sample.php" ]; then
    echo -e "${GREEN}📥 Baixando WordPress em $WP_PATH (versão ${WP_CORE_VERSION}, sem sobrescrever wp-content)...${RESET}"
    wp core download --path="$WP_PATH" --skip-content --force --version="${WP_CORE_VERSION}"
else
    echo -e "${GREEN}✅ WordPress já está presente, nenhum download necessário.${RESET}"
fi
