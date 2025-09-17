# 🚀 WordPress Development Stack

Bem-vindo ao ambiente de desenvolvimento do WordPress! 🎉
Aqui, tudo foi cuidadosamente configurado para que você possa focar no código, sem se preocupar com configurações demoradas.

## 📜 Visão Geral

Este projeto utiliza uma abordagem moderna e modular para desenvolver aplicações WordPress com **Composer**, **Docker**, **Lando**, **Xdebug** e outras ferramentas que otimizam o fluxo de trabalho.

O template foi projetado para **separar o core do WordPress** do código personalizado, versionando apenas o necessário e garantindo segurança, performance e flexibilidade.

---

## 📂 Estrutura do Projeto

A estrutura de diretórios foi inspirada em projetos como **Bedrock** e **Radicle** para otimizar a organização:

```plaintext
.
├── config/              # Arquivos de configuração (php.ini, .env, etc.)
├── db_init/             # Arquivos de inicialização do banco de dados
├── scripts/             # Scripts auxiliares (setup, configuração de hosts, etc.)
├── templates/           # Modelos de arquivos do projeto
├── wp/                  # Core do WordPress (ignorado no Git)
├── wp-content/          # Plugins, temas e uploads
│   ├── mu-plugins/      # Must-use plugins (plugins customizados)
│   ├── plugins/         # Plugins convencionais
│   ├── themes/          # Temas ativos
│   └── uploads/         # Uploads (não versionado)
├── vendor/              # Dependências gerenciadas pelo Composer (não versionado)
├── .lando.yml           # Configuração do Lando
├── docker-compose.yml   # Configuração do Docker Compose
├── Makefile             # Automação de tarefas
├── composer.json        # Gerenciamento de dependências do WordPress
└── README.md            # Este arquivo
```

---

## 🛠️ Configuração e Desenvolvimento

### 🔧 1. Configurando o Ambiente

1. **Clone o repositório**
   ```sh
   git clone git@github.com:lgobatto/leolando.git gui_design
   cd gui_design
   ```

2. **Configure os hosts locais** (necessário para acessar pelo navegador)
   ```sh
   ./scripts/set-hosts.sh
   ```

3. **Suba o ambiente com Lando**
   ```sh
   lando start
   ```

4. **Acesse o ambiente local no navegador**
   - 📌 http://gui_design.lndo.site
   - 🔒 https://gui_design.lndo.site

---

### 📦 2. Gerenciamento de Pacotes com Composer

Utilizamos **Composer** para gerenciar os plugins e temas do WordPress, garantindo um ambiente consistente.
Todos os comandos devem ser executados **dentro do ambiente Lando**.

#### 🔍 Instalar dependências do projeto:
```sh
lando composer install
```

#### 📌 Adicionar um plugin via Composer:
```sh
lando composer require wpackagist-plugin/advanced-custom-fields
```

#### 🔄 Atualizar dependências:
```sh
lando composer update
```

---

### 🏗️ 3. Construção do Tema

Se o projeto possuir um tema personalizado, é necessário instalar as dependências e rodar o build:

1. **Instalar dependências do tema:**
   ```sh
   lando yarn install (necessário informar o path do tema)
   ```

2. **Compilar os assets do tema:**
   ```sh
   lando yarn build (necessário informar o path do tema)
   ```

---

## 🐞 Debugging com Xdebug

O **Xdebug** já está configurado para permitir depuração via **VS Code**. Basta abrir o **workspace** no VS Code e ativar o **debugger**.

📜 Configurações adicionais podem ser encontradas no arquivo [`environment.md`](./docs/environment.md).

---

## 📜 Boas Práticas

Aqui estão algumas práticas recomendadas para manter um código limpo e sustentável:

✔ **Versionamento correto:** Apenas código relevante é versionado.
✔ **Ambiente isolado:** Evitamos dependências do sistema operacional local.
✔ **Plugins via Composer:** Sem instalação manual de plugins.
✔ **Automação:** Tarefas manuais são reduzidas ao mínimo.

Para mais detalhes, confira [`good-practices.md`](./docs/good-practices.md).

---

## 🎯 Conclusão

Com esse setup, conseguimos um **ambiente moderno, rápido e seguro** para desenvolver aplicações WordPress de forma profissional. 🚀

Caso encontre problemas, verifique a documentação ou entre em contato com a equipe.

Happy coding! 🎉

Me avise se quiser ajudar ou sugerir algo! 🚀🔥