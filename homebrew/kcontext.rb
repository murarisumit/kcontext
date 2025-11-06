class Kcontext < Formula
  desc "Simple Kubernetes kubeconfig switcher CLI"
  homepage "https://github.com/murarisumit/kcontext"
  version "0.0.2"
  
  # Determine the project root by going up from the formula location
  # This formula can be in homebrew/ or in a tap's Formula/ directory
  formula_dir = File.dirname(__FILE__)
  project_root = if formula_dir.end_with?("homebrew")
    File.expand_path("..", formula_dir)
  else
    # We're in a tap, find the original project
    File.expand_path("#{ENV['HOME']}/workspace/personal/kcontext")
  end
  
  dist_dir = File.join(project_root, "dist")
  
  #  Check if we're doing a local build (dist directory exists with binaries)
  if File.directory?(dist_dir) && Dir.glob(File.join(dist_dir, "kcontext-*")).any?
    # Local build mode
    if OS.mac?
      if Hardware::CPU.intel?
        url "file://#{File.join(dist_dir, 'kcontext-darwin-amd64')}"
      else
        url "file://#{File.join(dist_dir, 'kcontext-darwin-arm64')}"
      end
    elsif OS.linux?
      if Hardware::CPU.intel?
        url "file://#{File.join(dist_dir, 'kcontext-linux-amd64')}"
      else
        url "file://#{File.join(dist_dir, 'kcontext-linux-arm64')}"
      end
    end
    # Don't specify sha256 for local builds - Homebrew will skip verification for file:// URLs
  else
    # Release mode - use GitHub releases
    on_macos do
      if Hardware::CPU.intel?
        url "https://github.com/murarisumit/kcontext/releases/download/v#{version}/kcontext-darwin-amd64"
        sha256 "" # Will be filled automatically by Homebrew when you release
      else
        url "https://github.com/murarisumit/kcontext/releases/download/v#{version}/kcontext-darwin-arm64"
        sha256 "" # Will be filled automatically by Homebrew when you release
      end
    end

    on_linux do
      if Hardware::CPU.intel?
        url "https://github.com/murarisumit/kcontext/releases/download/v#{version}/kcontext-linux-amd64"
        sha256 "" # Will be filled automatically by Homebrew when you release
      else
        url "https://github.com/murarisumit/kcontext/releases/download/v#{version}/kcontext-linux-arm64"
        sha256 "" # Will be filled automatically by Homebrew when you release
      end
    end
  end

  def install
    # The downloaded/cached file will have the original name (e.g., kcontext-darwin-arm64)
    # Find it and rename during installation
    bin.install Dir["kcontext-*"].reject { |f| f.end_with?('.exe') }.first => "kcontext"
  end

  def caveats
    <<~EOS
      To enable kcontext, add this one line to your shell config:

      Bash (~/.bashrc):
        eval "$(kcontext --init bash)"

      Zsh (~/.zshrc):
        eval "$(kcontext --init zsh)"

      Fish (~/.config/fish/config.fish):
        kcontext --init fish | source

      Then reload your shell and use: kcontext <kubeconfig-name>
    EOS
  end

  test do
    system "#{bin}/kcontext", "--version"
    system "#{bin}/kcontext", "--list"
  end
end
