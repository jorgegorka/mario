# Content Architecture Research Template

Template for `.planning/research/ARCHITECTURE.md` — marketing content architecture discovery for the project.

<template>

```markdown
# Content Architecture Research

**Project:** [project name]
**Industry:** [industry vertical]
**Primary Channels:** [channels in scope]
**Researched:** [date]
**Confidence:** [HIGH/MEDIUM/LOW]

## Marketing Presence Overview

### Content & Channel Structure

```
┌─────────────────────────────────────────────────────────────┐
│                      Strategy Layer                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │Positioning│  │ Personas │  │Messaging │  │Brand Voice│   │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘   │
│       │              │             │              │         │
├───────┴──────────────┴─────────────┴──────────────┴─────────┤
│                      Content Layer                           │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ Web Copy │  │  Blog    │  │  Email   │  │ Social   │   │
│  └────┬─────┘  └──────────┘  └──────────┘  └──────────┘   │
│       │                                                     │
├───────┴─────────────────────────────────────────────────────┤
│                    Distribution Layer                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │   SEO    │  │ Paid Ads │  │Automation│  │ Organic  │   │
│  └────┬─────┘  └──────────┘  └──────────┘  └──────────┘   │
│       │                                                     │
├───────┴─────────────────────────────────────────────────────┤
│                    Measurement Layer                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                  │
│  │Analytics │  │Attribution│  │Reporting │                  │
│  └──────────┘  └──────────┘  └──────────┘                  │
└─────────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

| Layer | Responsibility | Discovered Implementation |
|-------|----------------|---------------------------|
| Strategy | [positioning, personas, messaging, brand voice] | [what this project does] |
| Content | [web copy, blog, email, social media content] | [what this project does] |
| Distribution | [SEO, paid ads, automation, organic channels] | [what this project does] |
| Measurement | [analytics, attribution, reporting] | [what this project does] |

## Content Structure

```
content/
├── strategy/              # Brand and positioning documents
│   └── [organization discovered]
├── web/                   # Website pages and landing pages
│   ├── pages/             # [page structure discovered]
│   └── landing/           # [landing page organization discovered]
├── blog/                  # Blog posts and articles
│   └── [category organization discovered]
├── email/                 # Email sequences and campaigns
│   ├── sequences/         # [automated sequences discovered]
│   └── campaigns/         # [one-time campaigns discovered]
├── social/                # Social media content
│   └── [platform organization discovered]
├── ads/                   # Advertising copy and creative
│   └── [campaign structure discovered]
├── assets/                # Shared assets
│   ├── images/            # [image organization discovered]
│   ├── templates/         # [template organization discovered]
│   └── brand/             # [brand assets discovered]
```

### Structure Notes

- **Taxonomy:** [how content is categorized — by channel, by topic, by audience, by funnel stage]
- **Naming conventions:** [file naming patterns, URL slug patterns]
- **Reuse patterns:** [how content is repurposed across channels]
- **Version control:** [how content drafts and revisions are managed]

## Content Patterns Discovered

### Messaging Architecture

**Observed approach:** [centralized messaging doc / per-channel messaging / ad hoc / none]
**Where messaging lives:** [description of what was found]

**Example from project:**
```
[Brief example showing the project's actual messaging pattern]
```

### Content Production Workflow

**Observed approach:** [structured editorial process / informal / reactive]
**Workflow stages:** [ideation, briefing, creation, review, publishing, distribution]

### Audience Segmentation

**Approach:** [single audience / persona-based / segment-based / none]
**Segmentation criteria:** [demographics, behavior, firmographics, etc.]

**Example from project:**
```
[Brief example showing audience segmentation approach]
```

### Brand Voice Implementation

**Documentation:** [formal voice guide / informal reference / no documentation]
**Consistency:** [consistent across channels / varies by channel / inconsistent]
**Tone variation:** [documented per context / informal / no variation rules]

### Content Calendar & Planning

**Planning horizon:** [weekly / monthly / quarterly / annual / none]
**Calendar tool:** [Notion / Trello / spreadsheet / none]
**Content mix:** [how different content types are balanced in the calendar]

## Content Flow

### Buyer Journey Content Flow

```
Awareness
    ↓
Blog posts, social content, SEO → [content types and channels]
    ↓
Consideration
    ↓
Case studies, comparison pages, webinars → [content types]
    ↓
Decision
    ↓
Pricing page, demo, free trial, testimonials → [conversion content]
    ↓
Retention
    ↓
Onboarding emails, product updates, community → [retention content]
```

### Email Automation Flow

```
Signup / Lead Capture
    ↓
Welcome Sequence → [number of emails, timing]
    ↓
Nurture Sequence → [topic progression, segmentation]
    ↓
Conversion Trigger → [trial signup, demo request, purchase]
    ↓
Onboarding Sequence → [activation steps, success milestones]
```

### Content Repurposing Flow

```
Pillar Content (long-form blog / guide)
    ↓
Social posts (key quotes, statistics, insights)
    ↓
Email content (summary, key takeaways)
    ↓
Ad creative (headline variations, proof points)
    ↓
Slide deck / webinar material
```

### Key Content Flows

1. **[Flow name]:** [description of how content moves through channels]
2. **[Flow name]:** [description of content production and distribution]

## State & Asset Management

### Content Assets

| Asset Type | Storage Location | Management Approach |
|-----------|------------------|---------------------|
| Written content | [CMS, Google Docs, Notion, etc.] | [how drafts and finals are managed] |
| Visual assets | [Figma, Canva, Google Drive, etc.] | [how design files are organized] |
| Email templates | [ESP, HTML files, etc.] | [how templates are maintained] |
| Brand assets | [brand kit location] | [how brand guidelines are enforced] |
| Analytics data | [Google Analytics, platform dashboards] | [how data is reported and shared] |

### Channel-Specific State

| Channel | Current State | Key Metrics Tracked |
|---------|---------------|---------------------|
| Website | [page count, traffic level, conversion rate] | [what is measured] |
| Blog | [post count, publishing frequency, traffic] | [what is measured] |
| Email | [list size, sequence count, engagement rates] | [what is measured] |
| Social | [follower counts, posting frequency, engagement] | [what is measured] |
| Ads | [active campaigns, budget, ROAS] | [what is measured] |

## Scaling Considerations

| Area | Current Approach | Scaling Path |
|------|------------------|--------------|
| Content production | [volume, frequency, team size] | [editorial team, freelancers, AI assistance] |
| Channel management | [manual, tools, automation level] | [scheduling, automation, multi-channel tools] |
| Audience growth | [organic, paid, referral mix] | [channel expansion, partnership, community] |
| Measurement | [basic analytics, platform dashboards] | [attribution model, unified dashboard, data warehouse] |
| Personalization | [none, basic segments, dynamic content] | [behavioral targeting, AI personalization] |

### Content Production Capacity

- **Current throughput:** [pieces per week/month by channel]
- **Bottleneck:** [what limits production — writing, design, review, publishing]
- **Quality control:** [review process, brand compliance checks]
- **Repurposing efficiency:** [how much new vs. repurposed content]

### Distribution Capacity

- **Organic reach:** [current organic traffic and social reach]
- **Paid amplification:** [ad budget allocation and efficiency]
- **Email reach:** [list size, deliverability, engagement rates]
- **Partnership/earned:** [guest posts, PR, co-marketing]

## Anti-Patterns to Watch For

### Anti-Pattern 1: Content Silos

**What it looks like:** [each channel operates independently with no shared strategy]
**Why it is a problem:** [inconsistent messaging, duplicated effort, missed cross-promotion]
**This project's approach:** [what was discovered about cross-channel coordination]

### Anti-Pattern 2: Vanity Metrics Focus

**What it looks like:** [tracking likes, impressions, page views without connecting to business outcomes]
**Why it is a problem:** [no visibility into ROI, can't optimize for what matters, budget justification difficult]
**This project's approach:** [what was discovered about metric selection and reporting]

### Anti-Pattern 3: Campaign-Only Thinking

**What it looks like:** [all content is campaign-based with no evergreen or foundational content]
**Why it is a problem:** [constant content treadmill, no compounding SEO value, no content library to repurpose]
**This project's approach:** [how evergreen vs. campaign content is balanced]

### Anti-Pattern 4: No Content Audit or Refresh Process

**What it looks like:** [old content accumulates without review, outdated information stays published]
**Why it is a problem:** [search engine penalty for stale content, brand credibility risk, user confusion]
**This project's approach:** [content maintenance and refresh cadence discovered]

### Anti-Pattern 5: Channel Sprawl Without Depth

**What it looks like:** [presence on many channels but none done well]
**Why it is a problem:** [resources spread thin, no channel mastery, poor results everywhere]
**This project's approach:** [channel prioritization and focus discovered]

## Integration Points

### Cross-Channel Integrations

| Integration | Usage Discovered | Notes |
|-------------|------------------|-------|
| Website + Email | [form connections, lead capture, automation triggers] | [tools used] |
| Email + CRM | [contact sync, segmentation, lifecycle tracking] | [integration method] |
| Social + Content | [sharing automation, scheduling, repurposing workflow] | [tools used] |
| Ads + Analytics | [conversion tracking, audience sync, attribution] | [integration method] |
| SEO + Content | [keyword research, content optimization, rank tracking] | [tools used] |

### External Platform Integrations

| Platform | Integration Pattern | Notes |
|----------|---------------------|-------|
| [platform] | [API, widget, embed, manual] | [data flow, automation level] |
| [platform] | [integration method] | [notes] |

### Internal Content Boundaries

| Boundary | Communication | Notes |
|----------|---------------|-------|
| [Strategy ↔ Content creation] | [briefs, guidelines, reviews] | [handoff quality] |
| [Content ↔ Distribution] | [publishing workflow, scheduling] | [automation level] |

## Sources

- [Marketing assets and content inventory reviewed]
- [Analytics and performance data examined]
- [Marketing tools and platform configurations inspected]

---
*Content architecture research for: [project name]*
*Channels: [primary channels]*
*Researched: [date]*
```

</template>

<guidelines>

**Marketing Presence Overview:**
- Use ASCII box-drawing diagrams to show content layers and their relationships
- Discover which channels the project actively uses — not every business uses all channels
- Map the actual content architecture as implemented, not the ideal version

**Content Structure:**
- Start with the actual organization of content assets, then note gaps
- Pay attention to how strategy documents connect to channel-specific content
- Check for content taxonomies, tagging systems, and naming conventions
- Note where content is stored and how it is managed across tools

**Content Patterns:**
- Discover, do not prescribe — the project may have formal editorial processes or ad hoc creation
- Check for documented brand voice, messaging hierarchy, and audience segmentation
- Look at content calendar tools and planning processes
- Note content production workflow stages and team involvement

**Content Flow:**
- Trace the full buyer journey from awareness through retention
- Document email automation sequences and trigger logic
- Note content repurposing patterns — how pillar content becomes channel-specific content

**State & Asset Management:**
- Focus on where content assets live and how they are organized
- Document channel-specific metrics and performance tracking
- Note the tools used for each type of content management

**Scaling:**
- Focus on marketing-specific bottlenecks: content production capacity, distribution reach, measurement maturity
- Document the current and planned approach to content scaling
- Note team capacity and workflow efficiency

**Anti-Patterns:**
- Focus on marketing-specific anti-patterns discovered in the project
- Content silos, vanity metrics, campaign-only thinking, stale content, channel sprawl
- Note what protective measures exist (editorial calendar, review process, content audits)

**Integration Points:**
- Document which cross-channel integrations are active (website + email, social + content, etc.)
- Note external platform integration patterns and automation levels
- Look for gaps where manual processes could be automated

</guidelines>
</output>
