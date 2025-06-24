# 🚀 Getting Started

Guia completo para configurar o ambiente de desenvolvimento local do projeto **{{PROJECT_NAME}}**.

## 📋 **Pré-requisitos**

### Obrigatórios
- **[Lando](https://lando.dev/)** (v3.0+) - Ambiente de desenvolvimento local
- **[Docker](https://docker.com/)** (v20.0+) - Containerização
- **[Git](https://git-scm.com/)** - Controle de versão
- **[Node.js](https://nodejs.org/)** - Para ferramentas de desenvolvimento

### Recomendados
- **[Visual Studio Code](https://code.visualstudio.com/)** - Editor recomendado
- **Acesso ao GitLab** - Para interação com o repositório

### Verificação dos Pré-requisitos
```bash
# Verificar instalações
lando version          # v3.0+
docker --version       # v20.0+
git --version          # Qualquer versão recente
node --version         # Versão especificada em .nvmrc
```

## 🏁 **Setup Inicial**

### 1. **Clone do Repositório**
```bash
# SSH (recomendado)
git clone {{GIT_REPO_SSH}}
cd {{PROJECT_NAME}}

# HTTPS (alternativo)
git clone {{GIT_REPO_HTTPS}}
cd {{PROJECT_NAME}}
```

### 2. **Inicialização do Lando**
```bash
# Inicializar ambiente
lando start

# Verificar status
lando info
```

### 3. **Configuração WordPress**
```bash
# Configurar WordPress com usuário padrão
lando ssh -c "scripts/wp-setup.sh --user={{TEAM_EMAIL}}"

# Aguardar conclusão da configuração
```

### 4. **Verificação do Setup**
```bash
# Verificar se WordPress está funcionando
curl -I {{LOCAL_URL}}

# Deve retornar HTTP/2 200

# Verificar se WordPress está configurado
lando wp user list
```

## 🌐 **Acessos Locais**

| Serviço | URL | Credenciais |
|---------|-----|-------------|
| **Site Frontend** | [{{LOCAL_URL}}]({{LOCAL_URL}}) | - |
| **WordPress Admin** | [{{LOCAL_URL}}/wp-admin]({{LOCAL_URL}}/wp-admin) | Definidas no setup |
| **Database (phpMyAdmin)** | [{{LOCAL_URL}}:8080]({{LOCAL_URL}}:8080) | Ver `.lando.yml` |
| **MailHog** | [{{LOCAL_URL}}:8025]({{LOCAL_URL}}:8025) | - |

## 🛠️ **Comandos Essenciais**

### Lando Básico
```bash
# Iniciar ambiente
lando start

# Parar ambiente
lando stop

# Reiniciar ambiente
lando restart

# Reconstruir ambiente (quando mudar .lando.yml)
lando rebuild

# Destruir ambiente
lando destroy
```

### WordPress via Lando
```bash
# WP-CLI (todas as ferramentas dentro do container)
lando wp --help
lando wp user list
lando wp plugin list

# Logs
lando logs
```

### Database
```bash
# Acesso direto ao MySQL
lando mysql

# Verificar integridade do banco
lando wp db check

# Reparar tabelas (se necessário)
lando wp db repair
```

### Ferramentas de Desenvolvimento
```bash
# Node.js/NPM dentro do container
lando npm install
lando npm run build
lando npm run dev

# Composer (PHP)
lando composer install
lando composer update
```

## 🔧 **Configuração do Ambiente de Desenvolvimento**

### VS Code (Recomendado)
O projeto inclui configurações específicas para VS Code:

```bash
# Abrir projeto no VS Code
code .

# Extensões recomendadas serão instaladas automaticamente
```

### Configurações Incluídas:
- **PHP Intelephense** - IntelliSense para PHP
- **WordPress Snippets** - Snippets para WordPress
- **ESLint** - Linting JavaScript
- **Prettier** - Formatação de código
- **GitLens** - Histórico do Git
- **Docker** - Suporte a containers

### Configurações do Workspace:
- **PHP**: Configurado para WordPress
- **JavaScript**: ESLint + Prettier
- **Git**: Conventional Commits
- **Terminal**: Integrado com Lando

## 🚀 **Primeiros Passos no Desenvolvimento**

### 1. **Verificar Status do Ambiente**
```bash
# Verificar se tudo está funcionando
lando status

# Verificar logs
lando logs
```

### 2. **Explorar a Estrutura**
```bash
# Listar temas disponíveis
lando wp theme list

# Listar plugins ativos
lando wp plugin list --status=active

# Verificar configurações
lando wp config get
```

### 3. **Criar Primeira Feature**
```bash
# Criar branch seguindo GitFlow
git checkout -b feature/minha-primeira-feature

# Fazer alterações no código
# ...

# Commit seguindo Conventional Commits
git commit -m "feat: add new functionality"

# Push e criar Merge Request
git push origin feature/minha-primeira-feature
```

## 🐛 **Troubleshooting Comum**

### Problema: Lando não inicia
```bash
# Verificar se Docker está rodando
docker ps

# Limpar containers parados
docker container prune

# Reconstruir ambiente
lando rebuild
```

### Problema: WordPress não acessível
```bash
# Verificar se serviços estão rodando
lando status

# Verificar logs
lando logs

# Reiniciar WordPress
lando wp core install --url={{LOCAL_URL}} --title="{{PROJECT_NAME}}" --admin_user=admin --admin_password=admin --admin_email={{TEAM_EMAIL}}
```

### Problema: Banco de dados não conecta
```bash
# Verificar conexão
lando wp db check

# Reparar tabelas
lando wp db repair

# Recriar banco se necessário
lando wp db reset --yes
```

## 📚 **Próximos Passos**

Agora que seu ambiente está configurado, continue com:

1. **[Development](Development)** - Guia completo de desenvolvimento
2. **[Architecture](Architecture)** - Entenda a estrutura do projeto
3. **[Pipelines](Pipelines)** - Como funciona o CI/CD

## 🆘 **Precisa de Ajuda?**

- **Documentação**: [Wiki do Projeto]({{GIT_REPO_URL}}/-/wikis)
- **Issues**: [GitLab Issues]({{GIT_REPO_URL}}/-/issues)
- **Equipe**: {{TEAM_EMAIL}}

---

📝 **Última atualização**: {{CURRENT_DATE}}
🔄 **Versão**: {{PROJECT_VERSION}}
✨ **Ambiente**: {{LOCAL_URL}}