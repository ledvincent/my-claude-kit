---
name: verify
description: Check a feature ticket's code against its Spec and acceptance criteria with the verifier agent, in a fresh context, before /done.
argument-hint: <JIRA-ID>
disable-model-invocation: true
---

# Verify: check the work in a fresh context

Ticket: $ARGUMENTS (if empty, take the ID from the branch name).

1. **Check the gate.** Read `tasks/<ID>.md`.
   - `approvals: plan:` must be filled. If not, stop.
   - `type: light`: there is no Verify stage. Say so and point to `/dirox-kit:done <ID>`.
   - Find the base branch: `git symbolic-ref --short refs/remotes/origin/HEAD` without the `origin/` prefix, or `main` if that fails. If `git diff --name-only <base>...HEAD` is empty and there are no uncommitted changes, there is nothing to verify: stop.

2. **Run the verifier agent.** Start the `dirox-kit:verifier` agent with this prompt and nothing more, so it judges the code without your context:
   `Verify ticket <ID>. Task file: tasks/<ID>.md. Base branch: <base>.`

3. **Record the result.** In the task file, write or replace the content of the `### Verification` subsection (under `## Review`) with:
   - a first line, exactly `Verified: <today's date> at <git rev-parse --short HEAD>`, plus ` (uncommitted changes)` if the working tree was not clean. The session-start hook and /done read this line.
   - the test result
   - the agent's AC table and scope check
   - its findings, split into blocking and non-blocking

4. **Stop.** Show the findings.
   - Blocking findings: propose a fix for each and ask before making it. Never change a test just to make it pass. After fixing, run `/dirox-kit:verify <ID>` again.
   - No blocking findings: next is `/dirox-kit:done <ID>`.
