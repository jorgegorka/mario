# Mario

Prompts, agents, and workflows that make [Claude Code](https://docs.anthropic.com/en/docs/claude-code) work like a marketing team with perfect brand memory.

[![Gem Version](https://badge.fury.io/rb/marketing_mario.svg)](https://rubygems.org/gems/marketing_mario)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Mario turns Claude Code into a brand-aware marketing content engine. It builds deep brand foundations once, then uses them as persistent context for every piece of content you create — blog posts, landing pages, emails, social, ads. Specialized executor agents handle each marketing domain with frameworks and best practices baked in.

## Why Mario

**Without Mario**, Claude Code sessions are stateless. There's no memory between sessions, no brand context, no competitive awareness, and no way to keep content consistent across channels.

**With Mario**, you get:

- **Brand foundations** — 8 researched documents that capture your identity, voice, audience, positioning, and competitive landscape
- **Persistent memory** — brand context loads automatically into every content session
- **Competitive research** — topic researchers analyze competing content before you write
- **Marketing-aware agents** — strategy, web, email, social, SEO, and ads executors load domain-specific guides
- **Consistent voice** — every piece of content draws from the same brand bible
- **On-demand content** — one command to create any marketing asset, informed by your foundations

## How It Works

```
/mario:new-project → /mario:create → repeat
```

1. `/mario:new-project` builds your brand foundations through deep questioning and parallel research agents
2. `/mario:create` produces content using those foundations as context — blog posts, landing pages, emails, anything
3. Foundations persist across sessions, so every future `/mario:create` starts brand-aware

## Quick Start

### Installation

```bash
gem install marketing_mario
```

Install commands and agents globally (recommended):

```bash
mario install --global    # Installs to ~/.claude/ — available in all projects
```

Or locally for a single project:

```bash
mario install --local     # Installs to ./.claude/ — project-specific
```

### New Marketing Project

```
/mario:new-project                                          # Establish brand foundations
/clear
/mario:create "Write a blog post about customer onboarding" # Create content
/clear
/mario:create "Landing page for our enterprise plan"        # Create more content
/clear
/mario:create "Email welcome sequence for new signups"      # Keep going
```

Use `/clear` between commands to give each orchestrator a fresh context window. Each command loads only the context it needs.

## Usage Guide

### Brand Foundations

`/mario:new-project` takes you from idea to content-ready in one command:

- Deep questioning to understand your brand and market
- Spawns 7 parallel foundation researcher agents
- Produces comprehensive brand foundation documents
- Synthesizes everything into BRAND-BIBLE.md

The foundations created in `.planning/foundations/`:

| Document | Purpose |
|---|---|
| `BRAND-IDENTITY.md` | Core identity, mission, values, personality |
| `VOICE-TONE.md` | Voice attributes, tone guidelines, writing style |
| `AUDIENCE-PERSONAS.md` | Target segments, pain points, motivations |
| `COMPETITIVE-LANDSCAPE.md` | Competitor analysis, positioning gaps, opportunities |
| `MESSAGING-FRAMEWORK.md` | Key messages, value propositions, proof points |
| `PRODUCT-SERVICE.md` | Product details, features, benefits, differentiators |
| `CHANNELS-DISTRIBUTION.md` | Active channels, distribution strategy, platform approach |
| `BRAND-BIBLE.md` | Synthesized quick-reference from all foundations |

Pass `--auto` to skip interactive questioning and let researchers work from your initial input.

### Content Creation

`/mario:create` is the primary workflow:

1. Loads BRAND-BIBLE.md and PROJECT.md as context
2. Spawns a topic researcher to analyze competing content
3. Presents a research brief with recommended angle for your approval
4. Generates content aligned with brand voice and positioning
5. Conversational iteration until you're happy

```
/mario:create "Write a blog post about NPS surveys"
/mario:create "Landing page for our new feature"
/mario:create "Email nurture sequence for trial users"
```

### Templates

Save successful content structures as reusable templates:

```
/mario:save-template 003 email-sequence    # Save a plan's structure as template
/mario:new-from-template email-sequence    # Create a new plan from it
```

Templates live in `.planning/templates/` and capture the task structure without the specific content, so you can replicate what works.

### Quick Tasks

```
/mario:quick    # Same guarantees, skips optional agents
```

For small, ad-hoc tasks that don't warrant the full create workflow. Quick tasks live in `.planning/quick/`, get atomic commits, and update state — but skip research and checkpoints.

### Debugging

```
/mario:debug "form submission fails silently"    # Start debug session
/clear
/mario:debug                                      # Resume from where you left off
```

Uses the scientific method: observe, hypothesize, test, conclude. Debug state persists in `.planning/debug/` and survives `/clear`, so you can continue across sessions.

## Commands

### Core Workflow

| Command | Description |
|---|---|
| `/mario:new-project` | Establish brand foundations through questioning and parallel research |
| `/mario:create <desc>` | Create content using brand foundations and topic research |
| `/mario:plan <number>` | Create detailed execution plan for a backlog item |
| `/mario:execute <number>` | Execute a plan |
| `/mario:quick` | Small ad-hoc tasks with Mario guarantees |

### Templates

| Command | Description |
|---|---|
| `/mario:new-from-template [name]` | Create a new plan from a reusable template |
| `/mario:save-template <number> [name]` | Save a plan's structure as a reusable template |

### Progress, Todos & Debug

| Command | Description |
|---|---|
| `/mario:progress` | Status overview and next-action routing |
| `/mario:debug [desc]` | Systematic debugging with persistent state (survives `/clear`) |
| `/mario:add-todo [desc]` | Capture ideas and tasks |
| `/mario:check-todos [area]` | Review and work on pending todos |

### Configuration & Maintenance

| Command | Description |
|---|---|
| `/mario:settings [profile]` | Configure workflow mode and model profile |
| `/mario:help` | Show full command reference |
| `/mario:update` | Update gem with changelog preview |
| `/mario:reapply-patches` | Restore local guide customizations after update |

## Agent System

### Orchestrators

Lightweight coordinators that spawn specialized agents. They stay lean (~10-15% context usage), passing file paths to subagents rather than content. Each subagent gets a fresh 200k context window.

### Domain Executors

Plans include a `domain` field in their frontmatter. The orchestrator routes each plan to the appropriate marketing-aware executor:

| Domain | Executor | Guide |
|---|---|---|
| `strategy` | `mario-strategy-executor` | `guides/strategy.md` |
| `web` | `mario-web-executor` | `guides/web-copy.md` |
| `email` | `mario-email-executor` | `guides/email.md` |
| `social` | `mario-social-executor` | `guides/social.md` |
| `seo` | `mario-seo-executor` | `guides/seo-content.md` |
| `ads` | `mario-ads-executor` | `guides/paid-ads.md` |
| `general` (default) | `mario-executor` | (none) |

Each specialized executor loads its domain guide automatically, applying domain-specific frameworks and best practices.

### Research & Planning Agents

| Agent | Role |
|---|---|
| `mario-planner` | Creates PLAN.md files with task breakdown and goal-backward verification |
| `mario-backlog-planner` | Creates ordered plan lists for BACKLOG.md during project initialization |
| `mario-project-researcher` | Domain research during project initialization |
| `mario-topic-researcher` | Analyzes competing content for a specific topic during `/mario:create` |
| `mario-plan-researcher` | Researches a plan topic before planning |
| `mario-research-synthesizer` | Synthesizes parallel research outputs into unified briefs |
| `mario-debugger` | Scientific method debugging with persistent state |

## Guides

Guides encode marketing frameworks, best practices, and domain knowledge that executors follow during plan execution.

| Guide | Purpose |
|---|---|
| `strategy.md` | Brand strategy, personas, voice definition, positioning, competitive analysis |
| `web-copy.md` | Landing pages, headline frameworks, CTAs, CRO, microcopy |
| `email.md` | Email sequences, subject lines, nurture campaigns, deliverability |
| `social.md` | Content pillars, platform strategies, hooks, repurposing workflows |
| `seo-content.md` | Technical SEO, keyword strategy, content types, hub-and-spoke model |
| `paid-ads.md` | Ad copy frameworks, campaign structure, audience segmentation, attribution |

### Customizing Guides

Guides are installed to `~/.claude/guides/` (global) or `.claude/guides/` (local). Edit them to match your project's conventions. After updating Mario, use `/mario:reapply-patches` to restore your customizations.

## Planning Directory

```
.planning/
├── PROJECT.md            # Project vision and initial notes
├── BACKLOG.md            # Ordered list of plans to execute
├── STATE.md              # Project memory across sessions
├── config.json           # Workflow mode and settings
├── foundations/           # Brand foundation documents
│   ├── BRAND-IDENTITY.md
│   ├── VOICE-TONE.md
│   ├── AUDIENCE-PERSONAS.md
│   ├── COMPETITIVE-LANDSCAPE.md
│   ├── MESSAGING-FRAMEWORK.md
│   ├── PRODUCT-SERVICE.md
│   ├── CHANNELS-DISTRIBUTION.md
│   └── BRAND-BIBLE.md   # Synthesized quick-reference
├── plans/                # Execution plans and summaries
│   ├── 001-foundation/
│   │   ├── PLAN.md
│   │   └── SUMMARY.md
│   └── 002-core-features/
│       ├── PLAN.md
│       └── SUMMARY.md
├── templates/            # Reusable plan templates
├── quick/                # Quick task plans and summaries
├── todos/
│   ├── pending/          # Todos waiting to be worked on
│   └── done/             # Completed todos
└── debug/
    └── resolved/         # Archived resolved issues
```

## Configuration

### Model Profiles

Control which Claude models agents use via `/mario:settings`:

| Profile | Planning | Execution | Research |
|---|---|---|---|
| **quality** | Opus | Opus | Opus |
| **balanced** (default) | Opus | Sonnet | Sonnet |
| **budget** | Sonnet | Sonnet | Haiku |

### Settings

Configure via `/mario:settings`:

- **Research toggle** — enable/disable competitive research during content creation
- **Model profile** — select quality, balanced, or budget

### Workflow Modes

Set during `/mario:new-project`:

**Interactive Mode** — confirms each major decision, pauses at checkpoints for approval, more guidance throughout.

**YOLO Mode** — auto-approves most decisions, executes without confirmation, only stops for critical checkpoints.

Change anytime by editing `.planning/config.json`.

## Common Workflows

**Starting a new project:**

```
/mario:new-project        # Establish brand foundations
/clear
/mario:create "Blog post about customer onboarding best practices"
```

**Creating more content:**

```
/mario:create "Email welcome sequence for new signups"
/clear
/mario:create "Landing page for our enterprise plan"
```

**Resuming work after a break:**

```
/mario:progress  # See where you left off and continue
```

**Capturing ideas during work:**

```
/mario:add-todo                    # Capture from conversation context
/mario:add-todo Fix modal z-index  # Capture with explicit description
/mario:check-todos                 # Review and work on todos
```

**Debugging an issue:**

```
/mario:debug "form submission fails silently"  # Start debug session
/clear
/mario:debug                                    # Resume from where you left off
```

## Updating

```
/mario:update              # Shows changelog, confirms before installing
```

Local modifications to guides and templates are backed up automatically during updates. After updating, use `/mario:reapply-patches` to restore your customizations.

## Requirements

- Ruby >= 3.1.0
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)

## Contributors

- [Mario Alvarez](https://github.com/marioalna)
- [Jorge Alvarez](https://github.com/jorgegorka)

## Acknowledgements

- [GSD](https://gsd.build/) for inspiring the project and providing a solid foundation to build upon.
- [Corey Heines](https://github.com/coreyhaines31/marketingskills) we stand on the shoulders of giants.
- [TalentoHQ](https://talentohq.com/) for their work on agent orchestration and workflow design.

## License

[MIT](LICENSE)
