use clap::Parser;
use glob::glob;
use std::env;
use std::process;

mod shell_init;

const VERSION: &str = env!("CARGO_PKG_VERSION");

#[derive(Parser)]
#[command(name = "kcontext")]
#[command(about = "Simple Kubernetes kubeconfig switcher CLI", long_about = None)]
struct Cli {
    /// Kubeconfig file name to switch to
    config: Option<String>,

    /// Show version
    #[arg(short = 'v', long)]
    version: bool,

    /// List available kubeconfig files
    #[arg(short = 'l', long)]
    list: bool,

    /// Output shell command (for sourcing)
    #[arg(long)]
    shell: bool,

    /// Generate shell integration (bash, zsh, fish)
    #[arg(long, value_name = "SHELL")]
    init: Option<String>,
}

fn main() {
    let cli = Cli::parse();

    if cli.version {
        println!("kcontext version {}", VERSION);
        return;
    }

    if let Some(shell) = cli.init {
        shell_init::print_shell_init(&shell);
        return;
    }

    let configs = get_kubeconfigs();

    if cli.list {
        if configs.is_empty() {
            println!("No kubeconfig files found in ~/.kube/*.kubeconfig");
        } else {
            println!("Available kubeconfigs: {}", configs.join(" "));
        }
        return;
    }

    if let Some(config) = cli.config {
        // Validate config exists
        if !configs.contains(&config) {
            eprintln!("Error: kubeconfig '{}' not found", config);
            show_help(&configs);
            process::exit(1);
        }

        if cli.shell {
            // Output shell command for eval integration
            let home = env::var("HOME").unwrap_or_else(|_| String::from("."));
            let kubeconfig_path = format!("{}/.kube/{}", home, config);
            print!("export KUBECONFIG='{}'", kubeconfig_path);
        } else {
            // Direct execution - shell wrapper handles this
            eprintln!("Error: Shell integration not loaded. Run setup:");
            eprintln!("  eval \"$(kcontext --init bash)\"  # Add to ~/.bashrc");
            process::exit(1);
        }
    } else {
        show_help(&configs);
    }
}

fn show_help(configs: &[String]) {
    println!("Usage: kcontext <kubeconfig-name>\n");
    println!("Setup: Add to your shell config:");
    println!("  Bash:  eval \"$(kcontext --init bash)\"");
    println!("  Zsh:   eval \"$(kcontext --init zsh)\"");
    println!("  Fish:  kcontext --init fish | source\n");
    println!("Options:");
    println!("  --init <shell>  Generate shell integration (bash, zsh, fish)");
    println!("  --list          List available kubeconfig files");
    println!("  --version       Show version");
    println!("  --shell         Output shell command (for eval integration)\n");
    
    if configs.is_empty() {
        println!("No kubeconfig files found in ~/.kube/*.kubeconfig");
    } else {
        println!("Available kubeconfigs: {}", configs.join(" "));
    }
}

fn get_kubeconfigs() -> Vec<String> {
    let home = match env::var("HOME") {
        Ok(h) => h,
        Err(_) => return Vec::new(),
    };

    let pattern = format!("{}/.kube/*.kubeconfig", home);
    
    let mut kubeconfigs: Vec<String> = glob(&pattern)
        .ok()
        .into_iter()
        .flat_map(|paths| paths.filter_map(Result::ok))
        .filter_map(|path| {
            path.file_name()
                .and_then(|name| name.to_str())
                .map(|s| s.to_string())
        })
        .collect();

    kubeconfigs.sort();
    kubeconfigs
}
