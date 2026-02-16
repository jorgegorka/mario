<purpose>
Initialize a new project through unified flow: questioning, research (optional), requirements, roadmap. This is the most leveraged moment in any project — deep questioning here means better plans, better execution, better outcomes. One workflow takes you from idea to ready-for-planning.
</purpose>

<required_reading>
Read all files referenced by the invoking prompt's execution_context before starting.
</required_reading>

<auto_mode>
## Auto Mode Detection

Check if `--auto` flag is present in $ARGUMENTS.

**If auto mode:**
- Skip brownfield mapping offer (assume greenfield)
- Skip deep questioning (extract context from provided document)
- Config questions still required (Step 5)
- After config: run Steps 6-9 automatically with smart defaults:
  - Research: Always yes
  - Requirements: Include all table stakes + features from provided document
  - Requirements approval: Auto-approve
  - Roadmap approval: Auto-approve

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

Parse JSON for: `researcher_model`, `synthesizer_model`, `roadmapper_model`, `commit_docs`, `project_exists`, `has_codebase_map`, `planning_exists`, `has_existing_code`, `has_package_file`, `is_brownfield`, `needs_codebase_map`, `has_git`.

**If `project_exists` is true:** Error — project already initialized. Use `/mario:progress`.

**If `has_git` is false:** Initialize git:
```bash
git init
```

## 2. Brownfield Offer

**If auto mode:** Skip to Step 4 (assume greenfield, synthesize PROJECT.md from provided document).

**If `needs_codebase_map` is true** (from init — existing marketing materials detected but no codebase map):

Use AskUserQuestion:
- header: "Existing Materials"
- question: "I detected existing marketing materials in this directory. Would you like to map them first?"
- options:
  - "Map materials first" — Run /mario:map-codebase to understand existing marketing assets (Recommended)
  - "Skip mapping" — Proceed with project initialization

**If "Map materials first":**
```
Run `/mario:map-codebase` first, then return to `/mario:new-project`
```
Exit command.

**If "Skip mapping" OR `needs_codebase_map` is false:** Continue to Step 3.

## 3. Deep Questioning

**If auto mode:** Skip. Extract project context from provided document instead and proceed to Step 4.

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

## 4. Write PROJECT.md

**If auto mode:** Synthesize from provided document. No "Ready?" gate was shown — proceed directly to commit.

Synthesize all context into `.planning/PROJECT.md` using the template from `templates/project.md`.

**For greenfield projects:**

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

**For brownfield projects (codebase map exists):**

Infer Validated requirements from existing marketing materials:

1. Read `.planning/codebase/ARCHITECTURE.md` and `STACK.md`
2. Identify what marketing assets already exist
3. These become the initial Validated set

```markdown
## Requirements

### Validated

- ✓ [Existing capability 1] — existing
- ✓ [Existing capability 2] — existing
- ✓ [Existing capability 3] — existing

### Active

- [ ] [New requirement 1]
- [ ] [New requirement 2]

### Out of Scope

- [Exclusion 1] — [why]
```

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

## 5. Workflow Preferences

**Round 1 — Core workflow settings (4 questions):**

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
      { label: "Quick", description: "Ship fast (3-5 phases, 1-3 plans each)" },
      { label: "Standard", description: "Balanced scope and speed (5-8 phases, 3-5 plans each)" },
      { label: "Comprehensive", description: "Thorough coverage (8-12 phases, 5-10 plans each)" }
    ]
  },
  {
    header: "Execution",
    question: "Run plans in parallel?",
    multiSelect: false,
    options: [
      { label: "Parallel (Recommended)", description: "Independent plans run simultaneously" },
      { label: "Sequential", description: "One plan at a time" }
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
| **Researcher** | Before planning each phase | Investigates domain, finds patterns, surfaces gotchas |
| **Plan Checker** | After plan is created | Verifies plan actually achieves the phase goal |
| **Verifier** | After phase execution | Confirms must-haves were delivered |

All recommended for important projects. Skip for quick experiments.

```
questions: [
  {
    header: "Research",
    question: "Research before planning each phase? (adds tokens/time)",
    multiSelect: false,
    options: [
      { label: "Yes (Recommended)", description: "Investigate domain, find patterns, surface gotchas" },
      { label: "No", description: "Plan directly from requirements" }
    ]
  },
  {
    header: "Plan Check",
    question: "Verify plans will achieve their goals? (adds tokens/time)",
    multiSelect: false,
    options: [
      { label: "Yes (Recommended)", description: "Catch gaps before execution starts" },
      { label: "No", description: "Execute plans without verification" }
    ]
  },
  {
    header: "Verifier",
    question: "Verify work satisfies requirements after each phase? (adds tokens/time)",
    multiSelect: false,
    options: [
      { label: "Yes (Recommended)", description: "Confirm deliverables match phase goals" },
      { label: "No", description: "Trust execution, skip verification" }
    ]
  },
  {
    header: "Model Profile",
    question: "Which AI models for planning agents?",
    multiSelect: false,
    options: [
      { label: "Balanced (Recommended)", description: "Sonnet for most agents — good quality/cost ratio" },
      { label: "Quality", description: "Opus for research/roadmap — higher cost, deeper analysis" },
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
  "parallelization": true|false,
  "commit_docs": true|false,
  "model_profile": "quality|balanced|budget",
  "workflow": {
    "research": true|false,
    "plan_check": true|false,
    "verifier": true|false
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

## 5.5. Resolve Model Profile

Use models from init: `researcher_model`, `synthesizer_model`, `roadmapper_model`.

## 6. Research Decision

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

**Determine milestone context:**

Check if this is greenfield or subsequent milestone:
- If no "Validated" requirements in PROJECT.md → Greenfield (building from scratch)
- If "Validated" requirements exist → Subsequent milestone (adding to existing app)

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

<milestone_context>
[greenfield OR subsequent]

Greenfield: Research the standard marketing channels and tools for [domain] businesses.
Subsequent: Research what channels and tools are needed to expand marketing for an existing [domain] business. Don't re-research existing channels.
</milestone_context>

<question>
What channels are competitors using? What's the standard marketing stack for this type of business?
</question>

<project_context>
[PROJECT.md summary - core message, constraints, what they're marketing]
</project_context>

<downstream_consumer>
Your STACK.md feeds into roadmap creation. Be prescriptive:
- Specific channels with priority ranking
- Recommended tools and platforms
- What channels to avoid and why
</downstream_consumer>

<quality_gate>
- [ ] Channel recommendations are current and relevant to the business type
- [ ] Rationale explains WHY each channel matters, not just WHAT it is
- [ ] Confidence levels assigned to each recommendation
</quality_gate>

<output>
Write to: .planning/research/STACK.md
Use template: ~/.claude/mario/templates/research-project/STACK.md
</output>
", subagent_type="general-purpose", model="{researcher_model}", description="Channel landscape research")

Task(prompt="First, read ~/.claude/agents/mario-project-researcher.md for your role and instructions.

<research_type>
Project Research — Audience & messaging dimension for [domain].
</research_type>

<milestone_context>
[greenfield OR subsequent]

Greenfield: What messaging resonates with [domain] audiences? What are table-stakes marketing assets?
Subsequent: What messaging and assets are needed to reach [target audience]? What's expected from businesses in this space?
</milestone_context>

<question>
What messaging resonates with the target audience? What are table-stakes marketing assets for this business type?
</question>

<project_context>
[PROJECT.md summary]
</project_context>

<downstream_consumer>
Your FEATURES.md feeds into requirements definition. Categorize clearly:
- Table stakes (must-have marketing assets or prospects leave)
- Differentiators (messaging that creates competitive advantage)
- Anti-patterns (messaging approaches to deliberately avoid)
</downstream_consumer>

<quality_gate>
- [ ] Categories are clear (table stakes vs differentiators vs anti-patterns)
- [ ] Effort level noted for each asset
- [ ] Dependencies between assets identified
</quality_gate>

<output>
Write to: .planning/research/FEATURES.md
Use template: ~/.claude/mario/templates/research-project/FEATURES.md
</output>
", subagent_type="general-purpose", model="{researcher_model}", description="Audience & messaging research")

Task(prompt="First, read ~/.claude/agents/mario-project-researcher.md for your role and instructions.

<research_type>
Project Research — Content strategy dimension for [domain].
</research_type>

<milestone_context>
[greenfield OR subsequent]

Greenfield: How should marketing content be structured for [domain]? What are the content pillars, funnel stages, and distribution channels?
Subsequent: How should new content integrate with existing [domain] marketing strategy?
</milestone_context>

<question>
How should content be structured? What are the right content pillars, funnel stages, and distribution plan?
</question>

<project_context>
[PROJECT.md summary]
</project_context>

<downstream_consumer>
Your ARCHITECTURE.md informs phase structure in roadmap. Include:
- Content pillars and their relationships
- Funnel stages (awareness → consideration → decision → retention)
- Suggested build order (what content depends on what)
</downstream_consumer>

<quality_gate>
- [ ] Content pillars clearly defined with audience alignment
- [ ] Funnel stages mapped to content types
- [ ] Build order implications noted
</quality_gate>

<output>
Write to: .planning/research/ARCHITECTURE.md
Use template: ~/.claude/mario/templates/research-project/ARCHITECTURE.md
</output>
", subagent_type="general-purpose", model="{researcher_model}", description="Content strategy research")

Task(prompt="First, read ~/.claude/agents/mario-project-researcher.md for your role and instructions.

<research_type>
Project Research — Marketing pitfalls dimension for [domain].
</research_type>

<milestone_context>
[greenfield OR subsequent]

Greenfield: What do businesses in this space commonly get wrong with marketing? Critical mistakes?
Subsequent: What are common mistakes when expanding marketing for [domain] businesses?
</milestone_context>

<question>
What do businesses in this space commonly get wrong with marketing? Critical mistakes?
</question>

<project_context>
[PROJECT.md summary]
</project_context>

<downstream_consumer>
Your PITFALLS.md prevents mistakes in roadmap/planning. For each pitfall:
- Warning signs (how to detect early)
- Prevention strategy (how to avoid)
- Which phase should address it
</downstream_consumer>

<quality_gate>
- [ ] Pitfalls are specific to this business type (not generic marketing advice)
- [ ] Prevention strategies are actionable
- [ ] Phase mapping included where relevant
</quality_gate>

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
- .planning/research/STACK.md
- .planning/research/FEATURES.md
- .planning/research/ARCHITECTURE.md
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

**Stack:** [from SUMMARY.md]
**Table Stakes:** [from SUMMARY.md]
**Watch Out For:** [from SUMMARY.md]

Files: `.planning/research/`
```

**If "Skip research":** Continue to Step 7.

## 7. Define Requirements

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

**If research exists:** Read research/FEATURES.md and extract feature categories.

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
- Traceability section (empty, filled by roadmap)

**REQ-ID format:** `[CATEGORY]-[NUMBER]` (BRAND-01, WEB-02, EMAIL-01, SOCIAL-02, SEO-01, ADS-01)

**Requirement quality criteria:**

Good requirements are:
- **Specific and testable:** "Homepage copy with hero section, 3 benefit blocks, and CTA" (not "Write homepage")
- **Outcome-oriented:** "Welcome sequence converts 15% of signups to active users" (not "System sends emails")
- **Atomic:** One deliverable per requirement (not "Create all email sequences and social posts")
- **Independent:** Minimal dependencies on other requirements

Reject vague requirements. Push for specificity:
- "Handle email marketing" → "Welcome sequence with 5 emails over 14 days introducing the product and driving first purchase"
- "Do social media" → "30-day content calendar with 3 posts/week across Instagram and LinkedIn aligned to content pillars"

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

## 8. Create Roadmap

Display stage banner:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► CREATING ROADMAP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

◆ Spawning roadmapper...
```

Spawn mario-roadmapper agent with context:

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
Create roadmap:
1. Derive phases from requirements (don't impose structure)
2. Map every v1 requirement to exactly one phase
3. Derive 2-5 success criteria per phase (observable user behaviors)
4. Validate 100% coverage
5. Write files immediately (ROADMAP.md, STATE.md, update REQUIREMENTS.md traceability)
6. Return ROADMAP CREATED with summary

Write files first, then return. This ensures artifacts persist even if context is lost.
</instructions>
", subagent_type="mario-roadmapper", model="{roadmapper_model}", description="Create roadmap")
```

**Handle roadmapper return:**

**If `## ROADMAP BLOCKED`:**
- Present blocker information
- Work with user to resolve
- Re-spawn when resolved

**If `## ROADMAP CREATED`:**

Read the created ROADMAP.md and present it nicely inline:

```
---

## Proposed Roadmap

**[N] phases** | **[X] requirements mapped** | All v1 requirements covered ✓

| # | Phase | Goal | Requirements | Success Criteria |
|---|-------|------|--------------|------------------|
| 1 | [Name] | [Goal] | [REQ-IDs] | [count] |
| 2 | [Name] | [Goal] | [REQ-IDs] | [count] |
| 3 | [Name] | [Goal] | [REQ-IDs] | [count] |
...

### Phase Details

**Phase 1: [Name]**
Goal: [goal]
Requirements: [REQ-IDs]
Success criteria:
1. [criterion]
2. [criterion]
3. [criterion]

**Phase 2: [Name]**
Goal: [goal]
Requirements: [REQ-IDs]
Success criteria:
1. [criterion]
2. [criterion]

[... continue for all phases ...]

---
```

**If auto mode:** Skip approval gate — auto-approve and commit directly.

**CRITICAL: Ask for approval before committing (interactive mode only):**

Use AskUserQuestion:
- header: "Roadmap"
- question: "Does this roadmap structure work for you?"
- options:
  - "Approve" — Commit and continue
  - "Adjust phases" — Tell me what to change
  - "Review full file" — Show raw ROADMAP.md

**If "Approve":** Continue to commit.

**If "Adjust phases":**
- Get user's adjustment notes
- Re-spawn roadmapper with revision context:
  ```
  Task(prompt="
  <revision>
  User feedback on roadmap:
  [user's notes]

  Current ROADMAP.md: @.planning/ROADMAP.md

  Update the roadmap based on feedback. Edit files in place.
  Return ROADMAP REVISED with changes made.
  </revision>
  ", subagent_type="mario-roadmapper", model="{roadmapper_model}", description="Revise roadmap")
  ```
- Present revised roadmap
- Loop until user approves

**If "Review full file":** Display raw `cat .planning/ROADMAP.md`, then re-ask.

**Commit roadmap (after approval or auto mode):**

```bash
mario-tools commit "docs: create roadmap ([N] phases)" --files .planning/ROADMAP.md .planning/STATE.md .planning/REQUIREMENTS.md
```

## 9. Done

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
| Roadmap        | `.planning/ROADMAP.md`      |

**[N] phases** | **[X] requirements** | Ready to build ✓

───────────────────────────────────────────────────────────────

## ▶ Next Up

**Phase 1: [Phase Name]** — [Goal from ROADMAP.md]

/mario:discuss-phase 1 — gather context and clarify approach

<sub>/clear first → fresh context window</sub>

---

**Also available:**
- /mario:plan-phase 1 — skip discussion, plan directly

───────────────────────────────────────────────────────────────
```

</process>

<output>

- `.planning/PROJECT.md`
- `.planning/config.json`
- `.planning/research/` (if research selected)
  - `STACK.md`
  - `FEATURES.md`
  - `ARCHITECTURE.md`
  - `PITFALLS.md`
  - `SUMMARY.md`
- `.planning/REQUIREMENTS.md`
- `.planning/ROADMAP.md`
- `.planning/STATE.md`

</output>

<success_criteria>

- [ ] .planning/ directory created
- [ ] Git repo initialized
- [ ] Brownfield detection completed
- [ ] Deep questioning completed (threads followed, not rushed)
- [ ] PROJECT.md captures full context → **committed**
- [ ] config.json has workflow mode, depth, parallelization → **committed**
- [ ] Research completed (if selected) — 4 parallel agents spawned → **committed**
- [ ] Requirements gathered (from research or conversation)
- [ ] User scoped each category (v1/v2/out of scope)
- [ ] REQUIREMENTS.md created with REQ-IDs → **committed**
- [ ] mario-roadmapper spawned with context
- [ ] Roadmap files written immediately (not draft)
- [ ] User feedback incorporated (if any)
- [ ] ROADMAP.md created with phases, requirement mappings, success criteria
- [ ] STATE.md initialized
- [ ] REQUIREMENTS.md traceability updated
- [ ] User knows next step is `/mario:discuss-phase 1`

**Atomic commits:** Each phase commits its artifacts immediately. If context is lost, artifacts persist.

</success_criteria>
