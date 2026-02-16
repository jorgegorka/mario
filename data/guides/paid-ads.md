# Paid Advertising Guide

**A Comprehensive Guide for Marketing Executor Agents**

This guide covers paid advertising strategy across search, social, and display platforms. It includes campaign structure, ad copy frameworks, audience segmentation, keyword strategy, landing page alignment, attribution, budgeting, platform-specific guidance, testing methodology, and optimization workflows.

**Related guides:**
- [Brand Strategy and Positioning](strategy.md) -- Audience definitions, messaging hierarchy, and positioning for ad copy
- [Web Copywriting and CRO](web-copy.md) -- Landing page copy, CTA formulas, conversion optimization
- [SEO and Content Marketing](seo-content.md) -- Keyword research overlap, organic/paid coordination

## Table of Contents

- [Part 1: Campaign Structure](#part-1-campaign-structure)
  - [1.1 Account Hierarchy](#11-account-hierarchy)
  - [1.2 Naming Conventions](#12-naming-conventions)
  - [1.3 Campaign Types](#13-campaign-types)
- [Part 2: Ad Copy Frameworks](#part-2-ad-copy-frameworks)
  - [2.1 Copy Approaches](#21-copy-approaches)
  - [2.2 Character Limits by Platform](#22-character-limits-by-platform)
  - [2.3 Headline Formulas](#23-headline-formulas)
  - [2.4 Description Formulas](#24-description-formulas)
- [Part 3: Audience Segmentation](#part-3-audience-segmentation)
  - [3.1 Traffic Temperature](#31-traffic-temperature)
  - [3.2 Audience Types](#32-audience-types)
  - [3.3 Audience Layering](#33-audience-layering)
  - [3.4 Exclusion Strategy](#34-exclusion-strategy)
- [Part 4: Keyword Research for Ads](#part-4-keyword-research-for-ads)
  - [4.1 Match Types](#41-match-types)
  - [4.2 Negative Keywords](#42-negative-keywords)
  - [4.3 Keyword Grouping Strategies](#43-keyword-grouping-strategies)
  - [4.4 Keyword Intent Alignment](#44-keyword-intent-alignment)
  - [4.5 Bid Strategies](#45-bid-strategies)
- [Part 5: Landing Page Alignment](#part-5-landing-page-alignment)
  - [5.1 Message Match Principle](#51-message-match-principle)
  - [5.2 Scent Trail Consistency](#52-scent-trail-consistency)
  - [5.3 Dedicated Landing Pages](#53-dedicated-landing-pages)
  - [5.4 Conversion-Focused Design](#54-conversion-focused-design)
- [Part 6: Attribution and Tracking](#part-6-attribution-and-tracking)
  - [6.1 UTM Parameter Strategy](#61-utm-parameter-strategy)
  - [6.2 Conversion Tracking Setup](#62-conversion-tracking-setup)
  - [6.3 Event Naming Conventions](#63-event-naming-conventions)
  - [6.4 Attribution Models](#64-attribution-models)
- [Part 7: Budget and Bidding](#part-7-budget-and-bidding)
  - [7.1 Budget Allocation Framework](#71-budget-allocation-framework)
  - [7.2 Scaling Rules](#72-scaling-rules)
  - [7.3 ROAS Targets by Campaign Type](#73-roas-targets-by-campaign-type)
  - [7.4 When to Kill a Campaign](#74-when-to-kill-a-campaign)
- [Part 8: Platform-Specific Guidance](#part-8-platform-specific-guidance)
  - [8.1 Google Ads](#81-google-ads)
  - [8.2 Meta Ads](#82-meta-ads)
  - [8.3 LinkedIn Ads](#83-linkedin-ads)
- [Part 9: A/B Testing](#part-9-ab-testing)
  - [9.1 What to Test](#91-what-to-test)
  - [9.2 Statistical Significance](#92-statistical-significance)
  - [9.3 Testing Cadence](#93-testing-cadence)
  - [9.4 Creative Fatigue Signals](#94-creative-fatigue-signals)
- [Part 10: Campaign Optimization Checklist](#part-10-campaign-optimization-checklist)
  - [10.1 Pre-Launch Checks](#101-pre-launch-checks)
  - [10.2 Daily Monitoring](#102-daily-monitoring)
  - [10.3 Weekly Optimization](#103-weekly-optimization)
  - [10.4 Monthly Review](#104-monthly-review)
  - [10.5 Quarterly Strategy Refresh](#105-quarterly-strategy-refresh)

---

# Part 1: Campaign Structure

A clean campaign structure is the foundation of scalable paid advertising. Poor structure leads to wasted spend, unclear data, and optimization headaches.

## 1.1 Account Hierarchy

Every major ad platform follows a similar hierarchy:

```
Account
  +-- Campaign (budget, objective, targeting scope)
  |     +-- Ad Group / Ad Set (audience, keywords, placement)
  |     |     +-- Ad (creative, copy, destination URL)
  |     +-- Ad Group / Ad Set
  |           +-- Ad
  +-- Campaign
```

Hierarchy principles:

- **One objective per campaign.** Never mix awareness and conversion goals in a single campaign.
- **One theme per ad group.** Each ad group targets a tightly related set of keywords or a single audience segment.
- **Multiple ads per ad group.** Run 3-5 ad variations per ad group to enable testing.
- **Separate budgets by funnel stage.** Prospecting and retargeting need independent budgets.

## 1.2 Naming Conventions

Consistent naming makes reporting, filtering, and collaboration possible at scale.

```
Template:
[Platform]_[Objective]_[Audience]_[Geo]_[Funnel Stage]_[Detail]

Examples:
GOOG_Search_Competitor_US_BOF_BrandTerms
META_Conv_LAL1pct_US_MOF_CaseStudy_VideoTestimonial
LNKD_LeadGen_ITDirectors_US_TOF_Whitepaper

Abbreviations:
Platform:   GOOG, META, LNKD, TWTR, TKTK
Objective:  Search, Display, Shop, Video, Conv, LeadGen, Aware
Funnel:     TOF (top), MOF (middle), BOF (bottom)
Geo:        US, UK, EU, APAC, GLOBAL
Audience:   LAL (lookalike), RTG (retarget), CRM, INT (interest)
```

## 1.3 Campaign Types

```
Type              Best For                  Targeting            Key Metric
----              --------                  ---------            ----------
Search            Capturing demand          Keywords             Cost per conversion
Display           Awareness, retargeting    Audiences, topics    View-through conversions
Video             Brand, demos              Audiences, keywords  View rate, CPV
Shopping          E-commerce products       Product feed         ROAS, click share
Performance Max   Cross-channel reach       Audience signals     Conversions, ROAS
```

Organize campaigns by funnel stage, product line, or geography. Separate when language, pricing, or competitive landscape differs by region.

---

# Part 2: Ad Copy Frameworks

Ad copy must stop the scroll, communicate value, and compel a click -- in very few characters.

## 2.1 Copy Approaches

### Benefit-Driven

```
Headline:    "Cut Your Deploy Time by 60x"
Description: "Ship code in 2 minutes instead of 2 hours.
              Zero configuration required. Start free."
```

### Feature-Driven

```
Headline:    "One-Click Deployment for Any Stack"
Description: "Supports Docker, Kubernetes, and serverless.
              Built-in rollbacks. No vendor lock-in."
```

### Testimonial-Based

```
Headline:    "'We shipped 3x faster in week one' -- Acme CTO"
Description: "Join 2,000+ teams using ShipFast. See why G2 rated us #1."
```

### Comparison

```
Headline:    "Tired of Jenkins Pipeline Configs?"
Description: "ShipFast replaces 500 lines of YAML with one click.
              Migrate in under an hour. Free trial."
```

### Urgency-Based

Only use when the constraint is real. Never fabricate urgency.

```
Headline:    "Launch Pricing Ends March 1st"
Description: "Lock in 40% off annual plans before we raise prices.
              Full access, no feature limits. Start today."
```

## 2.2 Character Limits by Platform

```
Google Ads (RSA):
  Headlines:      Up to 15 (min 3), 30 characters each
  Descriptions:   Up to 4 (min 2), 90 characters each
  Display path:   2 fields, 15 characters each

Meta Ads (Facebook/Instagram):
  Primary text:   125 chars recommended (up to 2,200)
  Headline:       40 chars recommended (up to 255)
  Description:    30 chars recommended (up to 255)

LinkedIn Ads (Sponsored Content):
  Intro text:     150 chars recommended (up to 600)
  Headline:       70 chars recommended (up to 200)
  Description:    100 chars recommended (up to 300)
```

## 2.3 Headline Formulas

```
[Number] + [Outcome]:           "3x Faster Deploys"
[Action Verb] + [Object]:      "Automate Your Workflow"
[Question]:                     "Still Deploying Manually?"
[How to] + [Outcome]:          "How to Ship Code in 2 Min"
[Without] + [Pain]:            "Scale Without Downtime"
[Social Proof] + [Outcome]:    "10,000 Teams Ship Faster"
[Specific Result]:              "34% More Conversions"
```

Rules: lead with the strongest benefit, use numbers, include the keyword in at least one headline (search), write at varied lengths, and never repeat the same message across headlines.

## 2.4 Description Formulas

```
Structure: [Expand on benefit]. [Proof or feature]. [Specific CTA].

Examples:
"Deploy any application in under 2 minutes. No YAML, no configs,
 no DevOps team required. Start your free 14-day trial."

"Rated #1 on G2 for deployment automation. Used by 2,000+ teams.
 See a live demo in 3 minutes."
```

Test one element at a time: benefit vs. feature headline, question vs. statement, social proof vs. feature description, soft CTA vs. hard CTA. Run 3+ ad variations per ad group minimum.

---

# Part 3: Audience Segmentation

The same product requires different messaging for different audiences. Segmentation ensures the right message reaches the right person at the right stage.

## 3.1 Traffic Temperature

```
Cold Traffic:
  Goal:       Introduce, educate, build awareness
  Content:    Educational, thought leadership, broad benefits
  CTA:        Soft (read, watch, learn, discover)
  Expected:   Lowest CPC, lowest CVR (0.5-2%)

Warm Traffic:
  Goal:       Nurture, differentiate, build trust
  Content:    Case studies, comparisons, demos, webinars
  CTA:        Medium (see demo, read case study, compare plans)
  Expected:   Medium CPC, medium CVR (2-8%)

Hot Traffic:
  Goal:       Convert, overcome final objections
  Content:    Offers, testimonials, guarantees, urgency
  CTA:        Hard (start trial, buy now, schedule call)
  Expected:   Highest CPC, highest CVR (8-25%)
```

## 3.2 Audience Types

### Lookalike / Similar Audiences

```
Source: Customer email list (highest LTV), purchasers, engaged subscribers
Sizes: 1% (highest quality) | 1-3% (balanced) | 3-5% (broad) | 5-10% (awareness only)
```

### Custom Audiences from CRM

Upload customer lists to upsell, exclude from acquisition, target churned users, or reach unconverted trial users.

### Retargeting Audiences

```
Audience                         Window      Priority
--------                         ------      --------
Pricing page visitors            7 days      Highest
Cart abandoners                  7 days      Highest
Trial signups (not converted)    14 days     High
Product page viewers             14 days     Medium
Video viewers (50%+)             30 days     Medium
Blog readers / homepage visits   30 days     Low
```

## 3.3 Audience Layering

Combine targeting criteria to narrow reach and increase relevance:

```
Base audience:      [broad - interest or demographic]
  + Layer 1:        [behavioral - purchase intent, job title]
  + Layer 2:        [engagement - visited site, watched video]
  - Exclusion:      [existing customers, recent converters]

B2B Example:
  Base: IT Decision Makers | + 50-500 employees | + cloud interest | - customers

E-commerce Example:
  Base: Women 25-45 | + organic skincare interest | + engaged shoppers | - bought last 30d
```

## 3.4 Exclusion Strategy

```
All campaigns:      Current customers, employees, bot-heavy placements, recent converters
Prospecting:        Retargeting audiences, existing nurture subscribers
Retargeting:        Already-converted users, sub-5-second bouncers
```

---

# Part 4: Keyword Research for Ads

In paid search, every click costs money. Precision and intent alignment are critical.

## 4.1 Match Types

```
Broad Match:
  Matches synonyms, related searches, implied meanings. Widest reach, least control.
  Use: Discovery phase, paired with smart bidding. Mitigate with strong negatives.

Phrase Match:
  Query must include the keyword meaning. Moderate reach and control.
  Use: Balanced approach, scaling proven keywords.

Exact Match:
  Query must match exact meaning. Narrowest reach, highest control.
  Use: Proven high-converting terms, tight budget control.

Strategy:
  Launch:   Start with phrase + exact on core terms
  Scale:    Expand phrase from search term reports, add broad with 50+ conversions
  Optimize: Promote top search terms to exact, add negatives for irrelevant matches
```

## 4.2 Negative Keywords

```
Category            Examples
--------            --------
Jobs/Careers        hiring, jobs, salary, career, intern
Education           tutorial, course, certification, how to become
Free/Cheap          free, cheap, open source, DIY
Informational       what is, definition, meaning, history
Low Intent          review, comparison, reddit, forum

Lists:
  Universal negatives:    All campaigns (jobs, free, DIY)
  Industry negatives:     All campaigns in a vertical
  Campaign negatives:     Specific to individual campaigns

Review search term reports daily for new campaigns, weekly for mature ones.
```

## 4.3 Keyword Grouping Strategies

**SKAGs (Single Keyword Ad Groups):** One keyword per ad group. Maximum message match, but high maintenance. Use for top 10-20 highest-value terms.

**Themed Ad Groups:** 5-15 closely related keywords sharing the same intent and ad copy. Balanced control and manageability.

## 4.4 Keyword Intent Alignment

```
Intent Level     Keyword Pattern           Landing Page          Bid Priority
------------     ---------------           ------------          ------------
Navigational     [brand name]              Homepage              Highest (defend)
Transactional    "buy", "pricing", "demo"  Pricing / Demo page   Highest
Commercial       "best", "vs", "review"    Comparison page       High
Informational    "how to", "what is"       Blog / Guide          Low (or exclude)
```

## 4.5 Bid Strategies

```
Strategy              Best For                  Needs              When to Use
--------              --------                  -----              -----------
Manual CPC            New campaigns, tight $    Nothing            Under 30 conv/month
Target CPA            Consistent volume         30+ conv/month     After baseline CPA known
Maximize Conversions  Uncapped budget           Conversion data    Volume over efficiency
Target ROAS           E-commerce, revenue       50+ conv, revenue  Varying margins/values
```

---

# Part 5: Landing Page Alignment

The ad gets the click. The landing page gets the conversion. Misalignment wastes budget.

## 5.1 Message Match Principle

The landing page headline must echo the ad promise:

```
Ad Headline:       "Cut Deploy Time by 60x"
Landing Headline:  "Cut Deploy Time by 60x"    -- Match (good)
Landing Headline:  "Welcome to ShipFast"        -- Mismatch (bad)

Checklist:
[ ] Landing headline mirrors ad headline
[ ] Benefit promised in ad is visible above the fold
[ ] CTA on page matches CTA in ad
[ ] Visual style is consistent between ad and page
[ ] Offer mentioned in ad is immediately accessible
```

## 5.2 Scent Trail Consistency

Every step from query to ad to landing page must reinforce the same intent. Common breaks: ad links to homepage, ad mentions discount page lacks, ad targets persona A but page is generic, language mismatch.

## 5.3 Dedicated Landing Pages

Every distinct campaign theme needs its own landing page. Never send all ad traffic to the homepage.

```
Page structure:
1. Hero:       Headline (matches ad), subheadline, primary CTA
2. Problem:    The pain the visitor experiences
3. Solution:   How the product solves it (features as benefits)
4. Proof:      Testimonials, logos, data points
5. Objections: Top 2-3 concerns (FAQ or inline)
6. CTA:        Repeat primary call to action
```

## 5.4 Conversion-Focused Design

Remove navigation, sidebars, competing CTAs, and external links. Keep one primary CTA repeated 2-3 times, trust signals near the CTA, and minimal footer links. Target under 3 seconds load time on mobile -- each additional second reduces conversions by approximately 7%.

---

# Part 6: Attribution and Tracking

Without accurate tracking, paid advertising is guesswork.

## 6.1 UTM Parameter Strategy

```
utm_source:     Platform (google, meta, linkedin)
utm_medium:     Channel type (cpc, cpm, paid_social, display)
utm_campaign:   Campaign name (spring_sale, competitor_search)
utm_content:    Ad variation (benefit_headline_v1, video_testimonial)
utm_term:       Keyword or audience (deployment_automation, lal_1pct)

Rules:
1. Lowercase only
2. Underscores instead of spaces
3. No personally identifiable information
4. Consistent vocabulary across campaigns
```

## 6.2 Conversion Tracking Setup

```
Macro conversions:  Purchase, trial signup, demo request, form submit, tracked call
Micro conversions:  Email signup, download, video view 50%+, add to cart, pricing view

Checklist:
[ ] Platform pixels installed (Google tag, Meta pixel, LinkedIn Insight tag)
[ ] Conversion events configured for all macro conversions
[ ] Revenue values passed with purchase events
[ ] Cross-domain tracking configured if applicable
[ ] Server-side tracking as backup for client-side
[ ] Consent management integrated
```

## 6.3 Event Naming Conventions

Use object_action format: `form_submit`, `trial_start`, `demo_request`, `cart_add`, `purchase_complete`, `video_play`, `pricing_view`. Lowercase with underscores. Same name across all platforms.

```
Event Documentation:
  Event Name:       trial_start
  Description:      User starts a free trial
  Trigger:          Trial signup form submission success
  Parameters:       plan_type, source_page, utm_source
  Platforms:        Google Ads, Meta, LinkedIn, GA4
```

## 6.4 Attribution Models

```
Click-through:   Credit to the ad clicked before converting
                 Windows: Google 30d, Meta 7d, LinkedIn 30d

View-through:    Credit to an ad seen but not clicked
                 Windows: Google 1d, Meta 1d, LinkedIn 7d
                 Use 1-day or disable for conservative reporting

Multi-touch models:
  Last click       100% to last click              Simple reporting
  First click      100% to first touch             Understanding discovery
  Linear           Equal credit to all touches     Balanced view
  Time decay       More credit to recent touches   Long sales cycles
  Position-based   40% first, 40% last, 20% mid   B2B with multiple touches
  Data-driven      ML-based allocation             High-volume (600+/mo)

Start with last-click, evolve to position-based or data-driven as volume grows.
Always compare platform-reported conversions to CRM data.
```

---

# Part 7: Budget and Bidding

Budget management determines whether campaigns scale profitably or burn cash.

## 7.1 Budget Allocation Framework

```
The 70/20/10 Rule:
  70% -- Proven campaigns with consistent ROAS
  20% -- Testing (new audiences, creatives, platforms)
  10% -- Experimental (emerging platforms, unconventional strategies)

By Funnel Stage:
  TOF: 30-40%   Build awareness, fill the funnel
  MOF: 20-30%   Nurture consideration
  BOF: 30-40%   Convert high-intent prospects

Minimum Viable Budget:
  Target CPA x 2 = minimum daily budget per campaign
  Example: $50 CPA = $100/day minimum = $3,000/month
```

## 7.2 Scaling Rules

Never increase budget by more than 20% per day. Larger increases reset algorithm learning.

```
Scale UP when:  CPA below target 5+ days, budget exhausting early, impression share <70%
Scale DOWN when: CPA exceeds target 30%+ for 3+ days, frequency >3x/week, CVR drops 25%+
```

## 7.3 ROAS Targets by Campaign Type

```
Campaign Type        Minimum    Target     Notes
-------------        -------    ------     -----
Brand search         800%       1000%      Highest ROAS expected
Non-brand search     200%       400%       Core performance driver
Shopping             300%       500%       Varies by margin
Retargeting          400%       600%       High CVR expected
Prospecting social   100%       200%       Invest in pipeline
Display              50%        150%       Awareness role
Video                50%        100%       Brand building
```

## 7.4 When to Kill a Campaign

```
Kill immediately:
- Zero conversions after 3x target CPA spend
- CTR below 1% (search) or 0.5% (social) after 1,000 impressions
- Bounce rate above 80%
- Fraud indicators

Kill after optimization attempt:
- CPA exceeds 2x target for 14+ days despite changes
- ROAS below breakeven for 30 days
- Audience saturation (frequency >5x with declining CTR)

Diminishing returns signals:
- CPA rising as spend rises -- reduce to last efficient level
- CTR declining week over week -- refresh creative
- Frequency above 4x -- expand audience or pause and rotate
```

Use daily budgets for always-on campaigns. Use lifetime budgets for promotions with fixed start and end dates.

---

# Part 8: Platform-Specific Guidance

## 8.1 Google Ads

```
Search:
- RSAs with 10+ unique headlines, pin critical headlines only when necessary
- Include primary keyword in 2+ headlines
- Use all extensions (sitelinks, callouts, structured snippets)
- Set up search term exclusions within first week

Display:
- Responsive display ads as primary format
- Upload images in all sizes (landscape, square, portrait)
- Exclude mobile app placements for B2B
- Frequency caps: 3-5 impressions per user per day

Shopping:
- Optimize product feed titles with primary keywords
- High-quality images (white background, no watermarks)
- Custom labels to segment by margin, performance, or season
- Run Standard Shopping alongside Performance Max to compare

YouTube:
- Hook in first 5 seconds (before skip button)
- Skippable in-stream for consideration, bumper for awareness
- Custom intent audiences (search-based) for high relevance
- Test 15s, 30s, and 60s variations

Performance Max:
- Provide assets in all formats (text, image, video)
- Audience signals as suggestions, not hard targets
- Run 4-6 weeks before evaluating
- URL exclusions to prevent irrelevant page traffic
```

## 8.2 Meta Ads

```
Structure (Facebook/Instagram):
- One objective per campaign, one audience per ad set, 3-5 creatives per ad set
- Avoid audiences <100,000 for prospecting, >5 ad sets per campaign, <$20/day per ad set

Formats:
  Single image    1080x1080 or 1200x628      Simple messages, retargeting
  Carousel        1080x1080, 2-10 cards       Multiple products/features
  Video           4:5 or 1:1, under 60s       Storytelling, demos
  Stories/Reels   9:16, under 15s             Immersive, full-screen
  Collection      Cover + product feed         E-commerce catalog
  Lead form       Pre-filled from profile      In-platform lead capture

Advantage+:
- Meta's automated campaign type using ML for targeting
- Best for e-commerce, high-volume conversions
- Test alongside manual campaigns, compare CPA and lead quality
```

## 8.3 LinkedIn Ads

```
Campaign Types:
  Sponsored Content    Native feed ads (image, carousel, video)
  Message Ads          Direct messages in LinkedIn inbox
  Lead Gen Forms       In-platform forms pre-filled with profile data
  Text Ads             Sidebar ads (low cost, low engagement)
  Dynamic Ads          Personalized ads using profile data

B2B Targeting:
  Job title, function, seniority, company size, industry, company name (ABM),
  skills, group membership

Lead Gen Forms:
- 3-4 fields max (name, email, company, title)
- Pre-filled fields increase completion significantly
- Offer genuine value (whitepaper, report, template)
- CRM integration for instant delivery, follow up within 5 minutes

Budget: $5-$15 CPC, $30-$150 CPL, minimum $3,000/month for meaningful data.
Higher CPL is offset by higher lead quality in B2B.
```

---

# Part 9: A/B Testing

Systematic testing replaces opinion with evidence.

## 9.1 What to Test

```
Element             Impact    Ease    Priority
-------             ------    ----    --------
Headlines           High      Easy    First
Audience targeting  High      Medium  First
Landing page        High      Medium  First
Ad creative/images  High      Medium  First
CTA text            Medium    Easy    First
Descriptions        Medium    Easy    Second round
Bidding strategy    High      Hard    After baseline
Offer               High      Hard    Quarterly
```

Test one variable at a time. Headlines: benefit vs. feature vs. question vs. social proof. Audiences: lookalike sizes, interest vs. behavioral. Creative: image vs. video, UGC vs. branded. CTAs: soft vs. hard, specific vs. generic.

## 9.2 Statistical Significance

Do not call a winner until each variant has 100+ conversions (or 1,000+ clicks for CTR tests), confidence reaches 95%, and the test has run at least 7 full days. Common mistakes: calling winners early, testing multiple variables, unequal traffic splits, ignoring weekly seasonality.

## 9.3 Testing Cadence

```
Week 1-2:   Launch with equal budget split
Week 2-3:   Monitor, do not act
Week 3-4:   Evaluate, call winner if significant
Week 4+:    Scale winner, begin next test

Always have one test running per major campaign. Never test more than one
element per campaign simultaneously. Document all results.

Test Log Template:
  Test Name / Hypothesis / Variable / Control / Variant / Primary Metric
  Start Date / End Date / Sample Size / Result / Lift / Confidence / Next Action
```

## 9.4 Creative Fatigue Signals

```
Signal                          Threshold
------                          ---------
CTR declining week over week    3+ consecutive weeks
Frequency rising                Above 4x per user per week
CPA rising without market shift 20%+ increase over 2 weeks
Engagement dropping             Comments, shares, saves declining

Response:
  Refresh creative every 4-6 weeks or at fatigue signals
  Rotate images/video every 2-4 weeks for high-frequency campaigns
  Update copy angles every 6-8 weeks
  Pause fatigued ads, reintroduce after 2-4 week break
```

---

# Part 10: Campaign Optimization Checklist

## 10.1 Pre-Launch Checks

```
Strategy:
[ ] Objective aligns with business goal
[ ] Audience defined with exclusions
[ ] Budget sufficient for learning (min 2x CPA/day)
[ ] ROAS/CPA targets set based on margins

Creative:
[ ] Ad copy message-matches landing page
[ ] Headlines and descriptions are unique
[ ] Images/videos meet platform specs
[ ] CTA is clear and specific

Tracking:
[ ] UTM parameters correct and consistent
[ ] Conversion tracking firing (tested with real transaction)
[ ] Landing page loads under 3 seconds on mobile
[ ] All links working

Structure:
[ ] Naming follows convention
[ ] Negative keywords applied (search)
[ ] Audience exclusions set
[ ] Extensions configured (search)
[ ] Frequency caps set (display/social)
```

## 10.2 Daily Monitoring

```
[ ] Spend pacing on track
[ ] No campaigns spending significantly above/below target
[ ] No disapproved ads or policy violations
[ ] Search term report reviewed for new negatives
[ ] CPA/ROAS within target range
[ ] No anomalies (sudden CTR drops, CPC spikes)
```

## 10.3 Weekly Optimization

```
[ ] CPA/ROAS vs targets across all campaigns
[ ] Top and bottom ad groups identified
[ ] Underperforming ads paused (after sufficient data)
[ ] Bids adjusted on high/low performers
[ ] Audience performance reviewed by segment
[ ] Frequency levels checked (social)
[ ] Negative keywords updated from search terms
[ ] Ad fatigue signals checked
[ ] A/B test progress reviewed
[ ] Budget reallocated from underperformers to top performers
```

## 10.4 Monthly Review

```
[ ] Overall account CPA/ROAS vs targets
[ ] Performance by funnel stage (TOF, MOF, BOF)
[ ] Customer acquisition cost trend
[ ] Platform-reported vs CRM-verified conversions
[ ] Top 3 learnings documented
[ ] A/B test results summarized
[ ] Competitor ad activity reviewed (auction insights, ad library)
[ ] Next month budget allocation set
[ ] Creative refresh schedule planned
[ ] Testing roadmap updated
```

## 10.5 Quarterly Strategy Refresh

```
[ ] Full account structure reviewed for redundancy or gaps
[ ] Underperforming campaigns consolidated
[ ] New campaign types or platforms evaluated
[ ] Negative keyword lists refreshed
[ ] Customer lists updated for lookalike refresh
[ ] Persona alignment reviewed
[ ] New audience segments evaluated from CRM insights
[ ] All active creatives audited for fatigue
[ ] New creative themes developed from quarterly learnings
[ ] Conversion tracking accuracy audited
[ ] Attribution model reviewed
[ ] ROAS/CPA targets updated based on current margins and LTV
[ ] Quarterly performance summary documented
```

---

**Document Version**: 1.0
**Last Updated**: 2026-02-16
**Maintainer**: Marketing Team
