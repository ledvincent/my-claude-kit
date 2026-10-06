# Changelog

## 1.0.0 (2026-10-06)

Rebuilt on two standards: OpenSpec for behaviour and OKF for knowledge. Breaking: projects set up with 0.x need a new setup (no project used 0.x).

- **OpenSpec** (pinned 1.14.1, core profile) replaces the task files and living specs. `/dirox-kit:setup-project` runs `openspec init` and merges the Dirox rules into `openspec/config.yaml`.
- **OKF v0.2** replaces `.claude-dirox/docs/`. Each project gets `okf/` with generated index files; ADRs become `okf/decisions/`, the architecture page becomes `okf/architecture/`.
- New `okf` skill, with one concept template per type, and a dependency-free validator and index generator (`scripts/okf-validate.mjs`), copied into each project for CI.
- New commands for each ticket: `start-change` (replaces `intent` and `spec`), `implement` (replaces the build part of `plan`), `verify`, `close-change` (replaces `done`). Change sizes trivial, normal and big, with approvals as PR reviews.
- `kickoff` writes its plan and first specs as an OpenSpec change, then seeds `okf/`.
- The verifier agent checks each spec scenario against the test that proves it.
- The session-start hook shows `okf/index.md` and the current change instead of the task index.
- Project templates add a PR template, CODEOWNERS and a CI workflow (`openspec validate` and the OKF validator). The deny list also blocks `gh pr merge` and `gh pr review`, and OpenSpec telemetry is turned off.
- Docs: workflow, one page per role, design record, maintaining guide.

## 0.3.1 (2026-10-02)

- `setup-project` updates projects set up with older kits.

## 0.3.0 (2026-10-02)

- The workflow's files move from `docs/` and `tasks/` into `.claude-dirox/`.

## 0.2.0 (2026-10-02)

- First version as a Claude Code plugin: setup-project, kickoff, intent, spec, plan, verify and done skills; verifier agent; session-start task index.
