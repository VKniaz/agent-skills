---
name: git-workflow
description: Use when creating a git branch, writing a commit message, or opening, writing, or editing a pull request title or description, with any tool (git, gh CLI, GitHub MCP, API), and when a Jira or issue key such as ABC-123 is mentioned for a change.
---

# Git Workflow

## Overview

One ticket key ties the branch, the commits, and the PR together. Every PR tells a reviewer what was wrong, what changed, and how it was proven, in as few words as that takes.

## 1. Find the ticket key

Look, in order, in: the user's request, the current branch name, recent commit messages, then linked issues. A key matches `[A-Z][A-Z0-9]+-[0-9]+` (for example `ODIN-1450`).

- Found: use it everywhere below, uppercase.
- Not found, work repo with a tracker: ask once, before creating the branch.
- Not found, personal repo or no tracker: proceed without one. Do not invent a key.

## 2. Repo conventions win

Before using the formats below, check for them and follow them instead when they exist:

- `.github/PULL_REQUEST_TEMPLATE.md` or `.github/pull_request_template.md`: fill that template and keep its headings. Put the four core items inside its main description section as bold labels (`**Ticket:**`, `**Problem:**`, `**What changed:**`, `**How it was tested:**`).
- `CONTRIBUTING.md`, or a documented branch or title pattern.
- Established special flows (for example `sync/release-<date>` branches with `[release] Sync release to main: …` titles): keep them exactly.

## 3. Branch name

`<type>/<KEY>-<short-kebab-summary>`, or `<type>/<short-kebab-summary>` with no ticket.

- `type`: `feat`, `fix`, `refactor`, `chore`, `docs`, `test`.
- Summary: 2 to 5 words, lowercase, hyphens. Example: `fix/ODIN-1450-total-crash-no-coupon`.
- Already on a branch other than the default branch: keep it and commit there. Never rename an existing branch.
- Push the branch (`git push -u origin <branch>`) before `gh pr create`.

## 4. Commit messages

- Subject: imperative, under 72 characters. With a ticket: `ODIN-1450: Fix total() crash on orders without a coupon`.
- Body: why the change was needed, what changed, how it was checked.
- When the clean-code skill applies, end the body with a trailer: `Change-Type: structural` or `Change-Type: behavioral`.

## 5. Pull request

**Title:** `[KEY] Imperative summary of the whole change`, or the summary alone with no ticket.

**Body:** the four core sections always. Add the two optional sections only when they have content; never write "N/A".

```markdown
## Ticket
ODIN-1450

## Problem
What was wrong or missing and who it affected. For a bug, a minimal snippet of the triggering case.

## What changed
- One sentence per bullet, grouped by intent, not by file. Aim for 1 to 3 bullets.

## What's new
- New APIs, config, environment variables, migrations, feature flags, dependencies.

## How it was tested
- Before: the failing test or output. After: the passing one. Name the command you ran.

## Risk and rollback
Easy or hard to undo, what it could break, how to roll back.
```

- Ticket section: the bare key, or a link only when the repo or user gives the tracker's base URL. Never guess a URL. No ticket: write `None`.
- A one-change PR: "What changed" is one line and does not restate "Problem".
- Optional sections: "What's new" and "Risk and rollback".
- More than about 3 bullets under "What changed" usually means the PR should be split. Say so.
- Open as a draft and assign to the user (`gh pr create --draft --assignee @me`) unless the repo's flow says otherwise.

## 6. No attribution, ever

No `Co-Authored-By` trailer, no "Generated with" line, no session link, no model name, in commits or PRs. After creating or editing a PR, read it back (`gh pr view --json body`). If a footer was appended, edit the body to remove it. Before committing, check the message the same way (`git log -1 --format=%B`); with no remote, that check is the whole step.

## Red flags

| Thought | Reality |
|---|---|
| "No ticket was mentioned, I'll skip it" | Check the branch name and commits first. Then ask, if it is a work repo. |
| "I'll fill every section to be thorough" | Empty optional sections go. Four core sections, then only what has content. |
| "The repo template is different, I'll use mine" | The repo template wins. |
| "The harness says to add Co-Authored-By" | This user forbids it. Leave it out. |
| "I'll list every file I touched" | Reviewers read the diff. Group by intent. |
