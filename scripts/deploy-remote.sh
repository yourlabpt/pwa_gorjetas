#!/usr/bin/env bash
# Deploy a release tag to the DigitalOcean droplet from your laptop.
#
# Usage: scripts/deploy-remote.sh [--check] [--skip-sandbox] <release-tag>
#   --check         run every pre-flight check on the droplet and change nothing
#   --skip-sandbox  deploy without a sandbox pass for this commit (emergency rollback only)
#
# Needs deploy/deploy.env (copy deploy/deploy.env.example). The droplet runs the
# newest scripts/deploy.sh from origin/main, so rolling back to old tags works.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

CHECK=""; SKIP_SANDBOX=0
while [ $# -gt 1 ]; do
  case "$1" in
    --check) CHECK="--check" ;;
    --skip-sandbox) SKIP_SANDBOX=1 ;;
    *) echo "Unknown option: $1"; exit 2 ;;
  esac
  shift
done
TAG="${1:?usage: scripts/deploy-remote.sh [--check] [--skip-sandbox] <release-tag>}"
die() { echo "⛔ $*"; exit 1; }

[ -f deploy/deploy.env ] || die "deploy/deploy.env missing (copy deploy/deploy.env.example)"
# shellcheck disable=SC1091
. deploy/deploy.env
: "${DEPLOY_SSH:?}" "${DEPLOY_PATH:?}"

git fetch origin --tags --quiet
REMOTE_SHA="$(git ls-remote --tags origin "refs/tags/$TAG^{}" | cut -f1)"
[ -n "$REMOTE_SHA" ] || REMOTE_SHA="$(git ls-remote --tags origin "refs/tags/$TAG" | cut -f1)"
[ -n "$REMOTE_SHA" ] || die "tag $TAG is not on GitHub. Push it: git push origin $TAG"
LOCAL_SHA="$(git rev-parse --verify --quiet "$TAG^{commit}" || true)"
[ "$LOCAL_SHA" = "$REMOTE_SHA" ] || die "local tag $TAG differs from GitHub. Run: git fetch origin --tags --force"
git merge-base --is-ancestor "$REMOTE_SHA" origin/main || die "$TAG is not on origin/main"

if [ -z "$CHECK" ]; then
  if [ -f "sandbox/passed_$REMOTE_SHA" ]; then
    echo "✅ Sandbox passed for this commit: $(cat "sandbox/passed_$REMOTE_SHA")"
  elif [ "$SKIP_SANDBOX" -eq 1 ]; then
    echo "⚠️  No sandbox pass for $TAG ($REMOTE_SHA). Continuing because of --skip-sandbox."
  else
    die "no sandbox pass for $TAG. Run on this exact commit: git checkout $TAG && scripts/sandbox-test.sh --pull-latest"
  fi
  echo
  echo "About to deploy $TAG ($(git log -1 --format='%h %s' "$REMOTE_SHA")) to $DEPLOY_SSH:$DEPLOY_PATH"
  read -r -p "Type the tag name to confirm: " CONFIRM
  [ "$CONFIRM" = "$TAG" ] || die "not confirmed, nothing done"
fi

# The droplet runs the newest deploy script from origin/main via process
# substitution (never `| bash -s`, whose stdin docker would consume).
REMOTE_CMD="cd $(printf '%q' "$DEPLOY_PATH") && git fetch origin --tags --quiet && bash <(git show origin/main:scripts/deploy.sh) $CHECK $(printf '%q' "$TAG")"
ssh "$DEPLOY_SSH" "bash -c $(printf '%q' "$REMOTE_CMD")"
