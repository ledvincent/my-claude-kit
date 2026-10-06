---
name: verify
description: Check a change's code against its OpenSpec specs, in a fresh context, with the read-only verifier agent - every scenario mapped to a test that really asserts it - before closing the change.
argument-hint: <JIRA-ID>
disable-model-invocation: true
---

# Verify a change in a fresh context

Ticket: $ARGUMENTS (if empty, take the ID from the branch name).

1. **Find the change** in `openspec/changes/` (not `archive/`): the folder starting with the ticket ID in lowercase followed by `-`. None: it is a trivial change, which has no Verify stage. Say so and point to `/dirox-kit:close-change <ID>`.

2. **Check there is something to verify.** Base branch: `git symbolic-ref --short refs/remotes/origin/HEAD` without the `origin/` prefix, or `main` if that fails. If `git diff --name-only <base>...HEAD` is empty and `git status --short` shows nothing, stop: nothing is built yet.

3. **Run the verifier agent.** Start the `dirox-kit:verifier` agent with this prompt and nothing more, so it judges the code without your context:
   `Verify change <name>. Change folder: openspec/changes/<name>/. Base branch: <base>.`

4. **Record the result** in `openspec/changes/<name>/verification.md` (replace it if it exists):
   - first line exactly `Verified: <today's date> at <git rev-parse --short HEAD>`, plus ` (uncommitted changes)` if the working tree was not clean. `/dirox-kit:close-change` and the session-start hook read this line.
   - the agent's report as it came back.
   The file is archived with the change, so it stays as the record of what was checked.

5. **Stop.** Show the findings.
   - Blocking findings: propose a fix for each and ask before making it. Never change a test just to make it pass. Run `/dirox-kit:verify <ID>` again after fixing.
   - No blocking findings: next is `/dirox-kit:close-change <ID>`.
