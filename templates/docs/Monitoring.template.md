# 📊 Monitoring

Guia completo do monitoramento do projeto **{{PROJECT_NAME}}**, com foco em observabilidade, alertas e métricas de performance.

## 🎯 **Visão Geral**

O sistema de monitoramento do projeto **{{PROJECT_NAME}}** é projetado para garantir alta disponibilidade, performance otimizada e detecção proativa de problemas.

### **Principais Objetivos**
- **Disponibilidade**: 99.9% uptime
- **Performance**: Page load < 2 segundos
- **Segurança**: Detecção de vulnerabilidades
- **Qualidade**: Monitoramento de erros
- **Experiência**: Core Web Vitals otimizados

## 🔍 **Health Checks**

### **Endpoint de Health Check**

```php
// wp-content/mu-plugins/health-check.php
<?php
function health_check_endpoint() {
    $checks = [
        'database' => check_database_health(),
        'file_system' => check_file_system_health(),
        'cache' => check_cache_health(),
        'plugins' => check_plugins_health(),
        'themes' => check_themes_health(),
        'uploads' => check_uploads_health()
    ];

    $overall_status = array_filter($checks) ? 'healthy' : 'unhealthy';
    $response_code = $overall_status === 'healthy' ? 200 : 503;

    http_response_code($response_code);
    header('Content-Type: application/json');

    echo json_encode([
        'status' => $overall_status,
        'timestamp' => date('c'),
        'version' => '{{PROJECT_VERSION}}',
        'environment' => WP_ENV,
        'checks' => $checks
    ]);

    exit;
}

function check_database_health() {
    global $wpdb;

    try {
        $result = $wpdb->get_var("SELECT 1");
        return $result === '1';
    } catch (Exception $e) {
        return false;
    }
}

function check_file_system_health() {
    return [
        'wp_content_writable' => is_writable(WP_CONTENT_DIR),
        'uploads_writable' => is_writable(WP_CONTENT_DIR . '/uploads'),
        'cache_writable' => is_writable(WP_CONTENT_DIR . '/cache')
    ];
}

function check_cache_health() {
    $test_key = 'health_check_' . time();
    $test_value = 'test_value';

    wp_cache_set($test_key, $test_value, 'health', 60);
    $retrieved = wp_cache_get($test_key, 'health');

    return $retrieved === $test_value;
}

function check_plugins_health() {
    $active_plugins = get_option('active_plugins');
    $plugin_errors = [];

    foreach ($active_plugins as $plugin) {
        if (!file_exists(WP_PLUGIN_DIR . '/' . $plugin)) {
            $plugin_errors[] = $plugin;
        }
    }

    return [
        'active_count' => count($active_plugins),
        'errors' => $plugin_errors,
        'healthy' => empty($plugin_errors)
    ];
}

function check_themes_health() {
    $current_theme = get_stylesheet();
    $theme_path = get_template_directory();

    return [
        'current_theme' => $current_theme,
        'theme_exists' => file_exists($theme_path . '/style.css'),
        'theme_readable' => is_readable($theme_path . '/style.css')
    ];
}

function check_uploads_health() {
    $upload_dir = wp_upload_dir();

    return [
        'upload_dir_writable' => is_writable($upload_dir['basedir']),
        'upload_url_accessible' => wp_remote_get($upload_dir['baseurl'])['response']['code'] === 200
    ];
}

// Registrar endpoint
add_action('wp_ajax_health_check', 'health_check_endpoint');
add_action('wp_ajax_nopriv_health_check', 'health_check_endpoint');

// Endpoint público
add_action('init', function() {
    if ($_SERVER['REQUEST_URI'] === '/health') {
        health_check_endpoint();
    }
});
```

### **URLs de Health Check**

| Ambiente | URL | Método | Finalidade |
|----------|-----|--------|------------|
| **Local** | `{{LOCAL_URL}}/health` | GET | Verificação local |
| **Development** | `{{DEVELOPMENT_URL}}/health` | GET | Monitoramento dev |
| **Staging** | `{{STAGING_URL}}/health` | GET | Monitoramento staging |
| **Production** | `{{PRODUCTION_URL}}/health` | GET | Monitoramento produção |

## 📈 **Métricas de Performance**

### **Core Web Vitals**

```javascript
// wp-content/themes/{{PROJECT_NAME}}/assets/js/web-vitals.js
import {getCLS, getFID, getFCP, getLCP, getTTFB} from 'web-vitals';

function sendToAnalytics(metric) {
    const body = JSON.stringify(metric);
    const url = '/wp-admin/admin-ajax.php?action=web_vitals';

    if (navigator.sendBeacon) {
        navigator.sendBeacon(url, body);
    } else {
        fetch(url, {body, method: 'POST', keepalive: true});
    }
}

getCLS(sendToAnalytics);
getFID(sendToAnalytics);
getFCP(sendToAnalytics);
getLCP(sendToAnalytics);
getTTFB(sendToAnalytics);
```

### **Processamento de Métricas**

```php
// wp-content/mu-plugins/web-vitals.php
<?php
add_action('wp_ajax_web_vitals', 'process_web_vitals');
add_action('wp_ajax_nopriv_web_vitals', 'process_web_vitals');

function process_web_vitals() {
    $input = file_get_contents('php://input');
    $metric = json_decode($input, true);

    if (!$metric) {
        wp_die('Invalid metric data');
    }

    // Armazenar métrica
    $metrics = get_option('web_vitals_metrics', []);
    $metrics[] = [
        'name' => $metric['name'],
        'value' => $metric['value'],
        'rating' => $metric['rating'],
        'timestamp' => current_time('mysql'),
        'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? '',
        'url' => $_SERVER['HTTP_REFERER'] ?? ''
    ];

    // Manter apenas últimas 1000 métricas
    if (count($metrics) > 1000) {
        $metrics = array_slice($metrics, -1000);
    }

    update_option('web_vitals_metrics', $metrics);

    wp_die('OK');
}
```

### **Dashboard de Performance**

```php
// wp-content/mu-plugins/performance-dashboard.php
<?php
add_action('admin_menu', 'add_performance_dashboard');

function add_performance_dashboard() {
    add_management_page(
        'Performance Dashboard',
        'Performance',
        'manage_options',
        'performance-dashboard',
        'render_performance_dashboard'
    );
}

function render_performance_dashboard() {
    $metrics = get_option('web_vitals_metrics', []);

    // Calcular médias
    $averages = [];
    foreach (['CLS', 'FID', 'FCP', 'LCP', 'TTFB'] as $metric) {
        $values = array_filter(array_column($metrics, 'value'), function($m) use ($metric) {
            return strpos($m['name'], $metric) !== false;
        });
        $averages[$metric] = !empty($values) ? array_sum($values) / count($values) : 0;
    }

    ?>
    <div class="wrap">
        <h1>Performance Dashboard</h1>

        <div class="performance-metrics">
            <h2>Core Web Vitals</h2>
            <table class="wp-list-table widefat fixed striped">
                <thead>
                    <tr>
                        <th>Métrica</th>
                        <th>Valor Médio</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($averages as $metric => $value): ?>
                    <tr>
                        <td><?php echo $metric; ?></td>
                        <td><?php echo number_format($value, 3); ?></td>
                        <td><?php echo get_performance_status($metric, $value); ?></td>
                    </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    </div>
    <?php
}

function get_performance_status($metric, $value) {
    $thresholds = [
        'CLS' => [0.1, 0.25],
        'FID' => [100, 300],
        'FCP' => [1800, 3000],
        'LCP' => [2500, 4000],
        'TTFB' => [800, 1800]
    ];

    if (!isset($thresholds[$metric])) {
        return 'N/A';
    }

    [$good, $poor] = $thresholds[$metric];

    if ($value <= $good) {
        return '<span style="color: green;">✅ Good</span>';
    } elseif ($value <= $poor) {
        return '<span style="color: orange;">⚠️ Needs Improvement</span>';
    } else {
        return '<span style="color: red;">❌ Poor</span>';
    }
}
```

## 🚨 **Sistema de Alertas**

### **Alertas de Erro**

```php
// wp-content/mu-plugins/error-alerts.php
<?php
function setup_error_alerts() {
    // Capturar erros fatais
    register_shutdown_function('handle_fatal_error');

    // Capturar exceções não tratadas
    set_exception_handler('handle_uncaught_exception');

    // Capturar erros PHP
    set_error_handler('handle_php_error');
}

function handle_fatal_error() {
    $error = error_get_last();

    if ($error && in_array($error['type'], [E_ERROR, E_PARSE, E_CORE_ERROR, E_COMPILE_ERROR])) {
        send_alert('Fatal Error', [
            'message' => $error['message'],
            'file' => $error['file'],
            'line' => $error['line'],
            'type' => $error['type']
        ]);
    }
}

function handle_uncaught_exception($exception) {
    send_alert('Uncaught Exception', [
        'message' => $exception->getMessage(),
        'file' => $exception->getFile(),
        'line' => $exception->getLine(),
        'trace' => $exception->getTraceAsString()
    ]);
}

function handle_php_error($errno, $errstr, $errfile, $errline) {
    if (!(error_reporting() & $errno)) {
        return false;
    }

    if (in_array($errno, [E_ERROR, E_WARNING, E_PARSE, E_NOTICE])) {
        send_alert('PHP Error', [
            'type' => $errno,
            'message' => $errstr,
            'file' => $errfile,
            'line' => $errline
        ]);
    }

    return false;
}

function send_alert($type, $data) {
    $alert = [
        'type' => $type,
        'data' => $data,
        'timestamp' => current_time('mysql'),
        'url' => $_SERVER['REQUEST_URI'] ?? '',
        'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? '',
        'ip' => $_SERVER['REMOTE_ADDR'] ?? ''
    ];

    // Salvar alerta
    $alerts = get_option('error_alerts', []);
    $alerts[] = $alert;

    // Manter apenas últimos 100 alertas
    if (count($alerts) > 100) {
        $alerts = array_slice($alerts, -100);
    }

    update_option('error_alerts', $alerts);

    // Enviar notificação (se configurado)
    if (get_option('send_error_notifications', false)) {
        send_error_notification($alert);
    }
}

function send_error_notification($alert) {
    $to = get_option('admin_email');
    $subject = 'Error Alert: ' . $alert['type'];
    $message = "Error Alert\n\n";
    $message .= "Type: " . $alert['type'] . "\n";
    $message .= "Time: " . $alert['timestamp'] . "\n";
    $message .= "URL: " . $alert['url'] . "\n";
    $message .= "Data: " . json_encode($alert['data'], JSON_PRETTY_PRINT) . "\n";

    wp_mail($to, $subject, $message);
}

// Inicializar sistema de alertas
add_action('init', 'setup_error_alerts');
```

### **Alertas de Performance**

```php
// wp-content/mu-plugins/performance-alerts.php
<?php
add_action('wp_ajax_performance_check', 'check_performance_alerts');

function check_performance_alerts() {
    $metrics = get_option('web_vitals_metrics', []);
    $recent_metrics = array_filter($metrics, function($metric) {
        return strtotime($metric['timestamp']) > time() - 3600; // Última hora
    });

    $alerts = [];

    // Verificar LCP
    $lcp_values = array_filter(array_column($recent_metrics, 'value'), function($m) {
        return strpos($m['name'], 'LCP') !== false;
    });

    if (!empty($lcp_values)) {
        $avg_lcp = array_sum($lcp_values) / count($lcp_values);
        if ($avg_lcp > 4000) { // 4 segundos
            $alerts[] = [
                'type' => 'performance',
                'metric' => 'LCP',
                'value' => $avg_lcp,
                'threshold' => 4000,
                'message' => 'LCP está acima do limite recomendado'
            ];
        }
    }

    // Verificar CLS
    $cls_values = array_filter(array_column($recent_metrics, 'value'), function($m) {
        return strpos($m['name'], 'CLS') !== false;
    });

    if (!empty($cls_values)) {
        $avg_cls = array_sum($cls_values) / count($cls_values);
        if ($avg_cls > 0.25) { // 0.25
            $alerts[] = [
                'type' => 'performance',
                'metric' => 'CLS',
                'value' => $avg_cls,
                'threshold' => 0.25,
                'message' => 'CLS está acima do limite recomendado'
            ];
        }
    }

    // Salvar alertas
    if (!empty($alerts)) {
        $performance_alerts = get_option('performance_alerts', []);
        $performance_alerts = array_merge($performance_alerts, $alerts);

        // Manter apenas últimos 50 alertas
        if (count($performance_alerts) > 50) {
            $performance_alerts = array_slice($performance_alerts, -50);
        }

        update_option('performance_alerts', $performance_alerts);
    }

    wp_die(json_encode($alerts));
}
```

## 📊 **Logs e Analytics**

### **Sistema de Logging**

```php
// wp-content/mu-plugins/logging.php
<?php
class Logger {
    private $log_file;
    private $max_size = 10485760; // 10MB

    public function __construct($filename = 'app.log') {
        $this->log_file = WP_CONTENT_DIR . '/logs/' . $filename;

        // Criar diretório de logs se não existir
        if (!is_dir(dirname($this->log_file))) {
            wp_mkdir_p(dirname($this->log_file));
        }
    }

    public function log($level, $message, $context = []) {
        $entry = [
            'timestamp' => date('Y-m-d H:i:s'),
            'level' => strtoupper($level),
            'message' => $message,
            'context' => $context,
            'url' => $_SERVER['REQUEST_URI'] ?? '',
            'user_id' => get_current_user_id(),
            'ip' => $_SERVER['REMOTE_ADDR'] ?? ''
        ];

        $log_line = json_encode($entry) . PHP_EOL;

        // Rotacionar log se necessário
        if (file_exists($this->log_file) && filesize($this->log_file) > $this->max_size) {
            $this->rotate_log();
        }

        file_put_contents($this->log_file, $log_line, FILE_APPEND | LOCK_EX);
    }

    private function rotate_log() {
        $backup_file = $this->log_file . '.' . date('Y-m-d-H-i-s');
        rename($this->log_file, $backup_file);

        // Comprimir backup
        if (function_exists('gzopen')) {
            $gz_file = $backup_file . '.gz';
            $gz = gzopen($gz_file, 'w9');
            gzwrite($gz, file_get_contents($backup_file));
            gzclose($gz);
            unlink($backup_file);
        }
    }

    public function info($message, $context = []) {
        $this->log('info', $message, $context);
    }

    public function warning($message, $context = []) {
        $this->log('warning', $message, $context);
    }

    public function error($message, $context = []) {
        $this->log('error', $message, $context);
    }

    public function debug($message, $context = []) {
        if (WP_DEBUG) {
            $this->log('debug', $message, $context);
        }
    }
}

// Instância global do logger
global $logger;
$logger = new Logger();

// Função helper
function log_info($message, $context = []) {
    global $logger;
    $logger->info($message, $context);
}

function log_warning($message, $context = []) {
    global $logger;
    $logger->warning($message, $context);
}

function log_error($message, $context = []) {
    global $logger;
    $logger->error($message, $context);
}

function log_debug($message, $context = []) {
    global $logger;
    $logger->debug($message, $context);
}
```

### **Analytics de Uso**

```php
// wp-content/mu-plugins/analytics.php
<?php
add_action('wp_footer', 'track_page_view');

function track_page_view() {
    if (is_admin()) {
        return;
    }

    $analytics_data = [
        'page_url' => $_SERVER['REQUEST_URI'],
        'page_title' => wp_get_document_title(),
        'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? '',
        'ip' => $_SERVER['REMOTE_ADDR'] ?? '',
        'user_id' => get_current_user_id(),
        'timestamp' => current_time('mysql'),
        'post_type' => get_post_type(),
        'post_id' => get_the_ID(),
        'is_mobile' => wp_is_mobile(),
        'referrer' => $_SERVER['HTTP_REFERER'] ?? ''
    ];

    // Salvar analytics
    $analytics = get_option('page_analytics', []);
    $analytics[] = $analytics_data;

    // Manter apenas últimos 10000 registros
    if (count($analytics) > 10000) {
        $analytics = array_slice($analytics, -10000);
    }

    update_option('page_analytics', $analytics);
}
```

## 🔧 **Configuração de Monitoramento**

### **Configurações do WordPress**

```php
// wp-config.php
// Habilitar logging
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', false);

// Configurações de monitoramento
define('MONITORING_ENABLED', true);
define('PERFORMANCE_TRACKING', true);
define('ERROR_ALERTS', true);
```

### **Cron Jobs para Monitoramento**

```php
// wp-content/mu-plugins/monitoring-cron.php
<?php
add_action('wp', 'setup_monitoring_cron');

function setup_monitoring_cron() {
    if (!wp_next_scheduled('performance_check_cron')) {
        wp_schedule_event(time(), 'hourly', 'performance_check_cron');
    }

    if (!wp_next_scheduled('health_check_cron')) {
        wp_schedule_event(time(), 'every_5_minutes', 'health_check_cron');
    }
}

add_action('performance_check_cron', 'run_performance_check');
add_action('health_check_cron', 'run_health_check');

function run_performance_check() {
    wp_remote_post(home_url('/wp-admin/admin-ajax.php?action=performance_check'));
}

function run_health_check() {
    $health_url = home_url('/health');
    $response = wp_remote_get($health_url);

    if (is_wp_error($response) || wp_remote_retrieve_response_code($response) !== 200) {
        send_alert('Health Check Failed', [
            'url' => $health_url,
            'response_code' => wp_remote_retrieve_response_code($response),
            'response_body' => wp_remote_retrieve_body($response)
        ]);
    }
}
```

## 📚 **Recursos Adicionais**

### **Documentação**
- [WordPress Debugging](https://developer.wordpress.org/advanced-administration/debug/)
- [Core Web Vitals](https://web.dev/vitals/)
- [Performance Monitoring](https://developer.wordpress.org/advanced-administration/performance/)

### **Ferramentas**
- [Web Vitals](https://github.com/GoogleChrome/web-vitals) - Core Web Vitals
- [Lighthouse](https://developers.google.com/web/tools/lighthouse) - Performance auditing
- [GTmetrix](https://gtmetrix.com/) - Performance testing

---

📝 **Última atualização**: {{CURRENT_DATE}}
🔄 **Versão**: {{PROJECT_VERSION}}
✨ **Monitoramento**: Health Checks + Performance + Alertas