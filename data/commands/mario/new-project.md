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
- `.planning/PROJECT.md` — project context and initial notes
- `.planning/config.json` — workflow preferences
- `.planning/foundations/BRAND-IDENTITY.md` — company story, mission, values, positioning
- `.planning/foundations/VOICE-TONE.md` — voice attributes, tone spectrum, do/don't examples
- `.planning/foundations/AUDIENCE-PERSONAS.md` — ICP, buyer personas, pain points, JTBD
- `.planning/foundations/COMPETITIVE-LANDSCAPE.md` — competitors, positioning matrix, gaps
- `.planning/foundations/MESSAGING-FRAMEWORK.md` — core messages, proof points, elevator pitches
- `.planning/foundations/PRODUCT-SERVICE.md` — features→benefits, use cases, pricing
- `.planning/foundations/CHANNELS-DISTRIBUTION.md` — channel strategy, content types
- `.planning/foundations/BRAND-BIBLE.md` — synthesized quick-reference for all content creation

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
