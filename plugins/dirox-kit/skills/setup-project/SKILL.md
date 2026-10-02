---
name: setup-project
description: Set up a repository for the Dirox workflow, or update one set up with an older version of the kit. Adds the starter files (CLAUDE.md, .claude/settings.json, .claude-dirox/) from the kit's templates, and moves files from the old docs/ and tasks/ layout into .claude-dirox/. /dirox-kit:kickoff fills them in.
disable-model-invocation: true
---

# Set up or update this project for the Dirox workflow

Templates are in `${CLAUDE_PLUGIN_ROOT}/templates/project/`. This skill lays down and updates the files; `/dirox-kit:kickoff` plans the system and fills them in.

It never deletes a file and never overwrites content a person or a ticket wrote. Moving a file keeps its content.

1. **Check where you are.** Run `git rev-parse --show-toplevel` and work from that root. If this is not a git repository, stop and ask. If `git status --short` shows uncommitted changes, say so and ask whether to continue: a migration is easier to review on a clean tree.

2. **Find out what is already here.**
   - **Old layout (kit 0.1 / 0.2):** any of `tasks/README.md` mentioning `/dirox-kit:`, task files in `tasks/` whose front matter has `jira:`, `docs/architecture.md` starting with `# Architecture:`, `docs/specs/_template.md`, `docs/adr/000-template.md`, or a CLAUDE.md containing `/dirox-kit:` and `@docs/architecture.md` or `## Where to find things`. If you find it, do the migration (step 3) before anything else.
   - **Current layout:** `.claude-dirox/` exists and nothing from the old layout is left. Skip to step 4.
   - **Nothing:** a new setup. Skip to step 4.

3. **Migrate the old layout.**
   a. **Show the plan and wait for a yes.** List each move (`old path → new path`), the CLAUDE.md sections you will rewrite, and the files you will leave alone. Suggest doing it on a branch (`git switch -c chore/dirox-kit-update`) and ask before creating one.
   b. **Move only the kit's files.** Use `git mv` for tracked files and `mv` for untracked ones:
      - `docs/architecture.md`, `docs/index.md`, `docs/tech-stack.md`, `docs/deployments.md`, `docs/modules.md`, `docs/specs/`, `docs/adr/` → the same names under `.claude-dirox/docs/`
      - everything in `tasks/` → `.claude-dirox/tasks/`, except `tasks/index.md`, which is generated: leave it, it is rebuilt at the next session start
      - Any other file in `docs/` belongs to the project: leave it. Remove `docs/` or `tasks/` only if they end up empty.
   c. **Half-migrated projects.** If the target already exists in `.claude-dirox/` (for example, setup was run again after the kit moved):
      - The target is still the untouched template (the same as the template file once `{{PROJECT_NAME}}` and `{{JIRA_KEY}}` are filled): the old file holds the real content. Replace the template copy with the old file.
      - Both hold real content: do not choose. Show both and ask which to keep, or whether to merge them by hand.
   d. **Fix the paths that point to moved files.** Search the repo, excluding `.git/` (`git grep -n -E "(^|[^/.])(docs/(architecture|index|tech-stack|deployments|modules)\.md|docs/specs/|docs/adr/|tasks/)"`), and update each hit that points to a file you moved: links in the docs, Plan lines in task files, comments. Leave hits that point to the project's own files.
   e. **Update CLAUDE.md** against the current template:
      - Sections the kit owns (`Where to start`, which replaces the old `Where to find things`; `How we work`; `Dirox rules`): replace them with the template's version. Also drop any `@docs/architecture.md` import, since the architecture doc is read at Plan, not in every message.
      - Sections the project owns (`Project`, `Commands`, `Project rules`, and any section the template does not have): keep them word for word, only fixing paths as in step d.
   f. **Settings.** If `.claude/settings.json` still says `YOUR-GITHUB-ORG`, replace that with the value in the current template. For any other difference from the template, show it and ask; never remove a rule the project added.

4. **Add what is missing from the current templates.** List every template file, including hidden ones (`find "${CLAUDE_PLUGIN_ROOT}/templates/project" -type f`). For each one:
   - Missing in the project: create it at the same relative path. For a new setup, first ask the project name and the Jira project key (for example `SHOP`), unless CLAUDE.md already gives them; then replace `{{PROJECT_NAME}}` and `{{JIRA_KEY}}`.
   - `.claude-dirox/docs/index.md` created during a migration: fill it with one line per doc that already exists, instead of leaving the template's empty lists.
   - Already in the project:
     - Files that only describe the kit, so nobody edits them (`.claude-dirox/README.md`, `.claude-dirox/tasks/README.md`, `.claude-dirox/docs/specs/_template.md`, `.claude-dirox/docs/adr/000-template.md`): if they differ from the template, show the difference and offer to replace them with the current version.
     - Every other file: do not touch it. Tell the user what the template has that their file lacks, and ask whether to merge it.
   Do not copy `templates/optional/`; the kickoff adds those files only if the project needs them.

5. **Update .gitignore.** Add these lines if they are missing: `.claude/settings.local.json`, `.env`, `.env.*`, `.claude-dirox/tasks/index.md`. During a migration, remove the old `tasks/index.md` line.

6. **Report.** List the files moved, created, updated and kept, any questions left open, and then show `git status --short`. Do not commit. Next steps for the user:
   - review the changes, commit them on a branch and open a PR
   - after a migration: restart Claude Code so the session-start hook builds `.claude-dirox/tasks/index.md`
   - new setup: connect Jira so the skills can pull tickets (see the kit's README), create the kickoff ticket in Jira (for example `<KEY>-1`, an epic) and run `/dirox-kit:kickoff <KEY>-1`
