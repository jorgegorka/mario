<overview>
Plans execute autonomously. Checkpoints formalize interaction points where human verification or decisions are needed.

**Core principle:** Claude automates everything with CLI/API. Checkpoints are for verification and decisions, not manual work.

**Golden rules:**
1. **If Claude can run it, Claude runs it** - Never ask user to execute CLI commands, start servers, or run builds
2. **Claude sets up the verification environment** - Start dev servers, seed databases, configure env vars
3. **User only does what requires human judgment** - Visual checks, UX evaluation, "does this feel right?"
4. **Secrets come from user, automation comes from Claude** - Ask for API keys, then Claude uses them via CLI
</overview>

<checkpoint_types>

<type name="human-verify">
## checkpoint:human-verify (Most Common - 90%)

**When:** Claude completed automated work, human confirms it works correctly.

**Use for:**
- Visual UI checks (layout, styling, responsiveness)
- Interactive flows (click through wizard, test user flows)
- Functional verification (feature works as expected)
- Audio/video playback quality
- Animation smoothness
- Accessibility testing

**Structure:**
```xml
<task type="checkpoint:human-verify" gate="blocking">
  <what-built>[What Claude automated and deployed/built]</what-built>
  <how-to-verify>
    [Exact steps to test - URLs, commands, expected behavior]
  </how-to-verify>
  <resume-signal>[How to continue - "approved", "yes", or describe issues]</resume-signal>
</task>
```

**Example: Landing Page Copy (shows key pattern: Claude generates content BEFORE checkpoint)**
```xml
<task type="auto">
  <name>Generate landing page copy based on strategy brief</name>
  <files>content/landing-page.md, strategy/brand-voice.md</files>
  <action>Write landing page copy following strategy brief: headline, value proposition, benefit sections, social proof, and CTA. Apply brand voice guidelines throughout.</action>
  <verify>All required sections present, no placeholder text remaining</verify>
  <done>Landing page copy generated with all sections complete</done>
</task>

<task type="checkpoint:human-verify" gate="blocking">
  <what-built>Landing page copy for product launch - all sections complete</what-built>
  <how-to-verify>
    Review the generated landing page copy and verify:
    1. Brand voice: Does the tone match our brand voice guidelines?
    2. Value proposition: Is it clear and compelling in the headline and first section?
    3. Creative quality: Does the copy feel engaging, not generic or templated?
    4. Factual accuracy: Are all product claims and statistics correct?
  </how-to-verify>
  <resume-signal>Type "approved" or describe tone/messaging issues</resume-signal>
</task>
```

**Example: Email Sequence**
```xml
<task type="auto">
  <name>Generate 5-email nurture sequence</name>
  <files>content/email-sequence/, strategy/persona-profiles.md</files>
  <action>Write all 5 emails following the sequence brief: welcome, pain point, solution, social proof, conversion. Include subject lines, preview text, body copy, and CTAs for each.</action>
  <verify>All 5 emails complete with subject lines, preview text, and CTAs</verify>
  <done>Email sequence generated</done>
</task>

<task type="checkpoint:human-verify" gate="blocking">
  <what-built>5-email nurture sequence targeting marketing managers</what-built>
  <how-to-verify>
    Read all 5 emails in order and verify:
    - Subject lines are compelling and not misleading
    - Tone is appropriate and consistent across the sequence
    - CTAs escalate naturally (educate -> engage -> convert)
    - No email feels too aggressive or too passive
  </how-to-verify>
  <resume-signal>Type "approved" or describe issues</resume-signal>
</task>
```
</type>

<type name="decision">
## checkpoint:decision (9%)

**When:** Human must make choice that affects implementation direction.

**Use for:**
- Technology selection (which auth provider, which database)
- Architecture decisions (monorepo vs separate repos)
- Design choices (color scheme, layout approach)
- Feature prioritization (which variant to build)
- Data model decisions (schema structure)

**Structure:**
```xml
<task type="checkpoint:decision" gate="blocking">
  <decision>[What's being decided]</decision>
  <context>[Why this decision matters]</context>
  <options>
    <option id="option-a">
      <name>[Option name]</name>
      <pros>[Benefits]</pros>
      <cons>[Tradeoffs]</cons>
    </option>
    <option id="option-b">
      <name>[Option name]</name>
      <pros>[Benefits]</pros>
      <cons>[Tradeoffs]</cons>
    </option>
  </options>
  <resume-signal>[How to indicate choice]</resume-signal>
</task>
```

**Example: Positioning Angle Selection**
```xml
<task type="checkpoint:decision" gate="blocking">
  <decision>Select primary positioning angle for the campaign</decision>
  <context>
    Launching a new product campaign targeting marketing managers. Need to choose the lead messaging angle that will anchor all content across channels.
  </context>
  <options>
    <option id="time-savings">
      <name>Time Savings</name>
      <pros>Universally appealing, easy to quantify ("save 10 hours/week"), strong for busy personas</pros>
      <cons>Common positioning, may not differentiate from competitors</cons>
    </option>
    <option id="competitive-edge">
      <name>Competitive Edge</name>
      <pros>Appeals to ambitious buyers, positions product as strategic advantage, premium feel</pros>
      <cons>Harder to prove, may feel aggressive, requires strong proof points</cons>
    </option>
    <option id="simplicity">
      <name>Simplicity / Ease of Use</name>
      <pros>Differentiates from complex competitors, reduces perceived risk, approachable</pros>
      <cons>May signal "less powerful", harder to justify premium pricing</cons>
    </option>
  </options>
  <resume-signal>Select: time-savings, competitive-edge, or simplicity</resume-signal>
</task>
```

**Example: Content Direction Selection**
```xml
<task type="checkpoint:decision" gate="blocking">
  <decision>Select messaging angle for the email nurture sequence</decision>
  <context>
    Building a 5-email sequence for trial users who haven't converted. Need to choose the narrative arc.
  </context>
  <options>
    <option id="educational">
      <name>Educational (teach-first)</name>
      <pros>Builds trust, positions brand as expert, lower unsubscribe rate</pros>
      <cons>Slower conversion path, requires strong content depth</cons>
    </option>
    <option id="social-proof">
      <name>Social Proof (customer stories)</name>
      <pros>Relatable, builds credibility, easy to produce with existing customers</pros>
      <cons>Requires customer testimonials on hand, may feel repetitive</cons>
    </option>
    <option id="urgency">
      <name>Urgency / FOMO</name>
      <pros>Drives faster action, effective for limited-time offers, high conversion potential</pros>
      <cons>Can feel pushy, may damage brand trust if overused, requires genuine scarcity</cons>
    </option>
  </options>
  <resume-signal>Select: educational, social-proof, or urgency</resume-signal>
</task>
```
</type>

<type name="human-action">
## checkpoint:human-action (1% - Rare)

**When:** Action has NO CLI/API and requires human-only interaction, OR Claude hit an authentication gate during automation.

**Use ONLY for:**
- **Authentication gates** - Claude tried CLI/API but needs credentials (this is NOT a failure)
- Email verification links (clicking email)
- SMS 2FA codes (phone verification)
- Manual account approvals (platform requires human review)
- Credit card 3D Secure flows (web-based payment authorization)
- OAuth app approvals (web-based approval)

**Do NOT use for pre-planned manual work:**
- Deploying (use CLI - auth gate if needed)
- Creating webhooks/databases (use API/CLI - auth gate if needed)
- Running builds/tests (use Bash tool)
- Creating files (use Write tool)

**Structure:**
```xml
<task type="checkpoint:human-action" gate="blocking">
  <action>[What human must do - Claude already did everything automatable]</action>
  <instructions>
    [What Claude already automated]
    [The ONE thing requiring human action]
  </instructions>
  <verification>[What Claude can check afterward]</verification>
  <resume-signal>[How to continue]</resume-signal>
</task>
```

**Example: CMS Content Upload**
```xml
<task type="auto">
  <name>Generate all landing page content</name>
  <action>Write complete landing page copy: headline, subheadline, benefit sections, testimonials, CTA. Format per CMS requirements.</action>
  <verify>All sections complete, no placeholder text, copy reviewed and refined</verify>
  <done>Landing page content ready for upload</done>
</task>

<task type="checkpoint:human-action" gate="blocking">
  <action>Upload content to CMS and configure page settings</action>
  <instructions>
    I generated the complete landing page content in content/landing-page.md.
    Upload it to your CMS, configure the page URL, meta tags, and publish settings.
    The CMS requires browser-based authentication that I cannot complete.
  </instructions>
  <verification>Landing page URL is live and accessible</verification>
  <resume-signal>Type "done" with the published URL</resume-signal>
</task>
```

**Example: Ad Campaign Setup (Dynamic Checkpoint)**
```xml
<task type="auto">
  <name>Generate ad copy variations</name>
  <files>content/ads/google-search.md, content/ads/meta.md</files>
  <action>Write ad copy for Google Search and Meta: headlines, descriptions, display URLs, audience targeting. Create 3 variations per platform for A/B testing.</action>
  <verify>All ad variations complete, character limits met, landing page URLs specified</verify>
</task>

<!-- Ad platform requires browser-based login, Claude creates checkpoint -->

<task type="checkpoint:human-action" gate="blocking">
  <action>Set up ad campaigns in Google Ads and Meta Ads Manager</action>
  <instructions>
    I generated all ad copy variations in content/ads/.
    These platforms require browser-based authentication:
    1. Create campaigns in Google Ads using the copy in google-search.md
    2. Create campaigns in Meta Ads Manager using the copy in meta.md
    3. Configure audience targeting as specified in each file
    4. Set budgets and bidding strategy as documented
  </instructions>
  <verification>Campaign IDs provided, campaigns in review or active status</verification>
  <resume-signal>Type "done" when campaigns are created</resume-signal>
</task>

<!-- After campaigns created, Claude continues with tracking setup -->

<task type="auto">
  <name>Verify campaign tracking</name>
  <action>Check that UTM parameters are configured correctly, landing page loads with proper tracking pixels</action>
  <verify>Landing page contains expected tracking code, UTM parameters resolve correctly</verify>
</task>
```

**Key distinction:** Auth gates are created dynamically when Claude encounters auth errors. NOT pre-planned — Claude automates first, asks for credentials only when blocked.
</type>
</checkpoint_types>

<execution_protocol>

When Claude encounters `type="checkpoint:*"`:

1. **Stop immediately** - do not proceed to next task
2. **Display checkpoint clearly** using the format below
3. **Wait for user response** - do not hallucinate completion
4. **Verify if possible** - check files, run tests, whatever is specified
5. **Resume execution** - continue to next task only after confirmation

**For checkpoint:human-verify:**
```
╔═══════════════════════════════════════════════════════╗
║  CHECKPOINT: Verification Required                    ║
╚═══════════════════════════════════════════════════════╝

Progress: 5/8 tasks complete
Task: Landing page copy review

Built: Landing page copy with all sections complete

How to verify:
  1. Read the headline and value proposition section
  2. Check: Does the brand voice feel authentic and on-brand?
  3. Check: Is the value proposition clear within the first paragraph?
  4. Check: Are all claims accurate and defensible?

────────────────────────────────────────────────────────
→ YOUR ACTION: Type "approved" or describe issues
────────────────────────────────────────────────────────
```

**For checkpoint:decision:**
```
╔═══════════════════════════════════════════════════════╗
║  CHECKPOINT: Decision Required                        ║
╚═══════════════════════════════════════════════════════╝

Progress: 2/6 tasks complete
Task: Select positioning angle

Decision: Which messaging angle should anchor the campaign?

Context: Launching product campaign for marketing managers. Three angles with different tradeoffs.

Options:
  1. time-savings - Quantifiable, universally appealing
     Pros: Easy to prove ("save 10 hours/week"), resonates with busy personas
     Cons: Common positioning, may not differentiate from competitors

  2. competitive-edge - Premium, strategic positioning
     Pros: Appeals to ambitious buyers, justifies premium pricing
     Cons: Harder to prove, requires strong case studies

  3. simplicity - Approachable, low-risk appeal
     Pros: Differentiates from complex competitors, reduces perceived risk
     Cons: May signal "less powerful", harder to justify premium pricing

────────────────────────────────────────────────────────
→ YOUR ACTION: Select time-savings, competitive-edge, or simplicity
────────────────────────────────────────────────────────
```

**For checkpoint:human-action:**
```
╔═══════════════════════════════════════════════════════╗
║  CHECKPOINT: Action Required                          ║
╚═══════════════════════════════════════════════════════╝

Progress: 3/8 tasks complete
Task: Set up ad campaigns

Generated: Ad copy for Google Search and Meta (3 variations each)

What you need to do:
  1. Create campaigns in Google Ads using copy in content/ads/google-search.md
  2. Create campaigns in Meta Ads Manager using copy in content/ads/meta.md
  3. Configure audience targeting as specified in each file

I'll verify: Campaign IDs provided, landing pages load correctly

────────────────────────────────────────────────────────
→ YOUR ACTION: Type "done" when campaigns are created
────────────────────────────────────────────────────────
```
</execution_protocol>

<authentication_gates>

**Auth gate = Claude tried CLI/API, got auth error.** Not a failure — a gate requiring human input to unblock.

**Pattern:** Claude tries automation → auth error → creates checkpoint:human-action → user authenticates → Claude retries → continues

**Gate protocol:**
1. Recognize it's not a failure - missing auth is expected
2. Stop current task - don't retry repeatedly
3. Create checkpoint:human-action dynamically
4. Provide exact authentication steps
5. Verify authentication works
6. Retry the original task
7. Continue normally

**Key distinction:**
- Pre-planned checkpoint: "I need you to do X" (wrong - Claude should automate)
- Auth gate: "I tried to automate X but need credentials" (correct - unblocks automation)

</authentication_gates>

<automation_reference>

**The rule:** If it has CLI/API, Claude does it. Never ask human to perform automatable work.

## Content Generation Automation

**The rule:** If Claude can generate it, Claude generates it. Never ask human to write content.

**Content files:** Use Write/Edit tools. Never ask human to create content files manually.

**API key collection pattern:**
```xml
<!-- WRONG: Asking user to configure platform settings in dashboard -->
<task type="checkpoint:human-action">
  <action>Set up email campaign in Mailchimp</action>
  <instructions>Go to Mailchimp → Create Campaign → Paste content → Configure audience</instructions>
</task>

<!-- RIGHT: Claude generates content, checkpoints only for platform auth -->
<task type="auto">
  <name>Generate email campaign content</name>
  <action>Write complete email with subject, preview text, body, and CTA. Format for Mailchimp.</action>
  <verify>All fields present, character limits met, no placeholders</verify>
</task>

<task type="checkpoint:human-action">
  <action>Provide Mailchimp API key for campaign creation</action>
  <instructions>
    I need your Mailchimp API key to create the campaign via API.
    Get it from: Mailchimp → Account → Extras → API keys
    Paste the key
  </instructions>
  <verification>I'll create the campaign via API and verify</verification>
  <resume-signal>Paste your API key</resume-signal>
</task>

<task type="auto">
  <name>Create email campaign via Mailchimp API</name>
  <action>Use Mailchimp API to create campaign with generated content</action>
  <verify>API returns campaign ID, campaign appears in draft status</verify>
</task>
```

## Automatable Quick Reference

| Action | Automatable? | Claude does it? |
|--------|--------------|-----------------|
| Write landing page copy | Yes (content generation) | YES |
| Write email sequences | Yes (content generation) | YES |
| Generate social media posts | Yes (content generation) | YES |
| Write ad copy variations | Yes (content generation) | YES |
| Cross-check content consistency | Yes (programmatic comparison) | YES |
| Verify character limits | Yes (programmatic check) | YES |
| Format content for channels | Yes (content generation) | YES |
| Create content calendar | Yes (content generation) | YES |
| Upload to CMS (with API) | Yes (API) | YES |
| Upload to CMS (browser only) | No | NO |
| Set up ad campaigns in ad manager | No (browser auth required) | NO |
| Review brand voice "feel" | No (human judgment) | NO |
| Assess creative quality | No (human judgment) | NO |
| Approve content for publication | No (human decision) | NO |
| Submit content for client review | No (human action) | NO |

</automation_reference>

<writing_guidelines>

**DO:**
- Automate everything with CLI/API before checkpoint
- Be specific: "Visit https://myapp.fly.dev" not "check deployment"
- Number verification steps
- State expected outcomes: "You should see X"
- Provide context: why this checkpoint exists

**DON'T:**
- Ask human to do work Claude can automate ❌
- Assume knowledge: "Configure the usual settings" ❌
- Skip steps: "Set up database" (too vague) ❌
- Mix multiple verifications in one checkpoint ❌

**Placement:**
- **After automation completes** - not before Claude does the work
- **After UI buildout** - before declaring phase complete
- **Before dependent work** - decisions before implementation
- **At integration points** - after configuring external services

**Bad placement:** Before automation ❌ | Too frequent ❌ | Too late (dependent tasks already needed the result) ❌
</writing_guidelines>

<examples>

### Example 1: Content Calendar Setup (No Checkpoint Needed)

```xml
<task type="auto">
  <name>Generate content calendar from strategy brief</name>
  <files>content/calendar.md, strategy/brief.md</files>
  <action>
    1. Read strategy brief for campaign goals and timeline
    2. Map content types to funnel stages
    3. Assign topics and channels per week
    4. Include publishing dates and responsible content types
    5. Cross-reference with persona profiles for audience alignment
  </action>
  <verify>
    - All weeks in campaign period have assigned content
    - Each funnel stage has at least 2 content pieces
    - No date conflicts or impossible publishing cadence
  </verify>
  <done>Content calendar generated covering full campaign period</done>
</task>

<!-- NO CHECKPOINT NEEDED - Claude automated everything and verified programmatically -->
```

### Example 2: Full Campaign Content (Single checkpoint at end)

```xml
<task type="auto">
  <name>Write landing page copy</name>
  <files>content/landing-page.md, strategy/brand-voice.md</files>
  <action>Generate complete landing page: headline, value prop, benefits, social proof, CTA</action>
  <verify>All sections present, no placeholder text, brand voice guidelines applied</verify>
</task>

<task type="auto">
  <name>Write email nurture sequence</name>
  <files>content/emails/, strategy/persona-profiles.md</files>
  <action>Write 5-email sequence with subject lines, preview text, body, and CTAs</action>
  <verify>All 5 emails complete with required fields, sequence timing defined</verify>
</task>

<task type="auto">
  <name>Write social media posts</name>
  <files>content/social/, strategy/content-calendar.md</files>
  <action>Generate social posts for LinkedIn, Twitter, and Instagram per content calendar</action>
  <verify>Character limits met, hooks present, hashtags included</verify>
</task>

<task type="auto">
  <name>Cross-check consistency across all deliverables</name>
  <action>Compare key messages, CTAs, and product descriptions across all content pieces</action>
  <verify>No contradictions, consistent terminology, aligned CTAs</verify>
  <done>All campaign content generated and cross-checked</done>
</task>

<!-- ONE checkpoint at end verifies the complete campaign -->
<task type="checkpoint:human-verify" gate="blocking">
  <what-built>Complete campaign content: landing page, 5 emails, social posts</what-built>
  <how-to-verify>
    1. Read landing page: Does the value proposition resonate?
    2. Read email sequence in order: Does the narrative arc feel natural?
    3. Scan social posts: Do they capture attention and drive to landing page?
    4. Overall: Does voice feel consistent and on-brand across all pieces?
    5. Check: Are all claims accurate and all CTAs aligned?
  </how-to-verify>
  <resume-signal>Type "approved" or describe issues</resume-signal>
</task>
```
</examples>

<anti_patterns>

### BAD: Asking user to generate content

```xml
<task type="checkpoint:human-action" gate="blocking">
  <action>Write landing page copy</action>
  <instructions>
    1. Write a headline based on the strategy brief
    2. Write 3 benefit sections
    3. Add a CTA
  </instructions>
</task>
```

**Why bad:** Claude can generate content. User should only review quality and alignment, not write copy.

### GOOD: Claude generates, user reviews

```xml
<task type="auto">
  <name>Generate landing page copy</name>
  <action>Write complete landing page based on strategy brief and brand voice guidelines</action>
  <verify>All sections present, no placeholders, brand voice applied</verify>
</task>

<task type="checkpoint:human-verify" gate="blocking">
  <what-built>Landing page copy with headline, benefits, social proof, and CTA</what-built>
  <how-to-verify>
    Review the generated copy and verify:
    1. Brand voice feels authentic
    2. Value proposition is compelling
    3. Claims are accurate
  </how-to-verify>
</task>
```

### BAD: Asking user to format content for channel

```xml
<!-- BAD: Asking user to adapt content for each platform -->
<task type="checkpoint:human-action" gate="blocking">
  <action>Adapt blog post for social media</action>
  <instructions>Create LinkedIn version, Twitter thread, and Instagram caption from the blog post</instructions>
</task>

<!-- GOOD: Claude adapts, user reviews -->
<task type="auto">
  <name>Adapt blog content for social channels</name>
  <action>Create LinkedIn post, Twitter thread, and Instagram caption from blog content. Follow platform conventions and character limits.</action>
  <verify>Character limits met, hooks present, hashtags included</verify>
</task>

<task type="checkpoint:human-verify">
  <what-built>Social adaptations of blog post for LinkedIn, Twitter, Instagram</what-built>
  <how-to-verify>Review each platform version: Does the hook grab attention? Is the tone right for each platform?</how-to-verify>
  <resume-signal>Type "approved"</resume-signal>
</task>
```

### BAD: Too many checkpoints / GOOD: Single checkpoint

```xml
<!-- BAD: Checkpoint after every content piece -->
<task type="auto">Write landing page</task>
<task type="checkpoint:human-verify">Check landing page</task>
<task type="auto">Write email sequence</task>
<task type="checkpoint:human-verify">Check emails</task>
<task type="auto">Write social posts</task>
<task type="checkpoint:human-verify">Check social</task>

<!-- GOOD: One checkpoint at end -->
<task type="auto">Write landing page</task>
<task type="auto">Write email sequence</task>
<task type="auto">Write social posts</task>

<task type="checkpoint:human-verify">
  <what-built>Complete campaign content (landing page + emails + social)</what-built>
  <how-to-verify>Review all pieces for brand consistency, CTA alignment, and creative quality</how-to-verify>
  <resume-signal>Type "approved"</resume-signal>
</task>
```

### BAD: Vague verification / GOOD: Specific steps

```xml
<!-- BAD -->
<task type="checkpoint:human-verify">
  <what-built>Email sequence</what-built>
  <how-to-verify>Check it looks good</how-to-verify>
</task>

<!-- GOOD -->
<task type="checkpoint:human-verify">
  <what-built>5-email nurture sequence targeting marketing managers</what-built>
  <how-to-verify>
    Read all 5 emails in order and verify:
    1. Subject lines are compelling (would you open these?)
    2. Tone escalates naturally without being pushy
    3. Each email has a single clear CTA
    4. Sequence narrative makes sense even if reader skips emails
    5. Final email creates appropriate urgency without being aggressive
  </how-to-verify>
  <resume-signal>Type "approved" or describe issues with specific emails</resume-signal>
</task>
```

### BAD: Asking user to manually upload content

```xml
<task type="checkpoint:human-action">
  <action>Copy email content into Mailchimp</action>
  <instructions>Log into Mailchimp, create campaign, paste subject line, paste body, configure audience</instructions>
</task>
```

**Why bad:** If the platform has an API or CLI, Claude should use it. Only checkpoint if browser-based auth is truly required.

### BAD: Asking user to check consistency manually

```xml
<task type="checkpoint:human-action">
  <action>Cross-reference all content pieces for consistency</action>
  <instructions>Compare landing page, emails, and social posts to make sure messaging aligns</instructions>
</task>
```

**Why bad:** Claude can cross-check content programmatically. User should verify creative quality, not do consistency audits.

</anti_patterns>

<summary>

Checkpoints formalize human-in-the-loop points for verification and decisions, not manual work.

**The golden rule:** If Claude CAN automate it, Claude MUST automate it.

**Checkpoint priority:**
1. **checkpoint:human-verify** (90%) - Claude automated everything, human confirms visual/functional correctness
2. **checkpoint:decision** (9%) - Human makes architectural/technology choices
3. **checkpoint:human-action** (1%) - Truly unavoidable manual steps with no API/CLI

**When NOT to use checkpoints:**
- Things Claude can verify programmatically (tests, builds)
- File operations (Claude can read files)
- Code correctness (tests and static analysis)
- Anything automatable via CLI/API
</summary>
