# Git Strategy (Origin Source of Truth)

## Scope
This strategy applies to the fork repository:
- Origin (authoritative): `https://github.com/linktrend/link-n8n`
- Upstream (read-only source): `https://github.com/n8n-io/n8n`

`origin` is the only writable remote. `upstream` is fetch-only.

## Source-of-Truth Rules
1. All new work lands in `origin` via pull requests.
2. `upstream` is consumed only through controlled sync branches.
3. Production releases are built from commits present on `origin/master`.
4. `automations/templates` in this project is authoritative for automation definitions; mirrored copies in other systems are non-authoritative.

## Remote Safety Controls
Required local remote configuration:

```bash
git remote set-url origin https://github.com/linktrend/link-n8n.git
git remote set-url upstream https://github.com/n8n-io/n8n.git
git remote set-url --push upstream no_push
git config remote.pushDefault origin
git config branch.master.remote origin
git config branch.master.merge refs/heads/master
```

Verify:

```bash
git remote -v
```

Expected:
- `origin` fetch/push -> `https://github.com/linktrend/link-n8n.git`
- `upstream` fetch -> `https://github.com/n8n-io/n8n.git`
- `upstream` push -> `no_push`

## Branching and PR Model
- Trunk: `master`
- Working branches: short-lived only (`feat/*`, `fix/*`, `ops/*`, `sync/*`)
- No direct trunk pushes in normal operation
- Merge policy: PR-based, with approvals and required checks

## Upstream Sync Model
Use a dedicated sync branch and PR:

```bash
bash scripts/git/sync-upstream.sh
```

Script behavior:
1. Fetches `origin` and `upstream` (including tags)
2. Fast-forwards local `master` from `origin/master`
3. Creates branch `sync/upstream-YYYYMMDD-HHMM`
4. Merges `upstream/master` into sync branch with a merge commit

After script:
1. Run full validation (CI/test workflow)
2. Open PR from sync branch to `master`
3. Merge only after checks and approvals

## GitHub Enforcement (Repository Settings)
These are enforced at GitHub level on `master`:
1. Pull request required before merge
2. At least 2 approving reviews
3. Code owner review required
4. Dismiss stale reviews on new commits
5. Conversation resolution required
6. Force pushes blocked
7. Branch deletion blocked
8. Signed commits required

## Release and Promotion
1. Merge validated changes to `master`
2. Tag release from `master` (`mvo-vX.Y.Z`)
3. Deploy by commit SHA/tag to preserve auditability

## Daily Operating Commands

Update local state:

```bash
git fetch origin --prune
git checkout master
git pull --ff-only origin master
```

Create feature branch:

```bash
git checkout -b feat/<short-name>
```

Open PR after pushing branch:

```bash
git push -u origin feat/<short-name>
```

## Incident Safety
If local configuration is lost, immediately re-apply:

```bash
git remote set-url --push upstream no_push
git config remote.pushDefault origin
```

Then re-verify with `git remote -v` before any push.
