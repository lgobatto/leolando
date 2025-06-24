# 🎯 Integração com Cursor - Leolando

Este documento explica como configurar e usar o Cursor IDE com o projeto Leolando, garantindo que a IA respeite nossos padrões de Conventional Commits e GitFlow.

## 🚀 Configuração Inicial

### **1. Abrir o Projeto no Cursor**

```bash
# Abrir o workspace do projeto
code {PROJECT_NAME}.code-workspace
```

Ou simplesmente:
```bash
# Abrir a pasta do projeto
code .
```

### **2. Instalar Extensões Recomendadas**

O Cursor irá sugerir automaticamente as extensões recomendadas através do workspace. As principais são:

- **GitLens**: Histórico e informações do Git
- **Conventional Commits**: Suporte a Conventional Commits
- **PHP Intelephense**: IntelliSense para PHP
- **WordPress Toolbox**: Ferramentas para WordPress
- **Docker**: Suporte a containers
- **ESLint**: Linting para JavaScript/TypeScript

## 📝 Usando "Generate Commit Message"

### **Como Funciona**

Quando você usar a funcionalidade **"Generate commit message"** do Cursor:

1. **Analise Automática**: A IA analisa as mudanças no código
2. **Padrão Conventional**: Segue automaticamente o formato Conventional Commits
3. **Tipo Correto**: Determina o tipo apropriado (feat, fix, docs, etc.)
4. **Escopo Opcional**: Sugere escopo quando relevante
5. **Descrição Clara**: Gera descrição em inglês e imperativo

### **Exemplos de Commit Messages Geradas**

```bash
# Nova funcionalidade
feat(auth): add user authentication system

# Correção de bug
fix(validation): correct email validation logic

# Documentação
docs: update installation instructions

# Refatoração
refactor(database): optimize database queries

# Hotfix
hotfix: fix critical security vulnerability
```

### **Configurações Específicas**

O arquivo `.cursorrules` contém todas as regras para a IA:

```yaml
cursor.commitMessageRules:
  types: [feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert, wip, hotfix]
  scopes: [auth, api, ui, db, config, docs, tests, ci, build, deploy, security, performance, wordpress, lando]
  maxLength: 72
  subjectMaxLength: 50
```

## 🔧 Workflow com Cursor

### **1. Desenvolvimento Diário**

```bash
# 1. Criar feature branch
git flow feature start minha-feature

# 2. Desenvolver no Cursor
# 3. Fazer commit usando "Generate commit message"
# 4. Finalizar feature
git flow feature finish minha-feature
```

### **2. Usando Source Control**

1. **Stage Changes**: Ctrl+Shift+G → Stage All Changes
2. **Generate Message**: Clique em "Generate commit message"
3. **Review**: Verifique se a mensagem segue o padrão
4. **Commit**: Clique em "Commit"

### **3. Tasks Integradas**

Use Ctrl+Shift+P → "Tasks: Run Task" para executar:

- **🚀 Start Lando**: Inicia o ambiente
- **📦 Install Dependencies**: Instala dependências
- **🔧 Setup GitFlow**: Configura GitFlow
- **🧪 Run Tests**: Executa testes
- **🔍 Run Lint**: Executa linting
- **📝 Interactive Commit**: Commit interativo

## 🎯 Dicas e Truques

### **1. Atalhos Úteis**

```bash
Ctrl+Shift+G          # Source Control
Ctrl+Shift+P          # Command Palette
Ctrl+Shift+`          # Terminal
Ctrl+Shift+D          # Debug
```

### **2. Configurações Personalizadas**

As configurações estão centralizadas no workspace `{PROJECT_NAME}.code-workspace`:

```json
{
  "git.inputValidation": "always",
  "git.inputValidationLength": 72,
  "cursor.commitMessageTemplate": "conventional"
}
```

### **3. Debugging com Xdebug**

1. Configure o debugger no Cursor
2. Use "Listen for Xdebug" configuration
3. Defina breakpoints no código PHP
4. Acesse o site via Lando

## 🤖 IA Assistant Guidelines

### **Quando Gerar Commit Messages**

A IA do Cursor irá:

1. **Analisar Mudanças**: Verificar arquivos modificados
2. **Determinar Tipo**: Escolher o tipo apropriado
3. **Sugerir Escopo**: Quando relevante
4. **Gerar Descrição**: Em inglês e imperativo
5. **Validar Formato**: Seguir Conventional Commits

### **Exemplos de Análise**

```bash
# Arquivo PHP modificado com nova função
feat(auth): add user login functionality

# Arquivo de documentação atualizado
docs: update API documentation

# Correção de bug em validação
fix(validation): correct email format validation

# Refatoração de código
refactor(database): optimize user queries
```

## 🛠️ Troubleshooting

### **Problema: Commit Message não segue padrão**

**Solução:**
1. Verifique se `.cursorrules` está no projeto
2. Reinicie o Cursor
3. Use `lando npm run commit` como alternativa

### **Problema: Extensões não funcionam**

**Solução:**
1. Verifique se as extensões estão instaladas
2. Recarregue o workspace
3. Verifique se está usando o arquivo `.code-workspace`

### **Problema: Lando não funciona no terminal**

**Solução:**
1. Verifique se Lando está instalado
2. Use `lando info` para verificar status
3. Reinicie o terminal integrado

## 📚 Recursos Adicionais

### **Extensões Recomendadas**

- **GitLens**: Histórico detalhado do Git
- **Conventional Commits**: Validação de commits
- **PHP Intelephense**: IntelliSense PHP
- **WordPress Toolbox**: Ferramentas WordPress
- **Docker**: Suporte a containers
- **ESLint**: Linting JavaScript/TypeScript

### **Comandos Úteis**

```bash
# No terminal do Cursor
lando start              # Iniciar ambiente
lando npm run commit     # Commit interativo
lando npm run lint       # Executar linting
lando wp --info         # Info do WordPress
```

### **Configurações Avançadas**

Para configurações mais avançadas, edite:

- `{PROJECT_NAME}.code-workspace`: Configuração completa do workspace
- `.cursorrules`: Regras para IA

---

**🎯 Lembre-se**: O Cursor agora está totalmente integrado com nosso fluxo DevOps! Use "Generate commit message" com confiança - a IA respeitará nossos padrões de Conventional Commits automaticamente.