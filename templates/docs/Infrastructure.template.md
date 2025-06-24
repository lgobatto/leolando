# 🏗️ Infrastructure

Guia completo da infraestrutura do projeto **{{PROJECT_NAME}}**, com foco em containerização, ambientes e configurações de sistema.

## 🎯 **Visão Geral**

A infraestrutura do projeto **{{PROJECT_NAME}}** é baseada em **Lando** para desenvolvimento local e **GitLab CI/CD** para ambientes de deploy, garantindo consistência e facilidade de manutenção.

### **Principais Características**
- **Containerização**: Docker via Lando
- **Desenvolvimento Local**: Ambiente isolado e reproduzível
- **CI/CD**: GitLab Pipelines automatizados
- **Multi-ambiente**: Local, Development, Staging, Production
- **Backup**: Estratégia automatizada
- **Monitoramento**: Health checks e logs

## 🐳 **Containerização (Lando)**

### **Configuração Lando**

```yaml
# .lando.yml
name: {{PROJECT_NAME}}
recipe: wordpress
config:
  webroot: .
  database: mysql:8.0
  php: '8.1'
  via: nginx
  ssl: true
  xdebug: false

services:
  database:
    type: mysql:8.0
    portforward: true
    creds:
      user: root
      password: password
      database: wordpress
    config:
      database: config/mysql.cnf

  cache:
    type: redis:7.0
    portforward: true

  mailhog:
    type: mailhog
    portforward: true
    ssl: false

proxy:
  database:
    - database.{{PROJECT_NAME}}.lndo.site:3306
  cache:
    - cache.{{PROJECT_NAME}}.lndo.site:6379
  mailhog:
    - mail.{{PROJECT_NAME}}.lndo.site:8025

tooling:
  wp:
    service: appserver
    description: Run WP-CLI commands
  composer:
    service: appserver
    description: Run Composer commands
  npm:
    service: appserver
    description: Run NPM commands
  mysql:
    service: database
    description: Access MySQL database
  redis:
    service: cache
    description: Access Redis cache
```

### **Serviços Disponíveis**

| Serviço | Porta | URL | Finalidade |
|---------|-------|-----|------------|
| **Web Server** | 80/443 | `{{LOCAL_URL}}` | Aplicação WordPress |
| **Database** | 3306 | `database.{{PROJECT_NAME}}.lndo.site` | MySQL |
| **Cache** | 6379 | `cache.{{PROJECT_NAME}}.lndo.site` | Redis |
| **MailHog** | 8025 | `mail.{{PROJECT_NAME}}.lndo.site` | Email testing |
| **phpMyAdmin** | 8080 | `{{LOCAL_URL}}:8080` | Interface MySQL |

## 🌐 **Ambientes**

### **Desenvolvimento Local**

**Tecnologias:**
- **Lando**: Containerização local
- **Docker**: Isolamento de serviços
- **Nginx**: Web server
- **PHP 8.1**: Runtime PHP
- **MySQL 8.0**: Banco de dados
- **Redis 7.0**: Cache

**Configurações:**
```bash
# Variáveis de ambiente local
WP_ENV=development
WP_DEBUG=true
WP_DEBUG_LOG=true
WP_DEBUG_DISPLAY=false

# URLs locais
WP_HOME={{LOCAL_URL}}
WP_SITEURL={{LOCAL_URL}}
```

### **Development (GitLab)**

**Tecnologias:**
- **GitLab CI/CD**: Pipeline automatizado
- **Docker**: Containerização
- **Nginx**: Web server
- **PHP 8.1**: Runtime PHP
- **MySQL 8.0**: Banco de dados

**Configurações:**
```bash
# Variáveis de ambiente
WP_ENV=development
WP_DEBUG=false
WP_CACHE=true

# URLs
WP_HOME={{DEVELOPMENT_URL}}
WP_SITEURL={{DEVELOPMENT_URL}}
```

### **Staging (GitLab)**

**Tecnologias:**
- **GitLab CI/CD**: Pipeline automatizado
- **Docker**: Containerização
- **Nginx**: Web server
- **PHP 8.1**: Runtime PHP
- **MySQL 8.0**: Banco de dados
- **Redis**: Cache

**Configurações:**
```bash
# Variáveis de ambiente
WP_ENV=staging
WP_DEBUG=false
WP_CACHE=true

# URLs
WP_HOME={{STAGING_URL}}
WP_SITEURL={{STAGING_URL}}
```

### **Production (GitLab)**

**Tecnologias:**
- **GitLab CI/CD**: Pipeline manual
- **Docker**: Containerização
- **Nginx**: Web server
- **PHP 8.1**: Runtime PHP
- **MySQL 8.0**: Banco de dados
- **Redis**: Cache
- **CDN**: CloudFlare

**Configurações:**
```bash
# Variáveis de ambiente
WP_ENV=production
WP_DEBUG=false
WP_CACHE=true

# URLs
WP_HOME={{PRODUCTION_URL}}
WP_SITEURL={{PRODUCTION_URL}}
```

## 🔧 **Configurações de Sistema**

### **PHP Configuration**

```ini
# config/php.ini
[PHP]
; Performance
memory_limit = 256M
max_execution_time = 300
max_input_vars = 3000
post_max_size = 64M
upload_max_filesize = 64M

; Error handling
display_errors = Off
log_errors = On
error_log = /tmp/php_errors.log

; Security
expose_php = Off
allow_url_fopen = Off
allow_url_include = Off

; WordPress specific
auto_prepend_file = /app/wp-content/mu-plugins/security.php
```

### **Nginx Configuration**

```nginx
# config/nginx.conf
server {
    listen 80;
    listen 443 ssl;
    server_name {{LOCAL_URL}};
    root /app;
    index index.php;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;

    # WordPress rewrite rules
    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    # PHP processing
    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass appserver:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }

    # Static files caching
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Security: deny access to sensitive files
    location ~ /\. {
        deny all;
    }

    location ~ /(wp-config\.php|readme\.html|license\.txt) {
        deny all;
    }
}
```

### **MySQL Configuration**

```ini
# config/mysql.cnf
[mysqld]
# Performance
innodb_buffer_pool_size = 256M
innodb_log_file_size = 64M
innodb_flush_log_at_trx_commit = 2
innodb_flush_method = O_DIRECT

# Connection settings
max_connections = 100
max_allowed_packet = 64M

# Query cache
query_cache_type = 1
query_cache_size = 32M
query_cache_limit = 2M

# Logging
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow.log
long_query_time = 2

# Security
local_infile = 0
```

## 📦 **Deploy e CI/CD**

### **GitLab CI/CD Pipeline**

```yaml
# .gitlab-ci.yml
stages:
  - validate
  - build
  - test
  - deploy

variables:
  PHP_VERSION: "8.1"
  NODE_VERSION: "18"
  COMPOSER_CACHE_DIR: ".composer-cache"
  NPM_CACHE_DIR: ".npm-cache"

# Cache para otimizar builds
cache:
  paths:
    - .composer-cache/
    - .npm-cache/
    - node_modules/
    - vendor/

# Jobs de validação
validate:
  stage: validate
  image: php:8.1
  script:
    - composer install
    - composer lint
    - composer security-check

# Jobs de build
build:
  stage: build
  image: node:18
  script:
    - npm ci
    - npm run build
  artifacts:
    paths:
      - wp-content/themes/{{PROJECT_NAME}}/assets/dist/

# Jobs de teste
test:
  stage: test
  image: php:8.1
  script:
    - composer install
    - composer test
  coverage: '/Total:\s+(\d+\.\d+)%/'

# Deploy para development
deploy_development:
  stage: deploy
  script:
    - ./scripts/deploy.sh development
  environment:
    name: development
    url: {{DEVELOPMENT_URL}}
  only:
    - develop

# Deploy para staging
deploy_staging:
  stage: deploy
  script:
    - ./scripts/deploy.sh staging
  environment:
    name: staging
    url: {{STAGING_URL}}
  only:
    - staging

# Deploy para production
deploy_production:
  stage: deploy
  script:
    - ./scripts/deploy.sh production
  environment:
    name: production
    url: {{PRODUCTION_URL}}
  only:
    - main
  when: manual
```

### **Scripts de Deploy**

```bash
#!/bin/bash
# scripts/deploy.sh

set -e

ENVIRONMENT=$1
DEPLOY_PATH="/var/www/html"

echo "🚀 Deploying to $ENVIRONMENT..."

# Backup do ambiente atual
if [ -d "$DEPLOY_PATH" ]; then
    echo "📦 Creating backup..."
    tar -czf "backup-$(date +%Y%m%d-%H%M%S).tar.gz" "$DEPLOY_PATH"
fi

# Deploy dos arquivos
echo "📁 Deploying files..."
rsync -av --delete dist/ "$DEPLOY_PATH/"

# Configuração do WordPress
echo "⚙️ Configuring WordPress..."
wp core install --path="$DEPLOY_PATH" --url="$ENVIRONMENT_URL" --title="{{PROJECT_NAME}}" --admin_user=admin --admin_password=admin --admin_email={{TEAM_EMAIL}}

# Limpeza de cache
echo "🧹 Clearing caches..."
wp cache flush --path="$DEPLOY_PATH"

echo "✅ Deploy completed successfully!"
```

## 💾 **Backup e Recuperação**

### **Estratégia de Backup**

```bash
#!/bin/bash
# scripts/backup.sh

set -e

BACKUP_DIR="/backups"
DATE=$(date +%Y%m%d-%H%M%S)

echo "📦 Creating backup..."

# Backup do banco de dados
mysqldump -u root -ppassword wordpress > "$BACKUP_DIR/db-backup-$DATE.sql"

# Backup dos arquivos
tar -czf "$BACKUP_DIR/files-backup-$DATE.tar.gz" /var/www/html

# Limpeza de backups antigos (manter últimos 7 dias)
find "$BACKUP_DIR" -name "*.sql" -mtime +7 -delete
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +7 -delete

echo "✅ Backup completed successfully!"
```

### **Script de Recuperação**

```bash
#!/bin/bash
# scripts/restore.sh

set -e

BACKUP_FILE=$1
DEPLOY_PATH="/var/www/html"

echo "🔄 Restoring from $BACKUP_FILE..."

# Restaurar backup
tar -xzf "$BACKUP_FILE" -C /

# Limpar caches
wp cache flush --path="$DEPLOY_PATH"

echo "✅ Restore completed successfully!"
```

## 🔍 **Monitoramento**

### **Health Checks**

```php
// wp-content/mu-plugins/health-check.php
<?php
function health_check() {
    $checks = [
        'database' => check_database_connection(),
        'file_system' => check_file_permissions(),
        'cache' => check_cache_connection(),
        'plugins' => check_plugin_status()
    ];

    $status = array_filter($checks) ? 'healthy' : 'unhealthy';

    header('Content-Type: application/json');
    echo json_encode([
        'status' => $status,
        'checks' => $checks,
        'timestamp' => date('c')
    ]);

    exit;
}

function check_database_connection() {
    global $wpdb;
    return $wpdb->check_connection();
}

function check_file_permissions() {
    return is_writable(WP_CONTENT_DIR);
}

function check_cache_connection() {
    return wp_cache_get('health_check') !== false;
}

function check_plugin_status() {
    return !get_option('active_plugins') || count(get_option('active_plugins')) > 0;
}

add_action('wp_ajax_health_check', 'health_check');
add_action('wp_ajax_nopriv_health_check', 'health_check');
```

### **Logs e Debugging**

```php
// wp-content/mu-plugins/logging.php
<?php
function custom_log($message, $level = 'info', $context = []) {
    if (!WP_DEBUG_LOG) {
        return;
    }

    $log_entry = [
        'timestamp' => date('Y-m-d H:i:s'),
        'level' => strtoupper($level),
        'message' => $message,
        'context' => $context,
        'user_id' => get_current_user_id(),
        'url' => $_SERVER['REQUEST_URI'] ?? 'unknown'
    ];

    error_log(json_encode($log_entry) . PHP_EOL, 3, WP_CONTENT_DIR . '/debug.log');
}

// Log de erros
add_action('wp_error_added', function($code, $message, $data) {
    custom_log($message, 'error', ['code' => $code, 'data' => $data]);
}, 10, 3);

// Log de queries lentas
add_filter('query', function($query) {
    $start = microtime(true);

    return function($result) use ($query, $start) {
        $time = microtime(true) - $start;
        if ($time > 1.0) { // Log queries que demoram mais de 1 segundo
            custom_log("Slow query detected", 'warning', [
                'query' => $query,
                'time' => $time
            ]);
        }
        return $result;
    };
});
```

## 🔐 **Segurança**

### **Configurações de Segurança**

```php
// wp-config.php
// Desabilitar edição de arquivos via admin
define('DISALLOW_FILE_EDIT', true);
define('DISALLOW_FILE_MODS', true);

// Forçar HTTPS no admin
define('FORCE_SSL_ADMIN', true);

// Atualizações automáticas
define('WP_AUTO_UPDATE_CORE', true);

// Chaves de segurança únicas
define('AUTH_KEY', 'unique-phrase-here');
define('SECURE_AUTH_KEY', 'unique-phrase-here');
define('LOGGED_IN_KEY', 'unique-phrase-here');
define('NONCE_KEY', 'unique-phrase-here');
define('AUTH_SALT', 'unique-phrase-here');
define('SECURE_AUTH_SALT', 'unique-phrase-here');
define('LOGGED_IN_SALT', 'unique-phrase-here');
define('NONCE_SALT', 'unique-phrase-here');
```

### **Firewall e Proteção**

```nginx
# config/security.conf
# Proteção contra ataques comuns
location ~* \.(php|php3|php4|php5|phtml|pl|py|jsp|asp|sh|cgi)$ {
    deny all;
}

# Proteção contra SQL injection
location ~* union.*select {
    deny all;
}

# Proteção contra XSS
location ~* <script {
    deny all;
}

# Rate limiting
limit_req_zone $binary_remote_addr zone=login:10m rate=1r/s;
location /wp-login.php {
    limit_req zone=login burst=5 nodelay;
}
```

## 📊 **Performance**

### **Otimizações de Cache**

```php
// wp-content/mu-plugins/cache.php
<?php
// Cache de objetos
wp_cache_add_object_cache();

// Cache de páginas
wp_cache_add_page_cache();

// Cache de consultas
add_action('init', function() {
    if (!is_admin()) {
        wp_cache_add_query_cache();
    }
});

// Cache de transients
add_filter('transient_expiration', function($expiration, $transient) {
    if (strpos($transient, 'api_') === 0) {
        return 3600; // 1 hora para APIs
    }
    return $expiration;
}, 10, 2);
```

### **Otimizações de Banco**

```sql
-- Otimizações de tabelas WordPress
OPTIMIZE TABLE wp_posts;
OPTIMIZE TABLE wp_postmeta;
OPTIMIZE TABLE wp_options;

-- Índices para performance
CREATE INDEX idx_post_status_date ON wp_posts(post_status, post_date);
CREATE INDEX idx_meta_key_value ON wp_postmeta(meta_key, meta_value);
CREATE INDEX idx_option_name ON wp_options(option_name);
```

## 📚 **Recursos Adicionais**

### **Documentação**
- [Lando Documentation](https://docs.lando.dev/)
- [Docker Documentation](https://docs.docker.com/)
- [GitLab CI/CD Documentation](https://docs.gitlab.com/ee/ci/)
- [WordPress Deployment](https://developer.wordpress.org/advanced-administration/deployment/)

### **Ferramentas**
- [Lando](https://lando.dev/) - Local development
- [Docker](https://docker.com/) - Containerization
- [GitLab CI/CD](https://gitlab.com/features/gitlab-ci-cd) - Pipeline automation

---

📝 **Última atualização**: {{CURRENT_DATE}}
🔄 **Versão**: {{PROJECT_VERSION}}
✨ **Infraestrutura**: Lando + Docker + GitLab CI/CD