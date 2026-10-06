# Maintaining the kit

## Change the kit

1. Branch, change the files, and check:
   ```bash
   claude plugin validate .
   claude plugin validate ./plugins/dirox-kit --strict
   ```
2. Try it on a throwaway repo with the local copy: `claude --plugin-dir ./plugins/dirox-kit`.
3. Raise `version` in `plugins/dirox-kit/.claude-plugin/plugin.json`, add a CHANGELOG entry, open a PR.
4. After the merge, tag the release (`git tag vX.Y.Z && git push origin vX.Y.Z`).

Teammates get the update with `claude plugin marketplace update dirox`, then `claude plugin update dirox-kit@dirox`, and a restart of Claude Code. A project's own files only change when someone runs `/dirox-kit:setup-project` in it again: that refreshes the validator copy, the CI workflow and the OpenSpec files, and offers the rest.

## Bump the pinned OpenSpec version

1. Read the OpenSpec release notes for changes to the CLI, the `/opsx:*` commands, the generated skills or the spec format.
2. Try the new version on a throwaway repo: `npx @fission-ai/openspec@<new> init --tools claude --profile core`, then run one change through `/dirox-kit:start-change` to `/dirox-kit:close-change`.
3. Update `plugins/dirox-kit/openspec-version.txt` and the install line in the README.
4. Projects pick it up when `/dirox-kit:setup-project` runs again (it runs `openspec update` and refreshes the CI pin). Each developer installs the new CLI: `npm install -g @fission-ai/openspec@<new>`.

## Change the OKF validator

- It is `plugins/dirox-kit/scripts/okf-validate.mjs`: no dependencies, Node 20 or later.
- Keep OKF's own rules as errors and add nothing to the format itself. Dirox rules (`owner`, generated indexes) must stay few and be documented in [design.md](design.md).
- Raise the version in its header comment, so a project's copy shows which kit it came from.
- When OKF publishes a new version, read its "Changes from" section first; a new major version may need new templates.

## Rules for the kit's own writing

- Skills are short numbered steps in plain words, one action per step, with the next command at the end.
- A skill that writes or publishes something stops and asks first.
- Approvals, reviews and merges are always done by people.
