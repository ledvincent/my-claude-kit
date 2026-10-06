# dirox-claude-kit

The Dirox way of working with Claude Code, packaged as a plugin (`dirox-kit`).
It is thin glue between three standards and our team rules:

- **[OpenSpec](https://github.com/Fission-AI/OpenSpec)** holds what the system must do: requirements and scenarios, in `openspec/` in each project.
- **[OKF](https://github.com/GoogleCloudPlatform/open-knowledge-format)** (Open Knowledge Format v0.2) holds what the team knows: domain terms, decisions, architecture, data, integrations, runbooks, in `okf/` in each project.
- **Jira** holds the work and its status.

The kit holds behaviour (commands, rules, templates, the OKF validator). Each project holds its own content. The kit never forks OpenSpec: projects run the pinned OpenSpec CLI, and our commands call its skills.

## Commands

| Command | Who | What it does |
|---|---|---|
| `/dirox-kit:setup-project` | Tech lead | Sets up a repo (new or existing): pinned `openspec init`, `okf/`, CLAUDE.md, settings, PR template, CODEOWNERS, CI |
| `/dirox-kit:kickoff <ID>` | Tech lead, Architect, PM | Plans a new project or a takeover: first specs, `okf/` seeded, CLAUDE.md filled, Jira backlog proposed |
| `/dirox-kit:start-change <ID>` | BA, developer | Pulls the Jira ticket, sizes it, reads the knowledge, runs OpenSpec explore and propose, opens the review PR |
| `/dirox-kit:implement <ID>` | Developer | Checks the proposal was approved, then runs OpenSpec apply |
| `/dirox-kit:verify <ID>` | QC, developer | A read-only agent checks, in a fresh context, that every scenario is proven by a test |
| `/dirox-kit:close-change <ID>` | Developer | Tests, OKF retro, OpenSpec archive, both validators, PR description |

Plus the `okf` skill, which Claude uses on its own whenever it reads or writes `okf/`, and a session-start hook that shows Claude `okf/index.md` and the change for the current branch.

Every ticket: `start-change → (review) → implement → verify → close-change`. Trivial changes (no behaviour change) skip the OpenSpec change and the verify step. See [docs/workflow.md](docs/workflow.md).

## Prerequisites

- Claude Code, with access to `github.com/dirox-official/dirox-claude-kit` (private)
- Node 20.19 or later
- OpenSpec at the kit's pinned version: `npm install -g @fission-ai/openspec@1.14.1` (see [plugins/dirox-kit/openspec-version.txt](plugins/dirox-kit/openspec-version.txt))
- The GitHub CLI (`gh`), signed in: used to open PRs and check approvals
- Optional: the Atlassian MCP connector, so commands can pull Jira tickets

## Install

```bash
claude plugin marketplace add dirox-official/dirox-claude-kit
claude plugin install dirox-kit@dirox
```

A project set up with the kit also asks teammates to install it when they open the project (see `.claude/settings.json`).

If git says `Repository not found` or `Cannot prompt`, git is not using a GitHub account that can see the repo: run `gh auth login`, `gh auth switch --user <your Dirox account>` if you have several, and `gh auth setup-git`.

## Start a project

In the project repo, in Claude Code:

```
/dirox-kit:setup-project
```

Review and commit what it adds, replace the placeholders in `.github/CODEOWNERS`, then create the kickoff ticket in Jira and run `/dirox-kit:kickoff <KEY>-1`.

## Connect Jira

The commands pull tickets through a Jira tool if one is connected; otherwise they ask you to paste the ticket. To connect Atlassian's MCP server for yourself:

```bash
claude mcp add --transport http atlassian https://mcp.atlassian.com/v1/mcp/authv2
```

Then run `/mcp` in Claude Code to sign in. The kickoff can add the same server for the whole project.

## Docs

- [docs/workflow.md](docs/workflow.md): the lifecycle, change sizes, where things live, CI
- Per role: [developer](docs/roles/developer.md), [BA](docs/roles/ba.md), [architect](docs/roles/architect.md), [QC](docs/roles/qc.md), [PM](docs/roles/pm.md)
- [docs/design.md](docs/design.md): why the kit looks like this, and the decisions behind it
- [docs/maintaining.md](docs/maintaining.md): changing the kit, bumping OpenSpec, releasing
- [CHANGELOG.md](CHANGELOG.md)

## Repository layout

```
.claude-plugin/marketplace.json        the catalogue ("dirox")
plugins/dirox-kit/
  .claude-plugin/plugin.json           the plugin
  skills/                              setup-project, kickoff, start-change, implement, verify, close-change, okf
  skills/okf/templates/                one OKF concept template per folder type
  agents/verifier.md                   read-only scenario-to-test check
  hooks/hooks.json                     session start → scripts/okf-context.mjs
  scripts/okf-validate.mjs             OKF v0.2 validator and index generator (copied into projects)
  openspec-version.txt                 the pinned OpenSpec version
  templates/project/                   copied into each project by setup-project
  templates/openspec-config.yaml       Dirox rules merged into each project's openspec/config.yaml
  templates/optional/.mcp.json         Jira connector, added by the kickoff when wanted
docs/                                  workflow, roles, design, maintaining
```

The kit has no `openspec/` or `okf/` folder: those live in each project.
