module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    // Regras personalizadas para nosso projeto
    'type-enum': [
      2,
      'always',
      [
        'feat',     // Novas funcionalidades
        'fix',      // Correções de bugs
        'docs',     // Documentação
        'style',    // Alterações que não afetam o código (espaços, formatação, etc)
        'refactor', // Refatoração de código
        'perf',     // Melhorias de performance
        'test',     // Adicionando ou corrigindo testes
        'build',    // Alterações no sistema de build ou dependências externas
        'ci',       // Alterações em arquivos de CI/CD
        'chore',    // Outras alterações que não afetam src ou test
        'revert',   // Reverte um commit anterior
        'wip',      // Work in progress
        'hotfix'    // Correções urgentes para produção
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
  }
};