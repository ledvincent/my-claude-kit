#!/usr/bin/env node
// SessionStart hook: prints what Claude should know before the first message.
// - okf/index.md, the map of the project knowledge (at most 100 lines; concepts are read on demand)
// - the OpenSpec change that belongs to the current branch's Jira ticket, with its task progress
// Prints nothing in a repo that uses neither OpenSpec nor OKF. Never fails the session.

import fs from "node:fs";
import path from "node:path";
import { execFileSync } from "node:child_process";

const MAX_LINES = 100;
const root = process.env.CLAUDE_PROJECT_DIR || process.cwd();
const okfIndex = path.join(root, "okf", "index.md");
const changesDir = path.join(root, "openspec", "changes");
const hasOkf = fs.existsSync(path.join(root, "okf"));
const hasOpenSpec = fs.existsSync(path.join(root, "openspec"));
const out = [];

try {
  if (!hasOkf && !hasOpenSpec) process.exit(0);
  if (!hasOkf || !hasOpenSpec) {
    out.push("dirox-kit: this project is missing " + (hasOkf ? "openspec/" : "okf/") + ". Tell the user to run /dirox-kit:setup-project.");
  }

  if (fs.existsSync(okfIndex)) {
    const lines = fs.readFileSync(okfIndex, "utf8").replace(/\r\n?/g, "\n")
      .replace(/^---\n[\s\S]*?\n---\n/, "").trimEnd().split("\n");
    out.push("Project knowledge map (okf/index.md). Open a concept only when the task needs it:", "");
    out.push(...lines.slice(0, MAX_LINES));
    if (lines.length > MAX_LINES) out.push("", `… ${lines.length - MAX_LINES} more lines: read okf/index.md for the rest.`);
    out.push("");
  }

  let branch = "";
  try {
    branch = execFileSync("git", ["-C", root, "branch", "--show-current"], { encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] }).trim();
  } catch { /* not a git repo */ }
  const key = (branch.match(/[A-Z][A-Z0-9]+-\d+/) || [])[0];
  if (key && hasOpenSpec) {
    const prefix = key.toLowerCase() + "-";
    const open = fs.existsSync(changesDir)
      ? fs.readdirSync(changesDir, { withFileTypes: true })
        .filter((e) => e.isDirectory() && e.name !== "archive" && e.name.startsWith(prefix)).map((e) => e.name)
      : [];
    const archived = fs.existsSync(path.join(changesDir, "archive"))
      && fs.readdirSync(path.join(changesDir, "archive")).some((n) => n.slice(11).startsWith(prefix));
    if (open.length) {
      for (const name of open) {
        const tasks = path.join(changesDir, name, "tasks.md");
        let progress = "no tasks.md yet";
        if (fs.existsSync(tasks)) {
          const t = fs.readFileSync(tasks, "utf8");
          const done = (t.match(/^\s*- \[[xX]\]/gm) || []).length;
          const all = done + (t.match(/^\s*- \[ \]/gm) || []).length;
          progress = `${done}/${all} tasks done`;
        }
        const verified = fs.existsSync(path.join(changesDir, name, "verification.md")) ? ", verification recorded" : "";
        out.push(`Current change: ${name} (openspec/changes/${name}/), ${progress}${verified}. Read its proposal and tasks before working on it.`);
      }
    } else if (archived) {
      out.push(`Ticket ${key}: its OpenSpec change is archived (done).`);
    } else {
      out.push(`Ticket ${key} has no OpenSpec change yet. Start with /dirox-kit:start-change ${key} (a trivial change needs none).`);
    }
  }
} catch (e) {
  out.push(`dirox-kit: session-start hook skipped (${e.message}).`);
}

if (out.length) console.log(out.join("\n").trim());
process.exit(0);
