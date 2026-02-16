---
name: mario:map-codebase
description: Audit existing marketing materials with parallel mapper agents to produce .planning/codebase/ documents
argument-hint: "[optional: specific area to audit, e.g., 'email' or 'social']"
allowed-tools:
  - Read
  - Bash
  - Glob
  - Grep
  - Write
  - Task
---

<objective>
Audit existing marketing materials using parallel mario-codebase-mapper agents to produce structured marketing audit documents.

Each mapper agent explores a focus area and **writes documents directly** to `.planning/codebase/`. The orchestrator only receives confirmations, keeping context usage minimal.

Output: .planning/codebase/ folder with 7 structured documents about the current marketing state.
</objective>

<execution_context>
@~/.claude/mario/workflows/map-codebase.md
</execution_context>

<context>
Focus area: $ARGUMENTS (optional - if provided, tells agents to focus on specific marketing area)

**Load project state if exists:**
Check for .planning/STATE.md - loads context if project already initialized

**This command can run:**
- Before /mario:new-project (existing marketing operations) - creates marketing audit first
- After /mario:new-project (new marketing initiatives) - updates audit as marketing evolves
- Anytime to refresh marketing understanding
</context>

<when_to_use>
**Use map-codebase for:**
- Existing marketing operations before project initialization (understand current state first)
- Refreshing marketing audit after significant changes
- Onboarding to an unfamiliar marketing operation
- Before major strategy shifts (understand current state)
- When STATE.md references outdated marketing info

**Skip map-codebase for:**
- Brand new ventures with no marketing yet (nothing to audit)
- Trivial operations (<3 active channels)
</when_to_use>

<process>
1. Check if .planning/codebase/ already exists (offer to refresh or skip)
2. Create .planning/codebase/ directory structure
3. Spawn 4 parallel mario-codebase-mapper agents:
   - Agent 1: tools focus -> writes TOOLS-AND-PLATFORMS.md, AUDIENCE-INSIGHTS.md
   - Agent 2: channel focus -> writes CHANNEL-ARCHITECTURE.md, CONTENT-INVENTORY.md
   - Agent 3: brand focus -> writes BRAND-GUIDELINES.md, PERFORMANCE-METRICS.md
   - Agent 4: gaps focus -> writes MARKETING-GAPS.md
4. Wait for agents to complete, collect confirmations (NOT document contents)
5. Verify all 7 documents exist with line counts
6. Commit marketing audit
7. Offer next steps (typically: /mario:new-project or /mario:plan-phase)
</process>

<success_criteria>
- [ ] .planning/codebase/ directory created
- [ ] All 7 marketing audit documents written by mapper agents
- [ ] Documents follow template structure
- [ ] Parallel agents completed without errors
- [ ] User knows next steps
</success_criteria>
