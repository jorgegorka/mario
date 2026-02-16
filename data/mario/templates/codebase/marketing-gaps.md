# Marketing Gaps Template

Template for `.planning/codebase/MARKETING-GAPS.md` - captures issues and opportunities in existing marketing.

**Purpose:** Surface actionable gaps and problems in the current marketing operation. Focused on "what needs fixing or is missing?"

---

## File Template

```markdown
# Marketing Gaps

**Audit Date:** [YYYY-MM-DD]

## Messaging Inconsistencies

**[Area/Channel]:**
- Issue: [What's inconsistent]
- Where: [Which channels or assets show the inconsistency]
- Impact: [How it affects the audience or brand]
- Fix approach: [How to align messaging]

**[Area/Channel]:**
- Issue: [What's inconsistent]
- Where: [Which channels or assets]
- Impact: [Effect on audience]
- Fix approach: [How to fix]

## Channel Underperformance

**[Channel]:**
- Problem: [What's underperforming]
- Metrics: [Current numbers vs. benchmarks or expectations]
- Likely cause: [Why it's underperforming]
- Improvement path: [What to try]

**[Channel]:**
- Problem: [What's underperforming]
- Metrics: [Numbers]
- Likely cause: [Root cause]
- Improvement path: [Next steps]

## Brand Voice Gaps

**[Gap area]:**
- Issue: [What's missing or unclear]
- Impact: [How it affects content creation]
- Recommendation: [What to create or document]

## Content Quality Issues

**[Content area]:**
- Issue: [What's wrong with the content]
- Examples: [Specific pages, posts, or assets affected]
- Impact: [Effect on SEO, conversions, or brand perception]
- Fix approach: [How to improve]

## SEO Problems

**[SEO area]:**
- Issue: [What's broken or missing]
- Evidence: [Data or observations supporting the issue]
- Impact: [Effect on search visibility or traffic]
- Fix approach: [Technical or content fix needed]

## Conversion Bottlenecks

**[Funnel stage]:**
- Problem: [Where prospects drop off]
- Data: [Conversion rate or drop-off metrics]
- Likely cause: [Why prospects leave]
- Fix approach: [What to test or change]

## Missing Coverage

**[Gap area]:**
- What's missing: [Channel, audience segment, or content type not addressed]
- Opportunity: [Why this matters]
- Effort: [Rough estimate of what's needed to address it]
- Priority: [High/Medium/Low]

---

*Marketing gaps audit: [date]*
*Update as issues are fixed or new ones discovered*
```

<good_examples>
```markdown
# Marketing Gaps

**Audit Date:** 2025-06-15

## Messaging Inconsistencies

**Homepage vs. email welcome sequence:**
- Issue: Homepage positions product as "enterprise project management" while welcome email series describes it as "simple task tracking for small teams"
- Where: Homepage hero section, welcome email #1 and #3
- Impact: New subscribers who signed up from the homepage encounter conflicting positioning, likely contributing to low email engagement (18% open rate on email #3 vs. 42% on #1)
- Fix approach: Align on single positioning statement; update email sequence to match current homepage messaging

**Social media tone vs. website:**
- Issue: LinkedIn posts use casual, first-person founder voice while website copy is formal and third-person corporate
- Where: LinkedIn company posts vs. product pages and about page
- Impact: Visitors from LinkedIn encounter a different brand personality on the website, potential trust disconnect
- Fix approach: Define tone spectrum in brand guidelines -- founder LinkedIn can be more casual, but website should warm up to match

## Channel Underperformance

**Instagram:**
- Problem: Low engagement despite consistent posting (2-3 times/week for 6 months)
- Metrics: Average 12 likes per post, 0.8% engagement rate (industry benchmark: 1.5-3%)
- Likely cause: Content is repurposed LinkedIn text posts as image cards -- not native to Instagram format. No Reels or Stories.
- Improvement path: Test Instagram-native formats (Reels, carousel posts, Stories). If engagement doesn't improve in 60 days, consider deprioritizing Instagram in favor of higher-ROI channels

**Google Ads (non-branded search):**
- Problem: High cost per lead on non-branded keywords
- Metrics: $85 CPL on non-branded vs. $12 CPL on branded. Non-branded campaigns spending $2,000/month with 24 leads
- Likely cause: Broad keyword targeting, landing pages not optimized for specific search intent
- Improvement path: Narrow to long-tail keywords with clear purchase intent. Create dedicated landing pages per ad group. Test reducing non-branded budget by 50% and reallocating to LinkedIn

## Brand Voice Gaps

**No documented brand voice guide:**
- Issue: Brand voice is understood intuitively by the founder but not documented anywhere
- Impact: Freelance writers and new team members produce inconsistent content. Editor spends significant time rewriting for voice
- Recommendation: Create brand voice document with 3-4 voice attributes, do/don't examples, and tone variations by channel

**Missing competitor differentiation language:**
- Issue: No clear documented messaging for how the product differs from top 3 competitors
- Impact: Comparison page is generic. Sales emails don't address competitive objections
- Recommendation: Create competitive positioning matrix and battle cards with specific language for each competitor

## Content Quality Issues

**Outdated blog posts:**
- Issue: 15+ blog posts reference product features that have changed or been removed
- Examples: "Getting Started with Workflows" (references old UI), "2023 Feature Roundup" (outdated screenshots), "Integration Guide for Zapier" (deprecated API version)
- Impact: Visitors encounter inaccurate information, damages credibility. Some posts still rank for SEO keywords
- Fix approach: Audit all posts older than 12 months. Update top-traffic posts first. Add "last updated" dates. Redirect or consolidate posts that can't be salvaged

**Thin landing pages:**
- Issue: 4 landing pages have fewer than 200 words of copy with no social proof
- Examples: /features/reporting, /features/integrations, /use-cases/agencies, /use-cases/freelancers
- Impact: Low conversion rates (0.5% vs. 2.8% on detailed landing pages). Poor SEO performance
- Fix approach: Expand with customer quotes, feature details, screenshots, and comparison content. Target 800-1200 words per landing page

## SEO Problems

**Missing meta descriptions on key pages:**
- Issue: 23 pages lack custom meta descriptions, defaulting to auto-generated snippets
- Evidence: Google Search Console shows these pages have lower-than-average CTR (1.2% vs. 3.5% site average)
- Impact: Lower click-through rates from search results, missed opportunity to control messaging
- Fix approach: Write custom meta descriptions for all pages with >100 monthly impressions. Prioritize product and feature pages

**Slow page load on blog:**
- Issue: Blog pages load in 4.2 seconds (mobile) due to unoptimized images and render-blocking scripts
- Evidence: Google PageSpeed Insights score of 45/100 on mobile for blog posts
- Impact: Higher bounce rates, potential negative ranking signal. Core Web Vitals failing
- Fix approach: Implement image compression and lazy loading, defer non-critical JS, enable caching

**Cannibalization on "project management" terms:**
- Issue: 3 blog posts and 2 landing pages target the same "project management for small teams" keyword cluster
- Evidence: None of the 5 pages ranks in top 20 for any variation of the keyword
- Impact: Search engines can't determine which page to rank, diluting authority across all 5
- Fix approach: Consolidate into one definitive page, redirect others, use internal linking to support the primary page

## Conversion Bottlenecks

**Free trial to paid conversion:**
- Problem: Only 4% of free trial users convert to paid (industry benchmark: 8-12%)
- Data: 500 trial starts/month, 20 conversions. Biggest drop-off at day 3 (60% of trial users never return after day 2)
- Likely cause: Onboarding sequence is generic. No in-app guidance. Trial period (14 days) may be too short for complex use cases
- Fix approach: Build segmented onboarding emails based on use case selected at signup. Add in-app onboarding checklist. Test 21-day trial period

**Blog to email signup:**
- Problem: Blog gets 35,000 monthly visitors but only 150 email signups (0.4% conversion)
- Data: Sidebar signup form is only CTA. No content upgrades or lead magnets on individual posts
- Likely cause: Generic "Subscribe to our newsletter" CTA with no specific value proposition
- Fix approach: Create topic-specific lead magnets for top 10 traffic posts. Add inline CTAs within post content. Test exit-intent popup with specific offer

## Missing Coverage

**No video content strategy:**
- What's missing: YouTube channel exists but has only 3 videos from 2023. No regular video production
- Opportunity: Competitors publish weekly tutorials. Video results appear in 40% of target keyword SERPs
- Effort: Requires content planning, recording setup, and editing workflow. Minimum 2 videos/month to build momentum
- Priority: Medium (high potential but significant resource investment)

**No customer community:**
- What's missing: No community space for customers to connect, share use cases, or get peer support
- Opportunity: Reduces support burden, increases retention, generates user-generated content and testimonials
- Effort: Set up community platform (Circle, Discord, or Discourse), seed with initial content, moderate ongoing
- Priority: Low (focus on acquisition channels first, consider after reaching 1,000 paying customers)

**No partner/affiliate channel:**
- What's missing: No referral or affiliate program despite customers frequently mentioning the product to peers
- Opportunity: Word-of-mouth is top self-reported acquisition channel (22% of signups). Formalizing could amplify this
- Effort: Set up referral tracking (ReferralCandy, PartnerStack), create partner resources, define commission structure
- Priority: High (leverages existing organic referrals with relatively low setup effort)

---

*Marketing gaps audit: 2025-06-15*
*Update as issues are fixed or new ones discovered*
```
</good_examples>

<guidelines>
**What belongs in MARKETING-GAPS.md:**
- Messaging inconsistencies across channels with specific examples
- Underperforming channels with metrics and benchmarks
- Brand voice documentation gaps
- Content quality issues (outdated, thin, inaccurate)
- SEO problems (technical and content)
- Conversion bottlenecks with data
- Missing channels, audience segments, or content types
- Improvement approaches for each gap

**What does NOT belong here:**
- Opinions without evidence ("our social media is bad")
- Vague complaints without fix approaches
- Future feature ideas or wishlists
- Detailed campaign plans (those come during planning)
- Competitive analysis (that's a separate reference)

**When filling this template:**
- Review messaging across all channels for consistency
- Compare channel metrics against industry benchmarks
- Check for documented brand voice and style guides
- Audit content for accuracy, freshness, and quality
- Run technical SEO audit (page speed, meta tags, indexing)
- Map the funnel and identify where conversion rates drop
- List channels or audience segments not currently addressed
- Include specific metrics and examples, not generalizations
- Suggest fix approaches for every gap identified
- Prioritize by impact and effort

**Tone guidelines:**
- Factual, not emotional ("0.4% blog-to-email conversion" not "terrible signup rates")
- Solution-oriented ("Create topic-specific lead magnets" not "needs better CTAs")
- Evidence-based ("4.2s mobile load time, PageSpeed score 45/100" not "site is slow")

**Useful for marketing planning when:**
- Deciding what to work on next (prioritize high-impact gaps)
- Planning content improvements and refreshes
- Allocating budget across channels
- Building the case for new tools or resources
- Setting quarterly marketing goals
- Identifying quick wins vs. long-term projects
</guidelines>
