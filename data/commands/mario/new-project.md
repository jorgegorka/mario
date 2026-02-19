---
name: mario:new-project
description: Establish brand foundations with deep context gathering
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
- `--auto` — Automatic mode. After config questions, runs foundation research automatically. Expects idea document via @ reference.
</context>

<objective>
Establish brand foundations through unified flow: questioning -> foundation research -> brand bible synthesis.

**Creates:**
- `.mario_planning/PROJECT.md` — project context and initial notes
- `.mario_planning/config.json` — workflow preferences
- `.mario_planning/foundations/BRAND-IDENTITY.md` — company story, mission, values, positioning
- `.mario_planning/foundations/VOICE-TONE.md` — voice attributes, tone spectrum, do/don't examples
- `.mario_planning/foundations/AUDIENCE-PERSONAS.md` — ICP, buyer personas, pain points, JTBD
- `.mario_planning/foundations/COMPETITIVE-LANDSCAPE.md` — competitors, positioning matrix, gaps
- `.mario_planning/foundations/MESSAGING-FRAMEWORK.md` — core messages, proof points, elevator pitches
- `.mario_planning/foundations/PRODUCT-SERVICE.md` — features→benefits, use cases, pricing
- `.mario_planning/foundations/CHANNELS-DISTRIBUTION.md` — channel strategy, content types
- `.mario_planning/foundations/BRAND-BIBLE.md` — synthesized quick-reference for all content creation

**After this command:** Run `/mario:create` to start creating content.
</objective>

<execution_context>
@~/.claude/mario/workflows/new-project.md
@~/.claude/mario/references/questioning.md
@~/.claude/mario/references/ui-brand.md
@~/.claude/mario/templates/project.md
</execution_context>

<process>
Execute the new-project workflow from @~/.claude/mario/workflows/new-project.md end-to-end.
Preserve all workflow gates (validation, approvals, commits, routing).
</process>
