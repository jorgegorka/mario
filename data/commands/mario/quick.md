---
name: mario:quick
description: Execute a quick task with Mario guarantees (atomic commits, state tracking) but skip optional agents
argument-hint: ""
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - Task
  - AskUserQuestion
---
<objective>
Execute small, ad-hoc tasks with Mario guarantees (atomic commits, STATE.md tracking) while skipping optional agents (research, plan-checker, verifier).

Quick mode is the same system with a shorter path:
- Spawns mario-planner (quick mode) + mario-executor(s)
- Skips mario-plan-checker, mario-verifier
- Quick tasks become regular plans in `.mario_planning/plans/`
- Updates STATE.md and BACKLOG.md

Use when: You know exactly what to do and the task is small enough to not need research or verification.
</objective>

<execution_context>
@~/.claude/mario/workflows/quick.md
</execution_context>

<context>
@.mario_planning/BACKLOG.md
@.mario_planning/STATE.md
</context>

<process>
Execute the quick workflow from @~/.claude/mario/workflows/quick.md end-to-end.
Preserve all workflow gates (validation, task description, planning, execution, state updates, commits).
</process>
