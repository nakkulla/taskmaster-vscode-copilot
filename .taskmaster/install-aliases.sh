#!/bin/bash

# Taskmaster VS Code Environment - Shell Integration Installer
# This script helps you add Taskmaster aliases to your shell configuration

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }

ALIASES_FILE="/Users/isy_macair/Projects/taskmaster/.taskmaster/bashrc-aliases.sh"

print_info "Taskmaster VS Code Environment - Shell Integration Installer"
print_info "==========================================================="

# Detect shell
if [ -n "$ZSH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
    SHELL_NAME="zsh"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
    SHELL_NAME="bash"
else
    print_warning "Could not detect shell type. Please manually add aliases."
    SHELL_CONFIG="$HOME/.bashrc"
    SHELL_NAME="bash"
fi

print_info "Detected shell: $SHELL_NAME"
print_info "Config file: $SHELL_CONFIG"

# Check if aliases are already installed
if grep -q "Taskmaster VS Code Environment Setup Aliases" "$SHELL_CONFIG" 2>/dev/null; then
    print_warning "Taskmaster aliases appear to be already installed in $SHELL_CONFIG"
    read -p "Do you want to reinstall? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Installation cancelled."
        exit 0
    fi
    # Remove old installation
    sed -i.bak '/# Taskmaster VS Code Environment Setup Aliases/,/echo "🎯 Taskmaster aliases loaded!"/d' "$SHELL_CONFIG"
    print_success "Removed old installation"
fi

print_info "Installing Taskmaster aliases to $SHELL_CONFIG..."

# Add aliases to shell config
cat "$ALIASES_FILE" >> "$SHELL_CONFIG"

print_success "Aliases installed successfully!"
print_info ""
print_info "To start using the aliases, either:"
print_info "1. Restart your terminal, or"
print_info "2. Run: source $SHELL_CONFIG"
print_info ""
print_info "Available commands after restart:"
print_info "  setup-vscode          - Setup VS Code environment in current directory"
print_info "  setup-vscode-dir DIR  - Setup VS Code environment in specified directory"
print_info "  taskmaster-init [DIR] - Initialize Taskmaster + VS Code environment"
print_info "  tm                    - Short alias for task-master-ai"
print_info "  tm-list               - List tasks"
print_info "  tm-next               - Show next task"
print_info "  tm-init [DIR]         - Initialize new project"
print_info "  tm-code               - Setup VS Code and open current project"
print_info ""
print_info "Example usage:"
print_info "  cd /path/to/new/project"
print_info "  tm-init                # Initialize Taskmaster + VS Code"
print_info "  # or for existing project:"
print_info "  setup-vscode           # Just setup VS Code environment"

# Ask if user wants to source the config now
echo
read -p "Do you want to reload your shell configuration now? (Y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    source "$SHELL_CONFIG"
    print_success "Shell configuration reloaded!"
    print_info "You can now use the Taskmaster aliases immediately."
else
    print_info "Please restart your terminal or run: source $SHELL_CONFIG"
fi
