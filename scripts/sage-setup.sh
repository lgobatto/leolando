#!/bin/bash
source .env

# Definição de cores para mensagens
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
RESET='\033[0m'

echo -e "${YELLOW}🔹 Verificando se os arquivos do sage existem...${RESET}"
# Caminho correto do WordPress no contêiner
THEMES_PATH="/app/wp-content/themes"
SAGE_PATH="$THEMES_PATH/${PROJECT_NAME}"

create_sage() {
    rm -rf $THEMES_PATH/${PROJECT_NAME}
    echo -e "${GREEN}📥 Criando projeto do tema baseado em sage versão: ${SAGE_VERSION}...${RESET}"
    cd $THEMES_PATH
    composer create-project roots/sage ${PROJECT_NAME} "${SAGE_VERSION}"
}

# Se o SAGE ainda não foi instalado, criamos o tema
if [ ! -f "${SAGE_PATH}/composer.json" ]; then
    create_sage
else
    echo -e "${GREEN}✅ O tema já está presente, nenhum download necessário.${RESET}"
fi
