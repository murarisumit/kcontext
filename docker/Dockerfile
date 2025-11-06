FROM rust:1.70-bookworm

# Install common tools
RUN apt-get update && apt-get install -y \
    git \
    make \
    bash \
    zsh \
    fish \
    curl \
    tree \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -s /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create fake kubeconfig files for testing
RUN mkdir -p /home/vscode/.kube && \
    echo 'apiVersion: v1\nkind: Config\ncurrent-context: dev\nclusters:\n- cluster:\n    server: https://dev-cluster.example.com\n  name: dev' > /home/vscode/.kube/dev.kubeconfig && \
    echo 'apiVersion: v1\nkind: Config\ncurrent-context: staging\nclusters:\n- cluster:\n    server: https://staging-cluster.example.com\n  name: staging' > /home/vscode/.kube/staging.kubeconfig && \
    echo 'apiVersion: v1\nkind: Config\ncurrent-context: production\nclusters:\n- cluster:\n    server: https://prod-cluster.example.com\n  name: production' > /home/vscode/.kube/production.kubeconfig && \
    chown -R vscode:vscode /home/vscode/.kube

USER vscode
WORKDIR /workspace

# Set up shells with kcontext init (will be added after install)
RUN echo 'PS1="dev-container:\w\$ "' >> /home/vscode/.bashrc && \
    touch /home/vscode/.zshrc && \
    mkdir -p /home/vscode/.config/fish
