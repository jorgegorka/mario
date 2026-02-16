---
name: Email Campaign
description: Multi-email campaign with sequence planning and goals
variables:
  - campaign_name
  - audience
  - goal
  - num_emails
---

# Email Campaign: {{campaign_name}}

## Campaign Overview
- **Audience:** {{audience}}
- **Goal:** {{goal}}
- **Emails in sequence:** {{num_emails}}

## Email Sequence

### Email 1: [Subject Line]
- **Send timing:** Day 0 (trigger: [signup/purchase/event])
- **Purpose:** [What this email accomplishes]
- **Subject line:** [Primary subject]
- **Preview text:** [Preview text]
- **Body outline:**
  - Opening: [Hook]
  - Main content: [Key message]
  - CTA: [Action and link]
- **Success metric:** [Open rate / click rate target]

### Email 2: [Subject Line]
- **Send timing:** Day [X] after Email 1
- **Purpose:** [What this email accomplishes]
- **Subject line:** [Primary subject]
- **Preview text:** [Preview text]
- **Body outline:**
  - Opening: [Hook]
  - Main content: [Key message]
  - CTA: [Action and link]
- **Success metric:** [Open rate / click rate target]

[Repeat for remaining emails...]

## Campaign Settings
- **From name:** [Sender name]
- **From email:** [Sender email]
- **Reply-to:** [Reply address]
- **List/segment:** [Target segment]
- **Suppression:** [Who to exclude]

## A/B Testing Plan
- **Test element:** [Subject line / send time / CTA]
- **Variants:** [A vs B description]
- **Sample size:** [Percentage]
- **Winner criteria:** [Metric and threshold]

## Compliance
- [ ] Unsubscribe link included in all emails
- [ ] Physical address in footer
- [ ] CAN-SPAM / GDPR compliant
- [ ] Opt-in confirmed for all recipients
