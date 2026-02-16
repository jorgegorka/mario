# Content Inventory Template

Template for `.planning/codebase/CONTENT-INVENTORY.md` - maps existing marketing content and assets.

**Purpose:** Document what marketing content exists, where it lives, and how it's organized. Answers "what content do we have and where is it?"

---

## File Template

```markdown
# Content Inventory

**Audit Date:** [YYYY-MM-DD]

## Website Pages

**Core Pages:**
- [Page]: [URL path, purpose, current performance notes]
- [Page]: [URL path, purpose, notes]

**Product/Service Pages:**
- [Page]: [URL path, purpose, key messaging]
- [Page]: [URL path, purpose, key messaging]

**Landing Pages:**
- [Page]: [URL path, campaign/purpose, conversion rate if known]
- [Page]: [URL path, purpose, notes]

**Legal/Utility:**
- [Page]: [URL path]

## Blog/Content

**Content Categories:**
- [Category]: [Number of posts, description, example topics]
- [Category]: [Number of posts, description]

**Top Performing Content:**
- [Title]: [URL, monthly traffic or key metric, primary keyword]
- [Title]: [URL, traffic, keyword]
- [Title]: [URL, traffic, keyword]

**Content Needing Attention:**
- [Title or batch]: [Issue: outdated, thin, broken links, etc.]
- [Title or batch]: [Issue]

**Publishing Cadence:**
- [e.g., "2-3 posts per week, published Tuesday/Thursday/Saturday mornings"]

## Email Sequences

**Automated Sequences:**
- [Sequence name]: [Trigger, number of emails, goal, current performance]
- [Sequence name]: [Trigger, emails, goal, performance]

**Recurring Campaigns:**
- [Campaign type]: [Frequency, audience, purpose]
- [Campaign type]: [Frequency, audience, purpose]

**List Segments:**
- [Segment]: [Size, criteria, primary use]
- [Segment]: [Size, criteria, primary use]

## Social Profiles

**Active Profiles:**
- [Platform] ([handle]): [Follower count, content theme, posting frequency]
- [Platform] ([handle]): [Followers, theme, frequency]

**Dormant/Inactive:**
- [Platform] ([handle]): [Status, last active, reason for dormancy]

## Ad Campaigns

**Active Campaigns:**
- [Platform - Campaign name]: [Objective, targeting, monthly budget, key metrics]
- [Platform - Campaign name]: [Objective, targeting, budget, metrics]

**Recent/Paused Campaigns:**
- [Campaign]: [Why paused, results achieved, potential to restart]

## Downloadable Assets

**Lead Magnets:**
- [Asset name]: [Format, topic, landing page URL, downloads/month]
- [Asset name]: [Format, topic, URL, downloads]

**Sales Collateral:**
- [Asset name]: [Format, purpose, audience]
- [Asset name]: [Format, purpose]

**Other Resources:**
- [Asset name]: [Format, purpose]

## Content Organization

**Taxonomy:**
- [How content is categorized: e.g., "Blog categories: Product, Strategy, Case Studies, Industry News"]
- [Tagging system: e.g., "Tags by topic, audience segment, and funnel stage"]

**Content Calendar:**
- [Where managed: e.g., "Notion board with columns: Idea, Writing, Review, Scheduled, Published"]
- [Planning horizon: e.g., "4 weeks ahead for blog, 2 weeks for social"]

**Asset Storage:**
- [Where files live: e.g., "Google Drive /Marketing/Assets/ for design files"]
- [Image library: e.g., "Canva brand kit for social templates"]
- [Video: e.g., "YouTube channel + raw files on Google Drive"]

---

*Content inventory: [date]*
*Update quarterly or when major content changes occur*
```

<good_examples>
```markdown
# Content Inventory

**Audit Date:** 2025-06-15

## Website Pages

**Core Pages:**
- Homepage: `/` - Main entry point, hero messaging: "Project management that teams actually use". 45,000 monthly visits.
- About: `/about` - Company story, team, mission. 800 monthly visits.
- Pricing: `/pricing` - Three tiers (Starter $12, Pro $29, Agency $49 per seat/month). 8,500 monthly visits, high-intent page.
- Contact: `/contact` - Contact form + support email. 400 monthly visits.

**Product/Service Pages:**
- Features overview: `/features` - Feature grid with screenshots. 3,200 monthly visits.
- Features/Workflows: `/features/workflows` - Deep dive on workflow automation. 1,100 visits.
- Features/Client Portal: `/features/client-portal` - Client-facing project views. 900 visits.
- Features/Time Tracking: `/features/time-tracking` - Built-in time tracking. 750 visits.
- Use Cases/Agencies: `/use-cases/agencies` - Agency-specific landing page. Thin content (180 words). 500 visits.
- Use Cases/Startups: `/use-cases/startups` - Startup-specific landing page. Thin content (150 words). 350 visits.

**Landing Pages:**
- Template Library: `/templates` - Free project templates lead magnet. 2.8% conversion to email signup.
- Comparison/Asana: `/compare/asana` - "TaskFlow vs Asana" comparison. 4.1% conversion to trial.
- Comparison/Monday: `/compare/monday` - "TaskFlow vs Monday.com" comparison. 3.5% conversion to trial.
- Webinar Registration: `/webinar` - Monthly webinar signup page. 12% registration rate.

**Legal/Utility:**
- Privacy Policy: `/privacy`
- Terms of Service: `/terms`
- Cookie Policy: `/cookies`

## Blog/Content

**Content Categories:**
- Project Management (32 posts): Tips, frameworks, and methodologies for managing projects. "How to run a weekly standup that doesn't waste time."
- Agency Life (18 posts): Agency-specific challenges and solutions. "5 client communication templates that save hours."
- Product Updates (12 posts): Feature launches, improvements, roadmap updates. "Introducing Workflow Automations."
- Case Studies (8 posts): Customer stories with metrics. "How Design Studio X reduced project overruns by 40%."
- Industry Trends (6 posts): Market analysis and predictions. "State of Agency Operations in 2025."

**Top Performing Content:**
- "The Complete Guide to Project Scoping": `/blog/project-scoping-guide`, 4,200/month, ranks #3 for "project scoping template"
- "Agency Project Management: The Definitive Guide": `/blog/agency-project-management`, 3,800/month, ranks #5 for "agency project management"
- "Free Project Timeline Template": `/blog/project-timeline-template`, 2,900/month, ranks #2 for "project timeline template"
- "Basecamp vs TaskFlow: Honest Comparison": `/blog/basecamp-vs-taskflow`, 2,100/month, ranks #4 for "basecamp alternatives"
- "How to Calculate Agency Utilization Rate": `/blog/agency-utilization-rate`, 1,800/month, ranks #6 for "agency utilization rate"

**Content Needing Attention:**
- 15 posts from 2023 reference old UI screenshots and deprecated features
- 4 posts with broken outbound links (identified via Ahrefs site audit)
- "Getting Started" series (3 posts) conflicts with current onboarding flow
- 8 posts under 500 words with minimal organic traffic -- candidates for consolidation or expansion

**Publishing Cadence:**
- 2-3 blog posts per week, published Tuesday and Thursday mornings
- 1 case study per month
- Product update posts as needed (approximately 1-2/month)

## Email Sequences

**Automated Sequences:**
- Welcome sequence: Triggered on email signup, 5 emails over 10 days, goal: introduce product and drive trial signup. 42% open rate on email 1, declining to 28% on email 5. 3.5% trial conversion.
- Lead magnet follow-up: Triggered on template download, 3 emails over 7 days, goal: nurture to trial. 38% open rate, 2.1% trial conversion.
- Trial onboarding: Triggered on trial start, 7 emails over 14 days, goal: activate and convert. 55% open rate on day 1, 15% by day 14. Key email: day 3 "Complete your setup" has highest click rate (12%).
- Re-engagement: Triggered after 30 days inactive, 3 emails over 14 days, goal: bring back churned trials. 18% open rate, 1.2% reactivation.

**Recurring Campaigns:**
- Weekly newsletter: Every Thursday, full list (12,000), curated tips + latest blog post. 32% open rate, 4.5% click rate.
- Product updates: Monthly, customers only (750), feature announcements. 45% open rate.
- Webinar invitations: Monthly, full list, upcoming webinar promotion. 25% open rate, 8% registration rate.

**List Segments:**
- Active subscribers (8,400): Opened at least 1 email in last 90 days
- Trial users (500): Currently in 14-day trial
- Customers (750): Paying customers
- Churned trials (2,350): Started trial but didn't convert
- Cold subscribers (1,500): No opens in 90+ days, candidates for re-engagement or cleanup

## Social Profiles

**Active Profiles:**
- LinkedIn Company (@taskflow): 2,500 followers, product tips and industry insights, 3-4 posts/week
- LinkedIn Founder (@sarahchen): 8,000 followers, thought leadership and founder stories, 4-5 posts/week
- Twitter/X (@taskflowapp): 1,800 followers, quick tips and product updates, daily
- Instagram (@taskflow): 950 followers, behind-the-scenes and team culture, 2-3 posts/week

**Dormant/Inactive:**
- Facebook Page: 320 followers, last posted 8 months ago. Deprioritized due to low engagement and audience mismatch.
- TikTok: Account created but no content published. Was planned for Q1 2025 but deprioritized.

## Ad Campaigns

**Active Campaigns:**
- Google Ads - Branded Search: Branded keywords, $500/month, 95% impression share, $3 CPC
- Google Ads - Non-Branded Search: "project management for agencies", "small team PM tool", $2,500/month, $85 CPL
- LinkedIn Ads - Sponsored Content: Agency owner targeting, content promotion, $2,000/month, $45 CPL
- Google Display - Retargeting: Website visitors (last 30 days), $500/month, $22 CPL

**Recent/Paused Campaigns:**
- LinkedIn Lead Gen Forms: Paused after 60-day test. $65 CPL but lead quality was low (2% converted to trial vs. 8% from organic LinkedIn). May revisit with different targeting.
- Product Hunt Launch: One-time, generated 800 signups in 48 hours. #3 Product of the Day. Can leverage for future feature launches.

## Downloadable Assets

**Lead Magnets:**
- Project Scoping Template Pack: PDF, 5 templates for scoping agency projects. `/templates/scoping`, 180 downloads/month.
- Weekly Team Standup Template: Notion template, meeting agenda. `/templates/standup`, 120 downloads/month.
- Agency Utilization Calculator: Google Sheet, capacity planning. `/templates/utilization`, 90 downloads/month.
- Project Management Checklist: PDF, 50-item launch checklist. `/templates/pm-checklist`, 60 downloads/month.

**Sales Collateral:**
- Product one-pager: PDF, overview for decision-makers sharing with team. Used in sales follow-ups.
- ROI calculator: Interactive web page, estimates time savings. Linked from pricing page.
- Customer testimonial compilation: PDF, 8 customer quotes with photos and company names.

**Other Resources:**
- Brand kit: Figma file with logos, colors, fonts, social media templates
- Email signature templates: HTML, standardized team email signatures
- Slide deck template: Google Slides, branded presentation template for webinars

## Content Organization

**Taxonomy:**
- Blog categories: Project Management, Agency Life, Product Updates, Case Studies, Industry Trends
- Tags: By topic (scoping, time-tracking, client-communication), audience (agencies, startups, freelancers), funnel stage (awareness, consideration, decision)

**Content Calendar:**
- Managed in Notion: Columns for Idea Backlog, Outlined, Writing, Review, Scheduled, Published
- Planning horizon: Blog planned 4 weeks ahead, social planned 2 weeks ahead, email planned 1 week ahead
- Monthly content planning meeting with marketing team (first Monday of month)

**Asset Storage:**
- Google Drive: `/Marketing/` - Content drafts, final assets, brand resources
- Google Drive: `/Marketing/Blog/` - Blog post drafts and images by date
- Canva: Brand kit with social templates, ad creative templates, email header templates
- YouTube: Tutorial videos and webinar recordings (12 videos published)
- Notion: Editorial calendar, content briefs, style guide reference

---

*Content inventory: 2025-06-15*
*Update quarterly or when major content changes occur*
```
</good_examples>

<guidelines>
**What belongs in CONTENT-INVENTORY.md:**
- Website pages with purposes and performance notes
- Blog content organized by category with top performers highlighted
- Email sequences (automated and recurring) with performance data
- Social media profiles with follower counts and posting frequency
- Active and paused ad campaigns with budgets and results
- Downloadable assets and lead magnets
- Content organization system (taxonomy, calendar, storage)

**What does NOT belong here:**
- Full content of any asset (just titles, descriptions, and links)
- Detailed analytics (that's PERFORMANCE-METRICS.md)
- Brand voice guidelines (that's BRAND-GUIDELINES.md)
- Tool configurations (that's TOOLS-AND-PLATFORMS.md)
- Strategy or planning decisions (those come during planning)

**When filling this template:**
- Crawl the website to inventory all pages (use site: search or sitemap)
- Check CMS for all published blog posts, categorized by topic
- Review email platform for all active sequences and recurring campaigns
- Check social media profiles for follower counts and posting frequency
- Review ad platform dashboards for active and paused campaigns
- Inventory all downloadable assets (PDFs, templates, tools)
- Document the content calendar and organizational system
- Note content that needs updating, consolidation, or removal
- Include performance data where readily available

**Useful for marketing planning when:**
- Identifying content gaps (what topics or funnel stages lack content?)
- Planning content updates and refreshes
- Repurposing existing content for new channels
- Auditing for outdated or underperforming content
- Onboarding new content creators
- Planning a content consolidation or migration
- Understanding the full scope of existing marketing assets
</guidelines>
