# Agent Instructions for homebrew-ingmarstein

This is a personal Homebrew tap (`ingmarstein/ingmarstein`) for formulae that don't meet homebrew-core's notability requirements.

## Version Updates

Preferred method for version bumps:

```sh
brew bump-formula-pr --strict ingmarstein/ingmarstein/<formula> --url=<url> --sha256=<sha256>
# or
brew bump-formula-pr --strict ingmarstein/ingmarstein/<formula> --tag=<tag> --revision=<revision>
# or
brew bump-formula-pr --strict ingmarstein/ingmarstein/<formula> --version=<version>
```

### Manual Version Updates

If manual editing is needed:

```sh
brew edit ingmarstein/ingmarstein/<formula>
# Update url and sha256 (or tag and revision)
# Leave `bottle do` block unchanged
```

Commit message: `<formula> <version>`

## Formula Fixes

Commit message: `<formula>: fix <description>` or `<formula>: <description>`

### When to Add a Revision

Add or increment `revision` when:
- Fix requires existing bottles to be rebuilt
- Dependencies changed in a way that affects the built package
- The installed binary/library behavior changes

Do NOT add revision for cosmetic changes (comments, style, livecheck fixes).

## Validation

Run before committing:

```sh
# Build from source
HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source ingmarstein/ingmarstein/<formula>

# Run tests
brew test ingmarstein/ingmarstein/<formula>

# Audit
brew audit --strict ingmarstein/ingmarstein/<formula>

# Style check
brew style Formula/<formula>.rb
```

## Commit Message Format

- Version update: `<formula> <version>`
- Fix/change: `<formula>: fix <description>` or `<formula>: <description>`
- Bottle update: `<formula>: update <version> bottle.`
- First line MUST be 50 characters or less

## Bottle Management

Bottles are managed by CI. Do not manually edit `bottle do` blocks.

A formula change only produces a bottle if it lands through a pull request. `tests.yml` gates `brew test-bot --only-formulae` (and the bottle artifact upload) on `if: github.event_name == 'pull_request'`, so a direct push to `main` runs the syntax checks only and publishes nothing. Label the PR `pr-pull` to trigger `publish.yml`, which runs `brew pr-pull`: it cherry-picks the commits onto `main`, uploads the bottle to `ghcr.io/v2/ingmarstein/ingmarstein`, and then **closes** the PR. `state: closed` with `merged: false` is the expected outcome, not a failure.

Two traps worth knowing:

- `publish.yml` runs on `pull_request_target`, which takes the workflow definition from the **base** branch. A fix to that workflow only takes effect once it is on `main`; it cannot be tested from the PR branch itself.
- `Homebrew/actions/*` must be referenced `@main`. The `master` branch no longer exists, and a stale ref fails the entire job at "Set up job" with `Unable to resolve action 'homebrew/actions@master'`.

Bottle tags follow the CI runner — `macos-26` produces `arm64_tahoe` — and a formula with `depends_on :macos` gets no Linux bottle. `livecheck` uses `strategy :github_latest`, which calls `/releases/latest`, so a tag with no GitHub Release 404s as `GitHub::API::HTTPNotFoundError` and fails the whole test-bot job even though bottling and `brew test` both passed. **Every tag needs a GitHub Release, not just a tag.** The same livecheck feeds the scheduled `autobump.yml`.

## References

- [Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
- [Taps documentation](https://docs.brew.sh/Taps)
