#!/bin/bash

# Taskmaster VS Code Environment Setup Script
# This script copies VS Code instruction files and settings to a new project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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
    echo -e "ℹ $1"
}

# Add command line options for automatic cleanup
CLEANUP_MODE="ask"  # Default: ask for each directory

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --clean-all)
            CLEANUP_MODE="all"
            shift
            ;;
        --clean-none)
            CLEANUP_MODE="none"
            shift
            ;;
        --help)
            echo "Usage: $0 [target-directory] [options]"
            echo ""
            echo "Options:"
            echo "  --clean-all   Automatically remove all other editor configurations"
            echo "  --clean-none  Skip cleanup of other editor configurations"
            echo "  --help        Show this help message"
            echo ""
            echo "Without options, the script will ask before removing each configuration."
            exit 0
            ;;
        *)
            if [ -z "$PROJECT_DIR_ARG" ]; then
                PROJECT_DIR_ARG="$1"
            fi
            shift
            ;;
    esac
done

# Override PROJECT_DIR if argument was provided
if [ -n "$PROJECT_DIR_ARG" ]; then
    PROJECT_DIR="$PROJECT_DIR_ARG"
else
    # Get project directory (current directory if not specified)
    PROJECT_DIR="$(pwd)"
fi

# Resolve absolute path
PROJECT_DIR=$(cd "$PROJECT_DIR" && pwd)

print_info "Setting up VS Code environment for project: $PROJECT_DIR"

# Check if Taskmaster is initialized
if [ ! -d "$PROJECT_DIR/.taskmaster" ]; then
    print_error "Taskmaster not initialized in this project."
    print_info "Please run 'taskmaster init' first."
    exit 1
fi

# Check if templates exist
TEMPLATES_DIR="$PROJECT_DIR/.taskmaster/templates"
if [ ! -d "$TEMPLATES_DIR" ]; then
    print_error "Templates directory not found."
    print_info "Please ensure you have the latest Taskmaster templates."
    exit 1
fi

# Create directories
print_info "Creating directories..."

mkdir -p "$PROJECT_DIR/.github/instructions"
mkdir -p "$PROJECT_DIR/.vscode"

print_success "Directories created"

# Copy GitHub instruction files
print_info "Copying GitHub instruction files..."

if [ -d "$TEMPLATES_DIR/github/instructions" ]; then
    cp -r "$TEMPLATES_DIR/github/instructions/"* "$PROJECT_DIR/.github/instructions/"
    print_success "GitHub instruction files copied"
else
    print_warning "GitHub instruction templates not found"
fi

# Copy Copilot instructions
if [ -f "$TEMPLATES_DIR/github/copilot-instructions.md" ]; then
    cp "$TEMPLATES_DIR/github/copilot-instructions.md" "$PROJECT_DIR/.github/"
    print_success "Copilot instructions copied"
else
    print_warning "Copilot instructions template not found"
fi

# Copy VS Code settings
if [ -f "$TEMPLATES_DIR/vscode/settings.json" ]; then
    if [ -f "$PROJECT_DIR/.vscode/settings.json" ]; then
        print_warning "VS Code settings.json already exists"
        read -p "Do you want to overwrite it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cp "$TEMPLATES_DIR/vscode/settings.json" "$PROJECT_DIR/.vscode/"
            print_success "VS Code settings overwritten"
        else
            print_info "VS Code settings skipped"
        fi
    else
        cp "$TEMPLATES_DIR/vscode/settings.json" "$PROJECT_DIR/.vscode/"
        print_success "VS Code settings copied"
    fi
else
    print_warning "VS Code settings template not found"
fi

# Clean up other editor configurations
if [ "$CLEANUP_MODE" != "none" ]; then
    print_info "Cleaning up other editor configurations..."
    
    # Define editor configurations to check (format: "path:description:type")
    EDITOR_CONFIGS=(
        ".cursor:Cursor AI editor configuration:dir"
        ".roo:Roo.dev configuration:dir"
        ".roomodes:Roo editor modes file:file"
        ".windsurf:Windsurf editor configuration:dir"
        ".windsurfrules:Windsurf rules file:file"
        ".v0:V0 configuration:dir"
        ".bolt:Bolt configuration:dir"
        ".replit:Replit configuration:dir"
    )
    
    FOUND_CONFIGS=()
    
    # Check which configurations exist
    for config_entry in "${EDITOR_CONFIGS[@]}"; do
        config_path="${config_entry%%:*}"
        config_rest="${config_entry#*:}"
        config_desc="${config_rest%%:*}"
        config_type="${config_rest##*:}"
        
        if [ "$config_type" = "dir" ] && [ -d "$PROJECT_DIR/$config_path" ]; then
            FOUND_CONFIGS+=("$config_entry")
        elif [ "$config_type" = "file" ] && [ -f "$PROJECT_DIR/$config_path" ]; then
            FOUND_CONFIGS+=("$config_entry")
        fi
    done
    
    # Process found configurations
    if [ ${#FOUND_CONFIGS[@]} -gt 0 ]; then
        if [ "$CLEANUP_MODE" == "all" ]; then
            print_info "Automatically removing all other editor configurations..."
            for config_entry in "${FOUND_CONFIGS[@]}"; do
                config_path="${config_entry%%:*}"
                config_rest="${config_entry#*:}"
                config_desc="${config_rest%%:*}"
                config_type="${config_rest##*:}"
                
                rm -rf "$PROJECT_DIR/$config_path"
                if [ "$config_type" = "dir" ]; then
                    print_success "$config_path directory removed ($config_desc)"
                else
                    print_success "$config_path file removed ($config_desc)"
                fi
            done
        else
            # Ask mode - prompt for each configuration
            for config_entry in "${FOUND_CONFIGS[@]}"; do
                config_path="${config_entry%%:*}"
                config_rest="${config_entry#*:}"
                config_desc="${config_rest%%:*}"
                config_type="${config_rest##*:}"
                
                if [ "$config_type" = "dir" ]; then
                    print_warning "Found $config_path directory ($config_desc)"
                    read -p "Do you want to remove the $config_path directory? (y/N): " -n 1 -r
                else
                    print_warning "Found $config_path file ($config_desc)"
                    read -p "Do you want to remove the $config_path file? (y/N): " -n 1 -r
                fi
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    rm -rf "$PROJECT_DIR/$config_path"
                    if [ "$config_type" = "dir" ]; then
                        print_success "$config_path directory removed"
                    else
                        print_success "$config_path file removed"
                    fi
                else
                    if [ "$config_type" = "dir" ]; then
                        print_info "$config_path directory kept"
                    else
                        print_info "$config_path file kept"
                    fi
                fi
            done
        fi
    else
        print_info "No other editor configurations found"
    fi
else
    print_info "Skipping cleanup of other editor configurations (--clean-none option)"
fi

print_info ""

# List created files
print_info "Created files and directories:"
echo "  📁 .github/"
echo "  📁 .github/instructions/"
if [ -d "$PROJECT_DIR/.github/instructions" ]; then
    for file in "$PROJECT_DIR/.github/instructions"/*; do
        if [ -f "$file" ]; then
            echo "    📄 $(basename "$file")"
        fi
    done
fi
if [ -f "$PROJECT_DIR/.github/copilot-instructions.md" ]; then
    echo "  📄 .github/copilot-instructions.md"
fi
echo "  📁 .vscode/"
if [ -f "$PROJECT_DIR/.vscode/settings.json" ]; then
    echo "    📄 settings.json"
fi

print_success "VS Code environment setup complete!"
print_info ""
print_info "Next steps:"
print_info "1. Open VS Code in this project directory"
print_info "2. Install the GitHub Copilot extension if not already installed"
print_info "3. Reload VS Code to apply the new settings"
print_info "4. Start using Taskmaster with enhanced VS Code integration!"
