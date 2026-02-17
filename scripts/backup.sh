#!/usr/bin/env bash
set -euo pipefail

source ~/.config/restic/env

MANIFEST="/tmp/git-repos-manifest.txt"

# Generate git repos manifest (repo path + remote URL)
find ~/projects -name .git -type d 2>/dev/null | while read gitdir; do
    repo_dir="$(dirname "$gitdir")"
    remote="$(git -C "$repo_dir" remote get-url origin 2>/dev/null || echo "no-remote")"
    echo "$repo_dir|$remote"
done > "$MANIFEST"

# Also capture dotfiles remote
echo "$HOME/.dotfiles|$(git -C ~/.dotfiles remote get-url origin 2>/dev/null)" >> "$MANIFEST"

# Run backup
restic backup \
    ~/.ssh/ \
    ~/.netrc \
    ~/.claude.json \
    "$MANIFEST" \
    --tag nixos-dr \
    --exclude='known_hosts*'

# Prune old snapshots
restic forget \
    --keep-daily 7 \
    --keep-weekly 4 \
    --keep-monthly 6 \
    --prune

echo "Backup complete. Snapshots:"
restic snapshots --tag nixos-dr
