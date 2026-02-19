# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Mario is a Ruby gem that provides a meta-prompting and context engineering system for Claude Code. It adapts the "GSD" system to generate and execute marketing plans, offering structured planning, multi-agent orchestration, and verification workflows via Claude Code slash commands. It installs commands, agents, workflows, and templates into `~/.claude/` (global) or `.claude/` (local).

## Commands

**Tests:**
```bash
bundle exec rake test          # Run full test suite
ruby -Itest -Ilib test/tools/state_manager_test.rb  # Run a single test file
ruby -Itest -Ilib test/tools/state_manager_test.rb -n test_method_name  # Run a single test
```

**Lint:**
```bash
bundle exec rubocop            # Run linter
bundle exec rubocop -a         # Auto-fix
```

**Build:**
```bash
gem build marketing_mario.gemspec
```

**Install locally:**
```bash
bundle install
mario install --global       # Install commands/agents to ~/.claude/
mario install --local        # Install to ./.claude/
```

## Architecture

### Two-Binary System

- **`exe/mario`** — User-facing CLI for install/uninstall/version
- **`exe/mario-tools`** — Internal tool CLI dispatched by workflows during Claude Code sessions. Routes to `MarketingMario::Tools::CLI.run(ARGV)` which dispatches to subcommands: `state`, `resolve-model`, `find-phase`, `phase`, `phases`, `roadmap`, `milestone`, `validate`, `progress`, `todo`, `template`, `frontmatter`, `verify`, `init`, `commit`

### Hierarchy Model

```
Project → Milestones → Phases → Plans → Tasks
```

Phases are numbered (1, 2, 3) or decimal (2.1, 2.2) for insertions. Plans within phases use wave-based execution numbering (01-01, 01-02) to express parallelism and dependencies.

### Data Directory (`data/`)

Content installed into user's `.claude/` directory:

- **`commands/mario/`** — 27 slash command definitions (Markdown with YAML frontmatter)
- **`agents/`** — 11 agent definitions (orchestrators are lightweight coordinators; subagents get full 200k context)
- **`mario/workflows/`** — 29 workflow instructions that orchestrators follow
- **`mario/templates/`** — 26 templates for plans, state, reports, etc.
- **`mario/references/`** — 13 reference documents for agent context

### Tool Modules (`lib/marketing_mario/tools/`)

Each module follows the pattern: `MarketingMario::Tools::ModuleName` with a `dispatch(args, raw:)` method handling subcommands. Key modules:

- **`StateManager`** — Load/update `.mario_planning/STATE.md`, history digest, metrics, decisions, blockers
- **`PhaseManager`** — Phase directory operations, plan listing, milestone operations
- **`RoadmapAnalyzer`** — Parse `ROADMAP.md`, extract phase info, track progress
- **`Init`** — Workflow initialization; single call loads all context via `--include` flag, returns JSON
- **`ConfigManager`** — `.mario_planning/config.json` management
- **`Installer`** — Manifest-based installation with SHA256 integrity, local patch backup on upgrade

### Typical Runtime Flow (inside a Claude Code session)

1. User invokes slash command (e.g., `/mario:execute-phase 1`)
2. Command definition in `data/commands/` tells Claude to follow the workflow
3. Workflow calls `mario-tools init <workflow> <args>` to load context as JSON
4. Orchestrator spawns specialized agents (planner, executor, verifier) via Claude's Task tool
5. Agents execute, commit atomically, create summaries
6. State updated in `.mario_planning/STATE.md`

### Model Profiles

Three profiles (`quality`, `balanced`, `budget`) map agent types to Claude models (Opus/Sonnet/Haiku). Resolved via `mario-tools resolve-model`.

## Code Conventions

- Double quotes for strings (RuboCop enforced)
- Line length max 120, method length max 30, ABC size max 30
- JSON output from tools via `Output.json(data, raw: raw)`, errors via `Output.error(message)`
- `raw` flag on dispatch methods: `true` for JSON output (consumed by workflows), `false` for human-readable
- YAML frontmatter on all Markdown files in `data/` (commands, agents, workflows, templates)
