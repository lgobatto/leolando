# 🌿 GitFlow Workflow - Leolando

Este documento descreve o fluxo de trabalho GitFlow implementado no projeto Leolando, incluindo as regras de branching, commits e releases.

## 📋 Visão Geral

Nosso GitFlow é baseado no modelo tradicional, mas adaptado para projetos WordPress com CI/CD moderno e ambiente Lando:

```
master/main (produção)
├── develop (desenvolvimento)
├── staging (pré-produção)
├── feature/* (funcionalidades)
├── hotfix/* (correções urgentes)
└── release/* (preparação de releases)
```

## 🌿 Estrutura de Branches

### **Branches Principais**

#### `master/main` (Produção)
- **Propósito**: Código em produção
- **Proteção**: Merge apenas via Pull/Merge Request
- **Deploy**: Automático via Release Please
- **Commits**: Apenas merges de `staging` ou `hotfix/*`

#### `develop` (Desenvolvimento)
- **Propósito**: Integração de features
- **Proteção**: Merge apenas via Pull/Merge Request
- **Deploy**: Automático para ambiente de desenvolvimento
- **Commits**: Merges de `feature/*` e `hotfix/*`

#### `staging` (Pré-Produção)
- **Propósito**: Testes finais antes da produção
- **Proteção**: Merge apenas via Pull/Merge Request
- **Deploy**: Automático para ambiente de staging
- **Commits**: Merges de `develop` e `release/*`

### **Branches de Trabalho**

#### `feature/*` (Funcionalidades)
- **Padrão**: `feature/nome-da-funcionalidade`
- **Base**: `develop`
- **Destino**: `develop`
- **Exemplo**: `feature/user-authentication`

#### `hotfix/*` (Correções Urgentes)
- **Padrão**: `hotfix/descricao-do-bug`
- **Base**: `master/main`
- **Destino**: `master/main` e `develop`
- **Exemplo**: `hotfix/security-vulnerability`

#### `release/*` (Preparação de Release)
- **Padrão**: `release/v1.2.3`
- **Base**: `develop`
- **Destino**: `staging` e `master/main`
- **Exemplo**: `release/v1.2.0`

## 📝 Conventional Commits

Todos os commits devem seguir o padrão Conventional Commits:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### **Tipos de Commit**

| Tipo | Descrição | Exemplo |
|------|-----------|---------|
| `feat` | Nova funcionalidade | `feat: adiciona autenticação de usuário` |
| `fix` | Correção de bug | `fix: corrige erro de validação de email` |
| `docs` | Documentação | `docs: atualiza README com novas instruções` |
| `style` | Formatação | `style: corrige indentação do código` |
| `refactor` | Refatoração | `refactor: reorganiza estrutura de classes` |
| `perf` | Performance | `perf: otimiza consultas do banco de dados` |
| `test` | Testes | `test: adiciona testes para autenticação` |
| `build` | Build | `build: atualiza dependências do composer` |
| `ci` | CI/CD | `ci: adiciona workflow de deploy automático` |
| `chore` | Manutenção | `chore: atualiza versão do PHP` |
| `revert` | Reverter | `revert: reverte mudança que causou bug` |
| `wip` | Work in Progress | `wip: implementação parcial do dashboard` |
| `hotfix` | Correção urgente | `hotfix: corrige vulnerabilidade de segurança` |

### **Exemplos de Commits**

```bash
# Nova funcionalidade
feat(auth): adiciona autenticação via OAuth2

# Correção de bug
fix(validation): corrige validação de CPF

# Documentação
docs: atualiza instruções de instalação

# Refatoração
refactor(database): reorganiza queries para melhor performance

# Hotfix
hotfix: corrige vulnerabilidade XSS no formulário de contato
```

## 🔄 Fluxo de Trabalho

### **1. Iniciando uma Nova Feature**

```bash
# 1. Atualizar develop
git checkout develop
git pull origin develop

# 2. Criar branch da feature
git checkout -b feature/nova-funcionalidade

# 3. Desenvolver e commitar (usando Lando)
git add .
lando npm run commit

# 4. Fazer push
git push origin feature/nova-funcionalidade
```

### **2. Finalizando uma Feature**

```bash
# 1. Atualizar feature com develop
git checkout feature/nova-funcionalidade
git rebase develop

# 2. Fazer push forçado (se necessário)
git push origin feature/nova-funcionalidade --force-with-lease

# 3. Criar Pull/Merge Request para develop
# 4. Aguardar aprovação e merge
```

### **3. Preparando Release**

```bash
# 1. Criar branch de release
git checkout develop
git checkout -b release/v1.2.0

# 2. Fazer ajustes finais (version, changelog, etc.)
# 3. Commitar mudanças
lando npm run commit

# 4. Fazer merge para staging
git checkout staging
git merge release/v1.2.0

# 5. Fazer merge para master (após testes)
git checkout master
git merge release/v1.2.0

# 6. Criar tag
git tag -a v1.2.0 -m "Release v1.2.0"
git push origin v1.2.0
```

### **4. Hotfix Urgente**

```bash
# 1. Criar branch de hotfix
git checkout master
git checkout -b hotfix/correcao-urgente

# 2. Fazer correção
lando npm run commit

# 3. Fazer merge para master
git checkout master
git merge hotfix/correcao-urgente

# 4. Fazer merge para develop
git checkout develop
git merge hotfix/correcao-urgente

# 5. Criar tag
git tag -a v1.1.1 -m "Hotfix v1.1.1"
git push origin v1.1.1
```

## 🛡️ Branch Protection Rules

### **GitHub**

```yaml
# master/main
- Require pull request reviews before merging
- Require status checks to pass before merging
- Require branches to be up to date before merging
- Include administrators
- Restrict pushes that create files that match the specified pattern

# develop
- Require pull request reviews before merging
- Require status checks to pass before merging
- Require branches to be up to date before merging

# staging
- Require pull request reviews before merging
- Require status checks to pass before merging
- Require branches to be up to date before merging
```

### **GitLab**

```yaml
# master/main
- Allowed to merge: Maintainers
- Allowed to push: No one
- Code owner approval required: Yes

# develop
- Allowed to merge: Developers
- Allowed to push: No one

# staging
- Allowed to merge: Maintainers
- Allowed to push: No one
```

## 🚀 Release Process

### **Automático (Recomendado)**
1. Commits seguem Conventional Commits
2. Release Please detecta mudanças
3. Cria Pull/Merge Request automático
4. Aprovação manual
5. Deploy automático

### **Manual**
```bash
# Gerar changelog e nova versão
lando npm run release

# Ou especificar versão
lando npm run release:minor
lando npm run release:major
lando npm run release:patch
```

## 📋 Checklist de Qualidade

### **Antes do Merge**
- [ ] Commits seguem Conventional Commits
- [ ] Código passa nos testes
- [ ] Documentação atualizada
- [ ] Changelog atualizado (se aplicável)
- [ ] Review aprovado

### **Antes do Release**
- [ ] Todos os testes passando
- [ ] Documentação atualizada
- [ ] Changelog gerado
- [ ] Version bump correto
- [ ] Deploy de staging testado

## 🔧 Ferramentas e Scripts

### **Husky Hooks (via Lando)**
- `pre-commit`: Executa linting via Lando
- `commit-msg`: Valida formato do commit via Lando

### **Scripts NPM (via Lando)**
- `lando npm run commit`: Commit interativo
- `lando npm run release`: Gera release
- `lando npm run lint`: Executa linting
- `lando npm run test`: Executa testes

### **Ferramentas**
- **Commitizen**: Commits interativos
- **Commitlint**: Validação de commits
- **Standard Version**: Geração de releases
- **Husky**: Git hooks
- **Lando**: Ambiente de desenvolvimento

## 🆘 Troubleshooting

### **Erro de Commit Rejeitado**
```bash
# Verificar formato do commit
git log --oneline -5

# Usar commit interativo via Lando
lando npm run commit
```

### **Conflitos de Merge**
```bash
# Atualizar branch base
git checkout develop
git pull origin develop

# Rebase da feature
git checkout feature/minha-feature
git rebase develop

# Resolver conflitos e continuar
git rebase --continue
```

### **Reverter Commit**
```bash
# Reverter último commit
git revert HEAD

# Reverter commit específico
git revert <commit-hash>
```

### **Problemas com Lando**
```bash
# Verificar status do Lando
lando info

# Reiniciar Lando
lando restart

# Rebuild do ambiente
lando rebuild

# Verificar logs
lando logs
```

## 🐳 Ambiente Lando

### **Serviços Disponíveis**
- **appserver**: PHP + Nginx + WordPress
- **node**: Node.js para ferramentas DevOps
- **cache**: Redis para cache
- **database**: MySQL/MariaDB

### **Comandos Lando Úteis**
```bash
# Informações do ambiente
lando info

# Acessar serviços
lando ssh appserver
lando ssh node

# Executar comandos
lando composer install
lando wp --info
lando npm install

# Logs
lando logs
lando logs appserver
```

---

**📚 Recursos Adicionais:**
- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitFlow](https://nvie.com/posts/a-successful-git-branching-model/)
- [Release Please](https://github.com/googleapis/release-please)
- [Lando Documentation](https://docs.lando.dev/)