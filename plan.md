# Flatten Mario: From Phase Hierarchy to Plan-Based Marketing Workflow

## Context

Mario currently uses a deep hierarchy inherited from GSD (software development): Project → Milestones → Phases → Plans → Tasks. This is overkill for marketing work where projects are more sequential and many tasks are recurring (newsletters, blog posts, social content). The full ceremony (research → discuss → plan → execute → verify) adds unnecessary friction for simpler marketing deliverables.

**Goal:** Replace the hierarchy with a flat model: **Project → Plans → Tasks**. Plans become the primary work unit. Add reusable templates for recurring content tasks. Keep research + plan + execute, drop discuss and verify as separate ceremonies.

---

## New Data Model

### Hierarchy

```
Project (.planning/PROJECT.md)
  └── Plans (.planning/plans/{NNN}-{slug}/)
        ├── PLAN.md
        ├── RESEARCH.md     (optional)
        └── SUMMARY.md      (after execution)
```

### BACKLOG.md replaces ROADMAP.md

Flat ordered list of plans instead of a phased roadmap:

```markdown
# Backlog: [Project Name]

## Plans

- [x] **001: Brand Positioning** — Define voice, personas, messaging
- [x] **002: Homepage Copy** — Hero, benefits, CTAs
- [ ] **003: Welcome Email Sequence** — 5-email onboarding drip
- [ ] **004: Social Content Calendar** — 30-day calendar

## Upcoming

Ideas not yet scoped into plans:
- Blog content strategy
- Paid advertising campaigns

## Completed

| # | Plan | Completed | Commit |
|---|------|-----------|--------|
| 001 | Brand Positioning | 2026-02-10 | abc1234 |
```

### STATE.md simplified

One level of tracking (current plan), no phase/plan dual tracking, no performance metrics table.

### Templates for recurring tasks

```
.planning/templates/       (user-created, per-project)
  blog-post.md
  email-campaign.md

~/.claude/mario/templates/recurring/   (shipped defaults)
  blog-post.md
  email-campaign.md
  social-calendar.md
  landing-page.md
  content-brief.md
```

Templates are Markdown with YAML frontmatter defining variables. `/mario:new-from-template` fills variables and creates a new plan.

---

## Command Surface (13 commands, down from 27)

### Keep (renamed/simplified)

| New | Old | Change |
|-----|-----|--------|
| `/mario:new-project` | same | Drop milestones, create BACKLOG.md instead of ROADMAP.md |
| `/mario:plan [N]` | `plan-phase` + `research-phase` | Merged. Research is inline (toggled by config) |
| `/mario:execute [N]` | `execute-phase` | Single plan execution, no wave grouping |
| `/mario:progress` | same | Simplified: shows plan list, routes to next |
| `/mario:quick` | same | Quick tasks go into `.planning/plans/` as regular plans |
| `/mario:add-todo` | same | Unchanged |
| `/mario:check-todos` | same | Unchanged |
| `/mario:settings` | `settings` + `set-profile` | Merged |
| `/mario:help` | same | Unchanged |
| `/mario:update` | same | Unchanged |
| `/mario:debug` | same | Unchanged |

### New

| Command | Purpose |
|---------|---------|
| `/mario:new-from-template <name>` | Create plan from reusable template |
| `/mario:save-template <plan-N> <name>` | Save completed plan as template |

### Remove (14 commands)

`discuss-phase`, `verify-work`, `research-phase`, `add-phase`, `insert-phase`, `remove-phase`, `list-phase-assumptions`, `new-milestone`, `complete-milestone`, `audit-milestone`, `plan-milestone-gaps`, `pause-work`, `resume-work`, `map-codebase`

---

## Ruby Tool Changes

### Critical files to modify

| File | Action | Details |
|------|--------|---------|
| `lib/mario/tools/phase_manager.rb` | **Rewrite → `plan_manager.rb`** | `.planning/plans/` directory, sequential numbering, no decimal inserts, no milestone ops |
| `lib/mario/tools/roadmap_analyzer.rb` | **Rewrite → `backlog_manager.rb`** | Parse BACKLOG.md (flat list), track completion, add/remove plans |
| `lib/mario/tools/state_manager.rb` | **Simplify** | Remove phase/plan dual tracking, drop `advance-plan` and `record-metric`, single plan position |
| `lib/mario/tools/init.rb` | **Simplify** | Remove `new_milestone`, `milestone_op`, `verify_work`, `phase_op`. Rename `plan_phase` → `plan`, `execute_phase` → `execute`. Add `template` |
| `lib/mario/tools/config_manager.rb` | **Simplify** | Remove `parallelization`, `plan_checker`, `verifier`, branch templates from DEFAULTS |
| `lib/mario/tools/cli.rb` | **Update routes** | Rename `phase` → `plan`, `phases` → `plans`, `roadmap` → `backlog`, `find-phase` → `find-plan`. Remove `milestone`, `phase-plan-index` |
| `lib/mario/tools/template_filler.rb` | **Adapt** | Remove phase template logic, add recurring template variable filling |
| `lib/mario/tools/verification.rb` | **Simplify** | Remove phase completeness checks, keep plan structure validation |

### New files

| File | Purpose |
|------|---------|
| `lib/mario/tools/backlog_manager.rb` | Parse/update BACKLOG.md: `analyze`, `add`, `complete`, `get` |
| `lib/mario/tools/template_manager.rb` | List/fill/save recurring templates: `list`, `fill`, `save`, `get` |

### Files to remove

None - the old files get rewritten in place (plan_manager replaces phase_manager, backlog_manager replaces roadmap_analyzer).

---

## Agent Changes

| Agent | Action |
|-------|--------|
| `mario-planner` | **Simplify**: remove wave/dependency logic, produce single PLAN.md per invocation |
| `mario-executor` | **Simplify**: execute one plan, create SUMMARY.md, no wave awareness |
| `mario-roadmapper` → `mario-backlog-planner` | **Rename + rewrite**: create ordered plan list, not phased roadmap |
| `mario-phase-researcher` → `mario-plan-researcher` | **Rename**: researches a plan topic, not a phase |
| `mario-project-researcher` | Unchanged |
| `mario-research-synthesizer` | Unchanged |
| `mario-debugger` | Unchanged |
| Domain executors (strategy, web, email, social, seo, ads) | Unchanged |
| `mario-plan-checker` | **Remove** (verification absorbed into execute) |
| `mario-verifier` | **Remove** |
| `mario-codebase-mapper` | **Remove** |
| `mario-integration-checker` | **Remove** |

---

## Workflow Changes

### Rewrite (6 workflows)

| Workflow | Change |
|----------|--------|
| `new-project.md` | Drop milestones, create BACKLOG.md, simpler config |
| `plan-phase.md` → `plan.md` | Remove wave logic, single PLAN.md, optional inline research |
| `execute-phase.md` → `execute.md` | Single plan execution, no wave grouping |
| `execute-plan.md` | Remove phase references, use plan numbers |
| `progress.md` | Simple: next unexecuted plan or done |
| `quick.md` | Quick tasks become regular plans in `.planning/plans/` |

### New (2 workflows)

| Workflow | Purpose |
|----------|---------|
| `new-from-template.md` | Fill template variables, create plan, update BACKLOG.md |
| `save-template.md` | Extract plan structure, create reusable template |

### Remove (17 workflows)

`new-milestone.md`, `complete-milestone.md`, `audit-milestone.md`, `plan-milestone-gaps.md`, `discuss-phase.md`, `verify-phase.md`, `verify-work.md`, `insert-phase.md`, `add-phase.md`, `remove-phase.md`, `research-phase.md`, `list-phase-assumptions.md`, `discovery-phase.md`, `transition.md`, `resume-project.md`, `pause-work.md`, `map-codebase.md`

---

## Template Changes

### Modify

| Template | Change |
|----------|--------|
| `state.md` | Remove phase/plan dual tracking, performance metrics |
| `roadmap.md` → `backlog.md` | Flat plan list |
| `project.md` | Remove milestone references |
| `requirements.md` | Traceability maps to plan numbers |
| `summary.md` + variants | Replace phase references with plan references |
| `phase-prompt.md` → `plan-prompt.md` | Simplify |

### New recurring templates

| Template | Purpose |
|----------|---------|
| `recurring/blog-post.md` | Blog post with variables for topic, audience, keywords |
| `recurring/email-campaign.md` | Multi-email campaign |
| `recurring/social-calendar.md` | Social media content calendar |
| `recurring/landing-page.md` | Landing page copy |
| `recurring/content-brief.md` | Content brief for freelancers/team |

### Remove

`milestone.md`, `milestone-archive.md`, `verification-report.md`, `UAT.md`, `context.md`, `discovery.md`, `continue-here.md`

---

## Test Changes

| Test | Action |
|------|--------|
| `test/tools/phase_manager_test.rb` → `plan_manager_test.rb` | Rewrite for flat plans |
| `test/tools/roadmap_analyzer_test.rb` → `backlog_manager_test.rb` | Rewrite for BACKLOG.md |
| `test/tools/state_manager_test.rb` | Simplify |
| `test/tools/init_test.rb` | Remove milestone/phase inits, add plan/backlog |
| `test/tools/config_manager_test.rb` | Remove deprecated config fields |
| `test/tools/template_filler_test.rb` | Adapt for flat model |
| `test/tools/verification_test.rb` | Simplify |
| NEW: `test/tools/backlog_manager_test.rb` | BACKLOG.md parsing |
| NEW: `test/tools/template_manager_test.rb` | Template fill/save |

---

## Implementation Sequence

### Wave 1: Core data model (Ruby tools)

Rewrite the Ruby tool modules that define the data model. These are the foundation everything else depends on.

1. `plan_manager.rb` (replaces `phase_manager.rb`)
2. `backlog_manager.rb` (replaces `roadmap_analyzer.rb`)
3. `template_manager.rb` (new)
4. `state_manager.rb` (simplify)
5. `config_manager.rb` (simplify DEFAULTS)
6. `init.rb` (simplify, rename workflow methods)
7. `cli.rb` (update routes)
8. `template_filler.rb` (adapt)
9. `verification.rb` (simplify)

### Wave 2: Tests for new Ruby modules

Write tests for the new/rewritten modules before changing the data files.

### Wave 3: Commands and workflows (data files)

1. Delete removed command files (14 commands)
2. Rename/rewrite kept command files
3. Create new command files (2 commands)
4. Delete removed workflow files (17 workflows)
5. Rename/rewrite kept workflow files (6 workflows)
6. Create new workflow files (2 workflows)

### Wave 4: Agents

1. Simplify `mario-planner` and `mario-executor`
2. Rename `mario-roadmapper` → `mario-backlog-planner`
3. Rename `mario-phase-researcher` → `mario-plan-researcher`
4. Delete removed agents (4 agents)

### Wave 5: Templates

1. Modify existing templates (state, requirements, summary, etc.)
2. Create `backlog.md` template (replacing `roadmap.md`)
3. Create recurring task templates (5 templates)
4. Delete removed templates

### Wave 6: Installer manifest and gemspec

Update the installer manifest to reflect new file structure. Version bump (2.0).

---

## Verification

1. **Tests pass**: `bundle exec rake test` after each wave
2. **Lint passes**: `bundle exec rubocop` after each wave
3. **Install works**: `mario install --global` installs the new commands/agents/workflows
4. **End-to-end flow**: In a test directory, run:
   - `/mario:new-project` creates PROJECT.md, REQUIREMENTS.md, BACKLOG.md, STATE.md
   - `/mario:plan 1` creates `.planning/plans/001-{slug}/PLAN.md`
   - `/mario:execute 1` runs the plan, creates SUMMARY.md
   - `/mario:progress` shows current position
   - `/mario:save-template 1 my-template` saves plan as template
   - `/mario:new-from-template my-template` creates new plan from template
5. **No phase/milestone references**: `grep -r "phase\|milestone" data/commands/ data/mario/workflows/ data/agents/` should return nothing (except help text explaining the migration)
