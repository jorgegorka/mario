---
name: mario:new-project
description: Initialize a new project with deep context gathering
argument-hint: "[--auto]"
allowed-tools:
  - Read
  - Bash
  - Write
  - Task
  - AskUserQuestion
---
<context>
**Flags:**
- `--auto` — Automatic mode. After config questions, runs research -> requirements -> backlog without further interaction. Expects idea document via @ reference.
</context>

<objective>
Initialize a new project through unified flow: questioning -> research (optional) -> requirements -> backlog.

**Creates:**
- `.planning/PROJECT.md` — project context
- `.planning/config.json` — workflow preferences
- `.planning/research/` — domain research (optional)
- `.planning/REQUIREMENTS.md` — scoped requirements
- `.planning/BACKLOG.md` — plan list
- `.planning/STATE.md` — project memory

**After this command:** Run `/mario:plan 1` to start planning.
</objective>

<execution_context>
@~/.claude/mario/workflows/new-project.md
@~/.claude/mario/references/questioning.md
@~/.claude/mario/references/ui-brand.md
@~/.claude/mario/templates/project.md
@~/.claude/mario/templates/requirements.md
</execution_context>

<process>
Execute the new-project workflow from @~/.claude/mario/workflows/new-project.md end-to-end.
Preserve all workflow gates (validation, approvals, commits, routing).
</process>
