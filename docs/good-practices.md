# 📜 Boas Práticas de Desenvolvimento

Este guia tem como objetivo definir as melhores práticas para manter **consistência, qualidade e organização** no desenvolvimento do projeto.

## 🚀 Visão Geral

- O **WordPress Core** não é versionado. Ele é gerenciado pelo ambiente.
- Os **plugins e temas** são versionados **apenas se forem customizados**.
- Utilizamos **Composer** para gerenciar dependências do WordPress.
- O ambiente é isolado via **Docker/Lando**.
- O fluxo de trabalho segue o **GitFlow** para garantir um desenvolvimento organizado.

---

## 🏗️ Estrutura do Projeto

O projeto está organizado da seguinte forma:

```plaintext
.
├── config/              # Configurações gerais (php.ini, env, etc.)
├── docs/                # Documentação e readmes
├── db_init/             # Scripts de inicialização do banco de dados
├── scripts/             # Scripts utilitários (setup, hosts, etc.)
├── wp-content/          # Plugins, temas e uploads (somente o necessário é versionado)
│   ├── mu-plugins/      # Must-use plugins (customizados)
│   ├── plugins/         # Plugins convencionais (gerenciados via Composer)
│   ├── themes/          # Temas ativos
│   └── uploads/         # Uploads (não versionado)
├── vendor/              # Dependências do Composer (não versionado)
├── .lando.yml           # Configuração do Lando
├── composer.json        # Gerenciamento de dependências do WordPress
└── README.md            # Documentação do projeto
```

---

## 📌 Versionamento

### 📌 O que é **versionado**:
✔ Código fonte do tema e plugins customizados

✔ Configurações essenciais (exemplo: `.env`, `composer.json`)

✔ Scripts auxiliares (`setup.sh`, `set-hosts.sh`)

✔ Configuração do ambiente (`.lando.yml`, `Makefile`)

✔ **Templates de configuração** (`templates/`) → Geram arquivos dinâmicos

### ❌ O que **não** é versionado:
❌ O **WordPress Core** (`wp/`) → Instalado via `composer install`

❌ Dependências do Composer (`vendor/`)

❌ Diretório de uploads (`wp-content/uploads/`)

❌ Plugins e temas baixados via WordPress Admin Ou via Composer (`wp-content/plugins/`, `wp-content/themes/`)

❌ **Arquivos de configuração gerados** (`.versionrc.js`, `.cursorrules`, workspace) → Gerados dinamicamente

O **`.gitignore`** está configurado para evitar que arquivos desnecessários sejam adicionados ao repositório.

### 🔧 Arquivos de Configuração Dinâmicos

Alguns arquivos são gerados automaticamente pelo script `setup.sh` a partir de templates:

- **`.versionrc.js`** → Configuração do Standard Version (releases automáticos)
- **`.cursorrules`** → Regras para IA do Cursor
- **`commitlint.config.js`** → Configuração do Commitlint (validação de commits)
- **`package.json`** → Configuração do Node.js e dependências
- **`{projeto}.code-workspace`** → Workspace do VS Code

Esses arquivos contêm variáveis personalizadas como URLs do repositório, nomes de projeto, etc.

---

## 🔄 Fluxo de Trabalho com GitFlow

Utilizamos **GitFlow** para organizar o desenvolvimento. O fluxo é o seguinte:

1. **`main`** → Contém apenas versões estáveis do código.
2. **`develop`** → Branch de desenvolvimento principal.
3. **`feature/nome-da-feature`** → Para novas funcionalidades.
4. **`hotfix/nome-do-hotfix`** → Para correções urgentes em produção.
5. **`release/nome-da-versao`** → Para preparar uma nova versão.

### 🔧 Criando uma nova funcionalidade:
```sh
git checkout develop
git pull origin develop
git checkout -b feature/nova-funcionalidade
```

### 🔄 Finalizando e integrando:
```sh
git checkout develop
git merge feature/nova-funcionalidade
git push origin develop
```

### 🚀 Criando uma versão de produção:
```sh
git checkout main
git merge release/nome-da-release
git push origin main
git tag -a v1.0.0 -m "Primeira versão"
git push origin v1.0.0
```

---

## 🎨 Padrões de Código

### 📝 PHP (PSR-12)
✔ Seguir o padrão **PSR-12** para código limpo e consistente.

✔ Utilizar **type hinting** (`string`, `int`, `array`) sempre que possível.

✔ Usar **classes, namespaces e autoloading** para organização.

#### Exemplo:
```php
namespace App\Controllers;

use App\Models\User;

class ProfileController {
    public function show(int $userId): User {
        return User::find($userId);
    }
}
```

---

### 🎨 JavaScript & CSS
✔ Código organizado e formatado com **Prettier**.

✔ Uso de **ESLint** para manter padrões de boas práticas.

✔ Estruturação de **Sass/SCSS** para modularização.

#### Exemplo:
```js
export default function showAlert(message) {
  console.log(`🚀 ${message}`);
}
```

## 🐞 Debugging com Xdebug

O **Xdebug** já está configurado para permitir depuração via **VS Code**. Basta abrir o **workspace** no VS Code e ativar o **debugger**.

📜 Configurações adicionais podem ser encontradas no arquivo [`environment.md`](./environment.md).

---

## 🚀 Conclusão

Seguindo essas práticas, garantimos um desenvolvimento **organizado, eficiente e seguro**.

Caso tenha dúvidas, consulte a documentação ou entre em contato com a equipe! 🚀🔥