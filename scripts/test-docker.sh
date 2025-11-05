#!/bin/bash
# Test script for kcontext in Docker container

set -e

# Change to docker directory
cd "$(dirname "$0")/../docker"

echo "🐳 Building test container..."
docker-compose build

echo ""
echo "🚀 Starting container..."
docker-compose run --rm kcontext-test bash -c '
    echo "📦 Building kcontext..."
    make build
    
    echo ""
    echo "🧪 Running tests..."
    make test
    
    echo ""
    echo "📋 Available kubeconfig files:"
    ./bin/kcontext --list
    
    echo ""
    echo "🐚 Testing Bash integration..."
    export PATH="$PWD/bin:$PATH"
    bash -c "eval \"\$(kcontext --init bash)\" && kcontext dev.kubeconfig && echo \"Current KUBECONFIG: \$KUBECONFIG\""
    
    echo ""
    echo "🐚 Testing Zsh integration..."
    zsh -c "export PATH=\"$PWD/bin:\$PATH\" && eval \"\$(kcontext --init zsh)\" && kcontext staging.kubeconfig && echo \"Current KUBECONFIG: \$KUBECONFIG\""
    
    echo ""
    echo "🐟 Testing Fish integration..."
    fish -c "set -x PATH $PWD/bin \$PATH; kcontext --init fish | source; and kcontext production.kubeconfig; and echo \"Current KUBECONFIG: \$KUBECONFIG\""
    
    echo ""
    echo "✅ All tests passed!"
'

echo ""
echo "💡 To enter interactive container, run:"
echo "   docker-compose run --rm kcontext-test"
