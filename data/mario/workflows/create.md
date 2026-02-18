<purpose>
Create content on demand. Load brand foundations, research the topic, present a checkpoint, generate content, iterate until the user is happy, and finalize. Every content session is independent — no backlog, no phases, no state tracking.
</purpose>

<required_reading>
Read all files referenced by the invoking prompt's execution_context before starting.
</required_reading>

<process>

## 1. Initialize

**MANDATORY FIRST STEP — Verify foundations exist:**

Check that `.planning/foundations/BRAND-BIBLE.md` exists.

**If foundations missing:**

```
╔══════════════════════════════════════════════════════════════╗
║  ERROR                                                       ║
╚══════════════════════════════════════════════════════════════╝

Brand foundations not found. Run /mario:new-project first to
create your brand reference documents.

**To fix:** /mario:new-project
```

**If foundations exist:**

Read `.planning/foundations/BRAND-BIBLE.md` and `.planning/PROJECT.md` for brand context.

Parse $ARGUMENTS for the content description (e.g., "Write a blog post about NPS surveys").

**If no content description provided:**

Ask inline (freeform, NOT AskUserQuestion):

"What content do you want to create? Describe the topic and format (e.g., 'a blog post about customer retention strategies' or 'a landing page for our new feature')."

Wait for response.

**Detect content type** from the description. Map to one of:

| Signal in description | Content Type |
|----------------------|-------------|
| "blog post", "article", "guide", "how-to", "pillar page" | `blog` |
| "landing page", "feature page", "web copy", "homepage", "hero" | `landing-page` |
| "newsletter", "email", "email sequence", "drip" | `email` |
| "social", "LinkedIn post", "tweet", "thread", "Instagram", "carousel" | `social` |
| "ad", "ad copy", "Google ad", "Meta ad", "paid" | `ad-copy` |
| Unclear or mixed | Ask the user to clarify |

Display stage banner:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► CREATING CONTENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Topic: [content description]
Type:  [detected content type]
```

## 2. Topic Research

Display spawning indicator:
```
◆ Spawning topic researcher...
  → Searching for competing content on [topic]
```

Spawn mario-topic-researcher agent:

```
Task(prompt="First, read ~/.claude/agents/mario-topic-researcher.md for your role and instructions.

<topic>
[Content description from user — e.g., "blog post about NPS surveys"]
</topic>

<content_type>
[Detected content type: blog | landing-page | email | social | ad-copy]

Use the matching research strategy from your <content_type_strategies> section.
This determines your search queries, analysis dimensions, gap criteria, and output focus.
</content_type>

<brand_context>
[Key sections from BRAND-BIBLE.md — voice attributes, target personas, competitive positioning, core messages. Enough for the researcher to align angle recommendations with the brand.]
</brand_context>

<instructions>
1. Select the content-type-specific research strategy
2. Search for 10-15 competing content using content-type-appropriate queries
3. Fetch and analyze the top 3-5 results using content-type-specific dimensions
4. Identify gaps using content-type-specific gap criteria
5. Recommend a specific angle that aligns with our brand
6. Propose a content outline using the content-type-specific output focus
7. Write research brief to .planning/topic-research.md
</instructions>

<output>
Write to: .planning/topic-research.md
Return structured result with: landscape summary, key gaps, recommended angle, proposed outline.
</output>
", subagent_type="general-purpose", description="Topic research")
```

After researcher returns, display research summary:
```
✓ Topic research complete

**Articles analyzed:** [N]
**Key gaps found:**
- [gap 1]
- [gap 2]
- [gap 3]
```

## 3. Structured Checkpoint

Present the research findings and recommended approach for user approval.

```
╔══════════════════════════════════════════════════════════════╗
║  CHECKPOINT: Content Approach                                ║
╚══════════════════════════════════════════════════════════════╝

**Topic:** [content description]
**Content type:** [inferred — blog post, landing page, email, etc.]

## Competing Landscape

[2-3 sentence summary of what exists on this topic]

## Recommended Angle

[1-2 sentence angle recommendation with rationale]

**Why this angle:**
- [Differentiation from existing content]
- [Alignment with our audience]
- [Brand positioning fit]

## Proposed Outline

1. **[Section]** — [rationale]
2. **[Section]** — [rationale]
3. **[Section]** — [rationale]
...

──────────────────────────────────────────────────────────────
→ Approve this approach, adjust, or describe a different angle
──────────────────────────────────────────────────────────────
```

Use AskUserQuestion:
- header: "Approach"
- question: "Does this content approach work for you?"
- options:
  - "Approve and generate" — Write the content with this angle and outline
  - "Adjust outline" — I want to change the structure
  - "Different angle" — I have a different approach in mind

**If "Adjust outline":**
- Ask what they'd like to change
- Revise the outline
- Re-present checkpoint

**If "Different angle":**
- Ask them to describe their preferred angle
- Revise angle and outline
- Re-present checkpoint

Loop until "Approve and generate" selected.

## 4. Generate Content

**Determine content domain:**

Based on the content type, identify which domain guide to load (if available):

| Content Type | Domain | Guide Path |
|-------------|--------|------------|
| Blog post, article, guide | SEO Content | `~/.claude/guides/seo-content.md` |
| Landing page, feature page, web copy | Web Copy | `~/.claude/guides/web-copy.md` |
| Email sequence, newsletter | Email | `~/.claude/guides/email.md` |
| Social media posts, threads | Social | `~/.claude/guides/social.md` |
| Ad copy, paid creative | Paid Ads | `~/.claude/guides/paid-ads.md` |
| Marketing strategy, content plan | Strategy | `~/.claude/guides/strategy.md` |

**If domain guide exists:** Read and use as additional context.
**If no domain guide:** Proceed without — the brand bible provides sufficient context.

**Design guide:** If content type is `landing-page`, `feature page`, `homepage`, or `web copy`,
also load `~/.claude/guides/design.md` for visual design principles (layout, hero sections,
micro interactions, accessibility). This is complementary to the web copy guide.

Display generation banner:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► GENERATING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Generate the content using:**
- Brand context from BRAND-BIBLE.md (voice, personas, messages, positioning)
- Topic research (competing landscape, gaps, angle)
- Approved outline from checkpoint
- Domain guide (if available)

**Content quality checklist (internal — verify before presenting):**
- [ ] Written for a specific persona
- [ ] Matches voice attributes from brand bible
- [ ] Tone adjusted for content type/channel
- [ ] Leads with outcomes, not features
- [ ] Includes proof points where appropriate
- [ ] Has clear call to action
- [ ] Addresses a specific awareness level
- [ ] Differentiates from competing content identified in research

## 5. Conversational Iteration

Present the draft to the user:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► DRAFT READY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Full content draft]

──────────────────────────────────────────────────────────────
→ Share feedback, request changes, or approve
──────────────────────────────────────────────────────────────
```

Use AskUserQuestion:
- header: "Draft"
- question: "How does this look?"
- options:
  - "Looks good — finalize" — Save and commit
  - "Needs changes" — I have specific feedback
  - "Start over" — Different approach entirely

**If "Needs changes":**
- Ask for specific feedback (inline, freeform)
- Revise the content based on feedback
- Re-present the updated draft
- Loop until user approves

**If "Start over":**
- Return to Step 3 (checkpoint) with user's new direction

Loop until "Looks good — finalize" selected.

## 6. Finalize

**Save the content:**

Determine appropriate file path based on content type:
- Blog posts: `content/blog/[slug].md`
- Landing pages: `content/pages/[slug].md`
- Email: `content/email/[slug].md`
- Social: `content/social/[slug].md`
- Other: `content/[slug].md`

Ask inline if the suggested path works, or let user specify.

Write the final content to the file.

**Commit:**

```bash
mario-tools commit "content: [content type] — [brief topic description]" --files [content file path]
```

**Clean up topic research:**

Remove the temporary research brief:
```bash
rm -f .planning/topic-research.md
```

**Present completion:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► CONTENT COMPLETE ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**[Content type]:** [topic]
**File:** [file path]
**Committed:** ✓

───────────────────────────────────────────────────────────────

## ▶ Next Up

**Create more content:**

`/mario:create "Write [next content piece]"`

<sub>/clear first → fresh context window</sub>

───────────────────────────────────────────────────────────────
```

</process>

<output>

- `content/[type]/[slug].md` — the created content
- `.planning/topic-research.md` — temporary (deleted after finalization)

</output>

<success_criteria>

- [ ] Brand foundations loaded (BRAND-BIBLE.md + PROJECT.md)
- [ ] Topic research completed — competing articles analyzed
- [ ] Structured checkpoint presented — user approved angle and outline
- [ ] Content generated with brand context + research + domain guide
- [ ] User iterated on draft until satisfied
- [ ] Content saved and committed
- [ ] Topic research cleaned up

**Quality:** On-brand, differentiated from competing content, targeted to a specific persona, includes proof points, has clear CTA.

</success_criteria>
