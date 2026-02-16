# Git Planning Commit

Commit planning artifacts using the mario-tools CLI, which automatically checks `commit_docs` config and gitignore status.

## Commit via CLI

Always use `mario-tools commit` for `.planning/` files — it handles `commit_docs` and gitignore checks automatically:

```bash
mario-tools commit "docs({scope}): {description}" --files .planning/STATE.md .planning/BACKLOG.md
```

The CLI will return `skipped` (with reason) if `commit_docs` is `false` or `.planning/` is gitignored. No manual conditional checks needed.

## Amend previous commit

To fold `.planning/` file changes into the previous commit:

```bash
mario-tools commit "" --files .planning/codebase/*.md --amend
```

## Commit Message Patterns

| Command | Scope | Example |
|---------|-------|---------|
| plan | plan | `docs(plan-003): create authentication plans` |
| execute | plan | `docs(plan-003): complete authentication plan` |

## When to Skip

- `commit_docs: false` in config
- `.planning/` is gitignored
- No changes to commit (check with `git status --porcelain .planning/`)
