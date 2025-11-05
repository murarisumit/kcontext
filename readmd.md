# Original Scripts

This directory contains the original bash scripts and completion code used for kubeconfig and context switching.

## Files

- `k8sconfig` - Original bash script for EKS cluster management
  - Lists EKS clusters
  - Fetches kubeconfig for specific clusters
  
- `k8sconfig_completion` - Bash completion for k8sconfig
  - Provides tab completion for k8sconfig commands

- `k8scontext` - Original bash script for kubeconfig switching  
  - Switches between kubeconfig files in ~/.kube/*.kubeconfig
  - Sources in ~/.bashrc
  
- `k8scontext_completion` - Bash completion for kcontext
  - Provides tab completion for available kubeconfig files

## Migration from Old to New

### Old Approach (Bash Scripts)
```bash
# In ~/.bashrc
source /path/to/k8scontext
source /path/to/k8scontext_completion

# Usage
kcontext my-cluster.kubeconfig
```

**Limitations:**
- ❌ Bash-only (no zsh/fish support)
- ❌ Requires sourcing multiple files
- ❌ Not portable across systems
- ❌ No package manager support

### New Approach (Go Binary)
```bash
# One-time setup in ~/.bashrc
eval "$(kcontext --init bash)"

# Usage (exactly the same!)
kcontext my-cluster.kubeconfig
```

**Advantages:**
- ✅ Single binary, no dependencies
- ✅ Multi-shell support (bash/zsh/fish)
- ✅ Cross-platform (macOS/Linux/Windows)
- ✅ Homebrew installable
- ✅ Faster execution
- ✅ Better error handling

## Why Rewrite in Go?

The new Go-based `kcontext` tool provides the same functionality with:
- Better performance (compiled binary vs interpreted bash)
- Cleaner shell integration (single eval line)
- Cross-platform compatibility
- Easy installation via Homebrew
- Built-in shell completion for all supported shells
- Professional error handling and validation

These scripts are kept in the `orig/` directory for reference and backwards compatibility.

