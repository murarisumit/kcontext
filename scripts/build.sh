#!/bin/bash

# Build script for kcontext (Rust) - creates binaries for multiple platforms

VERSION=${1:-"dev"}
BUILD_DIR="dist"

echo "🚀 Building kcontext v$VERSION for multiple platforms..."

# Clean and create build directory
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR

# Update version in Cargo.toml if not dev
if [ "$VERSION" != "dev" ]; then
    echo "📝 Updating version to $VERSION in Cargo.toml..."
    sed -i.bak "s/^version = .*/version = \"$VERSION\"/" Cargo.toml
    rm -f Cargo.toml.bak
fi

# Build for macOS (Intel) - requires macOS host or cross-compilation setup
echo "📦 Building for macOS (Intel)..."
if command -v cargo &> /dev/null; then
    cargo build --release --target x86_64-apple-darwin 2>/dev/null && \
        cp target/x86_64-apple-darwin/release/kcontext "$BUILD_DIR/kcontext-darwin-amd64" || \
        echo "⚠️  Skipping macOS Intel (cross-compilation not available)"
fi

# Build for macOS (Apple Silicon)
echo "📦 Building for macOS (Apple Silicon)..."
if command -v cargo &> /dev/null; then
    cargo build --release --target aarch64-apple-darwin 2>/dev/null && \
        cp target/aarch64-apple-darwin/release/kcontext "$BUILD_DIR/kcontext-darwin-arm64" || \
        echo "⚠️  Skipping macOS ARM (cross-compilation not available)"
fi

# Build for Linux (Intel)
echo "📦 Building for Linux (Intel)..."
cargo build --release --target x86_64-unknown-linux-gnu 2>/dev/null && \
    cp target/x86_64-unknown-linux-gnu/release/kcontext "$BUILD_DIR/kcontext-linux-amd64" || \
    (cargo build --release && cp target/release/kcontext "$BUILD_DIR/kcontext-linux-amd64")

# Build for Linux (ARM64)
echo "📦 Building for Linux (ARM64)..."
cargo build --release --target aarch64-unknown-linux-gnu 2>/dev/null && \
    cp target/aarch64-unknown-linux-gnu/release/kcontext "$BUILD_DIR/kcontext-linux-arm64" || \
    echo "⚠️  Skipping Linux ARM64 (cross-compilation not available)"

# Build for Windows
echo "📦 Building for Windows..."
cargo build --release --target x86_64-pc-windows-gnu 2>/dev/null && \
    cp target/x86_64-pc-windows-gnu/release/kcontext.exe "$BUILD_DIR/kcontext-windows-amd64.exe" || \
    echo "⚠️  Skipping Windows (cross-compilation not available)"

# Strip binaries to reduce size
echo "🔧 Stripping binaries..."
for file in $BUILD_DIR/kcontext-*; do
    if [ -f "$file" ] && [[ ! "$file" =~ \.exe$ ]]; then
        strip "$file" 2>/dev/null || true
    fi
done

# List built files
echo ""
echo "✅ Build complete! Files created:"
ls -lh $BUILD_DIR/

echo ""
echo "🍺 To test locally:"
ARCH=$(uname -m | sed 's/x86_64/amd64/; s/aarch64/arm64/')
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
TEST_BINARY="$BUILD_DIR/kcontext-${OS}-${ARCH}"
if [ -f "$TEST_BINARY" ]; then
    echo "  chmod +x $TEST_BINARY"
    echo "  $TEST_BINARY --version"
fi
