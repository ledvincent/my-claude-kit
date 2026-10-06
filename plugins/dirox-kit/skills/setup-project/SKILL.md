---
name: setup-project
description: Set up a repository for the Dirox workflow, new or existing, or update one set up with an older version of the kit. Runs the pinned OpenSpec init, adds okf/, CLAUDE.md, .claude/settings.json, the PR template, CODEOWNERS and the CI checks, and merges the Dirox rules into openspec/config.yaml. Never overwrites what people wrote.
disable-model-invocation: true
---

# Set up or update this project for the Dirox workflow

Kit files: templates in `${CLAUDE_PLUGIN_ROOT}/templates/`, the OKF validator in `${CLAUDE_PLUGIN_ROOT}/scripts/okf-validate.mjs`, the pinned OpenSpec version in `${CLAUDE_PLUGIN_ROOT}/openspec-version.txt` (call it `<version>` below).

Never delete a file and never overwrite content a person wrote. Files the kit owns (the validator copy, the CI workflow) may be replaced after telling the user.

1. **Check where you are.** Run `git rev-parse --show-toplevel` and work from that root. Not a git repository: stop and ask. If `git status --short` shows uncommitted changes, say so and ask whether to continue: the setup is easier to review on a clean tree. Suggest a branch (`git switch -c chore/dirox-kit-setup`) and ask before creating it.

2. **Check the tools.**
   - `node --version` must be 20.19 or later. If not, stop: OpenSpec and the validator need it.
   - `openspec --version` must print `<version>`. Missing or different: tell the person to run `npm install -g @fission-ai/openspec@<version>` and ask before running it yourself (it installs globally). The OpenSpec skills call `openspec` directly, so every developer needs it.
   - `gh --version`: if missing, warn that `/dirox-kit:start-change` and `/dirox-kit:implement` will ask for PR details by hand. Not blocking.

3. **Ask what you need** (unless `CLAUDE.md` already says): the project name and the Jira project key (for example `SHOP`).

4. **OpenSpec.** With `OPENSPEC_TELEMETRY=0` set for each command:
   - No `openspec/` folder: run `openspec init --tools claude --profile core --no-animation`. It creates `openspec/` and the OpenSpec commands and skills in `.claude/`.
   - `openspec/` exists: read `generatedBy` in `.claude/skills/openspec-propose/SKILL.md`. If it is not `<version>`, or the skills are missing, run `openspec update`. Never hand-edit the files OpenSpec generates.
   - Merge the Dirox rules: read `${CLAUDE_PLUGIN_ROOT}/templates/openspec-config.yaml` and `openspec/config.yaml`. Keep `schema:` and everything the project added. If the project has no `context:` or `rules:` yet, add ours. If it has its own, show both and ask how to combine them; never drop a project rule. The file must stay valid YAML.

5. **Copy the project templates.** List every file in `${CLAUDE_PLUGIN_ROOT}/templates/project/`, including hidden ones (`find "${CLAUDE_PLUGIN_ROOT}/templates/project" -type f`). For each one, at the same relative path:
   - Missing: create it. Replace `{{PROJECT_NAME}}`, `{{JIRA_KEY}}`, `{{DATE}}` (today, `YYYY-MM-DD`) and `{{OPENSPEC_VERSION}}` (`<version>`).
   - `.github/workflows/dirox-checks.yml` exists: it is kit-owned. If it differs from the template (once filled), show the difference and replace it.
   - `.claude/settings.json` exists: add what the template has and the file lacks (deny rules, the `env` entry, the marketplace, the enabled plugin). Never remove anything. Show the result.
   - `CLAUDE.md` exists: keep the project's sections word for word. For the kit's sections (`Where things are`, `How we work`, `Dirox rules`), show the difference with the template and ask whether to replace them. Remove references to the old `.claude-dirox/` layout only after asking.
   - Any other existing file: leave it. Say what the template has that the file lacks.
   Do not copy `templates/optional/`. The kickoff offers `.mcp.json` (the Jira connector) when the project uses Jira through MCP.

6. **The OKF validator.** Copy `${CLAUDE_PLUGIN_ROOT}/scripts/okf-validate.mjs` to `.github/scripts/okf-validate.mjs`. It is kit-owned: if a copy exists and differs, replace it and say so. Then run `node .github/scripts/okf-validate.mjs okf --write` and check it reports 0 errors.

7. **Existing project docs.** If the repo already has docs (a `docs/` folder, ADRs, an architecture page, a glossary), do not convert them now. List them and say they move into `okf/` area by area, as tickets touch them, or at `/dirox-kit:kickoff` for a takeover.

8. **.gitignore.** Add these lines if they are missing: `.claude/settings.local.json`, `.env`, `.env.*`.

9. **Check.** Run `openspec validate --all --strict --no-interactive` (a project with no specs yet may report nothing to validate; that is fine) and `node .github/scripts/okf-validate.mjs okf`.

10. **Report.** List the files created, updated and kept, any question left open, and show `git status --short`. Do not commit. Next steps for the person:
    - review, commit on a branch and open a PR
    - replace the placeholders in `.github/CODEOWNERS` and turn on "Require review from Code Owners" for the main branch
    - restart Claude Code so the session-start hook and the OpenSpec skills load
    - connect Jira (see the kit's README), create the kickoff ticket (for example `<KEY>-1`) and run `/dirox-kit:kickoff <KEY>-1`
