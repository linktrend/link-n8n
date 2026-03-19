#!/usr/bin/env bash
set -euo pipefail

# Sync helper for fork maintenance:
# - Keep origin as source-of-truth
# - Pull upstream changes through a dedicated sync branch and PR

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT"

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Not a git repository: $REPO_ROOT" >&2
  exit 1
fi

current_branch="$(git rev-parse --abbrev-ref HEAD)"
if [[ -n "$(git status --porcelain)" ]]; then
  echo "Working tree is not clean. Commit/stash changes first." >&2
  exit 1
fi

echo "[1/5] Fetching remotes..."
git fetch origin --prune --tags
git fetch upstream --prune --tags

echo "[2/5] Ensuring upstream push is blocked..."
git remote set-url --push upstream no_push

echo "[3/5] Updating local master from origin/master..."
git checkout master >/dev/null 2>&1
git pull --ff-only origin master

sync_branch="sync/upstream-$(date +%Y%m%d-%H%M)"
echo "[4/5] Creating sync branch: ${sync_branch}"
git checkout -b "$sync_branch"

echo "[5/5] Merging upstream/master into ${sync_branch}"
git merge --no-ff upstream/master -m "chore(sync): merge upstream/master into ${sync_branch}"

echo
echo "Sync branch ready: ${sync_branch}"
echo "Next steps:"
echo "  1) Run validation/CI locally"
echo "  2) git push -u origin ${sync_branch}"
echo "  3) Open PR to master"

git checkout "$current_branch" >/dev/null 2>&1 || true
