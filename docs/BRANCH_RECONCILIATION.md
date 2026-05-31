# link-n8n branch reconciliation (2026-05-31)

LiNKtrend SOP: **`development`** integration → **`staging`** → **`main`** promotion (Principal). Never push to `n8n-io/n8n`.

## Before (remote `origin`)

| Item | Value |
|------|--------|
| GitHub default branch | `master` |
| `origin/development` | `1dc454b932` — integration + upstream-sync + branch policy (tip) |
| `origin/staging` | `7192b24eb1` — **4 commits behind** `development` (ancestor) |
| `origin/main` | `6b183d0754` — **1 commit behind** `development` |
| `origin/master` | `6b183d0754` — same as `main`; **1 commit behind** `development`; GitHub `HEAD` pointed here |

Divergence (left = development only, right = other only):

| Compare | Ahead/behind vs `development` |
|---------|-------------------------------|
| `development` … `staging` | 4 / 0 |
| `development` … `main` | 1 / 0 |
| `development` … `master` | 1 / 0 |

Commits on `development` not yet on `staging`:

1. `830874e16f` — chore(policy): enforce dev/* source branch for development PRs
2. `548a5cc4d0` — chore(sync): daily upstream→staging workflow (superseded on `development`)
3. `6b183d0754` — ci: upstream sync to staging (superseded on `development`)
4. `1dc454b932` — chore(ci): align fork git policy with LiNKdev (upstream→**development**, branch-source-policy, block-upstream-prs)

## Local checkouts

| Path | Branch | Notes |
|------|--------|--------|
| `/Users/linktrend/Projects/link-n8n` | `development` | Matches `origin/development`; clean |
| `/Users/linktrend/Projects/LiNKautowork/link-n8n/` | `master` | Stale fetch until 2026-05-31; behind `origin/master`; has local `AGENTS.md` / `.cursor/` edits — not part of fork policy |

Nested clone has `upstream` → `n8n-io/n8n` with `push = no_push` (correct).

## Actions applied in this reconciliation

1. **Document** branch map and promotion backlog (this file).
2. **GitHub default branch** → `development` (integration target; `master` remains legacy/upstream naming — see `docs/UPSTREAM.md`).
3. **CI** — `.github/workflows/branch-source-policy.yml` already matches LiNKautowork promotion rules on `development` (commit `1dc454b932`).

## After (expected)

| Item | Value |
|------|--------|
| GitHub default branch | `development` |
| Integration branch | `development` @ `1dc454b932` |
| `staging` / `main` / `master` | Unchanged until **Principal** promotion PRs |

## Manual follow-up (Principal / GitHub UI)

1. **Promote** `development` → `staging` (PR; branch-source-policy allows only `development` → `staging`).
2. **Promote** `staging` → `main` when release-ready (not `master` unless branch protection is aligned).
3. **Branch protection** (optional): protect `development`, `staging`, `main`; require `branch-source-policy` check on PRs.
4. **Nested LiNKautowork clone**: `git fetch origin && git checkout development && git pull` — discard or commit local-only `AGENTS.md` / `.cursor/` separately.
5. **Do not** open PRs to `n8n-io/n8n` or push to upstream.

## Never

- Push to `https://github.com/n8n-io/n8n.git`
- Merge arbitrary branches into `main` / `staging` outside promotion flow
