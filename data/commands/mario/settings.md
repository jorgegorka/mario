---
name: mario:settings
description: Configure settings and model profile
argument-hint: "[profile]"
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

<objective>
Interactive configuration of Mario workflow settings and model profile.

**Two modes:**
- **With argument** (e.g., `/mario:settings quality`): Directly set the model profile without interactive prompts.
- **Without argument**: Interactive multi-question prompt for all settings (model profile, research, plan_check, verifier, branching).

Routes to the settings workflow which handles:
- Config existence ensuring
- Current settings reading and parsing
- Profile validation and setting (quality/balanced/budget)
- Interactive settings prompt (when no argument)
- Config merging and writing
- Confirmation display with model table and quick command references
</objective>

<execution_context>
@~/.claude/mario/workflows/settings.md
</execution_context>

<context>
Profile argument: $ARGUMENTS (optional — opens interactive mode if omitted)
</context>

<process>
**Follow the settings workflow** from `@~/.claude/mario/workflows/settings.md`.

The workflow handles all logic including:
1. Config file creation with defaults if missing
2. If $ARGUMENTS provided: validate profile name, update config, show confirmation
3. If no arguments: interactive settings presentation with pre-selection
4. Answer parsing and config merging
5. File writing
6. Confirmation display with model table
</process>
