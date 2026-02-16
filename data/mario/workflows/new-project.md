<purpose>
Initialize a new project through unified flow: questioning, research (optional), requirements, backlog. This is the most leveraged moment in any project — deep questioning here means better plans, better execution, better outcomes. One workflow takes you from idea to ready-for-planning.
</purpose>

<required_reading>
Read all files referenced by the invoking prompt's execution_context before starting.
</required_reading>

<auto_mode>
## Auto Mode Detection

Check if `--auto` flag is present in $ARGUMENTS.

**If auto mode:**
- Skip deep questioning (extract context from provided document)
- Config questions still required (Step 5)
- After config: run Steps 6-8 automatically with smart defaults:
  - Research: Always yes
  - Requirements: Include all table stakes + features from provided document
  - Requirements approval: Auto-approve
  - Backlog approval: Auto-approve

**Document requirement:**
Auto mode requires an idea document via @ reference (e.g., `/mario:new-project --auto @prd.md`). If no document provided, error:

```
Error: --auto requires an idea document via @ reference.

Usage: /mario:new-project --auto @your-idea.md

The document should describe the product or business you want to market.
```
</auto_mode>

<process>

## 1. Setup

**MANDATORY FIRST STEP — Execute these checks before ANY user interaction:**

```bash
INIT=$(mario-tools init new-project)
```

Parse JSON for: `researcher_model`, `synthesizer_model`, `backlog_planner_model`, `commit_docs`, `project_exists`, `planning_exists`, `has_git`.

**If `project_exists` is true:** Error — project already initialized. Use `/mario:progress`.

**If `has_git` is false:** Initialize git:
```bash
git init
```

## 2. Deep Questioning

**If auto mode:** Skip. Extract project context from provided document instead and proceed to Step 3.

**Display stage banner:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► QUESTIONING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Open the conversation:**

Ask inline (freeform, NOT AskUserQuestion):

"What's the product or business you're marketing? Who do you serve?"

Wait for their response. This gives you the context needed to ask intelligent follow-up questions.

**Follow the thread:**

Based on what they said, ask follow-up questions that dig into their response. Use AskUserQuestion with options that probe what they mentioned — interpretations, clarifications, concrete examples.

Keep following threads. Each answer opens new threads to explore. Ask about:
- Business context: What problem does the product solve? Who pays?
- Target audience: Who are the ideal customers? What do they care about?
- Value proposition: Why should someone choose this over alternatives?
- Channel goals: Which marketing channels matter most?
- Current state: What marketing exists today? What's working/not?
- Success metrics: What does success look like? Revenue? Leads? Brand awareness?
- Competitive landscape: Who are the competitors? How are they positioned?

Consult `questioning.md` for techniques:
- Challenge vagueness
- Make abstract concrete
- Surface assumptions
- Find edges
- Reveal motivation

**Check context (background, not out loud):**

As you go, mentally check the context checklist from `questioning.md`. If gaps remain, weave questions naturally. Don't suddenly switch to checklist mode.

**Decision gate:**

When you could write a clear PROJECT.md, use AskUserQuestion:

- header: "Ready?"
- question: "I think I understand what you're after. Ready to create PROJECT.md?"
- options:
  - "Create PROJECT.md" — Let's move forward
  - "Keep exploring" — I want to share more / ask me more

If "Keep exploring" — ask what they want to add, or identify gaps and probe naturally.

Loop until "Create PROJECT.md" selected.

## 3. Write PROJECT.md

**If auto mode:** Synthesize from provided document. No "Ready?" gate was shown — proceed directly to commit.

Synthesize all context into `.planning/PROJECT.md` using the template from `templates/project.md`.

Initialize requirements as hypotheses:

```markdown
## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] [Requirement 1]
- [ ] [Requirement 2]
- [ ] [Requirement 3]

### Out of Scope

- [Exclusion 1] — [why]
- [Exclusion 2] — [why]
```

All Active requirements are hypotheses until shipped and validated.

**Key Decisions:**

Initialize with any decisions made during questioning:

```markdown
## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| [Choice from questioning] | [Why] | — Pending |
```

**Last updated footer:**

```markdown
---
*Last updated: [date] after initialization*
```

Do not compress. Capture everything gathered.

**Commit PROJECT.md:**

```bash
mkdir -p .planning
mario-tools commit "docs: initialize project" --files .planning/PROJECT.md
```

## 4. Workflow Preferences

**Round 1 — Core workflow settings (3 questions):**

```
questions: [
  {
    header: "Mode",
    question: "How do you want to work?",
    multiSelect: false,
    options: [
      { label: "YOLO (Recommended)", description: "Auto-approve, just execute" },
      { label: "Interactive", description: "Confirm at each step" }
    ]
  },
  {
    header: "Depth",
    question: "How thorough should planning be?",
    multiSelect: false,
    options: [
      { label: "Quick", description: "Ship fast (3-5 plans)" },
      { label: "Standard", description: "Balanced scope and speed (5-10 plans)" },
      { label: "Comprehensive", description: "Thorough coverage (10-20 plans)" }
    ]
  },
  {
    header: "Git Tracking",
    question: "Commit planning docs to git?",
    multiSelect: false,
    options: [
      { label: "Yes (Recommended)", description: "Planning docs tracked in version control" },
      { label: "No", description: "Keep .planning/ local-only (add to .gitignore)" }
    ]
  }
]
```

**Round 2 — Workflow agents:**

These spawn additional agents during planning/execution. They add tokens and time but improve quality.

| Agent | When it runs | What it does |
|-------|--------------|--------------|
| **Researcher** | Before planning each plan | Investigates domain, finds patterns, surfaces gotchas |

```
questions: [
  {
    header: "Research",
    question: "Research before planning? (adds tokens/time)",
    multiSelect: false,
    options: [
      { label: "Yes (Recommended)", description: "Investigate domain, find patterns, surface gotchas" },
      { label: "No", description: "Plan directly from requirements" }
    ]
  },
  {
    header: "Model Profile",
    question: "Which AI models for planning agents?",
    multiSelect: false,
    options: [
      { label: "Balanced (Recommended)", description: "Sonnet for most agents — good quality/cost ratio" },
      { label: "Quality", description: "Opus for research/planning — higher cost, deeper analysis" },
      { label: "Budget", description: "Haiku where possible — fastest, lowest cost" }
    ]
  }
]
```

Create `.planning/config.json` with all settings:

```json
{
  "mode": "yolo|interactive",
  "depth": "quick|standard|comprehensive",
  "commit_docs": true|false,
  "model_profile": "quality|balanced|budget",
  "workflow": {
    "research": true|false
  }
}
```

**If commit_docs = No:**
- Set `commit_docs: false` in config.json
- Add `.planning/` to `.gitignore` (create if needed)

**If commit_docs = Yes:**
- No additional gitignore entries needed

**Commit config.json:**

```bash
mario-tools commit "chore: add project config" --files .planning/config.json
```

**Note:** Run `/mario:settings` anytime to update these preferences.

## 4.5. Resolve Model Profile

Use models from init: `researcher_model`, `synthesizer_model`, `backlog_planner_model`.

## 5. Research Decision

**If auto mode:** Default to "Research first" without asking.

Use AskUserQuestion:
- header: "Research"
- question: "Research the domain ecosystem before defining requirements?"
- options:
  - "Research first (Recommended)" — Discover standard stacks, expected features, architecture patterns
  - "Skip research" — I know this domain well, go straight to requirements

**If "Research first":**

Display stage banner:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► RESEARCHING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Researching [domain] ecosystem...
```

Create research directory:
```bash
mkdir -p .planning/research
```

**Determine project context:**

Check if this is greenfield or has existing materials:
- If no "Validated" requirements in PROJECT.md → Greenfield (building from scratch)
- If "Validated" requirements exist → Building on existing work

Display spawning indicator:
```
◆ Spawning 4 researchers in parallel...
  → Channel landscape research
  → Audience & messaging research
  → Content strategy research
  → Marketing pitfalls research
```

Spawn 4 parallel mario-project-researcher agents with rich context:

```
Task(prompt="First, read ~/.claude/agents/mario-project-researcher.md for your role and instructions.

<research_type>
Project Research — Channel landscape dimension for [domain].
</research_type>

<question>
What channels are competitors using? What's the standard marketing stack for this type of business?
</question>

<project_context>
[PROJECT.md summary - core message, constraints, what they're marketing]
</project_context>

<downstream_consumer>
Your CHANNELS.md feeds into backlog creation. Be prescriptive:
- Specific channels with priority ranking
- Recommended tools and platforms
- What channels to avoid and why
</downstream_consumer>

<output>
Write to: .planning/research/CHANNELS.md
Use template: ~/.claude/mario/templates/research-project/CHANNELS.md
</output>
", subagent_type="general-purpose", model="{researcher_model}", description="Channel landscape research")

Task(prompt="First, read ~/.claude/agents/mario-project-researcher.md for your role and instructions.

<research_type>
Project Research — Audience & messaging dimension for [domain].
</research_type>

<question>
What messaging resonates with the target audience? What are table-stakes marketing assets for this business type?
</question>

<project_context>
[PROJECT.md summary]
</project_context>

<downstream_consumer>
Your AUDIENCE.md feeds into requirements definition. Categorize clearly:
- Table stakes (must-have marketing assets or prospects leave)
- Differentiators (messaging that creates competitive advantage)
- Anti-patterns (messaging approaches to deliberately avoid)
</downstream_consumer>

<output>
Write to: .planning/research/AUDIENCE.md
Use template: ~/.claude/mario/templates/research-project/AUDIENCE.md
</output>
", subagent_type="general-purpose", model="{researcher_model}", description="Audience & messaging research")

Task(prompt="First, read ~/.claude/agents/mario-project-researcher.md for your role and instructions.

<research_type>
Project Research — Content strategy dimension for [domain].
</research_type>

<question>
How should content be structured? What are the right content pillars, funnel stages, and distribution plan?
</question>

<project_context>
[PROJECT.md summary]
</project_context>

<downstream_consumer>
Your CONTENT.md informs plan structure in backlog. Include:
- Content pillars and their relationships
- Funnel stages (awareness → consideration → decision → retention)
- Suggested build order (what content depends on what)
</downstream_consumer>

<output>
Write to: .planning/research/CONTENT.md
Use template: ~/.claude/mario/templates/research-project/CONTENT.md
</output>
", subagent_type="general-purpose", model="{researcher_model}", description="Content strategy research")

Task(prompt="First, read ~/.claude/agents/mario-project-researcher.md for your role and instructions.

<research_type>
Project Research — Marketing pitfalls dimension for [domain].
</research_type>

<question>
What do businesses in this space commonly get wrong with marketing? Critical mistakes?
</question>

<project_context>
[PROJECT.md summary]
</project_context>

<downstream_consumer>
Your PITFALLS.md prevents mistakes in planning. For each pitfall:
- Warning signs (how to detect early)
- Prevention strategy (how to avoid)
- Which plan should address it
</downstream_consumer>

<output>
Write to: .planning/research/PITFALLS.md
Use template: ~/.claude/mario/templates/research-project/PITFALLS.md
</output>
", subagent_type="general-purpose", model="{researcher_model}", description="Marketing pitfalls research")
```

After all 4 agents complete, spawn synthesizer to create SUMMARY.md:

```
Task(prompt="
<task>
Synthesize research outputs into SUMMARY.md.
</task>

<research_files>
Read these files:
- .planning/research/CHANNELS.md
- .planning/research/AUDIENCE.md
- .planning/research/CONTENT.md
- .planning/research/PITFALLS.md
</research_files>

<output>
Write to: .planning/research/SUMMARY.md
Use template: ~/.claude/mario/templates/research-project/SUMMARY.md
Commit after writing.
</output>
", subagent_type="mario-research-synthesizer", model="{synthesizer_model}", description="Synthesize research")
```

Display research complete banner and key findings:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► RESEARCH COMPLETE ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Key Findings

**Channels:** [from SUMMARY.md]
**Table Stakes:** [from SUMMARY.md]
**Watch Out For:** [from SUMMARY.md]

Files: `.planning/research/`
```

**If "Skip research":** Continue to Step 6.

## 6. Define Requirements

Display stage banner:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► DEFINING REQUIREMENTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Load context:**

Read PROJECT.md and extract:
- Core message (the ONE thing that must resonate)
- Stated constraints (budget, timeline, tech limitations)
- Any explicit scope boundaries

**If research exists:** Read research/AUDIENCE.md and extract feature categories.

**If auto mode:**
- Auto-include all table stakes features (users expect these)
- Include features explicitly mentioned in provided document
- Auto-defer differentiators not mentioned in document
- Skip per-category AskUserQuestion loops
- Skip "Any additions?" question
- Skip requirements approval gate
- Generate REQUIREMENTS.md and commit directly

**Present features by category (interactive mode only):**

```
Here are the marketing assets for [domain]:

## Brand Foundation
**Table stakes:**
- Brand voice guide documented
- Buyer personas created
- Core messaging framework
- Visual identity guidelines

**Differentiators:**
- Competitive positioning matrix
- Brand story narrative
- Tone variations by channel

**Research notes:** [any relevant notes]

---

## [Next Category: Website Copy, Email Marketing, Social Media, SEO Content, Paid Advertising]
...
```

**If no research:** Gather requirements through conversation instead.

Ask: "What are the main things users need to be able to do?"

For each capability mentioned:
- Ask clarifying questions to make it specific
- Probe for related capabilities
- Group into categories

**Scope each category:**

For each category, use AskUserQuestion:

- header: "[Category name]"
- question: "Which [category] features are in v1?"
- multiSelect: true
- options:
  - "[Feature 1]" — [brief description]
  - "[Feature 2]" — [brief description]
  - "[Feature 3]" — [brief description]
  - "None for v1" — Defer entire category

Track responses:
- Selected features → v1 requirements
- Unselected table stakes → v2 (users expect these)
- Unselected differentiators → out of scope

**Identify gaps:**

Use AskUserQuestion:
- header: "Additions"
- question: "Any requirements research missed? (Features specific to your vision)"
- options:
  - "No, research covered it" — Proceed
  - "Yes, let me add some" — Capture additions

**Validate core message:**

Cross-check requirements against Core Message from PROJECT.md. If gaps detected, surface them.

**Generate REQUIREMENTS.md:**

Create `.planning/REQUIREMENTS.md` with:
- v1 Requirements grouped by category (checkboxes, REQ-IDs)
- v2 Requirements (deferred)
- Out of Scope (explicit exclusions with reasoning)

**REQ-ID format:** `[CATEGORY]-[NUMBER]` (BRAND-01, WEB-02, EMAIL-01, SOCIAL-02, SEO-01, ADS-01)

**Requirement quality criteria:**

Good requirements are:
- **Specific and testable:** "Homepage copy with hero section, 3 benefit blocks, and CTA" (not "Write homepage")
- **Outcome-oriented:** "Welcome sequence converts 15% of signups to active users" (not "System sends emails")
- **Atomic:** One deliverable per requirement (not "Create all email sequences and social posts")
- **Independent:** Minimal dependencies on other requirements

Reject vague requirements. Push for specificity.

**Present full requirements list (interactive mode only):**

Show every requirement (not counts) for user confirmation:

```
## v1 Requirements

### Brand Foundation
- [ ] **BRAND-01**: Brand voice guide documented
- [ ] **BRAND-02**: 3 detailed buyer personas created
- [ ] **BRAND-03**: Core messaging framework defined

### Website Copy
- [ ] **WEB-01**: Homepage copy written
- [ ] **WEB-02**: Landing page for primary offering

[... full list ...]

---

Does this capture what you're marketing? (yes / adjust)
```

If "adjust": Return to scoping.

**Commit requirements:**

```bash
mario-tools commit "docs: define v1 requirements" --files .planning/REQUIREMENTS.md
```

## 7. Create Backlog

Display stage banner:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► CREATING BACKLOG
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

◆ Spawning backlog planner...
```

Spawn mario-backlog-planner agent with context:

```
Task(prompt="
<planning_context>

**Project:**
@.planning/PROJECT.md

**Requirements:**
@.planning/REQUIREMENTS.md

**Research (if exists):**
@.planning/research/SUMMARY.md

**Config:**
@.planning/config.json

</planning_context>

<instructions>
Create backlog:
1. Derive plans from requirements (each plan = one deliverable)
2. Map every v1 requirement to exactly one plan
3. Order plans by dependency and priority
4. Validate 100% coverage
5. Write files immediately (BACKLOG.md, STATE.md, update REQUIREMENTS.md traceability)
6. Return BACKLOG CREATED with summary

Write files first, then return. This ensures artifacts persist even if context is lost.
</instructions>
", subagent_type="mario-backlog-planner", model="{backlog_planner_model}", description="Create backlog")
```

**Handle backlog planner return:**

**If `## BACKLOG BLOCKED`:**
- Present blocker information
- Work with user to resolve
- Re-spawn when resolved

**If `## BACKLOG CREATED`:**

Read the created BACKLOG.md and present it nicely inline:

```
---

## Proposed Backlog

**[N] plans** | **[X] requirements mapped** | All v1 requirements covered ✓

| # | Plan | Description | Requirements |
|---|------|-------------|--------------|
| 001 | [Name] | [Description] | [REQ-IDs] |
| 002 | [Name] | [Description] | [REQ-IDs] |
| 003 | [Name] | [Description] | [REQ-IDs] |
...

---
```

**If auto mode:** Skip approval gate — auto-approve and commit directly.

**CRITICAL: Ask for approval before committing (interactive mode only):**

Use AskUserQuestion:
- header: "Backlog"
- question: "Does this backlog structure work for you?"
- options:
  - "Approve" — Commit and continue
  - "Adjust plans" — Tell me what to change
  - "Review full file" — Show raw BACKLOG.md

**If "Approve":** Continue to commit.

**If "Adjust plans":**
- Get user's adjustment notes
- Re-spawn backlog planner with revision context:
  ```
  Task(prompt="
  <revision>
  User feedback on backlog:
  [user's notes]

  Current BACKLOG.md: @.planning/BACKLOG.md

  Update the backlog based on feedback. Edit files in place.
  Return BACKLOG REVISED with changes made.
  </revision>
  ", subagent_type="mario-backlog-planner", model="{backlog_planner_model}", description="Revise backlog")
  ```
- Present revised backlog
- Loop until user approves

**If "Review full file":** Display raw `cat .planning/BACKLOG.md`, then re-ask.

**Commit backlog (after approval or auto mode):**

```bash
mario-tools commit "docs: create backlog ([N] plans)" --files .planning/BACKLOG.md .planning/STATE.md .planning/REQUIREMENTS.md
```

## 8. Done

Present completion with next steps:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► PROJECT INITIALIZED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**[Project Name]**

| Artifact       | Location                    |
|----------------|-----------------------------|
| Project        | `.planning/PROJECT.md`      |
| Config         | `.planning/config.json`     |
| Research       | `.planning/research/`       |
| Requirements   | `.planning/REQUIREMENTS.md` |
| Backlog        | `.planning/BACKLOG.md`      |

**[N] plans** | **[X] requirements** | Ready to build ✓

───────────────────────────────────────────────────────────────

## ▶ Next Up

**Plan 001: [Plan Name]** — [Description]

/mario:plan 001

<sub>/clear first → fresh context window</sub>

---

**Also available:**
- /mario:execute 001 — skip planning, execute directly

───────────────────────────────────────────────────────────────
```

</process>

<output>

- `.planning/PROJECT.md`
- `.planning/config.json`
- `.planning/research/` (if research selected)
  - `CHANNELS.md`
  - `AUDIENCE.md`
  - `CONTENT.md`
  - `PITFALLS.md`
  - `SUMMARY.md`
- `.planning/REQUIREMENTS.md`
- `.planning/BACKLOG.md`
- `.planning/STATE.md`

</output>

<success_criteria>

- [ ] .planning/ directory created
- [ ] Git repo initialized
- [ ] Deep questioning completed (threads followed, not rushed)
- [ ] PROJECT.md captures full context → **committed**
- [ ] config.json has workflow mode, depth → **committed**
- [ ] Research completed (if selected) — 4 parallel agents spawned → **committed**
- [ ] Requirements gathered (from research or conversation)
- [ ] User scoped each category (v1/v2/out of scope)
- [ ] REQUIREMENTS.md created with REQ-IDs → **committed**
- [ ] mario-backlog-planner spawned with context
- [ ] Backlog files written immediately (not draft)
- [ ] User feedback incorporated (if any)
- [ ] BACKLOG.md created with plans mapped to requirements
- [ ] STATE.md initialized
- [ ] REQUIREMENTS.md traceability updated
- [ ] User knows next step is `/mario:plan 001`

**Atomic commits:** Each step commits its artifacts immediately. If context is lost, artifacts persist.

</success_criteria>
</output>
