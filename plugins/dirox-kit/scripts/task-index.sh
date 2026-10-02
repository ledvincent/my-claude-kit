#!/usr/bin/env bash
# SessionStart hook: rebuilds tasks/index.md (open work, git-ignored) from the task files,
# and prints a short summary that Claude Code adds to the session's context.
# Plain bash + awk so it runs on macOS, Linux and Git Bash on Windows.

set -u
root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
tasks="$root/tasks"
[ -d "$tasks" ] || exit 0

# Prints the front matter as key=value lines (approvals are flattened: intent=..., spec=...).
# Comments after two spaces or more are dropped, like the template's "type: full        # ...".
read_meta() {
  awk '
    { sub(/\r$/, "") }
    NR == 1 { if ($0 != "---") exit; next }
    $0 == "---" { exit }
    {
      line = $0
      sub(/[ \t][ \t]+#.*$/, "", line)
      if (line ~ /^[ \t]*[a-z_]+:/) {
        key = line; sub(/:.*/, "", key); gsub(/[ \t]/, "", key)
        val = line; sub(/^[^:]*:[ \t]*/, "", val); sub(/[ \t]+$/, "", val); gsub(/\|/, "/", val)
        print key "=" val
      }
    }' "$1"
}

# Prints the paths listed under "### Files to change" (lines like "- `path` — why").
plan_files() {
  awk '
    { sub(/\r$/, "") }
    /^### Files to change/ { on = 1; next }
    /^##/ { on = 0 }
    on && /^[ \t]*[-*][ \t]*`/ { s = $0; sub(/^[^`]*`/, "", s); sub(/`.*/, "", s); if (s != "") print s }
  ' "$1"
}

rows=""
pairs=""
open=0
stage_of=""

for f in "$tasks"/*.md "$tasks"/*/task.md; do
  [ -f "$f" ] || continue
  case "$(basename "$f")" in README.md|index.md) continue ;; esac

  meta=$(read_meta "$f")
  get() { printf '%s\n' "$meta" | sed -n "s/^$1=//p" | head -n 1; }

  [ -n "$(get closed)" ] && continue
  id=$(get jira); [ -n "$id" ] || continue
  type=$(get type)

  if [ "$type" = "kickoff" ]; then
    if [ -z "$(get tech_lead)" ] || [ -z "$(get architect)" ] || [ -z "$(get pm)" ]; then stage="plan review"
    elif [ -z "$(get backlog)" ]; then stage="foundation files"
    else stage="tickets and close"; fi
  elif [ -z "$(get intent)" ]; then stage="intent"
  elif [ "$type" != "light" ] && [ -z "$(get spec)" ]; then stage="spec"
  elif [ -z "$(get plan)" ]; then stage="plan"
  elif grep -q '^Verified: ' "$f"; then stage="done"
  else stage="build"; fi

  open=$((open + 1))
  rel=${f#"$root"/}
  rows="$rows| $id | $(get title) | $type | $stage | $(get owner) | \`$rel\` |
"
  stage_of="$stage_of$id=$stage
"
  for p in $(plan_files "$f"); do
    pairs="$pairs$p	$id
"
  done
done

# Paths planned by more than one open ticket.
overlaps=$(printf '%s' "$pairs" | awk -F'\t' '
  NF == 2 && !seen[$1 SUBSEP $2]++ { ids[$1] = ids[$1] (n[$1]++ ? ", " : "") $2 }
  END { for (p in n) if (n[p] > 1) print "- `" p "` is in the Plan of " ids[p] }')

{
  echo "# Open work"
  echo
  echo "<!-- Generated at session start by the dirox-kit plugin from the task files. Git-ignored; do not edit. -->"
  echo
  if [ "$open" -eq 0 ]; then
    echo "No open tickets."
  else
    echo "| Ticket | Title | Type | Next stage | Owner | File |"
    echo "|---|---|---|---|---|---|"
    printf '%s' "$rows"
  fi
  if [ -n "$overlaps" ]; then
    echo
    echo "## Overlaps"
    echo "Coordinate with the other ticket's owner before changing these files."
    echo
    echo "$overlaps"
  fi
} > "$tasks/index.md"

# Short summary for Claude's context: kept small because it is added to every session.
echo "dirox-kit: $open open ticket(s), listed in tasks/index.md."
branch=$(git -C "$root" branch --show-current 2>/dev/null)
current=$(printf '%s' "$branch" | grep -oE '[A-Z][A-Z0-9]+-[0-9]+' | head -n 1)
if [ -n "$current" ]; then
  stage=$(printf '%s' "$stage_of" | sed -n "s/^$current=//p" | head -n 1)
  if [ -n "$stage" ]; then
    echo "Current ticket: $current, next stage: $stage. Read its task file first."
  elif [ -f "$tasks/$current.md" ] || [ -f "$tasks/$current/task.md" ]; then
    echo "Current ticket: $current (closed)."
  else
    echo "Current ticket: $current has no task file yet. Start with /dirox-kit:intent $current."
  fi
fi
[ -n "$overlaps" ] && printf 'Overlapping plans between open tickets:\n%s\n' "$overlaps"
exit 0
