# Upstream fork policy — linktrend/link-n8n

This repository is a **LiNKtrend fork** of [n8n-io/n8n](https://github.com/n8n-io/n8n). It is **not** a contribution path to upstream.

## Rules

1. **Never open pull requests** to `n8n-io/n8n`. Upstream changes are absorbed only inside this fork.
2. **Upstream sync** runs via `.github/workflows/upstream-sync.yml`, merging `n8n-io/n8n` default branch (currently **`master`**) into fork **`development`** only.
3. **Promotion** inside the fork: short-lived branches → **`development`** → **`staging`** → **`main`**, enforced by `.github/workflows/branch-source-policy.yml`.
4. PRs whose head is `n8n-io/n8n` are rejected by `.github/workflows/block-upstream-prs.yml`.

## Branch names

| Branch | Role |
|--------|------|
| `development` | Integration; receives automated upstream merges |
| `staging` | Pre-production; Principal promotion from `development` |
| `main` | Production-stable fork line; Principal promotion from `staging` |

### `master` vs `main`

- **Upstream** (`n8n-io/n8n`) uses **`master`** as its default branch.
- **This fork** uses **`main`** for LiNK promotion (same role as `main` in other `linktrend/*` repos).
- **`master`** may still exist on the fork as a legacy mirror of upstream naming (GitHub default is **`development`** — see `docs/BRANCH_RECONCILIATION.md`); do **not** treat PRs into `master` as part of the LiNK promotion flow unless branch protection is aligned. Prefer **`main`** for releases and promotion targets.

Allowed merge sources into `development`: `issue/*`, `dev/*`, `feature/*`, `fix/*`, `chore/*`, `codex/*`, `cursor/*`, `antigravity/*`, `dependabot/*`.

## Conflict resolution

If `upstream-sync` fails with merge conflicts, resolve them on **`development`** in this repository. Do not push conflict resolution upstream.

## LiNKautowork

LiNKautowork consumes this fork as the n8n execution plane; keep fork policy and compose/deploy docs in the LiNKautowork repo in sync with promoted `staging` / `main` lines.
