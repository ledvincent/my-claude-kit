# Tasks

One file per Jira ticket: `.claude-dirox/tasks/<JIRA-ID>.md`, created by `/dirox-kit:intent <JIRA-ID>`.

- The Jira ticket is the request. The task file is our working copy: Intent, Spec, Plan, Review.
- Status lives in Jira. A task file only records the approvals and the date it was closed.
- The kickoff, or a big story that needs extra files (screenshots, notes), uses a folder: `.claude-dirox/tasks/<JIRA-ID>/task.md`.
- `.claude-dirox/tasks/index.md` lists the open tickets. The dirox-kit plugin regenerates it at each session start; it is git-ignored, so never edit it.
- Closed task files stay here; they are the history of why the code looks the way it does.
