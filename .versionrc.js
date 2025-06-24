module.exports = {
  types: [
    { type: 'feat', section: '🚀 Novas Funcionalidades' },
    { type: 'fix', section: '🐛 Correções de Bugs' },
    { type: 'docs', section: '📚 Documentação' },
    { type: 'style', section: '🎨 Estilo' },
    { type: 'refactor', section: '♻️ Refatoração' },
    { type: 'perf', section: '⚡ Performance' },
    { type: 'test', section: '🧪 Testes' },
    { type: 'build', section: '🔧 Build' },
    { type: 'ci', section: '🔄 CI/CD' },
    { type: 'chore', section: '🧹 Manutenção' },
    { type: 'revert', section: '↩️ Revert' },
    { type: 'wip', section: '🚧 Work in Progress' },
    { type: 'hotfix', section: '🔥 Hotfix' }
  ],
  releaseCommitMessageFormat: 'chore(release): 📦 {{currentTag}}',
  issuePrefixes: ['#'],
  commitUrlFormat: 'https://github.com/codigodoleo/leolando/commit/{{hash}}',
  compareUrlFormat: 'https://github.com/codigodoleo/leolando/compare/{{previousTag}}...{{currentTag}}',
  issueUrlFormat: 'https://github.com/codigodoleo/leolando/issues/{{id}}',
  userUrlFormat: 'https://github.com/{{user}}'
};