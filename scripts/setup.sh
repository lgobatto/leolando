#!/bin/bash

# Definição de cores ANSI
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
RESET='\033[0m'

echo -e "${BLUE}🚀 Inicializando o setup do projeto...${RESET}"
echo -e "${YELLOW}Responda as perguntas abaixo para configurar seu ambiente.${RESET}\n"

# Obtendo valores padrão
DEFAULT_PROJECT_NAME=$(basename $(git rev-parse --show-toplevel) 2>/dev/null || echo "meuprojeto")
DEFAULT_NAMESPACE=$(basename $(dirname $(git config --get remote.origin.url) | cut -d':' -f2 | cut -d'/' -f1) 2>/dev/null || echo "meu-org")
DEFAULT_VERSION="1.0.0"
DEFAULT_AUTHOR=$(git config --get user.name || echo "Desenvolvedor")
DEFAULT_EMAIL=$(git config --get user.email || echo "contato@meuprojeto.com")

# Perguntar os dados do projeto (com valores padrão)
read -p "🔹 Nome do Projeto [${DEFAULT_PROJECT_NAME}]: " PROJECT_NAME
PROJECT_NAME=${PROJECT_NAME:-$DEFAULT_PROJECT_NAME}

read -p "🔹 Namespace do Projeto [${DEFAULT_NAMESPACE}]: " PROJECT_NAMESPACE
PROJECT_NAMESPACE=${PROJECT_NAMESPACE:-$DEFAULT_NAMESPACE}

read -p "🔹 Versão Inicial [${DEFAULT_VERSION}]: " PROJECT_VERSION
PROJECT_VERSION=${PROJECT_VERSION:-$DEFAULT_VERSION}

read -p "🔹 Nome do Autor [${DEFAULT_AUTHOR}]: " AUTHOR
AUTHOR=${AUTHOR:-$DEFAULT_AUTHOR}

read -p "🔹 Email do Autor [${DEFAULT_EMAIL}]: " AUTHOR_EMAIL
AUTHOR_EMAIL=${AUTHOR_EMAIL:-$DEFAULT_EMAIL}

PROJECT_DOMAIN="${PROJECT_NAME}.lndo.site"

# Selecionar entre Nginx ou Apache (Padrão: nginx)
DEFAULT_SERVER_TYPE="nginx"
echo -e "\n${CYAN}🔹 Escolha o servidor web [${DEFAULT_SERVER_TYPE}]:${RESET}"
select SERVER_TYPE in "nginx" "apache"; do
    SERVER_TYPE=${SERVER_TYPE:-$DEFAULT_SERVER_TYPE}
    case $SERVER_TYPE in
        nginx|apache ) break;;
        * ) echo -e "${RED}❌ Opção inválida! Escolha 1 (nginx) ou 2 (apache).${RESET}";;
    esac
done

# Selecionar a versão do PHP (Padrão: 8.3)
DEFAULT_PHP_VERSION="8.3"
echo -e "\n${CYAN}🔹 Escolha a versão do PHP [${DEFAULT_PHP_VERSION}]:${RESET}"
select PHP_VERSION in "8.3" "8.2" "8.1" "8.0" "7.4"; do
    PHP_VERSION=${PHP_VERSION:-$DEFAULT_PHP_VERSION}
    case $PHP_VERSION in
        8.3|8.2|8.1|8.0|7.4 ) break;;
        * ) echo -e "${RED}❌ Opção inválida! Escolha uma versão suportada.${RESET}";;
    esac
done

# 🔹 Escolher a versão do Node.js
echo -e "\n${CYAN}🔹 Escolha a versão do Node.js:${RESET}"
select NODE_VERSION in "18" "20" "21"; do
    case $NODE_VERSION in
        18|20|21 ) break;;
        * ) echo -e "${RED}❌ Opção inválida! Escolha uma versão suportada.${RESET}";;
    esac
done

# 🔹 Escolher a versão do WordPress Core
echo -e "\n${CYAN}🔹 Escolha a versão do WordPress Core:${RESET}"
select WP_CORE_VERSION in "latest" "6.5" "6.4" "6.3"; do
    case $WP_CORE_VERSION in
        latest|6.5|6.4|6.3 ) break;;
        * ) echo -e "${RED}❌ Opção inválida! Escolha uma versão válida.${RESET}";;
    esac
done

# 🔹 Habilitar WP_DEBUG
echo -e "\n${CYAN}🔹 Deseja habilitar WP_DEBUG? (S/N)${RESET}"
read -p "Digite S para Sim ou N para Não: " ENABLE_DEBUG
if [[ $ENABLE_DEBUG =~ ^[Ss]$ ]]; then
    WP_DEBUG="true"
else
    WP_DEBUG="false"
fi

# 🔹 Habilitar Redis para cache
echo -e "\n${CYAN}🔹 Deseja habilitar Redis para cache? (S/N)${RESET}"
read -p "Digite S para Sim ou N para Não: " ENABLE_REDIS
if [[ $ENABLE_REDIS =~ ^[Ss]$ ]]; then
    REDIS_ENABLED="true"
else
    REDIS_ENABLED="false"
fi

# Capturar o repositório Git
GIT_REPOSITORY=$(git config --get remote.origin.url)
if [[ -z "$GIT_REPOSITORY" ]]; then
    echo -e "${RED}❌ Nenhum repositório Git encontrado!${RESET}"
    read -p "Informe a URL do repositório manualmente: " GIT_REPOSITORY
fi

echo -e "\n${GREEN}✅ Informações capturadas com sucesso!${RESET}\n"

# Função para gerar salts do WordPress
generate_salt() {
    curl -s https://api.wordpress.org/secret-key/1.1/salt/ | \
    sed -e "s/define('AUTH_KEY', *'\(.*\)');/WORDPRESS_AUTH_KEY='\1'/" \
        -e "s/define('SECURE_AUTH_KEY', *'\(.*\)');/WORDPRESS_SECURE_AUTH_KEY='\1'/" \
        -e "s/define('LOGGED_IN_KEY', *'\(.*\)');/WORDPRESS_LOGGED_IN_KEY='\1'/" \
        -e "s/define('NONCE_KEY', *'\(.*\)');/WORDPRESS_NONCE_KEY='\1'/" \
        -e "s/define('AUTH_SALT', *'\(.*\)');/WORDPRESS_AUTH_SALT='\1'/" \
        -e "s/define('SECURE_AUTH_SALT', *'\(.*\)');/WORDPRESS_SECURE_AUTH_SALT='\1'/" \
        -e "s/define('LOGGED_IN_SALT', *'\(.*\)');/WORDPRESS_LOGGED_IN_SALT='\1'/" \
        -e "s/define('NONCE_SALT', *'\(.*\)');/WORDPRESS_NONCE_SALT='\1'/"
}

# Criar os arquivos baseados nos templates
echo -e "${BLUE}📄 Gerando arquivos de configuração...${RESET}"

mkdir -p wp-content/plugins wp-content/plugins/${PROJECT_NAME} wp-content/themes wp-content/themes/${PROJECT_NAME} wp-content/mu-plugins wp-content/languages
touch wp-content/plugins/${PROJECT_NAME}/.gitkeep wp-content/themes/${PROJECT_NAME}/.gitkeep

# Habilita a listagem de arquivos ocultos no globbing do shell
shopt -s dotglob

for file in templates/*; do
    # Remove o prefixo "templates/"
    output_file="${file#templates/}"

    # Remove qualquer ocorrência de ".template" no nome do arquivo
    output_file="$(echo "$output_file" | sed 's/.template//g')"

    echo -e "${YELLOW}🔹 Gerando arquivo:${RESET} ${output_file}"
    sed -e "s/{{PROJECT_NAME}}/${PROJECT_NAME}/g" \
        -e "s/{{PROJECT_NAMESPACE}}/${PROJECT_NAMESPACE}/g" \
        -e "s/{{PROJECT_VERSION}}/${PROJECT_VERSION}/g" \
        -e "s/{{AUTHOR}}/${AUTHOR}/g" \
        -e "s/{{AUTHOR_EMAIL}}/${AUTHOR_EMAIL}/g" \
        -e "s/{{PROJECT_DOMAIN}}/${PROJECT_DOMAIN}/g" \
        -e "s/{{SERVER_TYPE}}/${SERVER_TYPE}/g" \
        -e "s/{{PHP_VERSION}}/${PHP_VERSION}/g" \
        -e "s|{{GIT_REPOSITORY}}|${GIT_REPOSITORY}|g" \
        -e "s/{{NODE_VERSION}}/${NODE_VERSION}/g" \
        -e "s/{{WP_CORE_VERSION}}/${WP_CORE_VERSION}/g" \
        -e "s/{{WP_DEBUG}}/${WP_DEBUG}/g" \
        -e "s/{{REDIS_ENABLED}}/${REDIS_ENABLED}/g" \
        "$file" > "$output_file"
done

# Gerar salts do WordPress e concatenar ao final do arquivo .env
echo -e "${YELLOW}🔹 Gerando salts do WordPress...${RESET}"
echo -e "\n$(generate_salt)" >> .env

# Desativa a opção para não afetar outros comandos
shopt -u dotglob

mv .code-workspace ${PROJECT_NAME}.code-workspace

echo -e "${GREEN}✅ Arquivos gerados com sucesso!${RESET}\n"

# 🔹 Garantir permissões corretas
echo -e "\n${CYAN}🔹 Ajustando permissões de arquivos e diretórios...${RESET}"
find wp-content -type d -exec chmod 755 {} \;
find wp-content -type f -exec chmod 644 {} \;
echo -e "${GREEN}✔ Permissões corrigidas com sucesso!${RESET}"

# Limpar os arquivos de configuração
rm -rf templates

# Criar um primeiro commit (SEM modificar remote ou branch)
echo -e "${BLUE}🎯 Finalizando configuração do Git...${RESET}"
git add .
git add wp-content/plugins/${PROJECT_NAME} wp-content/themes/${PROJECT_NAME} # Adiciona pastas vazias
git commit -m "Inicializando projeto: ${PROJECT_NAME} v${PROJECT_VERSION}, Servidor: ${SERVER_TYPE}, PHP: ${PHP_VERSION}"

# Remover o próprio script após a execução
rm -- "$0"

echo -e "\n${GREEN}✅ Setup concluído com sucesso!${RESET}"
echo -e "🔗 Seu projeto usará o domínio: ${YELLOW}${PROJECT_DOMAIN}${RESET}"
echo -e "🌐 Servidor configurado: ${YELLOW}${SERVER_TYPE}${RESET}"
echo -e "🛠️ Versão do PHP: ${YELLOW}${PHP_VERSION}${RESET}"
echo -e "📦 Node.js: ${YELLOW}${NODE_VERSION}${RESET}"
echo -e "📦 WordPress Core: ${YELLOW}${WP_CORE_VERSION}${RESET}"
echo -e "🐞 WP_DEBUG: ${YELLOW}${WP_DEBUG}${RESET}"
echo -e "🔥 Redis: ${YELLOW}${REDIS_ENABLED}${RESET}"
echo -e "⚠️ Se necessário, configure manualmente o /etc/hosts no futuro.\n"