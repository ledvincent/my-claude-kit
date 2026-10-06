---
name: implement
description: Build an approved change. Checks that the proposal was approved (merged proposal PR for a big change, an approving review for a normal one), then runs OpenSpec apply following the project rules in CLAUDE.md. Also builds trivial changes, which have no OpenSpec change.
argument-hint: <JIRA-ID>
disable-model-invocation: true
---

# Implement a change

Ticket: $ARGUMENTS (if empty, take the ID from the branch name).

Base branch: `git symbolic-ref --short refs/remotes/origin/HEAD` without the `origin/` prefix, or `main` if that fails.

1. **Find the change.** Look in `openspec/changes/` (not `archive/`) for the folder starting with the ticket ID in lowercase followed by `-`.
   - **None**: ask whether this is a trivial change (no change in behaviour). If yes, skip to step 4. If not, stop: next is `/dirox-kit:start-change <ID>`.
   - **Found**: read `Size:` at the top of its `proposal.md`.

2. **Check the approval.** The people approve; you only check. Never approve, merge or review a PR yourself.
   - **Big**: run `git fetch origin <base>`, then `git cat-file -e origin/<base>:openspec/changes/<name>/proposal.md`. It must succeed: the proposal PR is merged. If the current branch was made before that merge, suggest updating it from `<base>` first.
   - **Normal**: run `gh pr view --json number,author,reviews,commits`. There must be a review with `state: APPROVED` from someone other than the PR author. If `openspec/changes/<name>/` changed in a commit after that review, the approval is out of date: ask for a new one.
   - `gh` not available: ask the person who approved, and when. Continue only with a clear answer.
   Not approved: stop and say what is missing.

3. **Check the plan is still valid.** `openspec validate "<name>" --strict` must pass. If something about the code makes the plan wrong, stop and suggest updating it with the `openspec-update-change` skill (`/opsx:update`); a big change then needs a new approval.

4. **Build.**
   - With a change: use the `openspec-apply-change` skill (the same as `/opsx:apply`) for `<name>`. It works through `tasks.md` and ticks each task.
   - Trivial: make the change directly. Keep it small.
   In both cases, follow the rules in `CLAUDE.md`:
   - Read narrowly: the files the design and tasks name, and what you find by searching for specific names. Never read the whole codebase.
   - Each scenario gets a test whose name contains the scenario's name, as listed in the Proof tasks.
   - Never change a test just to make it pass. Ask before refactoring outside the change.
   - Run the test command from `CLAUDE.md` as you go.

5. **Stop** when every task is done and the tests pass. Show what changed. Next: `/dirox-kit:verify <ID>`, or `/dirox-kit:close-change <ID>` for a trivial change.
