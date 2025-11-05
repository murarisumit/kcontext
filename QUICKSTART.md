# Quick Start Guide

Get started with kcontext in under 2 minutes! 🚀

## Installation

### Option 1: Homebrew (Recommended)
```bash
brew tap murarisumit/tap
brew install kcontext
```

### Option 2: Download Binary
```bash
# Download for macOS (Apple Silicon)
curl -L https://github.com/murarisumit/kcontext/releases/latest/download/kcontext-darwin-arm64 -o kcontext
chmod +x kcontext
sudo mv kcontext /usr/local/bin/

# Or for macOS (Intel)
curl -L https://github.com/murarisumit/kcontext/releases/latest/download/kcontext-darwin-amd64 -o kcontext
chmod +x kcontext
sudo mv kcontext /usr/local/bin/
```

## Setup Shell Integration

Add **one line** to your shell configuration:

### Bash
```bash
echo 'eval "$(kcontext --init bash)"' >> ~/.bashrc
source ~/.bashrc
```

### Zsh
```bash
echo 'eval "$(kcontext --init zsh)"' >> ~/.zshrc
source ~/.zshrc
```

### Fish
```bash
echo 'kcontext --init fish | source' >> ~/.config/fish/config.fish
source ~/.config/fish/config.fish
```

## Verify Installation

```bash
kcontext --version
kcontext --list
```

## Basic Usage

### List Available Kubeconfigs
```bash
kcontext --list
```

### Switch to a Kubeconfig
```bash
kcontext my-cluster.kubeconfig
```

### Verify Current Context
```bash
echo $KUBECONFIG
kubectl config current-context
```

## Organizing Your Kubeconfigs

kcontext looks for kubeconfig files in `~/.kube/*.kubeconfig`. Organize them like:

```
~/.kube/
├── dev.kubeconfig
├── staging.kubeconfig
├── production.kubeconfig
├── client-a.kubeconfig
└── client-b.kubeconfig
```

Then switch between them easily:
```bash
kcontext dev.kubeconfig
kcontext production.kubeconfig
```

## Tab Completion

Tab completion is automatically enabled after shell integration:

```bash
kcontext <TAB>  # Shows all available kubeconfig files
```

## Tips

1. **Prefix your kubeconfigs**: Use naming like `prod-`, `dev-`, `staging-` for easy identification
2. **Quick switching**: Use tab completion to avoid typing full names
3. **Check before you act**: Always verify your context after switching:
   ```bash
   kcontext prod.kubeconfig && kubectl config current-context
   ```

## Troubleshooting

### Not seeing your kubeconfig files?
Ensure they:
- Are in `~/.kube/` directory
- End with `.kubeconfig` extension
- Have proper read permissions

### Shell integration not working?
1. Verify you added the init line to your shell config
2. Reload your shell: `source ~/.bashrc` (or `~/.zshrc`)
3. Check if kcontext is in your PATH: `which kcontext`

## Next Steps

- Read the [full README](README.md) for advanced features
- Check [CONTRIBUTING.md](CONTRIBUTING.md) to contribute
- Report issues on [GitHub](https://github.com/murarisumit/kcontext/issues)

---

**Happy cluster switching! 🎉**
