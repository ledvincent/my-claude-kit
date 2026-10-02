---
name: setup-project
description: Set up a repository for the Dirox workflow. Adds the empty starter files (CLAUDE.md, .claude/settings.json, docs/, tasks/) from the kit's templates. /dirox-kit:kickoff fills them in.
disable-model-invocation: true
---

# Set up this project for the Dirox workflow

Templates are in `${CLAUDE_PLUGIN_ROOT}/templates/project/`. This skill only lays down the files; `/dirox-kit:kickoff` plans the system and fills them in.

1. **Check where you are.** Run `git rev-parse --show-toplevel` and work from that root. If this is not a git repository, stop and ask.

2. **Ask two things:** the project name and the Jira project key (for example `SHOP`).

3. **Copy the templates without overwriting anything.** List every file under the templates folder, including hidden ones (`find "${CLAUDE_PLUGIN_ROOT}/templates/project" -type f`). For each file:
   - Missing in the project: create it at the same relative path. Replace `{{PROJECT_NAME}}` and `{{JIRA_KEY}}`.
   - Already in the project: do not touch it. Tell the user what the template has that their file lacks, and ask whether to merge it.
   Do not copy `templates/optional/`; the kickoff adds those files only if the project needs them.

4. **Update .gitignore.** Add these lines if they are missing: `.claude/settings.local.json`, `.env`, `.env.*`, `tasks/index.md`.

5. **Report.** List the files created and the files kept. Next steps for the user:
   - commit them on a branch
   - connect Jira so the skills can pull tickets (see the kit's README)
   - create the kickoff ticket in Jira (for example `<KEY>-1`, an epic) and run `/dirox-kit:kickoff <KEY>-1`
