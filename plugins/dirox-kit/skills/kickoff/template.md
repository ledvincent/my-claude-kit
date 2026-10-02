---
jira: {{ID}}
title: {{TITLE}}
type: kickoff
owner: {{OWNER}}
approvals:        # written by a person, never by Claude: "name, YYYY-MM-DD"
  tech_lead:
  architect:
  pm:
  backlog:        # the PM approves the ticket list
closed:           # date, set by /dirox-kit:kickoff at the end
---
# {{ID}}: {{TITLE}}

<!-- Kickoff plan. Approved by the Tech lead, the Architect and the PM, then turned into the
     foundation files (CLAUDE.md, docs/, ADRs, skeleton specs) and the Jira backlog. -->

## Brief
<!-- Where the client brief is, and a short summary. Do not paste a confidential brief here. -->

## Scope
- In:
- Out:

## Modules
<!-- - name (`folder`): what it does -->

## Routes and APIs
<!-- - METHOD /path: what it does, which module -->

## Connections
<!-- External services, third-party APIs, queues, auth providers -->

## Data model
<!-- Main entities and how they relate -->

## Environments
<!-- local, staging, production: where each runs, how a release goes out -->

## Key decisions
<!-- - Decision: reason. ADR needed -->

## Features
<!-- One line per feature; each gets a skeleton spec in docs/specs/ -->

## Open questions

## Backlog
<!-- Written after the plan is approved. -->
| # | Title | Size | Depends on | Spec | Jira |
|---|---|---|---|---|---|

## Review
<!-- Files written, questions still open, follow-ups. -->
