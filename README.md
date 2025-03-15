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

## 🌍 3. Configurando o Arquivo de Hosts (Somente no Linux/macOS)

Para acessar o site localmente com um domínio amigável, adicione o domínio ao seu arquivo de hosts:

```bash
$ sudo bash scripts/set-hosts.sh
```

Isso permitirá que o domínio `testing.local` funcione corretamente no seu navegador.

**No Windows**, rode o script dentro do **WSL** ou edite manualmente `C:\Windows\System32\drivers\etc\hosts`.

---

## 🏗️ 4. Subindo o Ambiente com Lando

Agora é só rodar o Lando!

```bash
$ lando start
```

Isso irá:
✅ Criar os containers necessários  
✅ Configurar o banco de dados  
✅ Baixar e instalar o WordPress  
✅ Configurar o PHP, Nginx/Apache e Redis  

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

## 🛠️ 5. Ferramentas Integradas

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
```

---

## 🐞 6. Debugging com Xdebug no VS Code

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

## 🎯 Conclusão

Agora você tem um ambiente de desenvolvimento **totalmente funcional** para WordPress, rodando com **Lando, Composer, WP-CLI, Redis, Xdebug** e mais! 🚀

Se tiver dúvidas ou sugestões, fique à vontade para contribuir ou abrir uma issue no repositório.

🛠️ **Happy coding!** 🛠️

