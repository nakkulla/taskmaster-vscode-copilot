#!/bin/bash

# Taskmaster VS Code Environment Setup Script
# This script copies VS Code instruction files and settings to a new project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Template source directory (fixed path)
TEMPLATE_SOURCE_DIR="/Users/isy_macair/Projects/taskmaster/.taskmaster/templates"

# Get target project directory (current directory if not specified)
TARGET_DIR="${1:-$(pwd)}"

# Resolve absolute path
TARGET_DIR=$(cd "$TARGET_DIR" && pwd)

print_info "Setting up VS Code environment for project: $TARGET_DIR"
print_info "Using templates from: $TEMPLATE_SOURCE_DIR"

# Check if template source exists
if [ ! -d "$TEMPLATE_SOURCE_DIR" ]; then
    print_error "Template source directory not found: $TEMPLATE_SOURCE_DIR"
    print_info "Please ensure the Taskmaster template project exists."
    exit 1
fi

# Check if target is Taskmaster initialized (optional - will create if not exists)
if [ ! -d "$TARGET_DIR/.taskmaster" ]; then
    print_warning "Target directory is not Taskmaster initialized."
    print_info "This is OK - VS Code environment can be set up independently."
fi

# Create directories
print_info "Creating directories..."

mkdir -p "$TARGET_DIR/.github/instructions"
mkdir -p "$TARGET_DIR/.vscode"

print_success "Directories created"

# Copy GitHub instruction files
print_info "Copying GitHub instruction files..."

if [ -d "$TEMPLATE_SOURCE_DIR/github/instructions" ]; then
    cp -r "$TEMPLATE_SOURCE_DIR/github/instructions/"* "$TARGET_DIR/.github/instructions/"
    print_success "GitHub instruction files copied"
else
    print_warning "GitHub instruction templates not found"
fi

# Copy Copilot instructions
if [ -f "$TEMPLATE_SOURCE_DIR/github/copilot-instructions.md" ]; then
    cp "$TEMPLATE_SOURCE_DIR/github/copilot-instructions.md" "$TARGET_DIR/.github/"
    print_success "Copilot instructions copied"
else
    print_warning "Copilot instructions template not found"
fi

# Copy VS Code settings
if [ -f "$TEMPLATE_SOURCE_DIR/vscode/settings.json" ]; then
    if [ -f "$TARGET_DIR/.vscode/settings.json" ]; then
        print_warning "VS Code settings.json already exists"
        read -p "Do you want to overwrite it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cp "$TEMPLATE_SOURCE_DIR/vscode/settings.json" "$TARGET_DIR/.vscode/"
            print_success "VS Code settings overwritten"
        else
            print_info "VS Code settings skipped"
        fi
    else
        cp "$TEMPLATE_SOURCE_DIR/vscode/settings.json" "$TARGET_DIR/.vscode/"
        print_success "VS Code settings copied"
    fi
else
    print_warning "VS Code settings template not found"
fi

# List created files
print_info "Created files and directories:"
echo "  📁 .github/"
echo "  📁 .github/instructions/"
if [ -d "$TARGET_DIR/.github/instructions" ]; then
    for file in "$TARGET_DIR/.github/instructions"/*; do
        if [ -f "$file" ]; then
            echo "    📄 $(basename "$file")"
        fi
    done
fi
if [ -f "$TARGET_DIR/.github/copilot-instructions.md" ]; then
    echo "  📄 .github/copilot-instructions.md"
fi
echo "  📁 .vscode/"
if [ -f "$TARGET_DIR/.vscode/settings.json" ]; then
    echo "    📄 settings.json"
fi

print_success "VS Code environment setup complete!"
print_info ""
print_info "Next steps:"
print_info "1. Open VS Code in this project directory: code $TARGET_DIR"
print_info "2. Install the GitHub Copilot extension if not already installed"
print_info "3. Reload VS Code to apply the new settings"
print_info "4. Start using Taskmaster with enhanced VS Code integration!"
