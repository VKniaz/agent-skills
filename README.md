# clean-code

An agent skill for writing, fixing, refactoring, and committing code. It combines rules from several well-known agent rule sets into one short skill, settles the places where they contradict each other, and drops the parts that are tied to one tool or workflow.

Works with Claude Code, Codex, Cursor, and any agent that reads `SKILL.md` files.

## What it combines

It also names the classic principles (KISS, YAGNI, DRY, SOLID) and says when each one applies, so they don't pull against each other.

| Source | What this skill takes from it |
|---|---|
| [Karpathy-inspired guidelines](https://github.com/forrestchang/andrej-karpathy-skills) | State assumptions, simplicity first, surgical changes, goal-driven execution |
| [Kent Beck's CLAUDE.md](https://github.com/KentBeck/BPlusTree3) | Red-green-refactor, and Tidy First: structural and behavioral changes in separate commits |
| [pstack](https://github.com/cursor/plugins) principles by Lauren Tan | Model the domain, boundary discipline, attack the premise, fix root causes, idempotency |
| [Matt Pocock's skills](https://github.com/mattpocock/skills) | Domain modeling and testing through public interfaces |
| [ub-mode](https://github.com/unclebob/ub-mode) by Robert C. Martin | Measured quality gates (crapper, dryer, mutator) and "throw out a test that passes when everything returns nothing" |

The wording is rewritten, not copied. Credit for the ideas belongs to the authors above.

## Tweaks

Where the sources disagree, this skill picks one rule:

1. **Ask or proceed.** Karpathy says ask when unsure; pstack says never block on the human. Here: if running something can answer the question, run it. Ask only for product or preference calls and before irreversible actions.
2. **DRY versus "don't touch it".** Remove duplication in code you are changing. Mention duplication in nearby code, but leave it alone.
3. **Smallest diff versus redesign.** Smallest diff by default. Redesign the touched part only when the small version would special-case two or more places.
4. **Pushing.** ub-mode pushes to the main line at the end. Here: follow the repo's branch and PR flow, and push only when asked.
5. **Quality gates on request.** ub-mode runs all gates on every change. Here they run on changed files only, when asked or when the tools are installed, and the agent reports missing tools instead of inventing scores.
6. **SOLID versus "no abstractions for single-use code".** SOLID is named, but each letter applies only when it removes a real cost. Count today's implementations: one means the concrete thing, two means a plain interface, and nothing gets a factory, registry, or plugin system for methods nobody has asked for yet.
7. **Dropped:** worktree disk cleanup, logging every action, Cursor-specific model routing, and prose-style rules. They are not about code quality.

## Install

Claude Code:

```bash
git clone https://github.com/VKniaz/clean-code-skill
mkdir -p ~/.claude/skills
cp -R clean-code-skill/clean-code ~/.claude/skills/
```

Other agents: copy the `clean-code/` folder into that agent's skills directory (for example `~/.agents/skills/` or `~/.cursor/skills/`).

The skill loads on its own when an agent writes or changes code. It works best alongside [superpowers](https://github.com/obra/superpowers), which it points to for TDD and verification, but it works without it.

Optional quality gates: see [clean-code/quality-gates.md](clean-code/quality-gates.md).

## License

MIT
