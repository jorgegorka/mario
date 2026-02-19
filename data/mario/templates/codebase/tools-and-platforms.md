# Tools and Platforms Template

Template for `.mario_planning/codebase/TOOLS-AND-PLATFORMS.md` - captures the marketing technology stack.

**Purpose:** Document what tools and platforms power the marketing operation. Focused on "what do we use to execute marketing?"

---

## File Template

```markdown
# Tools and Platforms

**Audit Date:** [YYYY-MM-DD]

## CRM

**Primary:**
- [Tool]: [Purpose, plan/tier, key features used]
- Users: [Who uses it, how many seats]
- Data: [What's tracked: contacts, deals, companies, custom fields]

## Email Platform

**Primary:**
- [Tool]: [Purpose, plan/tier]
- List size: [Approximate subscriber count]
- Sequences: [Number of active automated sequences]
- Segmentation: [How lists are segmented]
- Integration: [Connected to CRM, website forms, etc.]

## Social Media

**Management:**
- [Tool]: [Purpose: scheduling, analytics, inbox management]
- Platforms managed: [Which social accounts]

**Platform-Specific:**
- [Platform]: [Account type: business/creator, follower count range]

## Analytics

**Web Analytics:**
- [Tool]: [Purpose, configuration notes]
- Key events: [What's tracked as conversions]

**Attribution:**
- [Tool or approach]: [How conversions are attributed to channels]

**Reporting:**
- [Tool]: [Purpose, who uses it, frequency]

## CMS

**Primary:**
- [Tool]: [Purpose, hosting, theme/framework]
- Content types: [Blog, landing pages, product pages, etc.]
- Editor access: [Who can publish, approval workflow]

## Advertising

**Platforms:**
- [Platform]: [Campaign types, approximate monthly spend]
- [Platform]: [Campaign types, approximate monthly spend]

**Management:**
- [Tool if any]: [Purpose: bid management, reporting, creative testing]

## SEO Tools

**Primary:**
- [Tool]: [Purpose: keyword research, rank tracking, site audit]

**Secondary:**
- [Tool]: [Purpose: backlink analysis, competitor research]

**Technical:**
- [Tool]: [Purpose: crawling, indexing, speed testing]

## Other Tools

**Design:**
- [Tool]: [Purpose: graphics, templates, brand assets]

**Project Management:**
- [Tool]: [Purpose: content calendar, task tracking, team coordination]

**Collaboration:**
- [Tool]: [Purpose: content drafting, feedback, approvals]

**Other:**
- [Tool]: [Purpose]

---

*Tools audit: [date]*
*Update after adding or removing tools*
```

<good_examples>
```markdown
# Tools and Platforms

**Audit Date:** 2025-06-15

## CRM

**Primary:**
- HubSpot CRM (Free tier): Contact management, deal pipeline, basic reporting
- Users: Marketing team (3), Sales (2)
- Data: Contacts with lifecycle stage, lead source, company, custom properties for industry and company size
- Integration: Connected to website forms, email platform, and ad platforms

## Email Platform

**Primary:**
- ConvertKit (Creator Pro): Email marketing and automation
- List size: 12,000 subscribers
- Sequences: 4 active automated sequences (welcome, lead magnet follow-up, trial onboarding, re-engagement)
- Segmentation: By lead magnet downloaded, engagement level, customer status
- Integration: Website signup forms, Zapier connection to HubSpot CRM

## Social Media

**Management:**
- Buffer (Team plan): Scheduling and analytics for LinkedIn, Twitter/X, Instagram
- Platforms managed: LinkedIn company page, founder LinkedIn, Twitter/X, Instagram

**Platform-Specific:**
- LinkedIn: Company page (2,500 followers) + founder profile (8,000 followers)
- Twitter/X: Company account (1,800 followers)
- Instagram: Business account (950 followers)

## Analytics

**Web Analytics:**
- Google Analytics 4: Website traffic, user behavior, conversion tracking
- Key events: newsletter_signup, trial_start, purchase, lead_magnet_download

**Attribution:**
- UTM parameters on all campaign links, first-touch attribution in HubSpot
- Self-reported "How did you hear about us?" on signup form

**Reporting:**
- Google Looker Studio: Monthly marketing dashboard (traffic, leads, conversions)
- HubSpot reports: Pipeline and revenue attribution (weekly review)

## CMS

**Primary:**
- WordPress (self-hosted on WP Engine): Company website and blog
- Content types: Blog posts, landing pages, product pages, documentation
- Editor access: Marketing team publishes directly, guest posts go through editor review
- Theme: Custom theme built on GeneratePress, page builder for landing pages

## Advertising

**Platforms:**
- Google Ads: Search campaigns (branded + non-branded keywords), $3,000/month
- LinkedIn Ads: Sponsored content and lead gen forms, $2,000/month
- Google Display Network: Retargeting campaigns, $500/month

**Management:**
- Manual management in native platforms (no third-party bid management tool)

## SEO Tools

**Primary:**
- Ahrefs (Standard): Keyword research, rank tracking, content gap analysis, site audit

**Secondary:**
- Google Search Console: Indexing status, search performance, technical issues

**Technical:**
- Google PageSpeed Insights: Core Web Vitals monitoring
- Screaming Frog (free tier): Periodic crawl audits

## Other Tools

**Design:**
- Canva (Pro): Social media graphics, email headers, ad creative
- Figma: Landing page mockups, brand asset management

**Project Management:**
- Notion: Content calendar, editorial workflow, marketing playbooks

**Collaboration:**
- Google Docs: Content drafting and feedback
- Loom: Async video feedback on creative assets

**Other:**
- Zapier (Starter): Automations between ConvertKit, HubSpot, and Slack notifications
- Hotjar (Basic): Heatmaps and session recordings on key landing pages

---

*Tools audit: 2025-06-15*
*Update after adding or removing tools*
```
</good_examples>

<guidelines>
**What belongs in TOOLS-AND-PLATFORMS.md:**
- All marketing tools and platforms currently in use
- Purpose and plan/tier for each tool
- Integration points between tools
- Who uses each tool
- Key configuration notes

**What does NOT belong here:**
- Login credentials or API keys (NEVER include these)
- Channel strategy (that's CHANNEL-ARCHITECTURE.md)
- Performance data (that's PERFORMANCE-METRICS.md)
- Content details (that's CONTENT-INVENTORY.md)
- Detailed tool tutorials or how-to guides

**When filling this template:**
- Inventory all marketing tools by checking browser bookmarks, team subscriptions, and expense reports
- Note the plan/tier for each tool (affects available features)
- Document integration points between tools (CRM <-> email, analytics <-> ads)
- Identify tool overlap (multiple tools doing the same thing)
- Note any tools that are paid but underused
- Check for free tier limitations that constrain marketing efforts

**Useful for marketing planning when:**
- Evaluating whether existing tools support a new campaign type
- Identifying integration gaps between platforms
- Planning tool consolidation or upgrades
- Budgeting for marketing technology spend
- Onboarding new team members to the marketing stack
- Deciding if a new tool is needed vs. using existing capabilities
</guidelines>
