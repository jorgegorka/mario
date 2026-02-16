<purpose>
Orchestrate parallel marketing audit agents to analyze existing marketing materials and produce structured documents in .planning/codebase/

Each agent has fresh context, explores a specific focus area, and **writes documents directly**. The orchestrator only receives confirmation + line counts, then writes a summary.

Output: .planning/codebase/ folder with 7 structured documents about the current marketing state.
</purpose>

<philosophy>
**Why dedicated audit agents:**
- Fresh context per domain (no token contamination)
- Agents write documents directly (no context transfer back to orchestrator)
- Orchestrator only summarizes what was created (minimal context usage)
- Faster execution (agents run simultaneously)

**Document quality over length:**
Include enough detail to be useful as reference. Prioritize practical examples (especially metrics, channel details, and content specifics) over arbitrary brevity.

**Always include specifics:**
Documents are reference material for planning and execution. Always include actual URLs, platform names, metrics, and asset names where available.
</philosophy>

<process>

<step name="init_context" priority="first">
Load marketing audit context:

```bash
INIT=$(mario-tools init map-codebase)
```

Extract from init JSON: `mapper_model`, `commit_docs`, `codebase_dir`, `existing_maps`, `has_maps`, `codebase_dir_exists`.
</step>

<step name="check_existing">
Check if .planning/codebase/ already exists using `has_maps` from init context.

If `codebase_dir_exists` is true:
```bash
ls -la .planning/codebase/
```

**If exists:**

```
.planning/codebase/ already exists with these documents:
[List files found]

What's next?
1. Refresh - Delete existing and re-audit marketing materials
2. Update - Keep existing, only update specific documents
3. Skip - Use existing marketing audit as-is
```

Wait for user response.

If "Refresh": Delete .planning/codebase/, continue to create_structure
If "Update": Ask which documents to update, continue to spawn_agents (filtered)
If "Skip": Exit workflow

**If doesn't exist:**
Continue to create_structure.
</step>

<step name="create_structure">
Create .planning/codebase/ directory:

```bash
mkdir -p .planning/codebase
```

**Expected output files:**
- TOOLS-AND-PLATFORMS.md (from tech mapper)
- AUDIENCE-INSIGHTS.md (from tech mapper)
- CHANNEL-ARCHITECTURE.md (from channel mapper)
- CONTENT-INVENTORY.md (from channel mapper)
- BRAND-GUIDELINES.md (from brand mapper)
- PERFORMANCE-METRICS.md (from brand mapper)
- MARKETING-GAPS.md (from gaps mapper)

Continue to spawn_agents.
</step>

<step name="spawn_agents">
Spawn 4 parallel mario-codebase-mapper agents.

Use Task tool with `subagent_type="mario-codebase-mapper"`, `model="{mapper_model}"`, and `run_in_background=true` for parallel execution.

**CRITICAL:** Use the dedicated `mario-codebase-mapper` agent, NOT `Explore`. The mapper agent writes documents directly.

**Agent 1: Tools and Audience Focus**

Task tool parameters:
```
subagent_type: "mario-codebase-mapper"
model: "{mapper_model}"
run_in_background: true
description: "Audit marketing tools and audience"
```

Prompt:
```
Focus: tech

Analyze existing marketing materials for tools, platforms, and audience insights.

Write these documents to .planning/codebase/:
- TOOLS-AND-PLATFORMS.md - CRM, email platform, social tools, analytics, CMS, advertising, SEO tools
- AUDIENCE-INSIGHTS.md - Customer segments, buyer personas, engagement patterns, conversion data, feedback themes

Explore thoroughly. Write documents directly using templates. Return confirmation only.
```

**Agent 2: Channel and Content Focus**

Task tool parameters:
```
subagent_type: "mario-codebase-mapper"
model: "{mapper_model}"
run_in_background: true
description: "Audit marketing channels and content"
```

Prompt:
```
Focus: arch

Analyze existing marketing channels and content assets.

Write these documents to .planning/codebase/:
- CHANNEL-ARCHITECTURE.md - Active channels, content distribution flow, funnel stages, channel interdependencies, attribution
- CONTENT-INVENTORY.md - Website pages, blog content, email sequences, social profiles, ad campaigns, downloadable assets

Explore thoroughly. Write documents directly using templates. Return confirmation only.
```

**Agent 3: Brand and Performance Focus**

Task tool parameters:
```
subagent_type: "mario-codebase-mapper"
model: "{mapper_model}"
run_in_background: true
description: "Audit brand guidelines and performance"
```

Prompt:
```
Focus: quality

Analyze existing marketing materials for brand voice and performance metrics.

Write these documents to .planning/codebase/:
- BRAND-GUIDELINES.md - Voice attributes, tone by context, terminology, style guide, visual identity
- PERFORMANCE-METRICS.md - Key metrics by channel, conversion rates, benchmarks, analytics setup, tracking gaps

Explore thoroughly. Write documents directly using templates. Return confirmation only.
```

**Agent 4: Marketing Gaps Focus**

Task tool parameters:
```
subagent_type: "mario-codebase-mapper"
model: "{mapper_model}"
run_in_background: true
description: "Audit marketing gaps"
```

Prompt:
```
Focus: concerns

Analyze existing marketing materials for gaps, inconsistencies, and improvement opportunities.

Write this document to .planning/codebase/:
- MARKETING-GAPS.md - Messaging inconsistencies, channel underperformance, brand voice gaps, content quality issues, SEO problems, conversion bottlenecks, missing coverage

Explore thoroughly. Write document directly using template. Return confirmation only.
```

Continue to collect_confirmations.
</step>

<step name="collect_confirmations">
Wait for all 4 agents to complete.

Read each agent's output file to collect confirmations.

**Expected confirmation format from each agent:**
```
## Mapping Complete

**Focus:** {focus}
**Documents written:**
- `.planning/codebase/{DOC1}.md` ({N} lines)
- `.planning/codebase/{DOC2}.md` ({N} lines)

Ready for orchestrator summary.
```

**What you receive:** Just file paths and line counts. NOT document contents.

If any agent failed, note the failure and continue with successful documents.

Continue to verify_output.
</step>

<step name="verify_output">
Verify all documents created successfully:

```bash
ls -la .planning/codebase/
wc -l .planning/codebase/*.md
```

**Verification checklist:**
- All 7 documents exist
- No empty documents (each should have >20 lines)

If any documents missing or empty, note which agents may have failed.

Continue to scan_for_secrets.
</step>

<step name="scan_for_secrets">
**CRITICAL SECURITY CHECK:** Scan output files for accidentally leaked secrets before committing.

Run secret pattern detection:

```bash
# Check for common API key patterns in generated docs
grep -E '(sk-[a-zA-Z0-9]{20,}|sk_live_[a-zA-Z0-9]+|sk_test_[a-zA-Z0-9]+|ghp_[a-zA-Z0-9]{36}|gho_[a-zA-Z0-9]{36}|glpat-[a-zA-Z0-9_-]+|AKIA[A-Z0-9]{16}|xox[baprs]-[a-zA-Z0-9-]+|-----BEGIN.*PRIVATE KEY|eyJ[a-zA-Z0-9_-]+\.eyJ[a-zA-Z0-9_-]+\.)' .planning/codebase/*.md 2>/dev/null && SECRETS_FOUND=true || SECRETS_FOUND=false
```

**If SECRETS_FOUND=true:**

```
SECURITY ALERT: Potential secrets detected in marketing audit documents!

Found patterns that look like API keys or tokens in:
[show grep output]

This would expose credentials if committed.

**Action required:**
1. Review the flagged content above
2. If these are real secrets, they must be removed before committing
3. Consider adding sensitive files to Claude Code "Deny" permissions

Pausing before commit. Reply "safe to proceed" if the flagged content is not actually sensitive, or edit the files first.
```

Wait for user confirmation before continuing to commit_codebase_map.

**If SECRETS_FOUND=false:**

Continue to commit_codebase_map.
</step>

<step name="commit_codebase_map">
Commit the marketing audit:

```bash
mario-tools commit "docs: audit existing marketing materials" --files .planning/codebase/*.md
```

Continue to offer_next.
</step>

<step name="offer_next">
Present completion summary and next steps.

**Get line counts:**
```bash
wc -l .planning/codebase/*.md
```

**Output format:**

```
Marketing audit complete.

Created .planning/codebase/:
- TOOLS-AND-PLATFORMS.md ([N] lines) - Marketing technology stack
- CHANNEL-ARCHITECTURE.md ([N] lines) - Channel organization and distribution
- CONTENT-INVENTORY.md ([N] lines) - Existing content and assets
- BRAND-GUIDELINES.md ([N] lines) - Voice, tone, and style standards
- PERFORMANCE-METRICS.md ([N] lines) - Current performance and measurement
- AUDIENCE-INSIGHTS.md ([N] lines) - Customer segments and behavior
- MARKETING-GAPS.md ([N] lines) - Issues and improvement opportunities


---

## Next Up

**Initialize project** -- use marketing audit context for planning

`/mario:new-project`

<sub>`/clear` first -> fresh context window</sub>

---

**Also available:**
- Re-run audit: `/mario:map-codebase`
- Review specific file: `cat .planning/codebase/TOOLS-AND-PLATFORMS.md`
- Edit any document before proceeding

---
```

End workflow.
</step>

</process>

<success_criteria>
- .planning/codebase/ directory created
- 4 parallel mario-codebase-mapper agents spawned with run_in_background=true
- Agents write documents directly (orchestrator doesn't receive document contents)
- Read agent output files to collect confirmations
- All 7 marketing audit documents exist
- Clear completion summary with line counts
- User offered clear next steps in Mario style
</success_criteria>
