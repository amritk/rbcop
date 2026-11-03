# Past RuboCop upgrades

The record of each move of rbcop's target release (#299), newest first, as it stood when the
upgrade merged. The process is docs/upgrading-rubocop.md. Paths and host names describe the CI host
at the time.

## 1.92.1 to 1.92.2 (#704)

Inventory taken 2026-10-29 (`docs/history/upgrade-1.92.2.tsv`, `docs/history/upgrade-1.92.2-lib.tsv`, release notes
of 1.92.2: 55 entries, all bug fixes and two behaviour changes). No new, removed or renamed cops;
`config/default.yml` and `config/obsoletion.yml` are unchanged. 30 cop files and 10 other lib files
change (five mixins and correctors, the runner's redundant-disable input, the renamed-cop config
warning, obsolete plugin config warnings). On the nine corpora five cops report differently (50
offenses gone, 3 new, no crash changes; Layout/SpaceAroundOperators is 47 of them). Plugin pins are
unaffected. The integration branch is `feat/rubocop-1.92.2`; its worklist and batches are
docs/history/upgrade-1.92.2-status.md.

### Gate environments for 1.92.2

As for 1.92.1 below, with `1.92.2` in every name: `~/rubocop-1.92.2/gems` is a copy of the 1.92.1
gem home with rubocop 1.92.1 replaced by 1.92.2 (`gem install --ignore-dependencies --local`; the
gemspec's dependency minimums did not move, so every other gem stays at the version the 1.92.1 set
pins), `~/rubocop-1.92.2/bin/rubocop` is the wrapper, `~/rubocop-1.92.2/record-oracles.sh` records
the root `/Users/johncosta/.claude/jobs/89c7fab2/tmp-1.92.2/`, and `ci-run.sh` has a `1.92.2` case.
The recording scripts in step 4 also need mcp 0.25.0 and rubydex 0.4.1 on `GEM_PATH`
(`~/rubocop-1.92.2/extra-gems` on CT 440, a separate gem home: put it first in `GEM_PATH`).

## 1.91.0 to 1.92.1 (#703)

Inventory taken 2026-10-25 (`docs/history/upgrade-1.92.1.tsv`, `docs/history/upgrade-1.92.1-lib.tsv`, release notes
of 1.92.0 and 1.92.1: about 440 entries). No new or removed cops; `config/default.yml` changes three
entries (Style/CollectionQuerying and Style/DisableCopsWithinSourceCodeDirective get
`VersionChanged: '1.92'`, Style/NegativeArrayIndex becomes `Safe: false`). 178 cop files and 82
other lib files change. On the nine corpora, 43 cops report differently (2,878 offenses gone, 457
new, 8 RuboCop crashes fixed); the largest are Style/MissingElse (2,112 gone), Style/HashLookupMethod
(257 gone), Style/CollectionQuerying, Layout/ClassStructure, Style/SymbolProc,
Layout/MultilineMethodCallIndentation and Lint/UselessAssignment. Outside cops: `--explain`,
`--max-offenses-per-cop`, JSON formatter fields for corrections and per-file errors, new MCP tools
and options, and runner, cache, LSP and target-Ruby lookup changes. Plugin pins are unaffected
(rubocop-capybara moved to 3.1.0, `rubocop ~> 1.89`, in #673).

The integration branch is `feat/rubocop-1.92.1` (version bumped, everything re-recorded); its
port worklist, with the failing tests, per-cop corpus diffs and the port batches, is
docs/history/upgrade-1.92.1-status.md.

### Gate environments for 1.92.1

The integration branch for #299 bumps `RUBOCOP_VERSION` to 1.92.1 first and gates against the new
release from then on; master and every other branch keep gating against 1.91.0. On the CI host:

- RuboCop 1.92.1 lives in its own gem home, `~/rubocop-1.92.1/gems`, with exactly the gem versions
  the 1.91.0 set activates (rubocop-ast 1.50.0, parser 3.3.12.0, prism 1.9.0, regexp_parser 2.13.1,
  unicode-display_width 3.3.0, ...) and the same plugin pins (docs/plugins.md, plus rubocop-i18n
  3.3.0 for mastodon's own config); every plugin pin accepts 1.92.1. Each gem went in with
  `gem install --ignore-dependencies -v <version>`, so nothing resolves outside that list. The
  rbenv 4.0.6 gem set is unchanged and still holds 1.91.0.
- `~/rubocop-1.92.1/bin/rubocop` is the wrapper: it sets `GEM_HOME`/`GEM_PATH` to that gem home and
  runs RuboCop on rbenv 4.0.6. Use it as `RUBOCOP=~/rubocop-1.92.1/bin/rubocop` for every recording
  script (step 4).
- The 1.92.1 oracle root is `/Users/johncosta/.claude/jobs/89c7fab2/tmp-1.92.1/`, next to the
  1.91.0 root (`.../tmp/`) and with the same layout: `oracle2` (nine corpora and `cold.txt`),
  `oracle3` (corpus2 projects), `oracle-performance`, `oracle-rails`, `oracle-minitest`,
  `oracle-rspec` (with `mastodon-project.txt`). The corpora stay in `.../tmp/` and are shared.
  `~/rubocop-1.92.1/record-oracles.sh <rbcop tree>` records the whole root with the scripts above
  and writes `.recorded` last.
- `ci-run.sh` (rbcop-ops `rbcop-ci/ci-run.sh.ct440`) reads `RUBOCOP_VERSION` from the synced tree's
  `src/config/mod.rs` and prints it as the first gate line, `target: rubocop X.Y.Z`. For 1.91.0
  nothing changes. For 1.92.1 it uses the 1.92.1 root and exports `RUBOCOP` (the scripts' live
  RuboCop), `RBCOP_RUBOCOP` (rbcop's fallback) and `GEM_HOME`/`GEM_PATH` (so `rubocop` on PATH,
  used by `tests/fallback.rs`, and rbcop's own gem lookups resolve to the 1.92.1 set). Any other
  version, or a root without `.recorded`, fails the gate before it starts.

When the upgrade merges, 1.92.1 becomes master's target with no further switch; the 1.91.0 entry
and root can go once no open branch still targets it.
