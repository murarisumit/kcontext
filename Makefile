.PHONY: build clean test verify install release help brew-tap-local brew-install-local brew-uninstall brew-untap-local brew-reinstall-local brew-test-local

BINARY_NAME=kcontext
VERSION?=dev
BUILD_DIR=dist
BIN_DIR=target/release

all: build

build:
	cargo build --release

build-all:
	@mkdir -p $(BUILD_DIR)
	./scripts/build.sh $(VERSION)

clean:
	cargo clean
	rm -rf $(BUILD_DIR)

test:
	cargo test

verify: build test
	@echo "Verifying binary..."
	@./$(BIN_DIR)/$(BINARY_NAME) --version
	@./$(BIN_DIR)/$(BINARY_NAME) --list

# Test in Docker container (clean environment)
docker-test:
	@echo "🐳 Running tests in Docker..."
	@cd docker && ../scripts/test-docker.sh

# Enter Docker container for interactive testing
docker-shell:
	@echo "🐚 Starting interactive Docker shell..."
	@cd docker && docker-compose run --rm kcontext-test

# Quick setup: build container and show instructions
docker-setup:
	@echo "🐳 Setting up Docker test environment..."
	@cd docker && docker-compose build
	@echo ""
	@echo "✅ Container ready! To test:"
	@echo ""
	@echo "1. Enter container:"
	@echo "   make docker-shell"
	@echo ""
	@echo "2. Inside container, run:"
	@echo "   make build"
	@echo "   make install"
	@echo "   eval \"\$$(kcontext --init bash)\""
	@echo ""
	@echo "3. Test installation:"
	@echo "   kcontext --version"
	@echo "   kcontext --list"
	@echo ""
	@echo "4. Test shell completion (press TAB):"
	@echo "   kcontext <TAB>"
	@echo ""
	@echo "5. Test kubeconfig switching:"
	@echo "   kcontext dev.kubeconfig"
	@echo "   echo \$$KUBECONFIG"
	@echo "   kcontext staging.kubeconfig"
	@echo "   echo \$$KUBECONFIG"

install:
	@if [ ! -f $(BIN_DIR)/$(BINARY_NAME) ]; then \
		echo "Error: $(BIN_DIR)/$(BINARY_NAME) not found. Run 'make build' first."; \
		exit 1; \
	fi
	@if [ -w /usr/local/bin ]; then \
		cp $(BIN_DIR)/$(BINARY_NAME) /usr/local/bin/$(BINARY_NAME); \
	else \
		sudo cp $(BIN_DIR)/$(BINARY_NAME) /usr/local/bin/$(BINARY_NAME); \
	fi
	@strip /usr/local/bin/$(BINARY_NAME) 2>/dev/null || true
	@echo "✅ Installed to /usr/local/bin/"

release:
	@echo "Creating release v$(VERSION)..."
	git tag -a v$(VERSION) -m "Release v$(VERSION)"
	git push origin v$(VERSION)
	@echo "🚀 Release pushed. GitHub Actions will build binaries."

# Homebrew local installation targets
brew-tap-local:
	@echo "🍺 Creating/updating local Homebrew tap..."
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "❌ Error: Homebrew not found. Please install Homebrew first."; \
		exit 1; \
	fi
	@# Check if tap already exists
	@if brew tap | grep -q "murarisumit/tap"; then \
		echo "✅ Tap murarisumit/tap already exists"; \
	else \
		echo "📦 Creating new tap murarisumit/tap..."; \
		brew tap-new murarisumit/tap; \
	fi
	@# Copy formula to the tap
	@TAP_DIR=$$(brew --repository)/Library/Taps/murarisumit/homebrew-tap; \
	mkdir -p $$TAP_DIR/Formula; \
	cp homebrew/kcontext.rb $$TAP_DIR/Formula/; \
	echo "✅ Formula copied to tap"

brew-install-local: build-all brew-tap-local
	@echo "🍺 Installing kcontext via Homebrew (local build)..."
	@HOMEBREW_NO_AUTO_UPDATE=1 brew install --force --formula murarisumit/tap/kcontext
	@echo "✅ Installed via Homebrew!"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Add to your shell config:"
	@echo "     eval \"\$$(kcontext --init bash)\"  # or zsh/fish"
	@echo "  2. Reload your shell"
	@echo "  3. Test: kcontext --version"

brew-uninstall:
	@echo "🗑️  Uninstalling kcontext via Homebrew..."
	@if command -v brew >/dev/null 2>&1; then \
		brew uninstall kcontext 2>/dev/null || echo "kcontext not installed via Homebrew"; \
	else \
		echo "❌ Homebrew not found"; \
	fi

brew-untap-local:
	@echo "🗑️  Removing local tap..."
	@if command -v brew >/dev/null 2>&1; then \
		brew untap murarisumit/tap 2>/dev/null || echo "Tap not found"; \
	fi

brew-reinstall-local: brew-uninstall brew-install-local

brew-test-local: brew-install-local
	@echo ""
	@echo "🧪 Testing Homebrew installation..."
	@kcontext --version
	@kcontext --list
	@echo "✅ Homebrew installation works!"

help:
	@echo "Available targets:"
	@echo "  build                - Build binary"
	@echo "  build-all            - Build for all platforms"
	@echo "  clean                - Remove build artifacts"
	@echo "  test                 - Run tests"
	@echo "  verify               - Build + test + verify"
	@echo "  docker-test          - Test in clean Docker environment"
	@echo "  docker-shell         - Interactive Docker shell"
	@echo "  docker-setup         - Build + install inside container"
	@echo "  install              - Install to /usr/local/bin"
	@echo "  brew-tap-local       - Create/update local Homebrew tap"
	@echo "  brew-install-local   - Install via Homebrew (local)"
	@echo "  brew-uninstall       - Uninstall via Homebrew"
	@echo "  brew-untap-local     - Remove local Homebrew tap"
	@echo "  brew-reinstall-local - Reinstall via Homebrew (local)"
	@echo "  brew-test-local      - Install and test via Homebrew"
	@echo "  release              - Tag and push release"
