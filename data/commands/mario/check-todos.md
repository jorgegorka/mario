---
name: mario:check-todos
description: List pending todos and select one to work on
argument-hint: [area filter]
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

<objective>
List all pending todos, allow selection, load full context for the selected todo, and route to appropriate action.

Routes to the check-todos workflow which handles:
- Todo counting and listing with area filtering
- Interactive selection with full context loading
- Backlog correlation checking
- Action routing (work now, add to backlog, brainstorm)
- STATE.md updates and git commits
</objective>

<execution_context>
@.planning/STATE.md
@.planning/BACKLOG.md
@~/.claude/mario/workflows/check-todos.md
</execution_context>

<process>
**Follow the check-todos workflow** from `@~/.claude/mario/workflows/check-todos.md`.

The workflow handles all logic including:
1. Todo existence checking
2. Area filtering
3. Interactive listing and selection
4. Full context loading with file summaries
5. Backlog correlation checking
6. Action offering and execution
7. STATE.md updates
8. Git commits
</process>
