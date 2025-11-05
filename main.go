package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"
)

var version = "0.0.1"

func main() {
	var showVersion = flag.Bool("version", false, "Show version")
	var listConfigs = flag.Bool("list", false, "List available kubeconfig files")
	var shellMode = flag.Bool("shell", false, "Output shell command (for sourcing)")
	var initShell = flag.String("init", "", "Generate shell integration (bash, zsh, fish)")
	flag.Parse()

	if *showVersion {
		fmt.Printf("kcontext version %s\n", version)
		return
	}

	if *initShell != "" {
		printShellInit(*initShell)
		return
	}

	configs := getKubeconfigs()

	if *listConfigs {
		if len(configs) > 0 {
			fmt.Printf("Available kubeconfigs: %s\n", strings.Join(configs, " "))
		} else {
			fmt.Println("No kubeconfig files found in ~/.kube/*.kubeconfig")
		}
		return
	}

	if len(flag.Args()) == 0 {
		showHelp(configs)
		return
	}

	config := flag.Args()[0]

	// Validate config exists
	found := false
	for _, c := range configs {
		if c == config {
			found = true
			break
		}
	}

	if !found {
		fmt.Fprintf(os.Stderr, "Error: kubeconfig '%s' not found\n", config)
		showHelp(configs)
		os.Exit(1)
	}

	if *shellMode {
		// Output shell command for eval integration
		kubeconfigPath := filepath.Join(os.Getenv("HOME"), ".kube", config)
		fmt.Printf("export KUBECONFIG='%s'", kubeconfigPath)
	} else {
		// Direct execution - shell wrapper handles this
		fmt.Fprintf(os.Stderr, "Error: Shell integration not loaded. Run setup:\n")
		fmt.Fprintf(os.Stderr, "  eval \"$(kcontext --init bash)\"  # Add to ~/.bashrc\n")
		os.Exit(1)
	}
}

func showHelp(configs []string) {
	fmt.Printf("Usage: kcontext <kubeconfig-name>\n\n")
	fmt.Printf("Setup: Add to your shell config:\n")
	fmt.Printf("  Bash:  eval \"$(kcontext --init bash)\"\n")
	fmt.Printf("  Zsh:   eval \"$(kcontext --init zsh)\"\n")
	fmt.Printf("  Fish:  kcontext --init fish | source\n\n")
	fmt.Printf("Options:\n")
	fmt.Printf("  --init <shell>  Generate shell integration (bash, zsh, fish)\n")
	fmt.Printf("  --list          List available kubeconfig files\n")
	fmt.Printf("  --version       Show version\n")
	fmt.Printf("  --shell         Output shell command (for eval integration)\n")
	fmt.Printf("\n")
	if len(configs) > 0 {
		fmt.Printf("Available kubeconfigs: %s\n", strings.Join(configs, " "))
	} else {
		fmt.Printf("No kubeconfig files found in ~/.kube/*.kubeconfig\n")
	}
}

func getKubeconfigs() []string {
	homeDir := os.Getenv("HOME")
	if homeDir == "" {
		return []string{}
	}

	kubeDir := filepath.Join(homeDir, ".kube")
	pattern := filepath.Join(kubeDir, "*.kubeconfig")

	matches, err := filepath.Glob(pattern)
	if err != nil {
		return []string{}
	}

	var configs []string
	for _, match := range matches {
		base := filepath.Base(match)
		configs = append(configs, base)
	}

	sort.Strings(configs)
	return configs
}

func printShellInit(shell string) {
	switch shell {
	case "bash":
		fmt.Print(bashInit)
	case "zsh":
		fmt.Print(zshInit)
	case "fish":
		fmt.Print(fishInit)
	default:
		fmt.Fprintf(os.Stderr, "Error: unsupported shell '%s'. Supported: bash, zsh, fish\n", shell)
		os.Exit(1)
	}
}
