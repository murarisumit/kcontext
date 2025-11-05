#!/bin/bash

# Build script for kcontext - creates binaries for multiple platforms

VERSION=${1:-"dev"}
BUILD_DIR="dist"

echo "🚀 Building kcontext v$VERSION for multiple platforms..."

# Clean and create build directory
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR

# Build for macOS (Intel)
echo "📦 Building for macOS (Intel)..."
GOOS=darwin GOARCH=amd64 go build -ldflags "-X main.version=$VERSION" -o "$BUILD_DIR/kcontext-darwin-amd64" .

# Build for macOS (Apple Silicon)  
echo "📦 Building for macOS (Apple Silicon)..."
GOOS=darwin GOARCH=arm64 go build -ldflags "-X main.version=$VERSION" -o "$BUILD_DIR/kcontext-darwin-arm64" .

# Build for Linux (Intel)
echo "📦 Building for Linux (Intel)..."
GOOS=linux GOARCH=amd64 go build -ldflags "-X main.version=$VERSION" -o "$BUILD_DIR/kcontext-linux-amd64" .

# Build for Linux (ARM)
echo "📦 Building for Linux (ARM64)..."
GOOS=linux GOARCH=arm64 go build -ldflags "-X main.version=$VERSION" -o "$BUILD_DIR/kcontext-linux-arm64" .

# Build for Windows
echo "📦 Building for Windows..."
GOOS=windows GOARCH=amd64 go build -ldflags "-X main.version=$VERSION" -o "$BUILD_DIR/kcontext-windows-amd64.exe" .

# List built files
echo ""
echo "✅ Build complete! Files created:"
ls -la $BUILD_DIR/

echo ""
echo "🍺 To test locally:"
echo "  chmod +x $BUILD_DIR/kcontext-$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m | sed 's/x86_64/amd64/')"
echo "  $BUILD_DIR/kcontext-$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m | sed 's/x86_64/amd64/') --version"
