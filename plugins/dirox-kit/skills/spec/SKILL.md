---
name: spec
description: Write the Spec section of a ticket's task file (requirements, rules, acceptance criteria) after the Intent is approved.
argument-hint: <JIRA-ID>
disable-model-invocation: true
---

# Spec: what exactly we will build

Ticket: $ARGUMENTS (if empty, take the ID from the branch name).

1. **Check the gate.** Read `tasks/<ID>.md`. If `approvals: intent:` is empty, stop and ask for the Intent to be approved first. If `type: light`, say no Spec is needed and point to `/dirox-kit:plan`.

2. **Read only what you need:**
   - the task file
   - `docs/index.md`, to find the right files
   - the `docs/specs/` file for the feature this ticket touches (if there is none, say so: one will be created at /done)
   - `docs/architecture.md` only if the ticket crosses modules
   Do not read source code. The Spec describes behaviour, not implementation.

3. **Write the Spec section:**
   - Requirements: what the system must do, numbered.
   - Business rules: limits, permissions, calculations, edge cases.
   - Interfaces: only what this ticket adds or changes (API, UI, data).
   - Error handling: what happens when things go wrong.
   - Acceptance criteria: they come from the Jira ticket, which is their source. Copy each one as `AC-1: Given …, when …, then …`, keeping its meaning; rewording only makes it testable. Never drop one. If the Intent's open questions call for a new criterion or a changed one, mark it `(not in Jira yet)`; the ticket owner adds it to Jira before approving the Spec, so Jira and the task file say the same thing.
   - Living spec changes: which `docs/specs/` file will change and what will change in its behaviour and rules. Acceptance criteria stay in Jira and the task file, not in the living spec. Do not edit that file now; /done applies it.

4. **Keep it short.** Write each fact once. Link to docs instead of copying them.

5. **Stop.** Show the acceptance criteria and anything you had to assume. Ask the person to approve by writing their name and date under `approvals: spec:`. Never fill an approval yourself.
   Next: `/dirox-kit:plan <ID>`.
