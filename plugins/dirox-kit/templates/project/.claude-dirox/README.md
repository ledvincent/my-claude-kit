# .claude-dirox

Working files for the Dirox way of working with Claude Code (the dirox-kit plugin).
Claude reads and updates them through the `/dirox-kit:…` commands; people review them in PRs.

- `docs/`: what the system is and does today. `index.md` maps the docs; then `architecture.md`, living specs in `specs/` and decision records in `adr/`.
- `tasks/`: one file per Jira ticket, with its Intent, Spec, Plan and Review.

Keep these files true: Claude trusts them, so a wrong doc is worse than none.
