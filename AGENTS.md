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

## References

- [Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
- [Taps documentation](https://docs.brew.sh/Taps)
