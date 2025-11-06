// Shell integration strings embedded directly in the binary

const BASH_INIT: &str = r#"# kcontext shell integration for bash
function kcontext {
    # Pass flags directly to the binary
    if [ "$1" = "--list" ] || [ "$1" = "--version" ] || [ "$1" = "--help" ] || [ -z "$1" ]; then
        command kcontext "$@"
        return $?
    fi
    
    # Get the export command from the binary and evaluate it
    local cmd
    cmd=$(command kcontext --shell "$@")
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        eval "$cmd"
    else
        return $exit_code
    fi
}

# Bash completion
function _kcontext_completion {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local configs
    configs=$(command kcontext --list 2>/dev/null | sed 's/Available kubeconfigs: //')
    mapfile -t COMPREPLY < <(compgen -W "${configs}" -- "${cur}")
}

complete -F _kcontext_completion kcontext
"#;

const ZSH_INIT: &str = r#"# kcontext shell integration for zsh
function kcontext {
    # Pass flags directly to the binary
    if [ "$1" = "--list" ] || [ "$1" = "--version" ] || [ "$1" = "--help" ] || [ -z "$1" ]; then
        command kcontext "$@"
        return $?
    fi
    
    # Get the export command from the binary and evaluate it
    local cmd
    cmd=$(command kcontext --shell "$@")
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        eval "$cmd"
    else
        return $exit_code
    fi
}

# Zsh completion
function _kcontext_completion {
    local -a configs
    configs=(${(f)"$(command kcontext --list 2>/dev/null | sed 's/Available kubeconfigs: //')"})
    _describe 'kubeconfig' configs
}

compdef _kcontext_completion kcontext
"#;

const FISH_INIT: &str = r#"# kcontext shell integration for fish
function kcontext
    # Pass flags directly to the binary
    if test "$argv[1]" = "--list"; or test "$argv[1]" = "--version"; or test "$argv[1]" = "--help"; or test (count $argv) -eq 0
        command kcontext $argv
        return $status
    end
    
    # Get the export command from the binary and evaluate it
    set -l cmd (command kcontext --shell $argv)
    set -l exit_code $status
    
    if test $exit_code -eq 0
        eval $cmd
    else
        return $exit_code
    end
end

# Fish completion
complete -c kcontext -f -a "(command kcontext --list 2>/dev/null | sed 's/Available kubeconfigs: //')"
"#;

/// Print shell initialization script for the given shell
pub fn print_shell_init(shell: &str) {
    match shell {
        "bash" => print!("{}", BASH_INIT),
        "zsh" => print!("{}", ZSH_INIT),
        "fish" => print!("{}", FISH_INIT),
        _ => {
            eprintln!("Error: unsupported shell '{}'. Supported: bash, zsh, fish", shell);
            std::process::exit(1);
        }
    }
}
