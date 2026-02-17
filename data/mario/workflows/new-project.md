<purpose>
Initialize a new project through unified flow: questioning, research, brand foundations. This is the most leveraged moment in any project — deep questioning here means better foundations, better content, better outcomes. One workflow takes you from idea to ready-for-content-creation.
</purpose>

<required_reading>
Read all files referenced by the invoking prompt's execution_context before starting.
</required_reading>

<auto_mode>
## Auto Mode Detection

Check if `--auto` flag is present in $ARGUMENTS.

**If auto mode:**
- Skip deep questioning (extract context from provided document)
- Config questions still required (Step 4)
- After config: run research automatically with smart defaults

**Document requirement:**
Auto mode requires an idea document via @ reference (e.g., `/mario:new-project --auto @prd.md`). If no document provided, error:

```
╔══════════════════════════════════════════════════════════════╗
║  ERROR                                                       ║
╚══════════════════════════════════════════════════════════════╝

--auto requires an idea document via @ reference.

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

Parse JSON for: `researcher_model`, `synthesizer_model`, `commit_docs`, `project_exists`, `planning_exists`, `has_git`.

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
- Brand personality: How should this brand feel? Professional, casual, edgy, warm?
- Voice preferences: Any existing tone guidelines or content examples?
- Key personas: Who are the main people you're trying to reach?
- Core messages: What's the one thing you want people to remember?
- Channel goals: Which marketing channels matter most?
- Current state: What marketing exists today? What's working/not?
- Success metrics: What does success look like? Revenue? Leads? Brand awareness?
- Competitive landscape: Who are the competitors? How are they positioned?
- Product details: What are the key features? What's the pricing model?

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

**Core workflow settings (2 questions):**

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

**Model profile:**

```
questions: [
  {
    header: "Model Profile",
    question: "Which AI models for research agents?",
    multiSelect: false,
    options: [
      { label: "Balanced (Recommended)", description: "Sonnet for most agents — good quality/cost ratio" },
      { label: "Quality", description: "Opus for research — higher cost, deeper analysis" },
      { label: "Budget", description: "Haiku where possible — fastest, lowest cost" }
    ]
  }
]
```

Create `.planning/config.json` with all settings:

```json
{
  "mode": "yolo|interactive",
  "commit_docs": true|false,
  "model_profile": "quality|balanced|budget"
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

Use models from init: `researcher_model`, `synthesizer_model`.

## 5. Foundation Research

**If auto mode:** Proceed directly without asking.

Use AskUserQuestion:
- header: "Research"
- question: "Research your brand foundations? This creates permanent reference documents for all content."
- options:
  - "Research foundations (Recommended)" — Deep research into brand, audience, competitors, messaging, product, channels
  - "Skip research" — I'll create foundation documents manually later

**If "Research foundations":**

Display stage banner:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► RESEARCHING FOUNDATIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Researching brand foundations for [project name]...
```

Create foundations directory:
```bash
mkdir -p .planning/foundations
```

Display spawning indicator:
```
◆ Spawning 7 foundation researchers in parallel...
  → Brand identity research
  → Voice & tone research
  → Audience & personas research
  → Competitive landscape research
  → Messaging framework research
  → Product/service research
  → Channels & distribution research
```

Spawn 7 parallel mario-project-researcher agents with rich context:

```
Task(prompt="First, read ~/.claude/agents/mario-project-researcher.md for your role and instructions.

<research_type>
Foundation Research — Brand Identity dimension for [project name].
</research_type>

<question>
What is this brand's story, mission, values, positioning, and personality? How is it differentiated from competitors?
</question>

<project_context>
[PROJECT.md summary - what they're marketing, core message, target audience, competitive context, website URL]
</project_context>

<downstream_consumer>
Your BRAND-IDENTITY.md is a permanent brand reference loaded by every content session. Be comprehensive and opinionated:
- Company story (origin, current state, vision)
- Mission, vision, values (observable, not aspirational)
- Value proposition (specific, differentiated, customer-outcome focused)
- Competitive positioning (unique space occupied, positioning map)
- Brand personality (3-5 attributes with means/does not mean)
- Brand proof points (evidence for claims)
</downstream_consumer>

<output>
Write to: .planning/foundations/BRAND-IDENTITY.md
Use template: ~/.claude/mario/templates/foundations/BRAND-IDENTITY.md
</output>
", subagent_type="general-purpose", model="{researcher_model}", description="Brand identity research")

Task(prompt="First, read ~/.claude/agents/mario-project-researcher.md for your role and instructions.

<research_type>
Foundation Research — Voice & Tone dimension for [project name].
</research_type>

<question>
How should this brand sound? What are the voice attributes, tone variations, language preferences, and writing conventions?
</question>

<project_context>
[PROJECT.md summary - brand personality notes, existing content examples, voice preferences mentioned]
</project_context>

<downstream_consumer>
Your VOICE-TONE.md is a permanent brand reference loaded by every content session. Be specific and actionable:
- Voice attributes (3-5 with means/does not mean/do/don't examples)
- Tone spectrum and tone by context (website, blog, email, social, ads, support)
- Language preferences (preferred terms, product terminology, words to avoid)
- Style conventions (capitalization, punctuation, formatting)
- Do/don't examples across content types
</downstream_consumer>

<output>
Write to: .planning/foundations/VOICE-TONE.md
Use template: ~/.claude/mario/templates/foundations/VOICE-TONE.md
</output>
", subagent_type="general-purpose", model="{researcher_model}", description="Voice & tone research")

Task(prompt="First, read ~/.claude/agents/mario-project-researcher.md for your role and instructions.

<research_type>
Foundation Research — Audience & Personas dimension for [project name].
</research_type>

<question>
Who is this brand talking to? What are the ideal customer profile, buyer personas, jobs to be done, and buyer journey stages?
</question>

<project_context>
[PROJECT.md summary - target audience, customer descriptions, segments mentioned]
</project_context>

<downstream_consumer>
Your AUDIENCE-PERSONAS.md is a permanent brand reference loaded by every content session. Create actionable profiles:
- ICP with qualifying/disqualifying signals
- 2-4 buyer personas (goals, pains, objections, triggers, decision factors, representative quotes)
- JTBD (functional, emotional, social jobs)
- Awareness levels with content needed at each level
- Buyer journey stages (awareness → consideration → decision → retention)
</downstream_consumer>

<output>
Write to: .planning/foundations/AUDIENCE-PERSONAS.md
Use template: ~/.claude/mario/templates/foundations/AUDIENCE-PERSONAS.md
</output>
", subagent_type="general-purpose", model="{researcher_model}", description="Audience & personas research")

Task(prompt="First, read ~/.claude/agents/mario-project-researcher.md for your role and instructions.

<research_type>
Foundation Research — Competitive Landscape dimension for [project name].
</research_type>

<question>
Who are the competitors? How do they position and message? Where are the gaps and differentiation opportunities?
</question>

<project_context>
[PROJECT.md summary - competitors mentioned, competitive context, differentiation notes]
</project_context>

<downstream_consumer>
Your COMPETITIVE-LANDSCAPE.md is a permanent brand reference loaded by every content session. Be thorough and strategic:
- 5-10 competitors (direct, indirect, substitute) with profiles
- Positioning matrix across 2-3 key dimensions
- Messaging analysis (common themes, unique angles, proof point comparison)
- Content & SEO landscape (volume, quality, keyword overlap)
- Gaps & opportunities (weaknesses, underserved audiences, messaging white space, content gaps)
</downstream_consumer>

<output>
Write to: .planning/foundations/COMPETITIVE-LANDSCAPE.md
Use template: ~/.claude/mario/templates/foundations/COMPETITIVE-LANDSCAPE.md
</output>
", subagent_type="general-purpose", model="{researcher_model}", description="Competitive landscape research")

Task(prompt="First, read ~/.claude/agents/mario-project-researcher.md for your role and instructions.

<research_type>
Foundation Research — Messaging Framework dimension for [project name].
</research_type>

<question>
What are the core messages for each audience? What proof points, objection handling, and elevator pitches should this brand use?
</question>

<project_context>
[PROJECT.md summary - core message, value proposition, audience notes, competitive context]
</project_context>

<downstream_consumer>
Your MESSAGING-FRAMEWORK.md is a permanent brand reference loaded by every content session. Create a complete messaging playbook:
- Core message, tagline, boilerplate
- Messaging hierarchy (core → pillars → proof points)
- Messages per persona (primary message, supporting messages, language cues, emotional trigger)
- Proof points organized by type (metrics, testimonials, case studies, awards)
- Objection handling (acknowledge/reframe/prove framework, 4-6 key objections)
- Elevator pitches (10-second, 30-second, 60-second)
- Message-to-channel mapping
</downstream_consumer>

<output>
Write to: .planning/foundations/MESSAGING-FRAMEWORK.md
Use template: ~/.claude/mario/templates/foundations/MESSAGING-FRAMEWORK.md
</output>
", subagent_type="general-purpose", model="{researcher_model}", description="Messaging framework research")

Task(prompt="First, read ~/.claude/agents/mario-project-researcher.md for your role and instructions.

<research_type>
Foundation Research — Product/Service dimension for [project name].
</research_type>

<question>
What does this product/service do and why should anyone care? What are the features, benefits, use cases, and pricing?
</question>

<project_context>
[PROJECT.md summary - include the Website URL if available, product details mentioned]
</project_context>

<source_instructions>
Primary: If a website URL is available in PROJECT.md, use WebFetch to crawl the features page, pricing page, product pages, and homepage. Extract features as they are presented to customers.

Secondary: If no URL is available, use WebSearch to find the company website based on the project context, then crawl it.

Document: If a customer document was provided via @ reference during project setup, extract features from it as well.
</source_instructions>

<downstream_consumer>
Your PRODUCT-SERVICE.md is a permanent brand reference loaded by every content session. Be comprehensive:
- Product overview (customer perspective, not internal)
- Features-to-benefits mapping (feature → what it does → customer benefit → persona → content context)
- Use cases (4-6 specific scenarios with persona, situation, problem, solution, outcome)
- Social proof themes (positive themes with quotes, negative themes with handling approach)
- Pricing positioning (model, tiers, narrative, anchor, objection preemption)
</downstream_consumer>

<output>
Write to: .planning/foundations/PRODUCT-SERVICE.md
Use template: ~/.claude/mario/templates/foundations/PRODUCT-SERVICE.md
</output>
", subagent_type="general-purpose", model="{researcher_model}", description="Product/service research")

Task(prompt="First, read ~/.claude/agents/mario-project-researcher.md for your role and instructions.

<research_type>
Foundation Research — Channels & Distribution dimension for [project name].
</research_type>

<question>
Where should this brand show up? What channels, content types, cadence, and distribution approach should it use?
</question>

<project_context>
[PROJECT.md summary - channel goals, current marketing state, audience channels mentioned]
</project_context>

<downstream_consumer>
Your CHANNELS-DISTRIBUTION.md is a permanent brand reference loaded by every content session. Be strategic and actionable:
- Channel strategy overview (growth model, primary channel, philosophy)
- Channel inventory (active, planned, rejected — with rationale)
- Channel-specific considerations (purpose, audience, tone, content types, cadence, metrics, tools)
- Content repurposing flow (how pillar content feeds other channels)
- Channel priority ranking (investment level, expected impact, rationale)
</downstream_consumer>

<output>
Write to: .planning/foundations/CHANNELS-DISTRIBUTION.md
Use template: ~/.claude/mario/templates/foundations/CHANNELS-DISTRIBUTION.md
</output>
", subagent_type="general-purpose", model="{researcher_model}", description="Channels & distribution research")
```

After all 7 agents complete, spawn synthesizer to create BRAND-BIBLE.md:

```
Task(prompt="
<task>
Synthesize 7 foundation research files into BRAND-BIBLE.md.
</task>

<research_files>
Read these files:
- .planning/foundations/BRAND-IDENTITY.md
- .planning/foundations/VOICE-TONE.md
- .planning/foundations/AUDIENCE-PERSONAS.md
- .planning/foundations/COMPETITIVE-LANDSCAPE.md
- .planning/foundations/MESSAGING-FRAMEWORK.md
- .planning/foundations/PRODUCT-SERVICE.md
- .planning/foundations/CHANNELS-DISTRIBUTION.md
</research_files>

<output>
Write to: .planning/foundations/BRAND-BIBLE.md
Use template: ~/.claude/mario/templates/foundations/BRAND-BIBLE.md
Commit ALL foundation files after writing BRAND-BIBLE.md.
</output>
", subagent_type="mario-research-synthesizer", model="{synthesizer_model}", description="Synthesize brand bible")
```

Display research complete banner and key findings:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► FOUNDATIONS COMPLETE ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Key Findings

**Voice:** [from BRAND-BIBLE.md voice card]
**Personas:** [from BRAND-BIBLE.md persona summaries]
**Core Message:** [from BRAND-BIBLE.md]
**Positioning:** [from BRAND-BIBLE.md competitive positioning]

Files: `.planning/foundations/`
```

**If "Skip research":** Continue to Step 6.

## 6. Done

Present completion with next steps:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► PROJECT INITIALIZED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**[Project Name]**

| Artifact        | Location                                    |
|-----------------|---------------------------------------------|
| Project         | `.planning/PROJECT.md`                      |
| Config          | `.planning/config.json`                     |
| Brand Identity  | `.planning/foundations/BRAND-IDENTITY.md`    |
| Voice & Tone    | `.planning/foundations/VOICE-TONE.md`        |
| Audience        | `.planning/foundations/AUDIENCE-PERSONAS.md`  |
| Competitors     | `.planning/foundations/COMPETITIVE-LANDSCAPE.md` |
| Messaging       | `.planning/foundations/MESSAGING-FRAMEWORK.md` |
| Product         | `.planning/foundations/PRODUCT-SERVICE.md`    |
| Channels        | `.planning/foundations/CHANNELS-DISTRIBUTION.md` |
| Brand Bible     | `.planning/foundations/BRAND-BIBLE.md`       |

**8 foundation documents** | Ready for content creation ✓

───────────────────────────────────────────────────────────────

## ▶ Next Up

**Create content** — Tell Mario what to write.

`/mario:create "Write a blog post about [topic]"`

<sub>/clear first → fresh context window</sub>

───────────────────────────────────────────────────────────────

**Also available:**
- `/mario:create "Write a landing page for [product]"` — any content type
- `/mario:help` — see all commands

───────────────────────────────────────────────────────────────
```

</process>

<output>

- `.planning/PROJECT.md`
- `.planning/config.json`
- `.planning/foundations/` (if research selected)
  - `BRAND-IDENTITY.md`
  - `VOICE-TONE.md`
  - `AUDIENCE-PERSONAS.md`
  - `COMPETITIVE-LANDSCAPE.md`
  - `MESSAGING-FRAMEWORK.md`
  - `PRODUCT-SERVICE.md`
  - `CHANNELS-DISTRIBUTION.md`
  - `BRAND-BIBLE.md`

</output>

<success_criteria>

- [ ] .planning/ directory created
- [ ] Git repo initialized
- [ ] Deep questioning completed (threads followed, not rushed)
- [ ] PROJECT.md captures full context → **committed**
- [ ] config.json has workflow mode → **committed**
- [ ] Foundation research completed (if selected) — 7 parallel agents spawned
- [ ] BRAND-BIBLE.md synthesized from 7 foundation files
- [ ] All foundation files → **committed**
- [ ] User knows next step is `/mario:create`

**Atomic commits:** Each step commits its artifacts immediately. If context is lost, artifacts persist.

</success_criteria>
