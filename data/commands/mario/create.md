---
name: mario:create
description: Create content with brand context and topic research
argument-hint: "<content description>"
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
  - Task
  - AskUserQuestion
  - WebSearch
  - WebFetch
---
<context>
Content description: $ARGUMENTS

Example usage:
- `/mario:create "Write a blog post about NPS surveys"`
- `/mario:create "Landing page for our new feature"`
- `/mario:create "Email welcome sequence for new signups"`
- `/mario:create "LinkedIn post about customer retention"`
</context>

<objective>
Create on-demand content backed by brand foundations and topic research.

**Loads:**
- `.planning/foundations/BRAND-BIBLE.md` — brand voice, personas, messages, positioning
- `.planning/PROJECT.md` — project context

**Flow:** Research topic → Checkpoint (approve angle) → Generate → Iterate → Finalize

**Requires:** Run `/mario:new-project` first to create brand foundations.
</objective>

<execution_context>
@~/.claude/mario/workflows/create.md
@~/.claude/mario/references/ui-brand.md
@.planning/foundations/BRAND-BIBLE.md
@.planning/PROJECT.md
</execution_context>

<process>
Execute the create workflow from @~/.claude/mario/workflows/create.md end-to-end.
Preserve all workflow gates (research, checkpoint, iteration, commits).
</process>
