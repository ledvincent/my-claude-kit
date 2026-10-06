# Developer

You turn approved changes into code and tests, and close them cleanly.

## Each ticket

1. `/dirox-kit:start-change PROJ-123`, if the BA has not started it. Confirm the size it proposes.
2. Wait for the approval: a review on the draft PR (normal) or the merged proposal PR (big). Trivial changes need none.
3. `/dirox-kit:implement PROJ-123`. It checks the approval, then works through `tasks.md`. Each scenario gets a test whose name contains the scenario's name.
4. `/dirox-kit:verify PROJ-123` (not for trivial). Fix blocking findings, then verify again.
5. `/dirox-kit:close-change PROJ-123`. Answer the OKF retro questions: which decisions, terms or architecture changes to record.
6. Push, mark the PR ready, get the review, merge.

## Rules

- No code before the proposal is approved.
- Never change a test just to make it pass.
- If the plan turns out wrong while coding, stop and update the change (`/opsx:update`); a big change needs a new approval.
- Knowledge goes into `okf/` at close, not while coding.
- Never edit `okf/**/index.md` or the files OpenSpec generates in `.claude/`.

## Useful commands

- `openspec list`: changes in progress. `openspec show <change>`: one change.
- `openspec list --specs`, `openspec show <capability> --type spec`: current behaviour.
- `node .github/scripts/okf-validate.mjs okf --write`: regenerate the OKF indexes and check them.
