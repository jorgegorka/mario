<overview>
The Draft-Review-Refine cycle ensures content quality through structured iteration. Like test-driven development forces you to think about behavior before implementation, this cycle forces you to check content against quality criteria before declaring it done.

**Principle:** If you can define the audience, channel, and success criteria before writing, the Draft-Review-Refine cycle improves the result.

**Key insight:** Structured review work is fundamentally heavier than drafting alone -- it requires 2-3 cycles (DRAFT, REVIEW, REFINE), each with content reading, criteria checking, and potential rework. Content that goes through structured review gets dedicated plans to ensure quality throughout the cycle.
</overview>

<when_to_use_structured_review>
## When Structured Review Improves Quality

**Structured review candidates (create a review plan):**
- Homepage copy, landing pages, and pillar content
- Launch emails and high-stakes campaign sequences
- Brand voice guide and positioning statements
- Ad campaigns with significant budget
- Multi-channel campaigns where consistency matters
- Content that defines or redefines brand perception
- Sales enablement materials (case studies, one-pagers)

**Skip structured review (lightweight review):**
- Low-stakes social media posts
- Internal content calendars and planning docs
- Minor copy updates and content refreshes
- Internal team communications
- Routine blog posts following established templates
- Content calendar entries and scheduling notes

**Heuristic:** Would publishing this content with an error damage the brand or waste significant budget?
-> Yes: Use structured review plan
-> No: Lightweight review, publish with quick check
</when_to_use_structured_review>

<review_plan_structure>
## Review Plan Structure

Each review plan covers **one content deliverable** through the full DRAFT-REVIEW-REFINE cycle.

```markdown
---
plan: NNN-slug
plan: NN
type: review
---

<objective>
[What content and why]
Purpose: [Why structured review matters for this piece]
Output: [Polished, reviewed content ready for publication]
</objective>

<context>
@.mario_planning/PROJECT.md
@.mario_planning/BACKLOG.md
@relevant/strategy/briefs.md
@relevant/brand/voice-guide.md
</context>

<deliverable>
  <name>[Content piece name]</name>
  <type>[Email sequence, landing page, ad copy, etc.]</type>
  <channel>[Where this will be published]</channel>
  <audience>[Target persona]</audience>
  <funnel_stage>[Awareness, consideration, decision]</funnel_stage>
  <brief>[Key messages, CTA goal, constraints]</brief>
</deliverable>

<quality_criteria>
[Specific criteria this content must meet]
</quality_criteria>

<success_criteria>
- Draft created following strategy brief
- Review completed against all quality criteria
- All review findings addressed in refinement
- No placeholder content remaining
- Channel requirements met
</success_criteria>

<output>
After completion, create SUMMARY.md with:
- DRAFT: What was created, key messaging decisions made
- REVIEW: What issues were found, what passed
- REFINE: What was changed, final quality assessment
</output>
```

**One deliverable per review plan.** If content pieces are trivial enough to batch, they are trivial enough to skip structured review -- use a standard plan with a quick check.
</review_plan_structure>

<execution_flow>
## Draft-Review-Refine Cycle

**DRAFT - Create initial content:**
1. Read the strategy brief and brand voice guidelines
2. Reference persona profiles for audience alignment
3. Follow the relevant content type guide (email, web, social, ads)
4. Apply channel-specific formatting requirements
5. Write complete content -- no placeholders, no "TBD" sections
6. Include all required elements for the content type

**REVIEW - Check against quality criteria:**
1. **Brand voice alignment:** Does the tone match guidelines? Are prohibited phrases avoided?
2. **CTA clarity and placement:** Is the CTA specific, action-oriented, and correctly positioned?
3. **Audience/persona alignment:** Does the content address the right pain points? Is the language appropriate?
4. **Channel-specific requirements:** Character limits, formatting, metadata, platform conventions?
5. **Factual accuracy:** Are claims accurate? Are statistics sourced? Are product details correct?
6. **Completeness:** Are all required sections present? Is metadata filled in?
7. **Consistency:** Do messages align with other deliverables in the campaign?

**REFINE - Polish based on review findings:**
1. Address every finding from the review -- do not skip issues
2. Tighten copy: remove redundancy, sharpen language, cut filler words
3. Verify cross-channel consistency if part of a multi-channel campaign
4. Confirm all placeholder content has been replaced
5. Final proofread for grammar, spelling, and formatting
6. Verify all metadata and channel requirements are met

**Result:** Each review plan produces polished content that has been systematically checked.
</execution_flow>

<quality_gates>
## Quality Gates

Content must pass all applicable gates before being marked complete:

**Gate 1: Brand Voice**
- Tone matches brand voice guidelines
- No prohibited language or phrasing
- Formality level appropriate for audience and channel
- Brand personality comes through consistently

**Gate 2: CTA Clarity**
- Primary CTA is present and prominent
- CTA language is action-oriented and specific
- CTA aligns with funnel stage
- CTA destination/action is clear to the reader

**Gate 3: Audience Alignment**
- Content addresses the correct persona's pain points
- Language complexity matches audience sophistication
- Examples and references resonate with the target audience
- Objections are anticipated and addressed where appropriate

**Gate 4: Channel Requirements**
- Character limits met for all platform-constrained fields
- Required metadata populated (subject lines, meta descriptions, alt text)
- Formatting follows channel conventions
- Technical requirements satisfied (image specs, link formats)

**Gate 5: Completeness**
- No placeholder text remaining (no TBD, TK, Lorem ipsum, template brackets)
- All required sections present for the content type
- All supporting elements included (headers, subheads, captions)
- Content can be published as-is without further editing

**If any gate fails:** Return to REFINE phase. Fix the specific issue. Re-check the failed gate. Do not proceed until all gates pass.
</quality_gates>

<review_quality>
## Good Reviews vs Bad Reviews

**Check substance, not just surface:**
- Good: "The value proposition is buried in paragraph 3 -- move it to the headline"
- Bad: "Looks good"
- Reviews should catch strategic issues, not just typos

**Be specific about what needs to change:**
- Good: "The CTA says 'Learn more' but this is a decision-stage landing page -- use 'Start free trial'"
- Bad: "CTA needs work"
- Vague feedback leads to vague improvements

**Reference the criteria:**
- Good: "Brand voice guide says avoid jargon, but this uses 'synergy' and 'leverage'"
- Bad: "Tone feels off"
- Anchoring feedback to criteria makes it actionable

**Prioritize findings:**
- Good: Separate critical issues (wrong audience, missing CTA) from minor issues (word choice preferences)
- Bad: List of 20 undifferentiated comments
- Not all feedback is equally important
</review_quality>

<review_findings_format>
## Review Findings Format

Structure review findings for clear action:

```markdown
## Review Findings: [Content Piece Name]

### Critical (must fix before publish)
1. **Missing CTA on landing page** - No primary conversion action above the fold
2. **Wrong persona** - Copy addresses technical buyers but target is marketing managers

### Important (should fix)
3. **Brand voice drift** - Second section becomes too formal compared to guidelines
4. **Inconsistent product name** - "ProductX" in headline, "Product X" in body

### Minor (nice to fix)
5. **Word choice** - "Utilize" could be "use" for simpler language
6. **Sentence length** - Third paragraph has a 45-word sentence, consider splitting
```

Each finding should state: **what** the issue is, **where** it occurs, and **why** it matters.
</review_findings_format>

<commit_pattern>
## Output Pattern for Review Plans

Review plans produce a single polished deliverable with a clear audit trail:

```
DRAFT: Homepage copy - first version

- Value proposition focused on time savings
- Three benefit sections aligned to persona pain points
- Primary CTA: "Start free trial"
- Secondary CTA: "See pricing"

REVIEW: Homepage copy - quality check

- Brand voice: PASS
- CTA clarity: PASS
- Audience alignment: NEEDS WORK - language too technical
- Channel requirements: PASS
- Completeness: NEEDS WORK - missing social proof section

REFINE: Homepage copy - final version

- Simplified language for non-technical audience
- Added customer testimonial section
- Adjusted headline for clarity
- All gates pass
```

**Comparison with standard plans:**
- Standard plans: content created and marked done
- Review plans: content created, checked, and refined

Both follow the same overall workflow; review plans add structured quality assurance.
</commit_pattern>

<context_budget>
## Context Budget

Review plans target **~40% context usage** (lower than standard plans' ~50%).

Why lower:
- DRAFT phase: generate content, reference strategy docs, follow brand guidelines
- REVIEW phase: re-read content, check against multiple criteria, document findings
- REFINE phase: modify content, re-check failed gates, verify consistency

Each phase involves reading deliverables, comparing against criteria, and making changes. The back-and-forth is inherently heavier than single-pass content creation.

Single deliverable focus ensures quality throughout the cycle.
</context_budget>
