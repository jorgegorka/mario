<purpose>
Verify phase goal achievement through goal-backward analysis. Check that the content delivers what the phase promised, not just that tasks completed.

Executed by a verification subagent spawned from execute-phase.md.
</purpose>

<core_principle>
**Task completion ≠ Goal achievement**

A task "create email welcome sequence" can be marked complete when the sequence is a placeholder outline. The task was done — but the goal "working onboarding email flow" was not achieved.

Goal-backward verification:
1. What must be TRUE for the goal to be achieved?
2. What must EXIST for those truths to hold?
3. What must be CONNECTED for those assets to function?

Then verify each level against the actual content.
</core_principle>

<required_reading>
@~/.claude/mario/references/verification-patterns.md
@~/.claude/mario/templates/verification-report.md
</required_reading>

<process>

<step name="load_context" priority="first">
Load phase operation context:

```bash
INIT=$(mario-tools init phase-op "${PHASE_ARG}")
```

Extract from init JSON: `phase_dir`, `phase_number`, `phase_name`, `has_plans`, `plan_count`.

Then load phase details and list plans/summaries:
```bash
mario-tools roadmap get-phase "${phase_number}"
grep -E "^| ${phase_number}" .planning/REQUIREMENTS.md 2>/dev/null
ls "$phase_dir"/*-SUMMARY.md "$phase_dir"/*-PLAN.md 2>/dev/null
```

Extract **phase goal** from ROADMAP.md (the outcome to verify, not tasks) and **requirements** from REQUIREMENTS.md if it exists.
</step>

<step name="establish_must_haves">
**Option A: Must-haves in PLAN frontmatter**

Use mario-tools to extract must_haves from each PLAN:

```bash
for plan in "$PHASE_DIR"/*-PLAN.md; do
  MUST_HAVES=$(mario-tools frontmatter get "$plan" --field must_haves)
  echo "=== $plan ===" && echo "$MUST_HAVES"
done
```

Returns JSON: `{ truths: [...], artifacts: [...], key_links: [...] }`

Aggregate all must_haves across plans for phase-level verification.

**Option B: Derive from phase goal**

If no must_haves in frontmatter (MUST_HAVES returns error or empty):
1. State the goal from ROADMAP.md
2. Derive **truths** (3-7 observable behaviors, each testable)
3. Derive **artifacts** (concrete file paths for each truth)
4. Derive **key links** (critical wiring where stubs hide)
5. Document derived must-haves before proceeding
</step>

<step name="verify_truths">
For each observable truth, determine if the content delivers it.

**Status:** ✓ VERIFIED (all supporting assets pass) | ✗ FAILED (asset missing/stub/disconnected) | ? UNCERTAIN (needs human)

For each truth: identify supporting assets → check asset status → check connections → determine truth status.

**Example:** Truth "Prospect understands product value proposition" depends on content/web/homepage.md (presents messaging), content/strategy/positioning.md (defines positioning), content/strategy/messaging-hierarchy.md (provides proof points). If the homepage is a stub or positioning doc is empty → FAILED. If all exist, are substantive, and connected → VERIFIED.
</step>

<step name="verify_artifacts">
Use mario-tools for artifact verification against must_haves in each PLAN:

```bash
for plan in "$PHASE_DIR"/*-PLAN.md; do
  ARTIFACT_RESULT=$(mario-tools verify artifacts "$plan")
  echo "=== $plan ===" && echo "$ARTIFACT_RESULT"
done
```

Parse JSON result: `{ all_passed, passed, total, artifacts: [{path, exists, issues, passed}] }`

**Artifact status from result:**
- `exists=false` → MISSING
- `issues` not empty → STUB (check issues for "Only N lines" or "Missing pattern")
- `passed=true` → VERIFIED (Levels 1-2 pass)

**Level 3 — Connected (manual check for assets that pass Levels 1-2):**
```bash
grep -r "$artifact_name" content/ --include="*.md" --include="*.html"  # REFERENCED
grep -r "$artifact_name" content/ --include="*.md" --include="*.html" | grep -v "draft"  # USED
```
CONNECTED = referenced AND used. ORPHANED = exists but not referenced/used.

| Exists | Substantive | Connected | Status |
|--------|-------------|-----------|--------|
| ✓ | ✓ | ✓ | ✓ VERIFIED |
| ✓ | ✓ | ✗ | ⚠️ ORPHANED |
| ✓ | ✗ | - | ✗ STUB |
| ✗ | - | - | ✗ MISSING |
</step>

<step name="verify_wiring">
Use mario-tools for key link verification against must_haves in each PLAN:

```bash
for plan in "$PHASE_DIR"/*-PLAN.md; do
  LINKS_RESULT=$(mario-tools verify key-links "$plan")
  echo "=== $plan ===" && echo "$LINKS_RESULT"
done
```

Parse JSON result: `{ all_verified, verified, total, links: [{from, to, via, verified, detail}] }`

**Link status from result:**
- `verified=true` → WIRED
- `verified=false` with "not found" → NOT_WIRED
- `verified=false` with "Pattern not found" → PARTIAL

**Fallback patterns (if key_links not in must_haves):**

| Pattern | Check | Status |
|---------|-------|--------|
| Landing Page → CTA | Page contains call-to-action linking to next step in funnel | CONNECTED / PARTIAL (CTA exists but links nowhere) / NOT_CONNECTED |
| Email → Landing Page | Email sequence references and links to landing page or content asset | CONNECTED / PARTIAL (link but page missing) / NOT_CONNECTED |
| Positioning → Copy | Website copy reflects messaging hierarchy and brand positioning | CONNECTED / STUB (placeholder copy) / NOT_CONNECTED |
| Content → Proof Points | Claims in content are supported by evidence from strategy docs | CONNECTED / NOT_CONNECTED |

Record status and evidence for each key link.
</step>

<step name="verify_requirements">
If REQUIREMENTS.md exists:
```bash
grep -E "Phase ${PHASE_NUM}" .planning/REQUIREMENTS.md 2>/dev/null
```

For each requirement: parse description → identify supporting truths/artifacts → status: ✓ SATISFIED / ✗ BLOCKED / ? NEEDS HUMAN.
</step>

<step name="scan_antipatterns">
Extract files modified in this phase from SUMMARY.md, scan each:

| Pattern | Search | Severity |
|---------|--------|----------|
| TODO/FIXME/XXX/HACK | `grep -n -E "TODO\|FIXME\|XXX\|HACK"` | ⚠️ Warning |
| Placeholder content | `grep -n -iE "placeholder\|coming soon\|will be here"` | 🛑 Blocker |
| Empty returns | `grep -n -E "return null\|return \{\}\|return \[\]\|=> \{\}"` | ⚠️ Warning |
| Log-only functions | Functions containing only console.log | ⚠️ Warning |

Categorize: 🛑 Blocker (prevents goal) | ⚠️ Warning (incomplete) | ℹ️ Info (notable).
</step>

<step name="identify_human_verification">
**Always needs human:** Visual appearance, user journey flow completion, brand voice consistency, external platform integration, emotional resonance, messaging clarity.

**Needs human if uncertain:** Complex wiring grep can't trace, dynamic state-dependent behavior, edge cases.

Format each as: Test Name → What to do → Expected result → Why can't verify programmatically.
</step>

<step name="determine_status">
**passed:** All truths VERIFIED, all artifacts pass levels 1-3, all key links WIRED, no blocker anti-patterns.

**gaps_found:** Any truth FAILED, artifact MISSING/STUB, key link NOT_WIRED, or blocker found.

**human_needed:** All automated checks pass but human verification items remain.

**Score:** `verified_truths / total_truths`
</step>

<step name="generate_fix_plans">
If gaps_found:

1. **Cluster related gaps:** Positioning stub + copy disconnected → "Align web copy to positioning". Multiple missing → "Complete core content". Connections only → "Link existing assets".

2. **Generate plan per cluster:** Objective, 2-3 tasks (files/action/verify each), re-verify step. Keep focused: single concern per plan.

3. **Order by dependency:** Fix missing → fix stubs → fix wiring → verify.
</step>

<step name="create_report">
```bash
REPORT_PATH="$PHASE_DIR/${PHASE_NUM}-VERIFICATION.md"
```

Fill template sections: frontmatter (phase/timestamp/status/score), goal achievement, artifact table, wiring table, requirements coverage, anti-patterns, human verification, gaps summary, fix plans (if gaps_found), metadata.

See ~/.claude/mario/templates/verification-report.md for complete template.
</step>

<step name="return_to_orchestrator">
Return status (`passed` | `gaps_found` | `human_needed`), score (N/M must-haves), report path.

If gaps_found: list gaps + recommended fix plan names.
If human_needed: list items requiring human testing.

Orchestrator routes: `passed` → update_roadmap | `gaps_found` → create/execute fixes, re-verify | `human_needed` → present to user.
</step>

</process>

<success_criteria>
- [ ] Must-haves established (from frontmatter or derived)
- [ ] All truths verified with status and evidence
- [ ] All artifacts checked at all three levels
- [ ] All key links verified
- [ ] Requirements coverage assessed (if applicable)
- [ ] Anti-patterns scanned and categorized
- [ ] Human verification items identified
- [ ] Overall status determined
- [ ] Fix plans generated (if gaps_found)
- [ ] VERIFICATION.md created with complete report
- [ ] Results returned to orchestrator
</success_criteria>
