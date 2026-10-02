---
name: plan
description: Write the Plan section of a ticket's task file (files to change, order, tests, risks) after the Spec is approved.
argument-hint: <JIRA-ID>
disable-model-invocation: true
---

# Plan: how we will build it

Ticket: $ARGUMENTS (if empty, take the ID from the branch name).

1. **Check the gate.** Read `tasks/<ID>.md`.
   - Full ticket: `approvals: spec:` must be filled.
   - Light ticket: `approvals: intent:` must be filled.
   If not, stop and ask for the approval first.

2. **Find the code, narrowly.** Start from `docs/index.md`. Use `docs/architecture.md` (and `docs/tech-stack.md` or `docs/modules.md` if they exist) to find the right modules, and read the ADRs in that area. Then search (Grep or Glob) for the specific names you need and read only those files. Never read the whole of `src/`.

3. **Write the Plan section:**
   - Files to change: one line each, `` `path/to/file` — why ``. Include the test files.
   - Order of work: small steps, each one leaving the code working and testable.
   - Proof: which test proves which acceptance criterion (AC-1 → `test name`).
   - Risks: what could break, and what else uses this code.
   - Decisions: choices that would be costly to reverse (framework, data model, security, hosting). Mark them "ADR needed".

4. **Check for overlap.** Look at the other task files in `tasks/` that have no `closed:` date. If any of them lists the same paths under Files to change, warn the user and name the ticket and its owner so they can coordinate. (The plugin's session-start hook also lists overlaps in `tasks/index.md`, but only for plans written before the session started.)

5. **Stop.** Show the plan. Ask the person to approve by writing their name and date under `approvals: plan:`, then to run `/dirox-kit:plan <ID>` again to start the build. Never fill an approval yourself.

6. **Build (only when `approvals: plan:` is already filled when this skill starts).** Skip steps 2 to 5. Follow the Plan step by step and run the tests as you go. If the Plan needs to change, update the Plan section first and tell the user why. When the build is finished: `/dirox-kit:verify <ID>` for a full ticket, `/dirox-kit:done <ID>` for a light one.
