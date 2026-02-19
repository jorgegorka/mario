# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- **BREAKING:** Renamed `.planning` directory to `.mario_planning` to avoid conflicts with other tools using the same directory name. Existing projects must rename their `.planning` directory to `.mario_planning`.

## [1.0.0] - 2026-02-18

Initial public release of Marketing Mario — a meta-prompting and context engineering system for Claude Code that generates and executes marketing plans.

### Added

- **Two-binary system**: `mario` CLI for installation and `mario-tools` for workflow dispatch
- **Hierarchy model**: Project → Milestones → Phases → Plans → Tasks with wave-based execution numbering for parallelism
- **15 slash commands**: `new-project`, `plan`, `execute`, `progress`, `quick`, `debug`, `create`, `new-from-template`, `save-template`, `add-todo`, `check-todos`, `settings`, `update`, `reapply-patches`, and `help`
- **14 specialized agents**: project researcher, research synthesizer, planner, plan researcher, executor, debugger, backlog planner, and domain-specific executors for ads, email, SEO, social, strategy, web, and topics
- **15 workflow definitions** orchestrating multi-agent planning, execution, and verification
- **18 templates** for plans, state files, reports, and project scaffolding
- **Tool modules**: StateManager, PlanManager, RoadmapAnalyzer, ConfigManager, Init, ModelProfiles, Verification, BacklogManager, GitIntegration, TemplateFiller, and Frontmatter
- **Model profiles**: three tiers (quality, balanced, budget) mapping agent types to Claude models
- **Manifest-based installer** with SHA256 integrity checks and local patch backup on upgrade
- **Global and local installation**: `mario install --global` for `~/.claude/` or `mario install --local` for `./.claude/`
