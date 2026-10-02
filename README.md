# dirox-claude-kit

The Dirox way of working with Claude Code, packaged as a plugin.
Every developer installs it once; every project gets the same commands, rules and starter files.

## What's inside (v0.2)

| Command | What it does |
|---|---|
| `/dirox-kit:setup-project` | Adds the empty starter files to a repo: CLAUDE.md, .claude/settings.json, docs/, tasks/ |
| `/dirox-kit:kickoff <ID>` | Once per project: plans the system, then writes CLAUDE.md, docs/, the first ADRs, a skeleton spec per feature and the backlog |
| `/dirox-kit:intent <ID>` | Pulls the Jira ticket, creates `tasks/<ID>.md`, writes the Intent |
| `/dirox-kit:spec <ID>` | Writes requirements and acceptance criteria (after the Intent is approved) |
| `/dirox-kit:plan <ID>` | Writes files to change, order, tests and risks (after the Spec is approved); run it again after the Plan is approved to build |
| `/dirox-kit:verify <ID>` | Checks the code against the Spec and each acceptance criterion with the verifier agent, in a fresh context |
| `/dirox-kit:done <ID>` | Checks the tests and criteria, updates the living docs, records ADRs, writes the Review |

Three sizes of ticket:
- Kickoff: `setup-project → kickoff → review → Jira backlog`
- Feature: `intent → spec → plan → build → verify → done`
- Small fix (light): `intent → plan → build → done`

The plugin also ships:
- the `verifier` agent, used by `/dirox-kit:verify`. It is read-only.
- a session-start hook that regenerates `tasks/index.md` (open tickets, their next stage, overlapping plans) and tells Claude which ticket the current branch is on.

```
dirox-claude-kit/
  .claude-plugin/marketplace.json        the catalogue ("dirox")
  plugins/dirox-kit/
    .claude-plugin/plugin.json           the plugin ("dirox-kit")
    skills/
      setup-project/SKILL.md
      kickoff/SKILL.md + template.md     template.md = shape of the kickoff plan (tasks/<ID>/task.md)
      intent/SKILL.md + template.md      template.md = shape of a task file
      spec/SKILL.md
      plan/SKILL.md
      verify/SKILL.md
      done/SKILL.md
    agents/verifier.md                   checks code against the spec, read-only
    hooks/hooks.json                     session start → scripts/task-index.sh
    scripts/task-index.sh                builds tasks/index.md (bash + awk, works in Git Bash)
    templates/project/                   copied into each project by setup-project
      CLAUDE.md                          base rules + project TODOs (filled at kickoff)
      .claude/settings.json              deny list + auto-install of this kit
      docs/index.md                      map of the docs
      docs/architecture.md
      docs/specs/_template.md
      docs/adr/000-template.md
      tasks/README.md
    templates/optional/                  added by kickoff only when the project needs them
      .mcp.json                          Jira (Atlassian) connector
      docs/tech-stack.md
      docs/deployments.md
      docs/modules.md                    only when architecture.md's module table gets too long
```

## Try it locally

From the folder that contains `dirox-claude-kit/`:

```bash
claude plugin validate ./dirox-claude-kit
claude plugin marketplace add ./dirox-claude-kit
claude plugin install dirox-kit@dirox
```

Then, in any git repo: `/dirox-kit:setup-project`, then `/dirox-kit:kickoff <KEY>-1`.

## Share it with the team

The kit lives at `github.com/dirox-official/dirox-claude-kit` (private: you need read access to the repo).

- Install it yourself: `claude plugin marketplace add dirox-official/dirox-claude-kit`, then `claude plugin install dirox-kit@dirox`.
- Every project set up with the kit asks teammates to install it when they open the project (see `templates/project/.claude/settings.json`).
- To ship an update: change the files, raise `version` in `plugin.json`, and push. Teammates get it with `claude plugin marketplace update dirox`.

## Connect Jira

The skills pull tickets through a Jira tool if one is connected; otherwise they ask you to paste the ticket.
To connect Atlassian's Rovo MCP server for yourself:

```bash
claude mcp add --transport http atlassian https://mcp.atlassian.com/v1/mcp/authv2
```

Then run `/mcp` in a Claude Code session to sign in. For a whole project, the kickoff can add `templates/optional/.mcp.json` to the repo instead.

## Later

- Hooks that enforce the deny list (block `cat .env`, pushes to main) instead of relying on permission rules alone
- CI checks on pull requests (tests, overlap check)
- `/dirox-kit:adr` to record a decision on its own
