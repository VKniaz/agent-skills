# Quality gates

Three tools by Robert C. Martin turn "make it right" into numbers. They support Python, Java, TypeScript/JavaScript, Go, Rust, and Clojure.

## Setup (once)

Clone them side by side. `mutator` reads names from `../crapper`, so they must be siblings.

```bash
mkdir -p ~/tools && cd ~/tools
git clone https://github.com/unclebob/crapper
git clone https://github.com/unclebob/dryer
git clone https://github.com/unclebob/mutator
```

The first run of each tool creates its own `.venv`.

## Run from the project root, changed code only

| Gate | Command | Pass when |
|---|---|---|
| Complexity vs coverage | `~/tools/crapper/crapper --changed` | Every changed function has CRAP below 10 |
| Duplication | `~/tools/dryer/dryer --changed` | No pairs reported at the default threshold (0.82) |
| Mutation testing | `~/tools/mutator/mutator --changed` | No surviving mutants, no uncovered sites in changed functions |

CRAP = complexity² × (1 − coverage)³ + complexity. Lower it by splitting the function, by testing it, or both. A flat `match`/`case` table may be fine at a higher score; say so rather than splitting it for the number.

Mutation fixes: an uncovered site needs a test; a survivor needs a sharper assertion; a survivor that no test can kill is often dead code, so delete it.

Full-tree mutation runs are slow. Use `--changed` or a single file unless the user asks for the whole tree.

## When the tools are missing

Say so in the report. Do not invent scores. Offer the setup above.

Results land in `.metrics/`. Add it to `.gitignore` unless the project tracks it.
