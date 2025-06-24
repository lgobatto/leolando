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
  commitUrlFormat: '{{GIT_REPO_URL}}/commit/{{hash}}',
  compareUrlFormat: '{{GIT_REPO_URL}}/compare/{{previousTag}}...{{currentTag}}',
  issueUrlFormat: '{{GIT_REPO_URL}}/issues/{{id}}',
  userUrlFormat: 'https://github.com/{{user}}'
};