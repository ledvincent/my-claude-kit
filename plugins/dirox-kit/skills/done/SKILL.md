---
name: done
description: Finish a ticket. Checks the tests and each acceptance criterion (using /verify's result for full tickets), updates the living docs, records decisions and writes the Review.
argument-hint: <JIRA-ID>
disable-model-invocation: true
---

# Done: check, document, close

Ticket: $ARGUMENTS (if empty, take the ID from the branch name).

Base branch: `git symbolic-ref --short refs/remotes/origin/HEAD` without the `origin/` prefix, or `main` if that fails.

1. **Check the verification (full tickets).** Read the `### Verification` subsection of the task file.
   - Missing, or it has blocking findings: stop and ask the user to run `/dirox-kit:verify <ID>` (again).
   - Its `Verified:` commit equals `git rev-parse --short HEAD` and the working tree is clean: the tests already passed on this code. Reuse its AC table and skip steps 2 and 3.
   - The code changed since: continue with steps 2 and 3.

2. **Run the tests** with the test command from CLAUDE.md. If any fail, fix them or stop and report. Do not close a ticket with failing tests.

3. **Check the work against the task file:**
   - Each acceptance criterion: make a table `AC | proven by | OK?`. Use a test name, or a manual check if there is no test.
   - Files changed (`git diff --name-only <base>...HEAD`) compared with the Plan's Files to change. List any extra files and why they changed.
   - Light ticket: there is no Spec, so check against the Jira ticket's acceptance criteria (if it has any), the Intent and the Plan.

4. **Update the living docs** in the same branch:
   - Apply the Spec's "Living spec changes" to the `docs/specs/` file. Create the file from `docs/specs/_template.md` if it does not exist.
   - Update `docs/architecture.md` (or `docs/modules.md` if it exists) if modules, data flow or deployment changed.
   - Add a line to `docs/index.md` for every doc file you create.
   - If no doc needs changing, write `No doc change: <reason>` in the Review.

5. **Record decisions.** For each Plan decision marked "ADR needed", create `docs/adr/NNN-short-title.md` from `docs/adr/000-template.md`, using the next free number. Never edit the content of an existing ADR. Only its Status line may change, for example to "Superseded by 007".

6. **Write the Review section** above `### Verification`:
   - what was done, in 2–3 lines
   - the AC table
   - docs updated and ADRs created
   - follow-ups: work found but not done. List them as suggested Jira tickets; do not create them.

7. **Close.** Set `closed:` to today's date. Suggest a commit message and a PR description that start with the Jira ID. Do not push, merge or move the Jira ticket unless the user asks.
