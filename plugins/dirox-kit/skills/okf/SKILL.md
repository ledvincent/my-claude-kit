---
name: okf
description: Read, write and validate the project knowledge in okf/ (Open Knowledge Format v0.2) - domain terms, decisions, architecture, data, integrations, runbooks. Use before planning or designing a change, when a task needs project knowledge, when recording a decision or a domain term, and for the OKF retro at the end of a change.
---

# Project knowledge in okf/

`okf/` holds what the team knows about the project, in the Open Knowledge Format (OKF) v0.2.
`openspec/` holds what the system must do. Each fact lives in one of them only:

| Goes in `openspec/` (behaviour) | Goes in `okf/` (knowledge) |
|---|---|
| Requirements and scenarios: what the system does, inputs, outputs, errors | Domain terms, decisions and why, architecture, data entities, integrations, runbooks |

They point to each other by repo path, never by copying: a requirement ends with
``Knowledge: `okf/domain/order.md` ``, and a concept says
``Specified in `openspec/specs/orders/spec.md` ``.

## Layout

The folder decides the `type`:

| Folder | `type` | One file per | Template |
|---|---|---|---|
| `okf/domain/` | `Glossary Term` | business term | `glossary-term.md` |
| `okf/decisions/` | `Decision` | decision costly to reverse, named `NNN-short-title.md` | `decision.md` |
| `okf/architecture/` | `Architecture` | `overview.md`; `tech-stack.md` when versions matter; `modules/<name>.md` once the overview's module table passes about 15 rows | `architecture.md`, `tech-stack.md` |
| `okf/data/` | `Data Entity` | main entity or table | `data-entity.md` |
| `okf/integrations/` | `Integration` | external system or API | `integration.md` |
| `okf/runbooks/` | `Runbook` | operational procedure (deploy, restore, rotate keys) | `runbook.md` |

Templates are in `${CLAUDE_SKILL_DIR}/templates/`. Create a folder only when its first concept arrives.

Reserved files, never concepts:
- `index.md` in every folder is **generated** by the validator. Never edit one by hand.
- `okf/log.md` lists what changed, newest first: `## YYYY-MM-DD`, then `* **Added**: [Title](/folder/file.md) - why` (or Updated, Deprecated).

## Reading

1. The session-start hook already gave you `okf/index.md`, one line per concept. If it did not, read that file.
2. Open only the concepts the task needs. Never read the whole of `okf/`.
3. A concept with `status: deprecated` or a passed `stale_after` may be wrong: say so before relying on it.

## Writing a concept

- Copy the folder's template. File names are kebab-case: `okf/domain/purchase-order.md`.
- Frontmatter: `type` (from the table), `title`, `description` (one sentence; it becomes the index line), `owner` (the person accountable, never "Claude"), `status` (`draft`, `stable` or `deprecated`), optional `tags`. Keep YAML simple: one `key: value` per line, quote values that contain `: ` or `#`.
- `verified` records a human review: `verified: [{by: "human:<github-user>", at: YYYY-MM-DD}]`. Only the person writes it. Never add or update `verified` yourself.
- Body: plain markdown, short. Links inside `okf/` start with `/` (bundle-relative, for example `/decisions/003-use-postgres.md`). Links to the rest of the repo are repo paths in backticks.
- Never paste secrets, credentials or personal data. Name where a secret is stored, never its value.
- Decisions are add-only. To change one, write a new decision, set the old one's `status: deprecated`, and add `Superseded by [NNN](/decisions/NNN-title.md).` at the top of its body. Only those two edits are allowed on an existing decision.

After any change to `okf/`:
1. Add a line to `okf/log.md` under today's date (create the date heading if needed, newest first).
2. Regenerate the indexes and check: `node "${CLAUDE_PLUGIN_ROOT}/scripts/okf-validate.mjs" okf --write`. CI runs the project's copy, `node .github/scripts/okf-validate.mjs okf`, without `--write`.
3. Fix every ERROR. A WARN for a broken link is allowed but worth fixing.

## OKF retro (end of a change)

Run by `/dirox-kit:close-change`, in the same PR as the code. Update `okf/` only when the change is structural or adds knowledge; most changes need nothing.

1. Read the change: `proposal.md`, `design.md` (its decisions), `tasks.md`, and `git diff --stat <base>...HEAD`.
2. List the candidates, one line each:
   - a design decision marked "Decision record needed" → new `okf/decisions/` file
   - a new domain term used in the specs → `okf/domain/`
   - a new or changed module, data flow or deployment → `okf/architecture/`
   - a new entity or table → `okf/data/`; a new external system → `okf/integrations/`
   - a new or changed operational step → `okf/runbooks/`
   - an existing concept the change made wrong → update it (or deprecate it)
3. Show the list and ask which to write. Nothing to write: say `No OKF change: <reason>` so it goes in the PR description.
4. Write the approved ones as above, then log, index, validate.
