# agent-skills

Agent skills for writing code and shipping it. Each one combines rules from several well-known agent rule sets into one short skill, settles the places where they contradict each other, and drops the parts that are tied to one tool or workflow.

Works with Claude Code, Codex, Cursor, and any agent that reads `SKILL.md` files.

| Skill | Use it for |
|---|---|
| [clean-code](clean-code/SKILL.md) | Writing, fixing, refactoring, and committing code: KISS, YAGNI, DRY, SOLID, TDD, Tidy First, root causes |
| [git-workflow](git-workflow/SKILL.md) | Branch names, commit messages, and PR descriptions tied to a ticket key, with no AI attribution |

## Install

Claude Code:

```bash
git clone https://github.com/VKniaz/agent-skills
mkdir -p ~/.claude/skills
cp -R agent-skills/clean-code agent-skills/git-workflow ~/.claude/skills/
```

Other agents: copy the skill folders into that agent's skills directory (for example `~/.agents/skills/` or `~/.cursor/skills/`).

The skills load on their own when an agent writes code, creates a branch, commits, or opens a PR. They work best alongside [superpowers](https://github.com/obra/superpowers), which clean-code points to for TDD and verification, but they work without it.

To stop Claude Code adding `Co-Authored-By` trailers and "Generated with" lines at the source, also add this to `~/.claude/settings.json`:

```json
"attribution": { "commit": "", "pr": "", "sessionUrl": false }
```

## clean-code

### What it combines

It names the classic principles (KISS, YAGNI, DRY, SOLID) and says when each one applies, so they don't pull against each other.

| Source | What this skill takes from it |
|---|---|
| [Karpathy-inspired guidelines](https://github.com/forrestchang/andrej-karpathy-skills) | State assumptions, simplicity first, surgical changes, goal-driven execution |
| [Kent Beck's CLAUDE.md](https://github.com/KentBeck/BPlusTree3) | Red-green-refactor, and Tidy First: structural and behavioral changes in separate commits |
| [pstack](https://github.com/cursor/plugins) principles by Lauren Tan | Model the domain, boundary discipline, attack the premise, fix root causes, idempotency |
| [Matt Pocock's skills](https://github.com/mattpocock/skills) | Domain modeling and testing through public interfaces |
| [ub-mode](https://github.com/unclebob/ub-mode) by Robert C. Martin | Measured quality gates (crapper, dryer, mutator) and "throw out a test that passes when everything returns nothing" |

### Tweaks

1. **Ask or proceed.** Karpathy says ask when unsure; pstack says never block on the human. Here: if running something can answer the question, run it. Ask only for product or preference calls and before irreversible actions.
2. **DRY versus "don't touch it".** Remove duplication in code you are changing. Mention duplication in nearby code, but leave it alone unless the user asked for a tidy-up.
3. **Smallest diff versus redesign.** Smallest diff by default. Redesign the touched part only when the small version would special-case two or more places.
4. **Tidy First order.** Beck puts structural changes first. Here an urgent fix ships first, alone, and the tidy-up follows.
5. **Pushing.** ub-mode pushes to the main line at the end. Here: follow the repo's branch and PR flow, and push only when asked.
6. **Quality gates on request.** ub-mode runs all gates on every change. Here they run on changed files only, and the agent reports missing tools instead of inventing scores.
7. **SOLID versus "no abstractions for single-use code".** Each SOLID letter applies only when it removes a real cost. One implementation means the concrete thing, two means a plain interface, and nothing gets a factory, registry, or plugin system for cases nobody has asked for.
8. **Dropped:** worktree disk cleanup, logging every action, Cursor-specific model routing, and prose-style rules.

Optional quality gates: see [clean-code/quality-gates.md](clean-code/quality-gates.md).

## git-workflow

### What it combines

| Source | What this skill takes from it |
|---|---|
| [fredrikaverpil `pr-style`](https://github.com/fredrikaverpil/dotfiles/blob/main/stow/shared/.claude/skills/pr-style/SKILL.md) | Short bullet PR bodies, draft PRs assigned to the author, no AI footer, read the PR back to strip platform footers |
| [Matt Pocock `pr`](https://github.com/mattpocock/skills/tree/main/skills/engineering/pr) | Before/after evidence, and risk as "one-way or two-way door" |
| [Liferay `pr`](https://tessl.io/registry/skills/github/liferay/liferay-portal/pr) | Ticket key at the front of the title |

### Tweaks

1. **One ticket key everywhere.** Found once (request, branch, commits) and used in the branch name, commit subjects, PR title, and a Ticket section.
2. **Scaled to the change.** Four core sections always (Ticket, Problem, What changed, How it was tested); "What's new" and "Risk and rollback" only when they have content.
3. **Repo conventions win.** A repo's PR template, contributing guide, or special release flow overrides these formats.
4. **Attribution off at the source.** The settings key above removes it; the skill only double-checks.

## License

MIT
