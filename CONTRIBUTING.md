# Contributing to kcontext

Thank you for considering contributing to kcontext! 🎉

## Development Setup

### Prerequisites
- Go 1.21 or later
- Docker (optional, for testing in isolated environment)
- Git

### Local Development

1. Clone the repository:
```bash
git clone https://github.com/murarisumit/kcontext.git
cd kcontext
```

2. Build the project:
```bash
make build
```

3. Run tests:
```bash
make test
```

4. Install locally for testing:
```bash
make install
eval "$(kcontext --init bash)"  # or zsh/fish
```

## Testing

### Unit Tests
```bash
make test
```

### Manual Testing
```bash
# Build and verify
make verify

# List available kubeconfigs
./bin/kcontext --list

# Test shell integration
eval "$(./bin/kcontext --init bash)"
kcontext your-cluster.kubeconfig
echo $KUBECONFIG
```

### Docker Testing
Test in a clean environment without affecting your local setup:
```bash
# Run automated tests
./scripts/test-docker.sh

# Or enter interactive shell
make docker-shell
```

## Making Changes

1. Create a feature branch:
```bash
git checkout -b feature/your-feature-name
```

2. Make your changes and ensure tests pass:
```bash
make test
```

3. Test in Docker to ensure cross-platform compatibility:
```bash
./scripts/test-docker.sh
```

4. Commit your changes:
```bash
git commit -m "Add feature: description"
```

5. Push to your fork:
```bash
git push origin feature/your-feature-name
```

6. Open a Pull Request

## Code Style

- Follow standard Go conventions
- Run `go fmt` before committing
- Add tests for new functionality
- Update documentation as needed

## Release Process

Releases are automated through GitHub Actions:

1. Update version in relevant files if needed
2. Tag the release:
```bash
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

3. GitHub Actions will automatically:
   - Build binaries for all platforms
   - Create a GitHub release
   - Attach binaries to the release

## Questions?

Feel free to open an issue for any questions or concerns!
