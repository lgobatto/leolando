module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    // Regras personalizadas para o projeto {{PROJECT_NAME}}
    'type-enum': [
      2,
      'always',
      [
        'feat',     // 🚀 Novas funcionalidades
        'fix',      // 🐛 Correções de bugs
        'docs',     // 📚 Documentação
        'style',    // 🎨 Alterações que não afetam o código (espaços, formatação, etc)
        'refactor', // ♻️ Refatoração de código
        'perf',     // ⚡ Melhorias de performance
        'test',     // 🧪 Adicionando ou corrigindo testes
        'build',    // 🔧 Alterações no sistema de build ou dependências externas
        'ci',       // 🔄 Alterações em arquivos de CI/CD
        'chore',    // 🧹 Outras alterações que não afetam src ou test
        'revert',   // ↩️ Reverte um commit anterior
        'wip',      // 🚧 Work in progress
        'hotfix'    // 🔥 Correções urgentes para produção
      ]
    ],
    'type-case': [2, 'always', 'lower'],
    'type-empty': [2, 'never'],
    'subject-case': [2, 'always', 'lower'],
    'subject-empty': [2, 'never'],
    'subject-full-stop': [2, 'never', '.'],
    'header-max-length': [2, 'always', 72],
    'body-leading-blank': [2, 'always'],
    'footer-leading-blank': [2, 'always']
  },
  // Configurações adicionais para o projeto
  helpUrl: '{{GIT_REPO_URL}}/blob/main/docs/gitflow-workflow.md#conventional-commits',
  prompt: {
    questions: {
      type: {
        description: 'Selecione o tipo de alteração que você está fazendo:',
        enum: {
          feat: {
            description: '🚀 Nova funcionalidade para o usuário',
            title: 'Features',
            emoji: '🚀',
          },
          fix: {
            description: '🐛 Correção de bug para o usuário',
            title: 'Bug Fixes',
            emoji: '🐛',
          },
          docs: {
            description: '📚 Alteração na documentação',
            title: 'Documentation',
            emoji: '📚',
          },
          style: {
            description: '🎨 Alteração que não afeta o código (espaços, formatação, etc)',
            title: 'Styles',
            emoji: '🎨',
          },
          refactor: {
            description: '♻️ Refatoração de código de produção',
            title: 'Code Refactoring',
            emoji: '♻️',
          },
          perf: {
            description: '⚡ Melhoria de performance',
            title: 'Performance Improvements',
            emoji: '⚡',
          },
          test: {
            description: '🧪 Adicionando ou corrigindo testes',
            title: 'Tests',
            emoji: '🧪',
          },
          build: {
            description: '🔧 Alterações no sistema de build ou dependências externas',
            title: 'Builds',
            emoji: '🔧',
          },
          ci: {
            description: '🔄 Alterações em arquivos de CI/CD',
            title: 'Continuous Integrations',
            emoji: '🔄',
          },
          chore: {
            description: '🧹 Outras alterações que não afetam src ou test',
            title: 'Chores',
            emoji: '🧹',
          },
          revert: {
            description: '↩️ Reverte um commit anterior',
            title: 'Reverts',
            emoji: '↩️',
          },
          wip: {
            description: '🚧 Work in progress',
            title: 'Work in Progress',
            emoji: '🚧',
          },
          hotfix: {
            description: '🔥 Correções urgentes para produção',
            title: 'Hotfixes',
            emoji: '🔥',
          },
        },
      },
      subject: {
        description: 'Escreva uma descrição curta e imperativa da mudança',
      },
      body: {
        description: 'Forneça uma descrição mais detalhada da mudança',
      },
      isBreaking: {
        description: 'Há alguma mudança que quebra a compatibilidade?',
      },
      breakingBody: {
        description: 'Uma descrição das mudanças que quebram a compatibilidade',
      },
      breaking: {
        description: 'Descreva as mudanças que quebram a compatibilidade',
      },
      isIssueAffected: {
        description: 'Esta mudança afeta algum issue aberto?',
      },
      issuesBody: {
        description: 'Se as issues são fechadas, a chave de fechamento deve ser adicionada',
      },
      issues: {
        description: 'Adicione referências de issues (ex: "fix #123", "re #123".)',
      },
    },
  },
};