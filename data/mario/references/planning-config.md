<planning_config>

Configuration options for `.planning/` directory behavior.

<config_schema>
```json
"planning": {
  "model_profile": "balanced",
  "commit_docs": true,
  "search_gitignored": false,
  "research": true,
  "execution_mode": "sequential",
  "team_execution": false
}
```

| Option | Default | Description |
|--------|---------|-------------|
| `model_profile` | `"balanced"` | Model profile for agent resolution: `"quality"`, `"balanced"`, or `"budget"` |
| `commit_docs` | `true` | Whether to commit planning artifacts to git |
| `search_gitignored` | `false` | Add `--no-ignore` to broad rg searches |
| `research` | `true` | Whether to run research before planning |
| `execution_mode` | `"sequential"` | Plan execution mode: `"sequential"` or `"parallel"` |
| `team_execution` | `false` | Whether to use multi-agent team execution |
</config_schema>

<commit_docs_behavior>

**When `commit_docs: true` (default):**
- Planning files committed normally
- SUMMARY.md, STATE.md, BACKLOG.md tracked in git
- Full history of planning decisions preserved

**When `commit_docs: false`:**
- Skip all `git add`/`git commit` for `.planning/` files
- User must add `.planning/` to `.gitignore`
- Useful for: OSS contributions, client projects, keeping planning private

**Using mario-tools (preferred):**

```bash
# Commit with automatic commit_docs + gitignore checks:
mario-tools commit "docs: update state" --files .planning/STATE.md

# Load config via state load (returns JSON):
INIT=$(mario-tools state load)
# commit_docs is available in the JSON output

# Or use init commands which include commit_docs:
INIT=$(mario-tools init execute "1")
# commit_docs is included in all init command outputs
```

**Auto-detection:** If `.planning/` is gitignored, `commit_docs` is automatically `false` regardless of config.json. This prevents git errors when users have `.planning/` in `.gitignore`.

**Commit via CLI (handles checks automatically):**

```bash
mario-tools commit "docs: update state" --files .planning/STATE.md
```

The CLI checks `commit_docs` config and gitignore status internally — no manual conditionals needed.

</commit_docs_behavior>

<search_behavior>

**When `search_gitignored: false` (default):**
- Standard rg behavior (respects .gitignore)
- Direct path searches work: `rg "pattern" .planning/` finds files
- Broad searches skip gitignored: `rg "pattern"` skips `.planning/`

**When `search_gitignored: true`:**
- Add `--no-ignore` to broad rg searches that should include `.planning/`
- Only needed when searching entire repo and expecting `.planning/` matches

**Note:** Most Mario operations use direct file reads or explicit paths, which work regardless of gitignore status.

</search_behavior>

<setup_uncommitted_mode>

To use uncommitted mode:

1. **Set config:**
   ```json
   "planning": {
     "commit_docs": false,
     "search_gitignored": true
   }
   ```

2. **Add to .gitignore:**
   ```
   .planning/
   ```

3. **Existing tracked files:** If `.planning/` was previously tracked:
   ```bash
   git rm -r --cached .planning/
   git commit -m "chore: stop tracking planning docs"
   ```

</setup_uncommitted_mode>

</planning_config>
