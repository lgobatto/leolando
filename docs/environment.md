# 🌍 Configuração do Ambiente de Desenvolvimento

Este documento descreve a configuração do ambiente de desenvolvimento baseado no **Lando** para WordPress. Aqui você encontrará informações sobre as ferramentas utilizadas, variáveis de ambiente e como personalizar sua configuração.

---

## 📦 1. Stack do Ambiente

Nosso ambiente é baseado nas seguintes tecnologias:

| Serviço       | Versão  | Configuração |
|--------------|--------|--------------|
| **PHP**      | {{PHP_VERSION}}    | Com Xdebug e Composer |
| **NGINX**    | latest | Configurado para servir o WordPress |
| **MySQL**    | 8^    | Gerenciado pelo Lando |
| **Redis**    | 5 ^     | Cache de objetos |
| **Node.js**  | {{NODE_VERSION}}     | Para automação e build de assets |
| **Lando**    | latest | Orquestrador de containers |

---

## 🔑 2. Variáveis de Ambiente

O projeto utiliza um arquivo `.env` para armazenar variáveis de ambiente sensíveis. Durante o **setup**, o script gera automaticamente esse arquivo com base nas respostas fornecidas.

### 📌 Exemplo de `.env`
```ini
# Configuração do WordPress
WORDPRESS_SITE_URL="{{PROJECT_DOMAIN}}"
WORDPRESS_WP_ENVIRONMENT_TYPE="local"

# Banco de Dados
WORDPRESS_SITE_URL="{{PROJECT_DOMAIN}}"
WORDPRESS_DB_NAME="wordpress"
WORDPRESS_DB_USER="wordpress"
WORDPRESS_DB_PASSWORD="wordpress"
WORDPRESS_DB_HOST="database"

# Debug
WORDPRESS_DEBUG={{WP_DEBUG}}
WORDPRESS_DEBUG_DISPLAY={{WP_DEBUG}}
WORDPRESS_DEBUG_LOG={{WP_DEBUG}}
```

---

## ⚙️ 3. Configuração do Lando

O arquivo `.lando.yml` define toda a configuração do ambiente, incluindo serviços e ferramentas. Aqui estão algumas opções importantes:

- **PHP {{PHP_VERSION}}com Xdebug** já configurado.
- **Banco de dados MySQL** com credenciais automáticas.
- **Redis** para caching de objetos.
- **Node.js** para build de assets.
- Ferramentas como **Composer, WP-CLI, Nginx e MySQL CLI** disponíveis via `lando`.

### 🔧 Comandos Úteis do Lando
```sh
# Subir o ambiente
lando start

# Parar o ambiente
lando stop

# Executar um shell no container PHP
lando ssh

# Executar comandos no WordPress via WP-CLI
lando wp help

# Instalar dependências do Composer dentro do container
lando composer install
```

---

## 🐞 4. Debugging com Xdebug

O **Xdebug** já está configurado no Lando para permitir depuração no **VS Code**. Para ativá-lo:

1. **Abra o VS Code e carregue o workspace**:
   ```sh
   code {{PROJECT_NAME}}.code-workspace
   ```
2. Vá para **Run and Debug** (Ctrl+Shift+D) e escolha "Listen for Xdebug".
3. Inicie o debugger e comece a depuração! 🎯

Para ativar/desativar manualmente:

```sh
# Ativar Xdebug
lando xdebug-on

# Desativar Xdebug
lando xdebug-off
```

---

## 🛠️ 5. Personalizando o Ambiente

Caso precise alterar a versão do PHP, Node.js ou MySQL, edite o arquivo `.lando.yml` e reinicie o ambiente com:

```sh
lando rebuild
```

Se precisar adicionar novos pacotes PHP, use o Composer:

```sh
lando composer require pacote/exemplo
```

---

## 🎯 Conclusão

Este ambiente foi projetado para ser **rápido, flexível e fácil de usar**. Se precisar de ajustes, consulte a documentação do Lando ou customize as configurações conforme necessário.

Para mais detalhes, veja o arquivo [`.lando.yml`](../.lando.yml).

🚀 **Happy coding!** 🚀