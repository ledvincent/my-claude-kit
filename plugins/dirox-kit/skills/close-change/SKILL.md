---
name: close-change
description: Finish a change. Checks the verification and the tests, runs the OKF retro (new or outdated knowledge goes into okf/ in the same PR), validates okf/ and openspec/, archives the OpenSpec change (which updates the main specs) and prepares the PR description.
argument-hint: <JIRA-ID>
disable-model-invocation: true
---

# Close a change

Ticket: $ARGUMENTS (if empty, take the ID from the branch name).

Base branch: `git symbolic-ref --short refs/remotes/origin/HEAD` without the `origin/` prefix, or `main` if that fails.

1. **Find the change** in `openspec/changes/` (not `archive/`): the folder starting with the ticket ID in lowercase followed by `-`. None: a trivial change; skip steps 2 and 6.

2. **Check the verification.** Read `openspec/changes/<name>/verification.md`.
   - Missing, or it lists blocking findings: stop and ask for `/dirox-kit:verify <ID>` (again).
   - Its `Verified:` commit equals `git rev-parse --short HEAD` and the working tree is clean: the tests already passed on this code. Reuse its scenario table and skip step 3.
   - The code changed since: continue with step 3, and suggest running `/dirox-kit:verify <ID>` again if the change was more than a small fix.

3. **Run the tests** with the test command from `CLAUDE.md`. If any fail, fix them or stop and report. Never close a change with failing tests.

4. **Check the scope.** Compare `git diff --name-only <base>...HEAD` with what `tasks.md` and `design.md` planned (for a trivial change, with the ticket). List extra files and why they changed. All tasks in `tasks.md` must be ticked, or the person agrees to drop the rest.

5. **OKF retro.** Follow the retro in the `okf` skill: list the knowledge this change adds or makes outdated (decisions marked "Decision record needed" in `design.md`, new domain terms, architecture, data, integrations, runbooks), ask which to write, write them, add the `okf/log.md` line, then run `node "${CLAUDE_PLUGIN_ROOT}/scripts/okf-validate.mjs" okf --write`. Fix every error. Nothing to write: note `No OKF change: <reason>`.

6. **Archive the change.** Use the `openspec-archive-change` skill (the same as `/opsx:archive`) for `<name>`. It merges the change's delta specs into `openspec/specs/` and moves the folder to `openspec/changes/archive/`. Then run `openspec validate --all --strict --no-interactive` and fix what it reports.

7. **Check both validators pass** one last time: `openspec validate --all --strict --no-interactive` and `node .github/scripts/okf-validate.mjs okf`. These are what CI runs.

8. **Prepare the PR.** Suggest a commit message starting with the Jira ID, and fill the PR description from `.github/pull_request_template.md`: the change, the scenario → test table, the OKF changes (or `No OKF change: <reason>`), follow-ups found but not done (as suggested Jira tickets; do not create them). For a normal change, the draft PR becomes ready for review.

9. **Stop.** Do not push, merge, mark the PR ready or move the Jira ticket unless the person asks.
