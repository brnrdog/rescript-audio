# Contributing

This project uses [Conventional Commits](https://www.conventionalcommits.org/) for automatic versioning and changelog generation.

## Development Setup

```bash
npm install
npm run build
npm test
npm run watch  # Development mode
```

## Commit Message Format

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

## Types

| Type | Description | Version Bump |
|------|-------------|--------------|
| `feat` | New feature | Minor |
| `fix` | Bug fix | Patch |
| `perf` | Performance improvement | Patch |
| `refactor` | Code refactoring | Patch |
| `docs` | Documentation changes | Patch (README only) |
| `chore` | Maintenance tasks | No release |
| `test` | Test changes | No release |

## Breaking Changes

Add `BREAKING CHANGE:` in the commit footer or `!` after the type for major version bumps:

```
feat!: remove deprecated API

BREAKING CHANGE: The old API has been removed.
```

## Examples

```bash
git commit -m "feat(oscillator): add custom waveform support"
git commit -m "fix(gain): correct parameter range validation"
git commit -m "docs(README): add filter examples"
```

## Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feat/amazing-feature`)
3. Make your changes
4. Run tests (`npm test`)
5. Commit using conventional commits
6. Push to your fork
7. Open a Pull Request

## Release Process

Releases are automated via semantic-release. When commits are pushed to `main`:

1. Commit messages are analyzed
2. Version is bumped based on commit types
3. Changelog is generated
4. Package is published to npm
5. GitHub release is created
