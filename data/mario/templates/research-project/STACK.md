# Marketing Stack Research Template

Template for `.planning/research/STACK.md` — discovered marketing tools, channels, and platform landscape for the project.

<template>

```markdown
# Marketing Stack Research

**Project:** [project name]
**Researched:** [date]
**Confidence:** [HIGH/MEDIUM/LOW]

## Core Platforms

| Component | Discovered Value | Source |
|-----------|-----------------|--------|
| Website platform | [WordPress/Webflow/Squarespace/custom/none] | [where found] |
| CMS | [built-in/Contentful/Strapi/Ghost/none] | [where found] |
| Analytics | [Google Analytics/Plausible/Mixpanel/none] | [where found] |
| Domain & hosting | [provider, CDN if any] | [where found] |

## Marketing Type

| Aspect | Discovered Value | Evidence |
|--------|-----------------|----------|
| B2B or B2C | [business model] | [pricing page, messaging, ICP] |
| Product-led or sales-led | [growth model] | [signup flow, demo request, free trial] |
| Content-heavy or product-focused | [content strategy] | [blog volume, resource library] |
| Multi-brand or single brand | [brand architecture] | [presence of sub-brands or product lines] |

## Content Channels

| Category | Discovered Value | Evidence |
|----------|-----------------|----------|
| Blog/content hub | [platform, publishing frequency, topic areas] | [URL, CMS] |
| Email marketing | [ESP: ConvertKit/Mailchimp/ActiveCampaign/Resend/none] | [signup forms, email headers] |
| Social media | [active platforms, posting frequency] | [profile links, activity level] |
| Video | [YouTube/Vimeo/Wistia/none] | [embedded videos, channel] |
| Podcast | [platform, hosting provider, or none] | [RSS feed, mentions] |

## Paid Advertising

| Category | Discovered Value | Evidence |
|----------|-----------------|----------|
| Search ads | [Google Ads/Bing Ads/none] | [ad transparency tools, UTM params] |
| Social ads | [Meta/LinkedIn/Twitter/TikTok/none] | [ad libraries, pixel/tag presence] |
| Display/retargeting | [platform or none] | [tracking pixels found] |
| Affiliate/referral | [program or none] | [referral pages, partner programs] |

## SEO & Content Tools

| Category | Discovered Value | Evidence |
|----------|-----------------|----------|
| SEO tool | [Ahrefs/SEMrush/Moz/Ubersuggest/none] | [if discoverable] |
| Keyword tracking | [tool or none] | [if discoverable] |
| Content optimization | [Clearscope/Surfer/MarketMuse/none] | [if discoverable] |
| Site audit | [tool or none] | [technical SEO setup] |

## CRM & Sales

| Category | Discovered Value | Evidence |
|----------|-----------------|----------|
| CRM | [HubSpot/Salesforce/Pipedrive/none] | [form submissions, tracking codes] |
| Lead capture | [forms, pop-ups, chatbots] | [website elements found] |
| Sales enablement | [tools or none] | [if discoverable] |
| Customer success | [Intercom/Zendesk/none] | [chat widgets, help center] |

## Design & Creative

| Category | Discovered Value | Evidence |
|----------|-----------------|----------|
| Design tool | [Figma/Canva/Adobe/none] | [brand assets, social templates] |
| Image/asset library | [storage location or none] | [Google Drive, DAM tool] |
| Video editing | [tool or none] | [video content presence] |
| Brand guidelines | [documented/informal/none] | [brand kit, style guide] |

## Automation & Integration

| Category | Discovered Value | Evidence |
|----------|-----------------|----------|
| Marketing automation | [HubSpot/Marketo/ActiveCampaign/none] | [workflow complexity, sequences] |
| Integration platform | [Zapier/Make/n8n/none] | [connected tools] |
| Scheduling | [Buffer/Hootsuite/Later/none] | [social posting patterns] |
| A/B testing | [Optimizely/VWO/built-in/none] | [test elements on site] |

## Tool Inventory

### Core Tools (Active)

| Tool | Plan/Tier | Category | Purpose |
|------|-----------|----------|---------|
| [tool name] | [free/pro/enterprise] | [email/analytics/CRM/etc.] | [what it does in this project] |
| [tool name] | [plan] | [category] | [purpose] |
| [tool name] | [plan] | [category] | [purpose] |

### Secondary Tools

| Tool | Purpose | Notes |
|------|---------|-------|
| [tool name] | [what it does] | [usage frequency, configuration notes] |
| [tool name] | [what it does] | [notes] |

## Channel Setup

```bash
# Website
[platform setup, CMS configuration, hosting details]

# Email
[ESP setup, list configuration, automation workflows]

# Analytics
[tracking setup, conversion goals, dashboards]

# Social
[connected accounts, scheduling tools, content templates]

# Advertising
[ad accounts, pixel installation, audience setup]
```

## Alternatives Considered

| In Use | Alternative | When to Consider Switching |
|--------|-------------|---------------------------|
| [current tool] | [other option] | [conditions where alternative fits better] |
| [current tool] | [other option] | [conditions where alternative fits better] |

## What to Avoid

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| [tool or practice] | [specific problem: expensive, poor integration, data lock-in] | [recommended alternative] |
| [tool or practice] | [specific problem] | [recommended alternative] |

## Channel Strategy Decisions

**If content-led growth:**
- [Content hub structure and publishing cadence]
- [SEO strategy and keyword targeting approach]
- [Content distribution and repurposing plan]

**If product-led growth:**
- [Onboarding email sequences and in-app messaging]
- [Freemium/trial conversion optimization]
- [Community and user-generated content strategy]

**If sales-led growth:**
- [Sales enablement content and collateral]
- [Account-based marketing approach]
- [Lead scoring and nurture sequences]

**If multi-channel:**
- [Channel priorities and resource allocation]
- [Cross-channel attribution model]
- [Content repurposing workflow across channels]

## Platform Compatibility

| Tool | Integrates With | Notes |
|------|-----------------|-------|
| [tool @ plan] | [other tools] | [integration quality, limitations] |
| [tool @ plan] | [other tools] | [known constraints] |

## Configuration Files Discovered

| File/Location | Purpose | Notable Settings |
|---------------|---------|-----------------|
| [config location] | [what it configures] | [any non-default values worth noting] |
| [config location] | [what it configures] | [any non-default values worth noting] |

## Sources

- [Website and marketing asset inspection] — [primary source of tool discovery]
- [Platform documentation] — [what was verified]
- [Official docs URL] — [what was verified]
- [Other source] — [confidence level]

---
*Marketing stack research for: [project name]*
*Researched: [date]*
```

</template>

<guidelines>

**Discovery, Not Prescription:**
- This template is for discovering what the project ACTUALLY uses for marketing
- Fill in values by inspecting the website, email headers, tracking codes, and marketing assets
- Do not assume or recommend — report what is found
- If a category has nothing discovered, mark it `[none found]` rather than suggesting additions

**Core Platforms:**
- Always check the website source for CMS indicators, analytics tags, and tracking pixels
- Check email headers for ESP identification
- Look for chat widgets, form providers, and third-party integrations embedded on the site

**Marketing Type:**
- Determine if the business is B2B or B2C from pricing pages, messaging, and target audience
- Look for product-led signals (free trial, self-serve signup) vs. sales-led (demo request, contact sales)
- Check blog volume and content library for content marketing maturity

**Content Channels:**
- Check for active blog with recent posts and consistent publishing cadence
- Look for email signup forms and identify the email service provider
- Check social media profile links and activity levels
- Look for video content, podcast mentions, or resource libraries

**Paid Advertising:**
- Check ad transparency tools (Google Ads Transparency, Meta Ad Library) for active campaigns
- Look for tracking pixels and UTM parameter patterns in URLs
- Check for retargeting pixels (Meta Pixel, LinkedIn Insight Tag, etc.)

**What to Avoid:**
- Flag tools that are redundant or create data silos
- Note platforms with poor integration support for the existing stack
- Identify tools that may cause vendor lock-in or data portability issues
- Flag any tools with known deliverability or performance issues

**Tool Inventory:**
- Record plan tiers where discoverable
- Note which tools are actively used vs. installed but dormant
- For important tools, check if they are current or significantly outdated

**Platform Compatibility:**
- Note any tools that do not integrate well with each other
- Flag if migration between tools would be required for planned improvements
- Check if API access is available on current plan tiers

</guidelines>
</output>
