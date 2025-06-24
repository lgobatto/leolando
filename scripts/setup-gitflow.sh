#!/bin/bash

# 🚀 Script de Setup do GitFlow - Leolando
# Este script configura o ambiente GitFlow completo com Conventional Commits

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir mensagens coloridas
print_message() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Verificar se estamos no diretório correto
if [ ! -f "package.json" ]; then
    print_error "Este script deve ser executado no diretório raiz do projeto!"
    exit 1
fi

print_message "Iniciando configuração do GitFlow..."

# 1. Verificar se Lando está rodando
print_info "Verificando se Lando está rodando..."
if ! lando info > /dev/null 2>&1; then
    print_warning "Lando não está rodando. Iniciando..."
    lando start
    print_message "Lando iniciado!"
else
    print_message "Lando já está rodando!"
fi

# 2. Instalar dependências do Node.js via Lando
print_info "Instalando dependências do Node.js via Lando..."
lando npm install
print_message "Dependências instaladas com sucesso!"

# 3. Configurar Husky
print_info "Configurando Husky..."
lando npm run prepare
print_message "Husky configurado!"

# 4. Verificar se Git está configurado
print_info "Verificando configuração do Git..."
if ! git config --get user.name > /dev/null 2>&1; then
    print_warning "Git não está configurado. Configure seu nome e email:"
    echo "git config --global user.name 'Seu Nome'"
    echo "git config --global user.email 'seu.email@exemplo.com'"
    read -p "Deseja continuar mesmo assim? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# 5. Configurar GitFlow
print_info "Configurando GitFlow..."
if command -v git-flow &> /dev/null; then
    # Inicializar GitFlow se não estiver inicializado
    if [ ! -f ".gitflow" ]; then
        git flow init -d
        print_message "GitFlow inicializado!"
    else
        print_message "GitFlow já está configurado!"
    fi
else
    print_warning "git-flow não encontrado. Instalando..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y git-flow
    elif command -v brew &> /dev/null; then
        brew install git-flow
    else
        print_error "Não foi possível instalar git-flow automaticamente."
        print_info "Instale manualmente: https://github.com/nvie/gitflow"
        exit 1
    fi
    git flow init -d
    print_message "GitFlow instalado e configurado!"
fi

# 6. Criar branches principais se não existirem
print_info "Verificando branches principais..."

# Verificar se develop existe
if ! git show-ref --verify --quiet refs/heads/develop; then
    print_info "Criando branch develop..."
    git checkout -b develop
    git push -u origin develop
    print_message "Branch develop criada!"
else
    print_message "Branch develop já existe!"
fi

# Verificar se staging existe
if ! git show-ref --verify --quiet refs/heads/staging; then
    print_info "Criando branch staging..."
    git checkout -b staging
    git push -u origin staging
    print_message "Branch staging criada!"
else
    print_message "Branch staging já existe!"
fi

# Voltar para develop
git checkout develop

# 7. Configurar aliases úteis
print_info "Configurando aliases do Git..."
git config alias.feature "flow feature"
git config alias.release "flow release"
git config alias.hotfix "flow hotfix"
git config alias.finish "flow finish"
print_message "Aliases configurados!"

# 8. Criar arquivo .gitmessage para commits
print_info "Configurando template de commits..."
cat > .gitmessage << 'EOF'
# Conventional Commits - Leolando

# Tipo de mudança (obrigatório):
# feat: nova funcionalidade
# fix: correção de bug
# docs: documentação
# style: formatação
# refactor: refatoração
# perf: performance
# test: testes
# build: build
# ci: ci/cd
# chore: manutenção
# revert: reverter
# wip: work in progress
# hotfix: correção urgente

# Escopo (opcional):
# Ex: feat(auth): adiciona autenticação OAuth2

# Descrição (obrigatório):
# Use imperativo, presente: "adiciona" não "adicionado" ou "adiciona"

# Corpo (opcional):
# Explicação mais detalhada da mudança

# Rodapé (opcional):
# Issues relacionadas: Closes #123, Fixes #456
EOF

git config commit.template .gitmessage
print_message "Template de commits configurado!"

# 9. Configurar .gitignore para arquivos temporários
print_info "Atualizando .gitignore..."
cat >> .gitignore << 'EOF'

# 🔹 Arquivos do GitFlow e Conventional Commits
.gitmessage
.husky/_
node_modules/

# 🔹 Arquivos temporários do desenvolvimento
*.tmp
*.temp
.env.local
.env.development.local
.env.test.local
.env.production.local

# 🔹 Logs do npm
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# 🔹 Arquivos de IDE
.vscode/settings.json
.idea/
*.swp
*.swo
*~

# 🔹 Arquivos do sistema
.DS_Store
Thumbs.db
EOF

print_message ".gitignore atualizado!"

# 10. Criar arquivo de configuração do editor
print_info "Configurando editor padrão..."
if command -v code &> /dev/null; then
    git config --global core.editor "code --wait"
    print_message "VS Code configurado como editor padrão!"
elif command -v vim &> /dev/null; then
    git config --global core.editor "vim"
    print_message "Vim configurado como editor padrão!"
else
    print_warning "Editor não detectado. Configure manualmente:"
    echo "git config --global core.editor 'seu-editor'"
fi

# 11. Testar configuração
print_info "Testando configuração..."
echo "🧪 Testando commit interativo..."
echo "Pressione Ctrl+C para cancelar o teste"
sleep 2

# 12. Verificar configuração final
print_info "Verificando configuração final..."

echo
print_message "🎉 Configuração do GitFlow concluída com sucesso!"
echo
print_info "📋 Resumo da configuração:"
echo "   ✅ Conventional Commits configurado"
echo "   ✅ Husky hooks ativos (usando Lando)"
echo "   ✅ GitFlow inicializado"
echo "   ✅ Branches principais criadas"
echo "   ✅ Aliases configurados"
echo "   ✅ Template de commits ativo"
echo "   ✅ Lando configurado com Node.js"
echo
print_info "🚀 Próximos passos:"
echo "   1. Configure as branch protection rules no GitHub/GitLab"
echo "   2. Execute: lando npm run commit (para commits interativos)"
echo "   3. Use: git flow feature start nome-da-feature"
echo "   4. Consulte: docs/gitflow-workflow.md"
echo
print_info "📚 Comandos úteis:"
echo "   lando npm run commit     - Commit interativo"
echo "   git flow feature         - Gerenciar features"
echo "   git flow release         - Gerenciar releases"
echo "   git flow hotfix          - Gerenciar hotfixes"
echo "   lando npm run release    - Gerar release"
echo "   lando npm run lint       - Executar linting"
echo
print_message "Happy coding! 🎯"