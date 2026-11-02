#!/usr/bin/env bash
# Set up these skills on a new machine. Safe to rerun.
set -euo pipefail

repo="$(cd "$(dirname "$0")" && pwd)"

# Claude Code: install as a plugin so `claude plugin update` keeps it current.
if command -v claude >/dev/null; then
  claude plugin marketplace add VKniaz/agent-skills || true
  claude plugin install agent-skills@vkniaz
  claude plugin install superpowers@claude-plugins-official || true
fi

# Other agents (Codex, Copilot CLI, Gemini CLI, Cursor): symlink, so `git pull` updates them.
link_skills() {
  mkdir -p "$1"
  for skill in "$repo"/skills/*/; do
    ln -sfn "${skill%/}" "$1/$(basename "$skill")"
  done
  echo "Linked skills into $1"
}
link_skills "$HOME/.agents/skills"
[ -d "$HOME/.cursor" ] && link_skills "$HOME/.cursor/skills"

# Stop Claude Code adding Co-Authored-By and "Generated with" lines.
settings="$HOME/.claude/settings.json"
if command -v jq >/dev/null; then
  mkdir -p "$(dirname "$settings")"
  [ -f "$settings" ] || echo '{}' > "$settings"
  tmp="$(mktemp)"
  jq '.attribution = {"commit": "", "pr": "", "sessionUrl": false}' "$settings" > "$tmp" && mv "$tmp" "$settings"
  echo "Turned off attribution in $settings"
else
  echo "jq not found: add \"attribution\": {\"commit\": \"\", \"pr\": \"\", \"sessionUrl\": false} to $settings by hand"
fi
