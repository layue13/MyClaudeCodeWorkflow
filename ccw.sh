#!/bin/bash

set -e

REPO_URL="https://github.com/layue13/MyClaudeCodeWorkflow.git"
INSTALL_DIR="$HOME/.claude-workflow"
BIN_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/claude"

print_usage() {
    echo "Claude Code Workflow Installer"
    echo ""
    echo "Usage: $0 [install|update|uninstall]"
    echo ""
    echo "Commands:"
    echo "  install     Install Claude Code Workflow globally"
    echo "  update      Update to latest version"
    echo "  uninstall   Remove Claude Code Workflow"
    echo ""
    echo "Default: install"
}

check_dependencies() {
    echo "Checking dependencies..."

    if ! command -v git &> /dev/null; then
        echo "Error: git is required but not installed"
        exit 1
    fi

    if ! command -v claude &> /dev/null; then
        echo "Warning: Claude Code CLI not found. Please install it first:"
        echo "  npm install -g @anthropic-ai/claude-cli"
        echo ""
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi

    echo "Dependencies check passed."
}

install_workflow() {
    echo "Installing Claude Code Workflow..."

    # Create directories
    mkdir -p "$BIN_DIR"
    mkdir -p "$CONFIG_DIR"

    # Clone or update repository
    if [ -d "$INSTALL_DIR" ]; then
        echo "Updating existing installation..."
        cd "$INSTALL_DIR"
        git pull origin main
    else
        echo "Cloning repository..."
        git clone "$REPO_URL" "$INSTALL_DIR"
    fi

    # Create global configuration symlinks
    echo "Setting up global configuration..."

    # Link .claude directory to global config
    if [ -L "$CONFIG_DIR/agents" ]; then
        rm "$CONFIG_DIR/agents"
    elif [ -d "$CONFIG_DIR/agents" ]; then
        echo "Warning: Existing agents directory found. Backing up..."
        mv "$CONFIG_DIR/agents" "$CONFIG_DIR/agents.backup.$(date +%s)"
    fi

    ln -sf "$INSTALL_DIR/.claude/agents" "$CONFIG_DIR/agents"

    # Copy CLAUDE.md to global config
    cp "$INSTALL_DIR/CLAUDE.md" "$CONFIG_DIR/CLAUDE.md"

    # Create wrapper script
    cat > "$BIN_DIR/ccw" << 'EOF'
#!/bin/bash

WORKFLOW_DIR="$HOME/.claude-workflow"
CONFIG_DIR="$HOME/.config/claude"

case "$1" in
    init)
        echo "Initializing Claude Code Workflow in current directory..."

        # Copy CLAUDE.md if not exists
        if [ ! -f "CLAUDE.md" ]; then
            cp "$CONFIG_DIR/CLAUDE.md" ./CLAUDE.md
            echo "✓ Created CLAUDE.md"
        else
            echo "✓ CLAUDE.md already exists"
        fi

        # Create .claude directory if not exists
        if [ ! -d ".claude" ]; then
            mkdir -p .claude
            echo "✓ Created .claude directory"
        fi

        # Link agents if not exists
        if [ ! -L ".claude/agents" ] && [ ! -d ".claude/agents" ]; then
            ln -sf "$CONFIG_DIR/agents" .claude/agents
            echo "✓ Linked Claude agents"
        else
            echo "✓ Claude agents already configured"
        fi

        echo ""
        echo "Claude Code Workflow initialized successfully!"
        echo "You can now use 'claude' command with the workflow configuration."
        ;;

    update)
        echo "Updating Claude Code Workflow..."
        cd "$WORKFLOW_DIR"
        git pull origin main
        cp CLAUDE.md "$CONFIG_DIR/CLAUDE.md"
        echo "✓ Updated to latest version"
        ;;

    status)
        echo "Claude Code Workflow Status:"
        echo "Installation: $WORKFLOW_DIR"
        if [ -d "$WORKFLOW_DIR" ]; then
            echo "✓ Installed"
            cd "$WORKFLOW_DIR"
            echo "Version: $(git rev-parse --short HEAD)"
            echo "Last update: $(git log -1 --format=%cd --date=short)"
        else
            echo "✗ Not installed"
        fi

        echo ""
        echo "Configuration: $CONFIG_DIR"
        if [ -f "$CONFIG_DIR/CLAUDE.md" ]; then
            echo "✓ Global CLAUDE.md configured"
        else
            echo "✗ Global CLAUDE.md missing"
        fi

        if [ -L "$CONFIG_DIR/agents" ]; then
            echo "✓ Global agents configured"
        else
            echo "✗ Global agents missing"
        fi
        ;;

    *)
        echo "Claude Code Workflow CLI"
        echo ""
        echo "Usage: ccw [command]"
        echo ""
        echo "Commands:"
        echo "  init      Initialize workflow in current directory"
        echo "  update    Update to latest version"
        echo "  status    Show installation status"
        echo ""
        echo "After initialization, use 'claude' command normally."
        ;;
esac
EOF

    chmod +x "$BIN_DIR/ccw"

    # Add to PATH if not already there
    add_to_path

    echo ""
    echo "✓ Claude Code Workflow installed successfully!"
    echo ""
    echo "Usage:"
    echo "  ccw init      # Initialize workflow in a project directory"
    echo "  ccw update    # Update to latest version"
    echo "  ccw status    # Check installation status"
    echo ""
    echo "To use in a project:"
    echo "  1. cd /path/to/your/project"
    echo "  2. ccw init"
    echo "  3. claude [your-command]"
}

add_to_path() {
    local shell_config=""

    if [ -n "$BASH_VERSION" ]; then
        shell_config="$HOME/.bashrc"
    elif [ -n "$ZSH_VERSION" ]; then
        shell_config="$HOME/.zshrc"
    else
        # Try to detect shell
        case "$SHELL" in
            */bash) shell_config="$HOME/.bashrc" ;;
            */zsh) shell_config="$HOME/.zshrc" ;;
            */fish) shell_config="$HOME/.config/fish/config.fish" ;;
        esac
    fi

    if [ -n "$shell_config" ] && [ -f "$shell_config" ]; then
        if ! grep -q "$BIN_DIR" "$shell_config"; then
            echo "" >> "$shell_config"
            echo "# Added by Claude Code Workflow installer" >> "$shell_config"
            echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$shell_config"
            echo "✓ Added $BIN_DIR to PATH in $shell_config"
            echo "Please restart your terminal or run: source $shell_config"
        fi
    else
        echo "Please add $BIN_DIR to your PATH manually"
    fi
}

uninstall_workflow() {
    echo "Uninstalling Claude Code Workflow..."

    # Remove installation directory
    if [ -d "$INSTALL_DIR" ]; then
        rm -rf "$INSTALL_DIR"
        echo "✓ Removed installation directory"
    fi

    # Remove global config
    if [ -L "$CONFIG_DIR/agents" ]; then
        rm "$CONFIG_DIR/agents"
        echo "✓ Removed global agents link"
    fi

    if [ -f "$CONFIG_DIR/CLAUDE.md" ]; then
        rm "$CONFIG_DIR/CLAUDE.md"
        echo "✓ Removed global CLAUDE.md"
    fi

    # Remove wrapper script
    if [ -f "$BIN_DIR/ccw" ]; then
        rm "$BIN_DIR/ccw"
        echo "✓ Removed ccw command"
    fi

    echo ""
    echo "✓ Claude Code Workflow uninstalled successfully!"
    echo "Note: You may need to remove $BIN_DIR from your PATH manually"
}

# Main script
case "$1" in
    install)
        check_dependencies
        install_workflow
        ;;
    update)
        if [ ! -d "$INSTALL_DIR" ]; then
            echo "Error: Claude Code Workflow is not installed"
            echo "Run: $0 install"
            exit 1
        fi
        install_workflow
        ;;
    uninstall)
        uninstall_workflow
        ;;
    help|--help|-h)
        print_usage
        ;;
    "")
        check_dependencies
        install_workflow
        ;;
    *)
        echo "Error: Unknown command '$1'"
        print_usage
        exit 1
        ;;
esac