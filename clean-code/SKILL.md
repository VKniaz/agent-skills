---
name: clean-code
description: Use when writing, changing, fixing, refactoring, reviewing, or committing code in any language, and especially when tempted to tidy unrelated code, add "just in case" options, guard a crash instead of finding its cause, skip or delete a test, or mix a cleanup into a behavior change.
---

# Clean Code

## Overview

The smallest correct change, proven by a test, with structure kept apart from behavior.

**Violating the letter of these rules is violating the spirit.**

## Principles, named

- **KISS.** Prefer the version a new reader understands in one pass. Fewer layers, less hidden state, no clever tricks.
- **YAGNI.** Build for today's requirement. Delete code, flags, and parameters nothing uses yet.
- **DRY.** One decision, one place (scoped in section 5).
- **SOLID, applied when it removes a real cost:**
  - Single responsibility: a unit has one reason to change.
  - Open/closed: add a case without editing a growing switch, once there are three or more cases.
  - Liskov: a subtype works anywhere its parent does. If it would raise "not supported", do not inherit.
  - Interface segregation: callers depend only on the methods they use.
  - Dependency inversion: depend on an interface only at a boundary (I/O, network, clock) or when two implementations exist today.
  - No interface, factory, registry, or layer for one implementation, or for implementations nobody has asked for yet.
  - The user asks for "extensible" or names future cases: still build for today, and say in your reply what you left out and what adding the next case will take.

## 1. Before you code

- Say your assumptions. If the request has two readings, name both.
- If a question can be answered by running something (behavior, output, timing), run it instead of asking. Ask the human only for product or preference calls, and before irreversible or outward-facing actions.
- If the evidence says the requested change is wrong, show the evidence and stop.
- Name the data shape first. Make illegal states impossible to represent.

## 2. Writing the change

- Ship the smallest diff that solves the problem. No speculative features, config options, one-caller abstractions, or handling for impossible cases.
- Every changed line traces to the request. Match the existing style.
- Subtract before you add. Remove dead weight you are about to build on first.
- A new requirement that does not fit: redesign the part it touches as if it had been there from day one. Choose that over the smallest diff only when the small version would special-case two or more places.
- Validate data where it enters. Trust it inside. Keep business logic in pure functions.
- Make operations safe to rerun or resume after a crash. Give shared mutable state one writer.

## 3. Tests

**REQUIRED SUB-SKILL:** superpowers:test-driven-development when installed. Otherwise: failing test first, watch it fail for the expected reason, minimum code to pass, refactor while green.

- Test through the public interface. Assert what a caller observes.
- Throw out any test that would still pass if every function returned nothing.
- Never delete, skip, or loosen a failing test to get green. Find out why it fails.
- Bug fix: reproduce it with a failing test before touching the code.

## 4. Root causes

- Fix the first place the system went wrong. A guard is a fix only when the state it handles is legitimate.
- Two fixes that share one assumption failed the same check? Write the assumption in one sentence and test it directly before a third fix.

## 5. DRY, scoped

- Remove duplication in the code you are changing: one decision, one place.
- Duplication in nearby code: mention it, do not fix it in this change. If the user asked for a tidy-up, it is in scope, in its own structural commit.
- Extract only when the copies must change together. Look-alike code that changes for different reasons stays apart.

## 6. Commits (Tidy First)

- Structural changes (rename, extract, move, delete dead code) and behavioral changes never share a commit. Each one passes the tests on its own.
- Order: structural first when it makes the behavior change simpler. Urgent fix (production, someone blocked): the fix commit goes first, so it ships alone, and the tidy-up follows.
- Before a structural commit, pin current behavior with tests that pass on the old code. They go in that structural commit. A structural commit may update a test's call sites for a signature change; its assertions stay the same.
- Commit only when tests pass and your change adds no new lint findings (use the repo's configured linter; none configured, skip it). The message says which kind it is, why, and how you checked it.
- Follow the repo's branch and PR flow. Never push to a shared or main branch unless that is the documented flow and the user asked for a push.

## 7. Quality pass (on request)

When the user asks to "make it right", or the repo has the tools, run the measured gates in [quality-gates.md](quality-gates.md) on changed files only.

## 8. Done

Done means checked against the real thing (test run, command output), not "it compiles". Report what you ran and what it showed. **REQUIRED SUB-SKILL:** superpowers:verification-before-completion when installed.

## Red flags

| Thought | Reality |
|---|---|
| "While I'm here I'll clean this up" | Separate commit, or mention it. |
| "I'll add an option in case they need it" | Nobody asked. Delete it. |
| "I'll add an interface/factory so it's SOLID and extensible" | Count today's implementations. One: use the concrete thing. Two: a plain interface, no registry or plugin system. |
| "A null check stops the crash" | Is null legitimate here? If not, find who produced it. |
| "This test is wrong, I'll remove it" | Prove it wrong first. Then change it in its own commit. |
| "Fix and refactor in one commit, it's faster" | Two commits. Reviewers and `git bisect` need them apart. |
| "No time for a test, it's urgent" | Urgent fixes are the ones that come back. The test takes a minute. |
| "One more fix will do it" (third try) | Attack the premise. |

## Sources

Combined and adapted from Karpathy-inspired guidelines (forrestchang/andrej-karpathy-skills), Kent Beck's TDD and Tidy First CLAUDE.md (KentBeck/BPlusTree3), pstack principles (cursor/plugins), Matt Pocock's skills (mattpocock/skills), and ub-mode (unclebob/ub-mode). See the repo README for what was changed.
