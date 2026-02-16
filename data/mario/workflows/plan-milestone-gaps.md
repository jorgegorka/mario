<purpose>
Create all phases necessary to close gaps identified by `/mario:audit-milestone`. Reads MILESTONE-AUDIT.md, groups gaps into logical phases, creates phase entries in ROADMAP.md, and offers to plan each phase. One command creates all fix phases — no manual `/mario:add-phase` per gap.
</purpose>

<required_reading>
Read all files referenced by the invoking prompt's execution_context before starting.
</required_reading>

<process>

## 1. Load Audit Results

```bash
# Find the most recent audit file
ls -t .planning/v*-MILESTONE-AUDIT.md 2>/dev/null | head -1
```

Parse YAML frontmatter to extract structured gaps:
- `gaps.requirements` — unsatisfied requirements
- `gaps.integration` — missing cross-phase connections
- `gaps.flows` — broken E2E flows

If no audit file exists or has no gaps, error:
```
No audit gaps found. Run `/mario:audit-milestone` first.
```

## 2. Prioritize Gaps

Group gaps by priority from REQUIREMENTS.md:

| Priority | Action |
|----------|--------|
| `must` | Create phase, blocks milestone |
| `should` | Create phase, recommended |
| `nice` | Ask user: include or defer? |

For integration/flow gaps, infer priority from affected requirements.

## 3. Group Gaps into Phases

Cluster related gaps into logical phases:

**Grouping rules:**
- Same affected phase → combine into one fix phase
- Same channel (email, web, social) → combine
- Dependency order (fix stubs before wiring)
- Keep phases focused: 2-4 tasks each

**Example grouping:**
```
Gap: EMAIL-01 unsatisfied (Welcome sequence doesn't link to onboarding)
Gap: Integration Phase 1→3 (Brand positioning not reflected in email copy)
Gap: Flow "New subscriber journey" broken at nurture step

→ Phase 6: "Connect Email Sequence to Brand Positioning"
  - Update welcome email copy to reflect brand voice
  - Add onboarding content links to email sequence
  - Align email CTAs with landing page messaging
  - Include proof points from positioning document
```

## 4. Determine Phase Numbers

Find highest existing phase:
```bash
# Get sorted phase list, extract last one
PHASES=$(mario-tools phases list)
HIGHEST=$(echo "$PHASES" | jq -r '.directories[-1]')
```

New phases continue from there:
- If Phase 5 is highest, gaps become Phase 6, 7, 8...

## 5. Present Gap Closure Plan

```markdown
## Gap Closure Plan

**Milestone:** {version}
**Gaps to close:** {N} requirements, {M} integration, {K} flows

### Proposed Phases

**Phase {N}: {Name}**
Closes:
- {REQ-ID}: {description}
- Integration: {from} → {to}
Tasks: {count}

**Phase {N+1}: {Name}**
Closes:
- {REQ-ID}: {description}
- Flow: {flow name}
Tasks: {count}

{If nice-to-have gaps exist:}

### Deferred (nice-to-have)

These gaps are optional. Include them?
- {gap description}
- {gap description}

---

Create these {X} phases? (yes / adjust / defer all optional)
```

Wait for user confirmation.

## 6. Update ROADMAP.md

Add new phases to current milestone:

```markdown
### Phase {N}: {Name}
**Goal:** {derived from gaps being closed}
**Requirements:** {REQ-IDs being satisfied}
**Gap Closure:** Closes gaps from audit

### Phase {N+1}: {Name}
...
```

## 7. Create Phase Directories

```bash
mkdir -p ".planning/phases/{NN}-{name}"
```

## 8. Commit Roadmap Update

```bash
mario-tools commit "docs(roadmap): add gap closure phases {N}-{M}" --files .planning/ROADMAP.md
```

## 9. Offer Next Steps

```markdown
## ✓ Gap Closure Phases Created

**Phases added:** {N} - {M}
**Gaps addressed:** {count} requirements, {count} integration, {count} flows

---

## ▶ Next Up

**Plan first gap closure phase**

`/mario:plan-phase {N}`

<sub>`/clear` first → fresh context window</sub>

---

**Also available:**
- `/mario:execute-phase {N}` — if plans already exist
- `cat .planning/ROADMAP.md` — see updated roadmap

---

**After all gap phases complete:**

`/mario:audit-milestone` — re-audit to verify gaps closed
`/mario:complete-milestone {version}` — archive when audit passes
```

</process>

<gap_to_phase_mapping>

## How Gaps Become Tasks

**Requirement gap → Tasks:**
```yaml
gap:
  id: EMAIL-01
  description: "Subscriber receives onboarding content"
  reason: "Welcome sequence exists but doesn't link to onboarding assets"
  missing:
    - "Links to onboarding guide in welcome emails"
    - "Personalized content recommendations"
    - "Clear CTA in each email"

becomes:

phase: "Complete Email Onboarding Flow"
tasks:
  - name: "Add onboarding links"
    files: [content/email/welcome-sequence.md, content/web/onboarding-guide.md]
    action: "Add links to onboarding guide content in welcome email sequence"

  - name: "Add personalization"
    files: [content/email/welcome-sequence.md]
    action: "Include segment-specific content recommendations based on signup source"

  - name: "Strengthen CTAs"
    files: [content/email/welcome-sequence.md]
    action: "Replace placeholder CTAs with action-oriented copy aligned to messaging hierarchy"
```

**Integration gap → Tasks:**
```yaml
gap:
  from_phase: 1
  to_phase: 3
  connection: "Brand positioning → Email copy"
  reason: "Email copy doesn't reflect brand voice or positioning"
  missing:
    - "Brand voice applied to email subject lines"
    - "Proof points from positioning document"

becomes:

phase: "Align Email Copy to Brand Positioning"
tasks:
  - name: "Apply brand voice to emails"
    files: [content/email/welcome-sequence.md, content/strategy/brand-voice.md]
    action: "Rewrite email copy to match brand voice attributes and tone guidelines"

  - name: "Add proof points"
    files: [content/email/welcome-sequence.md, content/strategy/positioning.md]
    action: "Include relevant proof points and social proof from positioning document"
```

**Flow gap → Tasks:**
```yaml
gap:
  name: "Subscriber journey from signup to first purchase"
  broken_at: "Nurture email step"
  reason: "No link to product page"
  missing:
    - "Product page link in nurture emails"
    - "Testimonial or case study reference"
    - "Clear next-step CTA"

becomes:

# Usually same phase as requirement/integration gap
# Flow gaps often overlap with other gap types
```

</gap_to_phase_mapping>

<success_criteria>
- [ ] MILESTONE-AUDIT.md loaded and gaps parsed
- [ ] Gaps prioritized (must/should/nice)
- [ ] Gaps grouped into logical phases
- [ ] User confirmed phase plan
- [ ] ROADMAP.md updated with new phases
- [ ] Phase directories created
- [ ] Changes committed
- [ ] User knows to run `/mario:plan-phase` next
</success_criteria>
