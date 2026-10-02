---
jira: {{ID}}
title: {{TITLE}}
type: full        # full = intent, spec, plan, verify, done · light = intent, plan, done (small fix, no behaviour change)
parent:           # parent Jira ID if this ticket belongs to a bigger one
owner: {{OWNER}}
approvals:        # written by a person, never by Claude: "name, YYYY-MM-DD"
  intent:
  spec:
  plan:
closed:           # date, set by /dirox-kit:done
---
# {{ID}}: {{TITLE}}

<!-- The Jira ticket is the request. This file is our working copy: what we understood,
     what we will build, how, and what we checked. Status lives in Jira, not here. -->

## Intent
<!-- Written by /dirox-kit:intent from the Jira ticket. Short. -->
- Problem:
- Why it matters:
- Out of scope:
- Open questions:

## Spec
<!-- Written by /dirox-kit:spec after the Intent is approved. Skipped for light tickets. -->
### Requirements
### Business rules
### Interfaces
<!-- API, UI, data: only what this ticket adds or changes -->
### Error handling
### Acceptance criteria
<!-- From the Jira ticket, made testable: AC-1: Given …, when …, then …
     A criterion not in Jira yet is marked "(not in Jira yet)" and added there before approval. -->
### Living spec changes
<!-- Which .claude-dirox/docs/specs/ file changes, and how. Applied by /dirox-kit:done. -->

## Plan
<!-- Written by /dirox-kit:plan after the Spec is approved. -->
### Files to change
<!-- - `path/to/file` — why -->
### Order of work
### Proof
<!-- Which test proves which AC -->
### Risks
### Decisions
<!-- Anything costly to reverse → needs an ADR at /dirox-kit:done -->

## Review
<!-- Written by /dirox-kit:done. -->
### Verification
<!-- Written by /dirox-kit:verify (full tickets only). -->
