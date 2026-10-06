# Design of dirox-kit 1.0

Why the kit looks the way it does. Read this before changing its structure.

## Goal

Our earlier formats (task files, living specs, ADRs in `.claude-dirox/`) were homemade: hard for others to read, and ours to maintain. Version 1.0 uses OpenSpec and OKF for everything generic and keeps custom code only where something is truly Dirox-specific. The kit is thin glue between OpenSpec, OKF, Jira and our team rules. When in doubt, the standard tool wins over our own code, and the standards are not customised.

## Principles

1. **The kit holds behaviour; each project holds its content.** `openspec/` and `okf/` live in project repos. The kit has neither.
2. **OpenSpec is used, never wrapped or forked.** Projects run the pinned OpenSpec CLI (`openspec init`, `openspec update`), which generates its own skills and `/opsx:*` commands. Our commands call those skills. Our rules go in `openspec/config.yaml` (`context`, `rules`), OpenSpec's own extension point. No custom schema.
3. **OKF is followed exactly.** Concepts have YAML frontmatter and a non-empty `type`; `index.md` and `log.md` follow the spec; links are bundle-relative. Our one extra field is `owner`. Human review uses OKF's own `verified` field. Our own OKF skill and validator; no community OKF plugin.
4. **Strict ownership.** `openspec/` = behaviour (requirements, scenarios). `okf/` = knowledge (domain, decisions, architecture, data, integrations, runbooks). They link by path; nothing is duplicated.
5. **Progressive loading.** Only `okf/index.md` is shown at session start (100 lines at most). Concepts, specs and architecture are read when a task needs them.
6. **People approve, Claude checks.** Approvals are PR reviews. Claude never approves, reviews or merges.

## Decisions

| Decision | Why |
|---|---|
| One plugin, `dirox-kit` (commands `/dirox-kit:*`) | A split into a core and a delivery plugin would have left the core nearly empty. No project used the earlier kit, so the 1.0 restructure needed no migration path |
| OKF v0.2, concept type set by folder: Glossary Term, Decision, Architecture, Data Entity, Integration, Runbook | OKF has no type registry; one type per folder keeps it predictable |
| OKF `verified` instead of a custom `last_verified` | OKF v0.2 already defines human review, and its trust levels depend on it |
| Validator errors: OKF conformance, missing `owner`, stale `index.md`. Warnings: broken links, missing title or description, unknown status | OKF readers must tolerate broken links, so they cannot be errors. `owner` and generated indexes are our rules |
| `okf/index.md` is generated from frontmatter, and CI checks it | A hand-kept index drifts. The root index lists every concept, grouped by folder, so one file maps the bundle |
| Validator: one dependency-free Node script, copied into each project's `.github/scripts/` | CI in a client repo cannot read the private kit repo without a token. Node is already required by OpenSpec |
| OpenSpec **core** profile; verification by our own verifier agent | The expanded profile is a per-machine setting: a teammate on the default profile running `openspec update` deletes `/opsx:verify` from the project. `/opsx:verify` also does not run the tests or check each scenario against a test. Our verifier does both, in a fresh context |
| Change sizes trivial, normal, big, with approvals sized to match | Review cost proportional to risk. Trivial = no behaviour change, so no OpenSpec change |
| Change names `<jira-key>-<short-name>` in lowercase; status stays in Jira | One ticket = one change = one branch = one PR, and the hook can find the change from the branch name |
| Scenario-to-test link: test names contain the scenario name, and `tasks.md` has a Proof group | Checkable by the verifier without any extra tooling |
| Verification recorded in `openspec/changes/<change>/verification.md` | `openspec validate --strict` accepts it, and it is archived with the change as the record of what was checked |
| Kickoff writes its first specs as an OpenSpec change (`<key>-1-kickoff`) and archives it | Specs are created by OpenSpec, not written by hand; the plan and backlog stay in the archived proposal |
| OKF updates at close, in the same PR, only when the change is structural or adds knowledge | Knowledge stays true without slowing every change |
| `gh` CLI is a prerequisite | `/dirox-kit:implement` reads the PR reviews to check the approval |
| No `/opsx:onboard` for existing projects | It is a guided tutorial that builds one sample change, not a doc converter. Existing docs move into `okf/` area by area |

## After v1

Build these once v1 has run on a real project: `/dirox-kit:status` (PM), `/dirox-kit:test-plan` (QC), `/dirox-kit:review-design` (Architect), `/dirox-kit:handover` (PM, Architect), `/dirox-kit:onboard` (convert an existing project's docs, area by area). Also: coding and review standards for `/dirox-kit:implement`, and hooks that enforce the deny list instead of relying on permission rules alone.

## Known limits

- CODEOWNERS cannot require both a BA and an Architect on the same file. For big changes, "approved by BA and Architect" is checked by people (PR template checklist); `/dirox-kit:implement` only checks that the proposal PR was merged.
- The validator reads the top level of YAML frontmatter and reports what YAML rejects there; it is not a full YAML parser.
- The `/dirox-kit:*` lifecycle commands are only started by people (`disable-model-invocation`). Claude can use the `okf` skill and the OpenSpec skills on its own.
