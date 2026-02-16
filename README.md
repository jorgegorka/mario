# Mario

A meta-prompting and context engineering system for building and executing marketing plans [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

[![Gem Version](https://badge.fury.io/rb/mario.svg)](https://rubygems.org/gems/mario)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Mario turns Claude Code into a disciplined marketing content engine that plans before it creates, verifies after it delivers, and tracks state across sessions. It provides structured planning, multi-agent orchestration, and verification workflows via slash commands. Specialized executor agents handle strategy, web copy, email, social, SEO, and paid ads domains with marketing-specific guides and frameworks baked in.

A system of prompts, agents, and workflows that make Claude Code work like a disciplined marketing team.

## Why Mario

**Without Mario**, Claude Code sessions are stateless. There's no memory between sessions, no structure to large projects, no verification that what was built matches what was planned, and no way to coordinate parallel work streams.

**With Mario**, you get:

- **Persistent memory** — `STATE.md` tracks decisions, progress, and blockers across sessions
- **Structured planning** — roadmaps, phases, and plans with dependency-aware execution
- **Parallel agents** — wave-based execution spawns multiple agents working simultaneously
- **Marketing-aware executors** — strategy, web, email, social, SEO, and ads agents load domain-specific guides and frameworks
- **Verification** — automated goal checking plus conversational UAT after every phase
- **Session continuity** — pause mid-phase, resume later with full context restoration

## How It Works

1. You invoke a slash command (e.g., `/mario:execute-phase 1`)
2. The command loads a workflow definition and gathers context via `mario-tools`
3. An orchestrator spawns specialised agents (planner, executor, verifier) in parallel, routing to domain-specific marketing executors based on plan metadata
4. Agents execute tasks, make atomic commits, and produce summaries
5. Project state is updated in `.planning/STATE.md`

## Quick Start

### Installation

```bash
gem install mario
```

Install commands and agents globally (recommended):

```bash
mario install --global    # Installs to ~/.claude/ — available in all projects
```

Or locally for a single project:

```bash
mario install --local     # Installs to ./.claude/ — project-specific
```

### New Marketing Project (Greenfield)

```
/mario:new-project           # Define vision, research domain, create roadmap
/clear
/mario:plan-phase 1          # Create detailed plan for first phase
/clear
/mario:execute-phase 1       # Execute it with parallel agents
/mario:verify-work 1         # Conversational UAT
```

Use `/clear` between commands to give each orchestrator a fresh context window. Each command loads only the context it needs.

### Existing Marketing Presence (Brownfield)

```
/mario:map-codebase          # Audit existing marketing → .planning/codebase/
/clear
/mario:new-project           # Define vision using marketing audit
/clear
/mario:plan-phase 1          # Plan first phase
/clear
/mario:execute-phase 1       # Execute
```

For adding campaigns to an existing project without a full roadmap, use `/mario:new-milestone` instead of `/mario:new-project`.

## Usage Guide

### The Core Loop: Plan, Execute, Verify

Every phase follows the same three-step cycle:

**Plan** (`/mario:plan-phase N`) — spawns a researcher, planner, and plan-checker working in sequence. The researcher investigates the ecosystem, the planner creates `PLAN.md` files with tasks, and the plan-checker validates the plan against the phase goal. Output: one or more `PLAN.md` files in `.planning/phases/`.

**Execute** (`/mario:execute-phase N`) — groups plans into waves based on dependency numbering. Plans in the same wave run in parallel via separate executor agents. Each agent reads its plan, executes tasks with atomic commits, and writes a `SUMMARY.md`. The orchestrator spot-checks results between waves.

**Verify** (`/mario:verify-work N`) — conversational UAT session. The verifier checks whether the phase goal was achieved (not just whether tasks were completed). If gaps are found, it creates a verification report and you can run `/mario:plan-phase N --gaps` to close them.

### Phase Preparation (Optional)

For complex phases, prepare before planning:

```
/mario:discuss-phase N              # Capture your vision and decisions → CONTEXT.md
/clear
/mario:research-phase N             # Deep ecosystem research → RESEARCH.md
/clear
/mario:list-phase-assumptions N     # See Claude's intended approach before committing
/clear
/mario:plan-phase N                 # Plan with full context
```

These commands are optional — `/mario:plan-phase` works standalone. But for phases involving unfamiliar libraries or architectural decisions, preparation pays off.

### Session Management

```
/mario:pause-work        # Creates .continue-here.md handoff document
/mario:resume-work       # Restores context and routes to next action
/mario:progress          # Status overview with next-action routing
```

Pause *before* hitting context limits. The handoff document captures current position, completed work, and what's next so the new session starts informed.

### Quick Tasks

```
/mario:quick             # Same guarantees, skips optional agents
```

For small, ad-hoc tasks that don't warrant a full phase cycle. Quick tasks live in `.planning/quick/`, get atomic commits, and update `STATE.md` — but skip the roadmap and don't create phase directories.

### Milestone Lifecycle

Milestones represent major release boundaries (v1.0, v2.0). The full lifecycle:

```
# After completing all phases in a milestone:
/mario:audit-milestone           # Check completion against original intent
/mario:plan-milestone-gaps       # Create phases to close any audit gaps
# Execute gap phases...
/mario:complete-milestone v1.0   # Archive milestone and tag release
/mario:new-milestone v2.0        # Start next milestone
```

Roadmap manipulation commands:

- `/mario:add-phase` — append a phase to the current milestone
- `/mario:insert-phase` — insert urgent work as a decimal phase (e.g., 3.1)
- `/mario:remove-phase` — remove a future phase and renumber

### Debugging

```
/mario:debug [description]    # Systematic debugging with persistent state
```

Uses the scientific method: observe, hypothesise, test, conclude. Debug state persists in `.planning/debug/` and survives `/clear`, so you can continue across sessions.

## Hierarchy Model

```
Project → Milestones → Phases → Plans → Tasks
```

- **Project** — the thing you're building
- **Milestones** — major release boundaries (v1.0, v2.0)
- **Phases** — logical chunks of work within a milestone
- **Plans** — concrete execution steps within a phase, with wave-based parallelism
- **Tasks** — individual items within a plan

Plans use wave-based numbering (e.g., `01-01`, `01-02`) to express parallelism. Plans sharing a wave number execute in parallel; higher waves wait for lower waves to complete.

## Agent System

### Orchestrators

Lightweight coordinators that spawn specialised agents. They stay lean (~10-15% context usage), passing file paths to subagents rather than content. Each subagent gets a fresh 200k context window.

### Specialised Executors

Plans include a `domain` field in their frontmatter. The execute-phase orchestrator routes each plan to the appropriate marketing-aware executor:

| Domain | Executor | Guide |
|--------|----------|-------|
| `strategy` | `mario-strategy-executor` | `guides/strategy.md` |
| `web` | `mario-web-executor` | `guides/web-copy.md` |
| `email` | `mario-email-executor` | `guides/email.md` |
| `social` | `mario-social-executor` | `guides/social.md` |
| `seo` | `mario-seo-executor` | `guides/seo-content.md` |
| `ads` | `mario-ads-executor` | `guides/paid-ads.md` |
| `general` (default) | `mario-executor` | (none) |

Each specialised executor loads its domain guide automatically, applying domain-specific frameworks and best practices.

### Analysis & Research Agents

| Agent | Role |
|-------|------|
| `mario-planner` | Creates PLAN.md files from phase goals and research |
| `mario-plan-checker` | Validates plans against phase goals |
| `mario-verifier` | Checks goal achievement, not just task completion |
| `mario-integration-checker` | Verifies cross-phase integration and E2E flows |
| `mario-debugger` | Scientific method debugging with persistent state |
| `mario-phase-researcher` | Deep ecosystem research for a specific phase |
| `mario-project-researcher` | Domain research during project initialisation |
| `mario-research-synthesizer` | Synthesises parallel research outputs |
| `mario-codebase-mapper` | Audits existing marketing presence |
| `mario-roadmapper` | Creates project roadmaps with phase breakdown |

## Guides

Guides encode marketing frameworks, best practices, and domain knowledge that executors follow during plan execution. Read below how to customise them for your project.

| Guide | Purpose |
|-------|---------|
| `strategy.md` | Brand strategy, personas, voice definition, positioning, competitive analysis |
| `web-copy.md` | Landing pages, headline frameworks, CTAs, CRO, microcopy |
| `email.md` | Email sequences, subject lines, nurture campaigns, deliverability |
| `social.md` | Content pillars, platform strategies, hooks, repurposing workflows |
| `seo-content.md` | Technical SEO, keyword strategy, content types, hub-and-spoke model |
| `paid-ads.md` | Ad copy frameworks, campaign structure, audience segmentation, attribution |

Executors load the relevant guide automatically based on plan domain.

### Customising Guides

Guides are installed to `~/.claude/guides/` (global) or `.claude/guides/` (local). Edit them to match your project's conventions. After updating Mario, use `/mario:reapply-patches` to restore your customisations.

## Commands

### Project Initialisation

| Command | Description |
|---|---|
| `/mario:new-project` | Initialise project: questioning, research, requirements, roadmap |
| `/mario:map-codebase` | Audit existing marketing presence before starting (brownfield projects) |

### Phase Planning

| Command | Description |
|---|---|
| `/mario:discuss-phase <n>` | Capture your vision for a phase before planning |
| `/mario:research-phase <n>` | Deep ecosystem research for specialised domains |
| `/mario:list-phase-assumptions <n>` | See Claude's intended approach before it plans |
| `/mario:plan-phase <n>` | Create detailed execution plan |

### Execution

| Command | Description |
|---|---|
| `/mario:execute-phase <n>` | Execute all plans in a phase (wave-based parallelism) |
| `/mario:quick` | Small ad-hoc tasks with Mario guarantees |
| `/mario:verify-work <n>` | Conversational UAT for built features |

### Roadmap & Milestones

| Command | Description |
|---|---|
| `/mario:add-phase <desc>` | Add phase to end of milestone |
| `/mario:insert-phase <after> <desc>` | Insert urgent work as decimal phase (e.g., 7.1) |
| `/mario:remove-phase <n>` | Remove future phase and renumber |
| `/mario:new-milestone <name>` | Start a new milestone |
| `/mario:complete-milestone <ver>` | Archive milestone and tag release |
| `/mario:audit-milestone` | Audit completion against original intent |
| `/mario:plan-milestone-gaps` | Create phases to close audit gaps |

### Session & Progress

| Command | Description |
|---|---|
| `/mario:progress` | Status overview and next-action routing |
| `/mario:resume-work` | Restore context from previous session |
| `/mario:pause-work` | Create handoff for mid-phase breaks |

### Debugging & Todos

| Command | Description |
|---|---|
| `/mario:debug [desc]` | Systematic debugging with persistent state (survives `/clear`) |
| `/mario:add-todo [desc]` | Capture ideas/tasks |
| `/mario:check-todos [area]` | Review and work on pending todos |

### Configuration & Maintenance

| Command | Description |
|---|---|
| `/mario:settings` | Configure workflow toggles and model profile |
| `/mario:set-profile <profile>` | Switch model profile |
| `/mario:help` | Show full command reference |
| `/mario:update` | Update gem with changelog preview |
| `/mario:reapply-patches` | Restore local guide customisations after update |

## Planning Directory

```
.planning/
├── PROJECT.md                # Project vision and requirements
├── ROADMAP.md                # Phase breakdown with status
├── STATE.md                  # Project memory across sessions
├── REQUIREMENTS.md           # Detailed requirements
├── CONTEXT.md                # Phase discussion decisions
├── config.json               # Workflow mode and agent toggles
├── quick/                    # Quick task plans and summaries
├── todos/
│   ├── pending/
│   └── done/
├── debug/
│   └── resolved/
├── research/                 # Project-level research outputs
├── codebase/                 # Existing marketing presence audit
│   ├── TOOLS-AND-PLATFORMS.md  # CRM, email platform, analytics, CMS
│   ├── AUDIENCE-INSIGHTS.md    # Customer segments, personas, engagement
│   ├── CHANNEL-ARCHITECTURE.md # Active channels, funnel stages, attribution
│   ├── CONTENT-INVENTORY.md    # Website pages, emails, social, ads
│   ├── BRAND-GUIDELINES.md     # Voice attributes, tone, terminology
│   ├── PERFORMANCE-METRICS.md  # Metrics by channel, conversion rates
│   └── MARKETING-GAPS.md       # Messaging gaps, underperforming channels
└── phases/
    ├── 01-foundation/
    │   ├── RESEARCH.md
    │   ├── 01-01-PLAN.md
    │   └── 01-01-SUMMARY.md
    └── 02-core-features/
        ├── 02-01-PLAN.md
        └── 02-01-SUMMARY.md
```

## Configuration

### Model Profiles

Control which Claude models agents use via `/mario:set-profile`:

| Profile | Planning | Execution | Research/Verification |
|---|---|---|---|
| **quality** | Opus | Opus | Opus |
| **balanced** (default) | Opus | Sonnet | Sonnet |
| **budget** | Sonnet | Sonnet | Haiku |

### Workflow Toggles

Configure via `/mario:settings`:

| Toggle | Default | Effect |
|---|---|---|
| Research | on | Phase researcher runs before planning |
| Plan check | on | Plan-checker validates plans against goals |
| Verifier | on | Verifier runs after phase execution |

Per-command overrides: `--research`, `--skip-research`, `--skip-verify`.

### Branching Strategies

| Strategy | When branch is created | Scope | Best for |
|---|---|---|---|
| `none` (default) | Never | N/A | Solo development, simple projects |
| `phase` | At `execute-phase` start | Single phase | Code review per phase, granular rollback |
| `milestone` | At first `execute-phase` | Entire milestone | Release branches, PR per version |

Configure via `/mario:settings` or directly in `.planning/config.json`.

## Updating

```
/mario:update              # Shows changelog, confirms before installing
```

Local modifications to guides and templates are backed up automatically during updates. After updating, use `/mario:reapply-patches` to restore your customisations.

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
