# Business analyst

You make sure each change describes the right behaviour, and that the domain is written down.

## Each ticket

1. Write the Jira ticket with testable acceptance criteria.
2. Run `/dirox-kit:start-change PROJ-123` (or pair with the developer). Answer the questions it raises; it uses OpenSpec explore when the ticket is unclear.
3. Review the proposal PR:
   - `proposal.md`: is the Why right, and is the scope (in and out) right?
   - `specs/**/spec.md`: does every acceptance criterion appear as a scenario, with its meaning kept? Are the WHEN/THEN outcomes what the client expects?
   - "Not in Jira yet": add those scenarios to the Jira ticket before you approve, so Jira and the spec agree.
4. Approve the PR in GitHub (normal change), or approve the proposal PR with the Architect (big change).

## Knowledge you own

- `okf/domain/`: one file per business term (`type: Glossary Term`). Keep definitions in the business's words.
- Set yourself as `owner` of the terms you define. When you have checked a concept, add `verified: [{by: "human:<your-github-user>", at: YYYY-MM-DD}]`.

## What you do not do

- Approve your own proposal if you wrote it: ask the Architect.
- Write behaviour into `okf/` or definitions into specs: behaviour goes in `openspec/`, meaning goes in `okf/`.
