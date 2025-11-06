# kcontext

[![Release](https://github.com/murarisumit/kcontext/actions/workflows/release.yml/badge.svg)](https://github.com/murarisumit/kcontext/actions/workflows/release.yml)

A simple, fast Kubernetes kubeconfig switcher CLI tool.

## ✨ Features

- 🚀 **Fast**: Single binary, no dependencies
- 🔍 **Auto-discovery**: Reads kubeconfig files from `~/.kube/*.kubeconfig`
- ✅ **Validation**: Ensures kubeconfig exists before switching
- 🎯 **Simple**: Just `kcontext my-cluster.kubeconfig` and you're done
- 🐚 **Multi-shell**: Works with bash, zsh, and fish

## 📦 Installation

### Homebrew
```bash
brew tap murarisumit/tap
brew install kcontext
```

After installation, add this **one line** to your shell config:

**Bash** (`~/.bashrc`):
```bash
eval "$(kcontext --init bash)"
```

**Zsh** (`~/.zshrc`):
```bash
eval "$(kcontext --init zsh)"
```

**Fish** (`~/.config/fish/config.fish`):
```fish
kcontext --init fish | source
```

Then reload your shell: `source ~/.bashrc` (or restart your terminal)

### Manual Installation
1. Download binary from [releases](https://github.com/murarisumit/kcontext/releases)
2. Make executable: `chmod +x kcontext-*`  
3. Move to PATH: `sudo mv kcontext-* /usr/local/bin/kcontext`
4. Add the init line to your shell config (see above)

## 🚀 Usage

### Basic Commands (Simple!)
```bash
kcontext my-cluster.kubeconfig    # Switch to my-cluster.kubeconfig
kcontext                           # Show help and available kubeconfig files  
kcontext --list                    # List all available kubeconfig files
```

### Verify It's Working
```bash
echo $KUBECONFIG              # Check current kubeconfig
kcontext --version            # Check version
```

### Advanced: Direct Shell Mode (if not using wrapper)
```bash
# If you haven't sourced kcontext.sh, you can still use:
eval "$(kcontext --shell my-cluster.kubeconfig)"
```

## 🎯 Why kcontext?

kcontext helps you manage multiple separate kubeconfig files (`~/.kube/*.kubeconfig`) instead of contexts within a single `~/.kube/config` file.

### Comparison with other tools:

| Tool | Usage | Approach | Dependencies | 
|------|-------|----------|--------------|
| **kcontext** | **`kcontext cluster.kubeconfig`** | **Separate kubeconfig files** | **None** |
| kubectx | `kubectx context-name` | Contexts in single config | kubectl |
| kubectl | `kubectl config use-context` | Contexts in single config | kubectl |

### Perfect for:
- ✅ **Managing separate kubeconfig files per cluster**
- ✅ **Keeping ~/.kube/config clean and organized**
- ✅ **Managing multiple clusters**
- ✅ **CI/CD environments**  
- ✅ **Homebrew users**
- ✅ **Cross-platform usage**
- ✅ **Minimal dependencies**

## � AWS EKS Integration

kcontext works great with AWS EKS! Use the AWS CLI to fetch kubeconfigs, then switch between them with kcontext.

### Workflow Example

```bash
# 1. Fetch kubeconfig for an EKS cluster (one-time per cluster)
aws eks update-kubeconfig --name my-cluster --kubeconfig ~/.kube/my-cluster.kubeconfig

# 2. Switch to it instantly with kcontext
kcontext my-cluster.kubeconfig

# 3. Verify
kubectl cluster-info
```

### Multiple EKS Clusters

```bash
# Fetch multiple cluster configs
aws eks update-kubeconfig --name prod-cluster --kubeconfig ~/.kube/prod.kubeconfig
aws eks update-kubeconfig --name staging-cluster --kubeconfig ~/.kube/staging.kubeconfig
aws eks update-kubeconfig --name dev-cluster --kubeconfig ~/.kube/dev.kubeconfig

# Switch between them easily
kcontext prod.kubeconfig
kcontext staging.kubeconfig
kcontext dev.kubeconfig
```

### Helper Script (Optional)

For convenience, you can create a helper script to list and fetch EKS clusters:

```bash
# List all EKS clusters
aws eks list-clusters --output text --query 'clusters[*]'

# Fetch a specific cluster
aws eks update-kubeconfig --name <cluster-name> --kubeconfig ~/.kube/<cluster-name>.kubeconfig
```

See `orig/k8sconfig` for a complete example script that automates this workflow.

**Note:** kcontext intentionally has no AWS dependencies - it just switches between kubeconfig files. Use AWS CLI or your preferred tool to manage the kubeconfig files themselves.

## �🛠️ Development

### Build locally
```bash
cargo build --release
# Binary will be in target/release/kcontext
```

### Run tests
```bash
cargo test
```

### Release process
1. Tag version: `git tag v0.0.2`
2. Push tag: `git push origin v0.0.2`  
3. GitHub Actions will build and release binaries
4. Update Homebrew formula if needed

### Local Homebrew testing
```bash
# Install via Homebrew from local build
make brew-install-local

# Test the installation
kcontext --version
kcontext --list

# Reinstall after changes
make brew-reinstall-local
```

See [docs/HOMEBREW_LOCAL_DEV.md](docs/HOMEBREW_LOCAL_DEV.md) for detailed Homebrew development guide.

## 🧪 Testing in Docker

Test in a clean environment without polluting your local setup:

```bash
# Run automated tests in container
./scripts/test-docker.sh

# Or enter interactive container
docker-compose run --rm kcontext-test

# Inside container (build fresh to avoid arch issues):
rm -f kcontext      # Remove any host binary
make build          # Build for container arch
make test           # Run tests
eval "$(./kcontext --init bash)"
kcontext dev.kubeconfig
echo $KUBECONFIG
```

The container comes with fake kubeconfig files (dev.kubeconfig, staging.kubeconfig, production.kubeconfig) for testing.

## 🏗️ Project Structure
```
kcontext/
├── src/
│   ├── main.rs             # Core application logic
│   ├── shell_init.rs       # Shell integration code
│   └── tests.rs            # Unit tests
├── Cargo.toml              # Rust dependencies and metadata
├── Cargo.lock              # Dependency lock file
├── Makefile                # Build tasks
├── scripts/
│   └── build.sh            # Multi-platform build script
├── homebrew/               # Homebrew formula
│   └── kcontext.rb
├── docker/                 # Docker test environment
├── orig/                   # Original bash scripts
└── README.md               # Documentation
```

## 📋 Requirements

- Rust 1.70+ (for building)
- Kubeconfig files in `~/.kube/*.kubeconfig` format
- Docker (optional, for isolated testing)

## 🤝 Contributing

1. Fork the project
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Test in Docker: `./scripts/test-docker.sh`
4. Commit changes: `git commit -m 'Add amazing feature'`
5. Push to branch: `git push origin feature/amazing-feature`
6. Open pull request

## 📄 License

MIT License - see LICENSE file for details.

---

**Made with ❤️ for Kubernetes users who want simple kubeconfig switching**
