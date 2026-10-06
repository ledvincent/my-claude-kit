# QC

You make sure every promised behaviour is proven.

## Where the test cases come from

Each change's scenarios are the test cases: `openspec/changes/<change>/specs/**/spec.md`, in WHEN/THEN form. Once the change is closed, they live in `openspec/specs/<capability>/spec.md`. The `Proof` group at the end of `tasks.md` names the automated test for each scenario.

## Each change

1. Review the scenarios in the proposal PR: missing edge cases, untestable outcomes, error cases. Ask for them before approval; they are much cheaper before code.
2. After the build, run `/dirox-kit:verify PROJ-123` (or read the `verification.md` the developer recorded). A read-only agent, in a fresh context, checks that each scenario has a test that really asserts it, that the tests pass, and that nothing outside the plan changed.
3. Blocking findings go back to the developer. For scenarios with no automated test, the report says which manual check would prove them: run those.
4. In the final PR, check the "Scenarios and tests" table of the PR description.

## Useful commands

- `openspec show <capability> --type spec`: the current behaviour of a capability, with its scenarios.
- `openspec list`: changes in progress.

A dedicated `/dirox-kit:test-plan` command is planned after v1.
