# shellcheck shell=sh
# Sourced by every script that runs RuboCop. Defines `rubocop` as $RUBOCOP (default: `rubocop` on
# PATH), word-split so a wrapper works, and exits loudly when it does not run, so a missing RuboCop
# never turns into empty oracles or "every file differs". With rbenv, for example:
#   RUBOCOP="rbenv exec rubocop" RBENV_VERSION=4.0.6 scripts/<script>.sh ...
rubocop_cmd=${RUBOCOP:-rubocop}
# Scripts run RuboCop from temp dirs, where rbenv would not see the repo's .ruby-version: pin it.
# No effect without rbenv.
# The repo root is the nearest directory above the sourcing script that holds Cargo.toml: scripts/
# and tests/<dir>/ both source this file, so `$(dirname "$0")/..` is not always the root.
rubocop_root=$(cd "$(dirname "$0")" && pwd)
while [ ! -f "$rubocop_root/Cargo.toml" ]; do
  if [ "$rubocop_root" = / ]; then
    echo "$0: no Cargo.toml above $(dirname "$0"); cannot find the rbcop repo root" >&2
    exit 1
  fi
  rubocop_root=$(dirname "$rubocop_root")
done
if [ -z "${RBENV_VERSION:-}" ] && [ -f "$rubocop_root/.ruby-version" ]; then
  RBENV_VERSION=$(cat "$rubocop_root/.ruby-version")
  export RBENV_VERSION
fi
# `command` skips this function, so the default `rubocop` does not recurse.
# shellcheck disable=SC2086
rubocop() { command $rubocop_cmd "$@"; }
# Checked from outside the repo, the way the scripts call it.
if ! rubocop_version=$(cd / && rubocop --version 2> /dev/null); then
  echo "$0: RuboCop does not run as '$rubocop_cmd'; set RUBOCOP (e.g. RUBOCOP=~/rubocop-1.92.2/bin/rubocop)" >&2
  exit 1
fi
# And it is the release rbcop targets (src/config/mod.rs RUBOCOP_VERSION), so an older RuboCop
# never records oracles or passes a live gate. Moving to a new release
# (docs/upgrading-rubocop.md), set RUBOCOP_EXPECTED to it.
rubocop_expected=${RUBOCOP_EXPECTED:-$(sed -n 's/^pub const RUBOCOP_VERSION: &str = "\(.*\)";$/\1/p' "$rubocop_root/src/config/mod.rs")}
rubocop_version=$(echo "$rubocop_version" | head -n 1)
if [ "$rubocop_version" != "$rubocop_expected" ]; then
  echo "$0: '$rubocop_cmd' is RuboCop $rubocop_version, not $rubocop_expected (set RUBOCOP, or RUBOCOP_EXPECTED when upgrading)" >&2
  exit 1
fi
