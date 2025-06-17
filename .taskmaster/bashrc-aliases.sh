# Taskmaster VS Code Environment Setup Aliases
# Add these lines to your ~/.bashrc or ~/.zshrc file

# Alias for setting up VS Code environment in current directory
alias setup-vscode='bash /Users/isy_macair/Projects/taskmaster/.taskmaster/setup-vscode-global.sh'

# Function for setting up VS Code environment in specified directory
setup-vscode-dir() {
    if [ -z "$1" ]; then
        echo "Usage: setup-vscode-dir <target-directory>"
        echo "Example: setup-vscode-dir /path/to/my/project"
        return 1
    fi
    bash /Users/isy_macair/Projects/taskmaster/.taskmaster/setup-vscode-global.sh "$1"
}

# Function for quick Taskmaster project initialization with VS Code setup
taskmaster-init() {
    local project_dir="${1:-$(pwd)}"
    
    echo "🚀 Initializing Taskmaster project with VS Code environment..."
    
    # Go to project directory
    cd "$project_dir" || { echo "Failed to access directory: $project_dir"; return 1; }
    
    # Initialize Taskmaster
    echo "📦 Initializing Taskmaster..."
    npx task-master-ai init
    
    # Setup VS Code environment
    echo "⚙️ Setting up VS Code environment..."
    bash /Users/isy_macair/Projects/taskmaster/.taskmaster/setup-vscode-global.sh "$project_dir"
    
    echo "✅ Project initialization complete!"
    echo "📝 Next steps:"
    echo "   1. Create PRD file: .taskmaster/docs/prd.txt"
    echo "   2. Parse PRD: npx task-master-ai parse-prd"
    echo "   3. Open VS Code: code ."
}

# Quick aliases for common Taskmaster commands
alias tm='npx task-master-ai'
alias tm-list='npx task-master-ai list'
alias tm-next='npx task-master-ai next'
alias tm-init='taskmaster-init'

# Function to open VS Code with Taskmaster project
tm-code() {
    setup-vscode
    code .
}

echo "🎯 Taskmaster aliases loaded!"
echo "Available commands:"
echo "  setup-vscode          - Setup VS Code environment in current directory"
echo "  setup-vscode-dir DIR  - Setup VS Code environment in specified directory"
echo "  taskmaster-init [DIR] - Initialize Taskmaster + VS Code environment"
echo "  tm                    - Short alias for task-master-ai"
echo "  tm-list               - List tasks"
echo "  tm-next               - Show next task"
echo "  tm-init [DIR]         - Initialize new project"
echo "  tm-code               - Setup VS Code and open current project"
