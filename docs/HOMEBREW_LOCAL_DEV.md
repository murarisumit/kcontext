# Homebrew Local Development Guide

This guide explains how to test the Homebrew formula locally before publishing.

## Prerequisites

- Homebrew installed
- Go 1.21+ installed
- This repository cloned

## Quick Start

### 1. Build and Install Locally

```bash
make brew-install-local
```

This will:
1. Build binaries for all platforms
2. Create/update a local Homebrew tap (`murarisumit/tap`)
3. Install kcontext via Homebrew

### 2. Test Installation

```bash
# Test the binary (use full path if you have aliases)
/opt/homebrew/bin/kcontext --version
/opt/homebrew/bin/kcontext --list

# Set up shell integration
eval "$(kcontext --init bash)"  # or zsh/fish

# Test switching
kcontext your-cluster.kubeconfig
echo $KUBECONFIG
```

## Available Make Targets

### `make brew-tap-local`
Creates or updates the local Homebrew tap at `murarisumit/tap`.

### `make brew-install-local`
Builds all binaries and installs via Homebrew using the local tap.

### `make brew-uninstall`
Uninstalls kcontext from Homebrew.

### `make brew-untap-local`
Removes the local Homebrew tap.

### `make brew-reinstall-local`
Uninstalls and reinstalls (useful after making changes).

### `make brew-test-local`
Installs and runs basic verification tests.

## How It Works

The Homebrew formula (`homebrew/kcontext.rb`) is smart enough to detect whether you're:

1. **Local Development**: If it finds binaries in the `dist/` directory, it uses `file://` URLs to install from local files
2. **Production Release**: If no local `dist/` directory exists, it downloads from GitHub releases

### Local Development Flow

```
make brew-install-local
├── make build-all
│   └── ./scripts/build.sh dev
│       └── Creates dist/kcontext-* binaries
├── make brew-tap-local
│   ├── Creates ~/Library/Homebrew/Taps/murarisumit/homebrew-tap if needed
│   └── Copies homebrew/kcontext.rb to the tap's Formula/ directory
└── brew install murarisumit/tap/kcontext
    ├── Formula detects dist/ directory exists
    ├── Uses file:// URL to local binary
    └── Installs to /opt/homebrew/bin/kcontext (or /usr/local/bin on Intel)
```

## Troubleshooting

### Clear Homebrew Cache

If you're seeing old versions or errors:

```bash
rm -rf ~/Library/Caches/Homebrew/downloads/*kcontext*
make brew-reinstall-local
```

### Existing Alias Conflicts

If you have an existing `kcontext` alias or function:

```bash
# Check what's active
type kcontext
which kcontext

# Use the full path to test
/opt/homebrew/bin/kcontext --version

# Or temporarily unalias
unalias kcontext  # for aliases
unset -f kcontext # for functions
```

### View Formula Location

```bash
# See where the formula is installed
brew --repository murarisumit/tap

# View the formula
cat $(brew --repository murarisumit/tap)/Formula/kcontext.rb
```

### Debugging Formula Issues

```bash
# See formula evaluation
brew info murarisumit/tap/kcontext

# See formula source
brew cat murarisumit/tap/kcontext

# Verbose installation
brew install --verbose murarisumit/tap/kcontext
```

## Testing Changes

After making changes to the code:

```bash
# Rebuild and reinstall
make brew-reinstall-local

# Or do it step by step
make clean
make build-all
make brew-tap-local
brew reinstall murarisumit/tap/kcontext
```

## Publishing to Homebrew

Once you're happy with local testing:

1. Tag a release:
   ```bash
   git tag -a v1.0.0 -m "Release v1.0.0"
   git push origin v1.0.0
   ```

2. GitHub Actions will build and publish binaries

3. Update the formula for production use:
   - Remove local tap: `brew untap murarisumit/tap`
   - Create official tap: `brew tap murarisumit/homebrew-tap`
   - Add formula to the official tap's repository
   - Users install with: `brew install murarisumit/tap/kcontext`

## Notes

- The local formula uses `file://` URLs which bypass SHA256 verification
- Production formulas should include proper SHA256 checksums
- Local installations show a warning about missing checksums (this is normal)
- The formula automatically detects the correct binary for your architecture
