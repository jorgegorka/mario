<purpose>
Orchestrate parallel debug agents to investigate review gaps and find root causes.

After review finds gaps, spawn one debug agent per gap. Each agent investigates autonomously with symptoms pre-filled from review notes. Collect root causes, update gap tracking with diagnosis, then hand off to planning with actual diagnoses.

Orchestrator stays lean: parse gaps, spawn agents, collect results, update tracking.
</purpose>

<paths>
DEBUG_DIR=.planning/debug

Debug files use the `.planning/debug/` path (hidden directory with leading dot).
</paths>

<core_principle>
**Diagnose before planning fixes.**

Review tells us WHAT is broken (symptoms). Debug agents find WHY (root cause). Planning then creates targeted fixes based on actual causes, not guesses.

Without diagnosis: "Email open rates are low" → guess at fix → maybe wrong
With diagnosis: "Email open rates are low" → "subject lines don't match audience pain points from positioning" → precise fix
</core_principle>

<process>

<step name="parse_gaps">
**Extract gaps from review notes:**

Read the "Gaps" section (YAML format):
```yaml
- truth: "Email welcome sequence drives trial signups"
  status: failed
  reason: "Stakeholder reported: subscribers open emails but don't click through to trial"
  severity: major
  test: 2
  artifacts: []
  missing: []
```

For each gap, also read any corresponding notes to get full context.

Build gap list:
```
gaps = [
  {truth: "Email welcome sequence drives trial signups...", severity: "major", test_num: 2, reason: "..."},
  {truth: "Landing page headline matches ad copy...", severity: "minor", test_num: 5, reason: "..."},
  ...
]
```
</step>

<step name="report_plan">
**Report diagnosis plan to user:**

```
## Diagnosing {N} Gaps

Spawning parallel debug agents to investigate root causes:

| Gap (Truth) | Severity |
|-------------|----------|
| Email welcome sequence drives trial signups | major |
| Landing page headline matches ad copy | minor |
| CTA leads to correct signup page | blocker |

Each agent will:
1. Create DEBUG-{slug}.md with symptoms pre-filled
2. Investigate autonomously (read code, form hypotheses, test)
3. Return root cause

This runs in parallel - all gaps investigated simultaneously.
```
</step>

<step name="spawn_agents">
**Spawn debug agents in parallel:**

For each gap, fill the debug-subagent-prompt template and spawn:

```
Task(
  prompt=filled_debug_subagent_prompt,
  subagent_type="general-purpose",
  description="Debug: {truth_short}"
)
```

**All agents spawn in single message** (parallel execution).

Template placeholders:
- `{truth}`: The expected behavior that failed
- `{expected}`: From UAT test
- `{actual}`: Verbatim user description from reason field
- `{errors}`: Any error messages from UAT (or "None reported")
- `{reproduction}`: "Test {test_num} in UAT"
- `{timeline}`: "Discovered during UAT"
- `{goal}`: `find_root_cause_only` (review flow - planning handles fixes)
- `{slug}`: Generated from truth
</step>

<step name="collect_results">
**Collect root causes from agents:**

Each agent returns with:
```
## ROOT CAUSE FOUND

**Debug Session:** ${DEBUG_DIR}/{slug}.md

**Root Cause:** {specific cause with evidence}

**Evidence Summary:**
- {key finding 1}
- {key finding 2}
- {key finding 3}

**Files Involved:**
- {file1}: {what's wrong}
- {file2}: {related issue}

**Suggested Fix Direction:** {brief hint for planning}
```

Parse each return to extract:
- root_cause: The diagnosed cause
- files: Files involved
- debug_path: Path to debug session file
- suggested_fix: Hint for gap closure plan

If agent returns `## INVESTIGATION INCONCLUSIVE`:
- root_cause: "Investigation inconclusive - manual review needed"
- Note which issue needs manual attention
- Include remaining possibilities from agent return
</step>

<step name="update_uat">
**Update gap tracking with diagnosis:**

For each gap, add artifacts and missing fields:

```yaml
- truth: "Email welcome sequence drives trial signups"
  status: failed
  reason: "Stakeholder reported: subscribers open emails but don't click through to trial"
  severity: major
  test: 2
  root_cause: "CTA copy in emails is generic and doesn't reference specific pain points from positioning"
  artifacts:
    - path: "content/email/welcome-sequence.md"
      issue: "CTA text is vague 'Learn more' instead of benefit-driven action"
  missing:
    - "Rewrite CTAs to reflect specific outcomes from messaging hierarchy"
    - "Add social proof near CTA to reduce friction"
  debug_session: .planning/debug/email-low-clickthrough.md
```

Update status to "diagnosed".

Commit the updated tracking:
```bash
mario-tools commit "docs(plan): add root causes from diagnosis" --files ".planning/plans/NNN-slug/gaps.md"
```
</step>

<step name="report_results">
**Report diagnosis results and hand off:**

Display:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► DIAGNOSIS COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

| Gap (Truth) | Root Cause | Files |
|-------------|------------|-------|
| Email drives trial signups | CTA copy is generic, not benefit-driven | content/email/welcome-sequence.md |
| Landing page matches ad copy | Headline was updated without updating ad variants | content/web/landing-page.md |
| CTA leads to signup page | Link target is placeholder URL | content/web/homepage.md |

Debug sessions: ${DEBUG_DIR}/

Proceeding to plan fixes...
```

Return to the orchestrator for next steps.
Do NOT offer manual next steps - the orchestrator handles the rest.
</step>

</process>

<context_efficiency>
Agents start with symptoms pre-filled from UAT (no symptom gathering).
Agents only diagnose—planning handles fixes (no fix application).
</context_efficiency>

<failure_handling>
**Agent fails to find root cause:**
- Mark gap as "needs manual review"
- Continue with other gaps
- Report incomplete diagnosis

**Agent times out:**
- Check DEBUG-{slug}.md for partial progress
- Can resume with /mario:debug

**All agents fail:**
- Something systemic (permissions, git, etc.)
- Report for manual investigation
- Fall back to planning without root causes (less precise)
</failure_handling>

<success_criteria>
- [ ] Gaps parsed from review notes
- [ ] Debug agents spawned in parallel
- [ ] Root causes collected from all agents
- [ ] Gap tracking updated with artifacts and missing
- [ ] Debug sessions saved to ${DEBUG_DIR}/
- [ ] Hand off to orchestrator for automatic planning
</success_criteria>
