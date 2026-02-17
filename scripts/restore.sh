#!/usr/bin/env bash
set -euo pipefail

# Usage: ./restore.sh
# Prerequisites: restic installed, ~/.config/restic/env exists

source ~/.config/restic/env

RESTORE_DIR="/tmp/nixos-restore"
rm -rf "$RESTORE_DIR"

echo "Restoring latest snapshot..."
restic restore latest --tag nixos-dr --target "$RESTORE_DIR"

# Restore SSH keys
echo "Restoring SSH keys..."
mkdir -p ~/.ssh
cp -a "$RESTORE_DIR/home/"*/".ssh"/* ~/.ssh/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*-key 2>/dev/null || true
chmod 644 ~/.ssh/*.pub 2>/dev/null || true

# Restore credentials
echo "Restoring credentials..."
cp -a "$RESTORE_DIR/home/"*/".netrc" ~/ 2>/dev/null || true
cp -a "$RESTORE_DIR/home/"*/".claude.json" ~/ 2>/dev/null || true

# Clone git repos from manifest
MANIFEST=$(find "$RESTORE_DIR" -name "git-repos-manifest.txt" | head -1)
if [ -n "$MANIFEST" ]; then
    echo "Re-cloning git repositories..."
    while IFS='|' read -r repo_path remote_url; do
        if [ "$remote_url" != "no-remote" ] && [ -n "$remote_url" ]; then
            if [ ! -d "$repo_path" ]; then
                echo "  Cloning $remote_url -> $repo_path"
                mkdir -p "$(dirname "$repo_path")"
                git clone "$remote_url" "$repo_path" || echo "  FAILED: $remote_url"
            else
                echo "  Already exists: $repo_path"
            fi
        fi
    done < "$MANIFEST"
fi

echo ""
echo "Restore complete. Next steps:"
echo "  1. cd ~/.dotfiles && sudo nixos-rebuild switch --flake .#\$HOSTNAME"
echo "  2. Log into Chrome, VSCode, Slack etc."
echo "  3. Rotate AWS keys in IAM console"
