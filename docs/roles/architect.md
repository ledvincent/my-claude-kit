# Architect

You own the architecture and the decisions, and you review designs before code is written.

## At kickoff

`/dirox-kit:kickoff PROJ-1` writes the plan as an OpenSpec change. Review its `design.md`: modules, connections, data model, environments, key decisions. Approve the kickoff PR with the Tech lead and the PM. The kickoff then writes `okf/architecture/overview.md` and one `okf/decisions/` file per key decision.

## Each change

- **Big changes** (new module, data model, integration, security) come as a separate proposal PR. You and the BA both approve it before any code is written.
- **Normal changes**: you or the BA approve the draft PR.
- In `design.md`, check:
  - It follows the existing decisions in `okf/decisions/` and cites them.
  - Every choice that is costly to reverse is marked "Decision record needed".
  - Risks and trade-offs are named.
- At close, the developer records the marked decisions in `okf/decisions/`. Review those files in the final PR.

## Knowledge you own

- `okf/architecture/` (`type: Architecture`): the overview, the tech stack, modules once there are many.
- `okf/decisions/` (`type: Decision`): add-only. To change a decision, a new one supersedes it and the old one becomes `status: deprecated`.
- `okf/integrations/` and `okf/data/`, with the developers.
- CODEOWNERS makes you a required reviewer for `okf/decisions/` and `okf/architecture/` once branch protection is on.
