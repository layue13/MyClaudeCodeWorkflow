#!/bin/bash

set -e

REPO_URL="https://github.com/layue13/MyClaudeCodeWorkflow.git"
TEMP_DIR="/tmp/claude-workflow-$$"
CLAUDE_DIR="$HOME/.claude"

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
    echo "Installing Claude Code Workflow to $CLAUDE_DIR..."

    # Create temporary directory for cloning
    mkdir -p "$TEMP_DIR"

    # Clone repository to temporary directory
    echo "Downloading latest version..."
    git clone "$REPO_URL" "$TEMP_DIR"

    # Create .claude directory if it doesn't exist
    mkdir -p "$CLAUDE_DIR"

    # Backup existing files if they exist
    if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
        echo "Backing up existing CLAUDE.md..."
        cp "$CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md.backup.$(date +%s)"
    fi

    if [ -d "$CLAUDE_DIR/agents" ]; then
        echo "Backing up existing agents directory..."
        mv "$CLAUDE_DIR/agents" "$CLAUDE_DIR/agents.backup.$(date +%s)"
    fi

    # Copy files to global .claude directory
    echo "Installing configuration files..."
    cp "$TEMP_DIR/CLAUDE.md" "$CLAUDE_DIR/"
    cp -r "$TEMP_DIR/.claude/agents" "$CLAUDE_DIR/"

    # Clean up temporary directory
    rm -rf "$TEMP_DIR"

    # Installation complete - no wrapper script needed

    echo ""
    echo "✓ Claude Code Workflow installed successfully!"
    echo ""
    echo "Files installed to: $CLAUDE_DIR"
    echo "  ├── CLAUDE.md        (Development guidelines)"
    echo "  └── agents/          (Claude agent configurations)"
    echo ""
    echo "The configuration is now globally available for all Claude sessions."
    echo "Simply use 'claude' command in any directory to access the workflow."
}

update_workflow() {
    echo "Updating Claude Code Workflow..."

    # Use same install process for updates
    install_workflow
}

uninstall_workflow() {
    echo "Uninstalling Claude Code Workflow..."

    # Remove workflow files from .claude directory
    if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
        rm "$CLAUDE_DIR/CLAUDE.md"
        echo "✓ Removed CLAUDE.md"
    fi

    if [ -d "$CLAUDE_DIR/agents" ]; then
        rm -rf "$CLAUDE_DIR/agents"
        echo "✓ Removed agents directory"
    fi

    echo ""
    echo "✓ Claude Code Workflow uninstalled successfully!"
    echo "Your .claude directory structure has been cleaned up."
}

# Main script
case "$1" in
    install)
        check_dependencies
        install_workflow
        ;;
    update)
        update_workflow
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