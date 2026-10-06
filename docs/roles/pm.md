# Project manager

You own the scope, the backlog and the client relationship. Status lives in Jira.

## At kickoff

1. Create the kickoff ticket in Jira (for example `PROJ-1`, an epic) and share the client brief with the Tech lead.
2. The Tech lead runs `/dirox-kit:kickoff PROJ-1`. Review the kickoff PR with the Tech lead and the Architect: scope in and out, open questions, and the proposed backlog (one row per ticket, with its size and dependencies) in the kickoff `proposal.md`.
3. Approve the PR. The backlog becomes Jira tickets: you create them, or the kickoff does if you ask and Jira is connected.

## During the project

- Tickets move in Jira as usual. The repo shows the detail:
  - changes in progress: `openspec/changes/`, or `openspec list`
  - done work: `openspec/changes/archive/`, dated
  - decisions: `okf/decisions/`
- Each change's PR description lists its scenarios and tests and the knowledge it added.
- Big changes need a separate approved proposal before any code. Plan for that review in the sprint.

## Handover

The client receives the project with its current behaviour in `openspec/specs/`, its knowledge in `okf/` (start at `okf/index.md`), and the history of every change in `openspec/changes/archive/`. A `/dirox-kit:handover` command that writes the summary is planned after v1, along with `/dirox-kit:status`.
