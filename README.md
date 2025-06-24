# 🏗️ Configuração do Ambiente WordPress com Lando

Bem-vindo ao nosso **template de desenvolvimento WordPress** com Léo+Lando! 🎉

Este template foi criado para oferecer um ambiente de desenvolvimento **rápido, confiável e padronizado**, facilitando a colaboração e o gerenciamento do projeto.

---

## 🚀 1. Criando o Repositório a Partir do Template

Como este é um **template** no GitHub, você não deve cloná-lo diretamente. Em vez disso, siga estes passos:

1. **Acesse o template no GitHub**.
2. Clique no botão **"Use this template"**.
3. Escolha **"Create a new repository"**.
4. Dê um nome ao seu projeto e clique em **"Create repository from template"**.

Agora, você tem seu próprio repositório baseado neste template. 🎉

---

## 📥 2. Clonando o Repositório e Executando o Setup

Agora que seu repositório está criado, vamos cloná-lo e configurá-lo:

```bash
# Clone o repositório
$ git clone git@github.com:seu-usuario/seu-repositorio.git

# Acesse a pasta do projeto
$ cd seu-repositorio
```

Agora, rode o script de configuração para personalizar o ambiente:

```bash
$ bash scripts/setup.sh
```

Durante a execução, algumas perguntas serão feitas para personalizar seu ambiente, como:
✅ Nome do projeto
✅ Versão inicial
✅ Autor e e-mail
✅ Versão do PHP e do Node.js
✅ Ativação do WP_DEBUG

Após concluir esse passo, seu ambiente estará configurado! 🎉

---

## 🌿 3. Configurando GitFlow e Conventional Commits

Este projeto utiliza **GitFlow** com **Conventional Commits** para um fluxo de trabalho profissional e padronizado, integrado com o ambiente **Lando**.

### **Setup Automático (Recomendado)**

Execute o script de configuração do GitFlow:

```bash
$ bash scripts/setup-gitflow.sh
```

Este script irá:
✅ Verificar e iniciar o Lando
✅ Instalar dependências do Node.js via Lando
✅ Configurar Husky hooks (usando Lando)
✅ Inicializar GitFlow
✅ Criar branches principais (develop, staging)
✅ Configurar aliases úteis
✅ Configurar template de commits

### **Setup Manual**

Se preferir configurar manualmente:

```bash
# Iniciar Lando
$ lando start

# Instalar dependências via Lando
$ lando npm install

# Configurar Husky via Lando
$ lando npm run prepare

# Inicializar GitFlow
$ git flow init -d

# Criar branches principais
$ git checkout -b develop
$ git push -u origin develop
$ git checkout -b staging
$ git push -u origin staging
$ git checkout develop
```

### **Fluxo de Trabalho**

```bash
# Iniciar uma nova feature
$ git flow feature start nome-da-feature

# Fazer commits (use o padrão Conventional Commits via Lando)
$ lando npm run commit

# Finalizar feature
$ git flow feature finish nome-da-feature

# Iniciar release
$ git flow release start v1.2.0

# Finalizar release
$ git flow release finish v1.2.0

# Hotfix urgente
$ git flow hotfix start correcao-urgente
$ git flow hotfix finish correcao-urgente
```

### **Conventional Commits**

Todos os commits devem seguir o padrão:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Tipos de commit:**
- `feat`: Nova funcionalidade
- `fix`: Correção de bug
- `docs`: Documentação
- `style`: Formatação
- `refactor`: Refatoração
- `perf`: Performance
- `test`: Testes
- `build`: Build
- `ci`: CI/CD
- `chore`: Manutenção
- `hotfix`: Correção urgente

**Exemplos:**
```bash
feat(auth): adiciona autenticação OAuth2
fix(validation): corrige validação de email
docs: atualiza instruções de instalação
```

📚 **Para mais detalhes, consulte:** `docs/gitflow-workflow.md`

---

## 🌍 4. Configurando o Arquivo de Hosts (Somente no Linux/macOS)

Para acessar o site localmente com um domínio amigável, adicione o domínio ao seu arquivo de hosts:

```bash
$ sudo bash scripts/set-hosts.sh
```

Isso permitirá que o domínio `testing.local` funcione corretamente no seu navegador.

**No Windows**, rode o script dentro do **WSL** ou edite manualmente `C:\Windows\System32\drivers\etc\hosts`.

---

## 🏗️ 5. Subindo o Ambiente com Lando

Agora é só rodar o Lando!

```bash
$ lando start
```

Isso irá:
✅ Criar os containers necessários
✅ Configurar o banco de dados
✅ Baixar e instalar o WordPress
✅ Configurar o PHP, Nginx/Apache e Redis
✅ Configurar o serviço Node.js para DevOps

**Para ver as URLs disponíveis, execute:**
```bash
$ lando info
```

Você verá algo como:
```
URLS
  ✔ APPSERVER NGINX URLS
    ✔ http://testing.lndo.site/ [200]
    ✔ https://testing.lndo.site/ [200]
```

Agora você já pode acessar seu site no navegador! 🚀

---

## 🛠️ 6. Ferramentas Integradas

Nosso ambiente já vem com algumas ferramentas configuradas no **Lando** para facilitar o desenvolvimento:

```bash
# Executar comandos do Composer dentro do container
$ lando composer install

# Rodar o Yarn dentro do container
$ lando yarn install

# Usar o WP-CLI dentro do container
$ lando wp help

# Acessar o banco de dados via MySQL CLI
$ lando mysql

# Limpar o cache do Redis
$ lando redis-cli FLUSHALL

# Executar comandos Node.js (DevOps)
$ lando npm run commit
$ lando npm run lint
$ lando npm run release
```

---

## 🔄 7. CI/CD e DevOps

Este projeto está configurado com um pipeline DevOps completo integrado ao ambiente Lando:

### **Ambientes**
- **Desenvolvimento**: Branch `develop` → Deploy automático
- **Staging**: Branch `staging` → Deploy automático
- **Produção**: Branch `master/main` → Deploy via Release Please

### **Ferramentas DevOps (via Lando)**
- **Conventional Commits**: Padronização de commits
- **Release Please**: Releases automáticos
- **Husky**: Git hooks (executados via Lando)
- **Commitlint**: Validação de commits (via Lando)
- **Standard Version**: Geração de changelogs (via Lando)

### **Comandos Úteis**
```bash
# Commit interativo via Lando
$ lando npm run commit

# Gerar release via Lando
$ lando npm run release

# Linting via Lando
$ lando npm run lint

# Testes via Lando
$ lando npm run test

# Composer via Lando
$ lando composer install
$ lando composer update

# WP-CLI via Lando
$ lando wp --info
$ lando wp help
```

📚 **Para mais detalhes sobre DevOps:** `docs/gitflow-workflow.md`

---

## 🐞 8. Debugging com Xdebug no VS Code

Já configuramos o **Xdebug** para funcionar no VS Code! Para ativá-lo:

1. **Abra o VS Code e carregue o workspace**:
   ```bash
   code testing.code-workspace
   ```
2. Vá para **Run and Debug** (Ctrl+Shift+D) e escolha "Listen for Xdebug".
3. Inicie o debugger e comece a depuração! 🎯

Caso precise ativar o Xdebug manualmente, use:
```bash
$ lando xdebug-on
```
E para desativar:
```bash
$ lando xdebug-off
```

---

## 📚 9. Documentação

- **GitFlow Workflow**: `docs/gitflow-workflow.md`
- **Boas Práticas**: `docs/good-practices.md`
- **Ambiente**: `docs/environment.md`

---

## 🎯 Conclusão

Agora você tem um ambiente de desenvolvimento **totalmente funcional** para WordPress, rodando com **Lando, Composer, WP-CLI, Redis, Xdebug** e um **pipeline DevOps completo integrado**! 🚀

Se tiver dúvidas ou sugestões, fique à vontade para contribuir ou abrir uma issue no repositório.

🛠️ **Happy coding!** 🛠️

