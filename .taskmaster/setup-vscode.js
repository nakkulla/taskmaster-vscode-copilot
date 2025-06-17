#!/usr/bin/env node

/**
 * Taskmaster VS Code Environment Setup Script
 * This script copies VS Code instruction files and settings to a new project
 */

const fs = require('fs');
const path = require('path');

// Colors for console output
const colors = {
    reset: '\x1b[0m',
    bright: '\x1b[1m',
    red: '\x1b[31m',
    green: '\x1b[32m',
    yellow: '\x1b[33m',
    blue: '\x1b[34m',
    cyan: '\x1b[36m'
};

// Helper functions for colored output
function printSuccess(message) {
    console.log(`${colors.green}✓ ${message}${colors.reset}`);
}

function printWarning(message) {
    console.log(`${colors.yellow}⚠ ${message}${colors.reset}`);
}

function printError(message) {
    console.log(`${colors.red}✗ ${message}${colors.reset}`);
}

function printInfo(message) {
    console.log(`${colors.cyan}ℹ ${message}${colors.reset}`);
}

// Recursive copy function
function copyRecursive(source, target) {
    if (!fs.existsSync(target)) {
        fs.mkdirSync(target, { recursive: true });
    }

    const items = fs.readdirSync(source);
    
    for (const item of items) {
        const sourcePath = path.join(source, item);
        const targetPath = path.join(target, item);
        
        if (fs.statSync(sourcePath).isDirectory()) {
            copyRecursive(sourcePath, targetPath);
        } else {
            fs.copyFileSync(sourcePath, targetPath);
        }
    }
}

// Main setup function
function setupVSCodeEnvironment(projectDir) {
    projectDir = projectDir || process.cwd();
    projectDir = path.resolve(projectDir);
    
    printInfo(`Setting up VS Code environment for project: ${projectDir}`);
    
    // Check if Taskmaster is initialized
    const taskmasterDir = path.join(projectDir, '.taskmaster');
    if (!fs.existsSync(taskmasterDir)) {
        printError('Taskmaster not initialized in this project.');
        printInfo('Please run Taskmaster initialization first.');
        process.exit(1);
    }
    
    // Check if templates exist
    const templatesDir = path.join(taskmasterDir, 'templates');
    if (!fs.existsSync(templatesDir)) {
        printError('Templates directory not found.');
        printInfo('Please ensure you have the latest Taskmaster templates.');
        process.exit(1);
    }
    
    // Create directories
    printInfo('Creating directories...');
    
    const githubInstructionsDir = path.join(projectDir, '.github', 'instructions');
    const vscodeDir = path.join(projectDir, '.vscode');
    
    fs.mkdirSync(githubInstructionsDir, { recursive: true });
    fs.mkdirSync(vscodeDir, { recursive: true });
    
    printSuccess('Directories created');
    
    // Copy GitHub instruction files
    printInfo('Copying GitHub instruction files...');
    
    const githubTemplatesDir = path.join(templatesDir, 'github', 'instructions');
    if (fs.existsSync(githubTemplatesDir)) {
        copyRecursive(githubTemplatesDir, githubInstructionsDir);
        printSuccess('GitHub instruction files copied');
    } else {
        printWarning('GitHub instruction templates not found');
    }
    
    // Copy Copilot instructions
    const copilotInstructionsTemplate = path.join(templatesDir, 'github', 'copilot-instructions.md');
    const copilotInstructionsTarget = path.join(projectDir, '.github', 'copilot-instructions.md');
    
    if (fs.existsSync(copilotInstructionsTemplate)) {
        fs.copyFileSync(copilotInstructionsTemplate, copilotInstructionsTarget);
        printSuccess('Copilot instructions copied');
    } else {
        printWarning('Copilot instructions template not found');
    }
    
    // Copy VS Code settings
    const vscodeSettingsTemplate = path.join(templatesDir, 'vscode', 'settings.json');
    const vscodeSettingsTarget = path.join(vscodeDir, 'settings.json');
    
    if (fs.existsSync(vscodeSettingsTemplate)) {
        if (fs.existsSync(vscodeSettingsTarget)) {
            printWarning('VS Code settings.json already exists');
            // For non-interactive mode, skip overwriting
            printInfo('VS Code settings skipped (file already exists)');
        } else {
            fs.copyFileSync(vscodeSettingsTemplate, vscodeSettingsTarget);
            printSuccess('VS Code settings copied');
        }
    } else {
        printWarning('VS Code settings template not found');
    }
    
    // List created files
    printInfo('Created files and directories:');
    console.log('  📁 .github/');
    console.log('  📁 .github/instructions/');
    
    if (fs.existsSync(githubInstructionsDir)) {
        const instructionFiles = fs.readdirSync(githubInstructionsDir);
        for (const file of instructionFiles) {
            const filePath = path.join(githubInstructionsDir, file);
            if (fs.statSync(filePath).isFile()) {
                console.log(`    📄 ${file}`);
            }
        }
    }
    
    if (fs.existsSync(copilotInstructionsTarget)) {
        console.log('  📄 .github/copilot-instructions.md');
    }
    
    console.log('  📁 .vscode/');
    if (fs.existsSync(vscodeSettingsTarget)) {
        console.log('    📄 settings.json');
    }
    
    printSuccess('VS Code environment setup complete!');
    console.log('');
    printInfo('Next steps:');
    printInfo('1. Open VS Code in this project directory');
    printInfo('2. Install the GitHub Copilot extension if not already installed');
    printInfo('3. Reload VS Code to apply the new settings');
    printInfo('4. Start using Taskmaster with enhanced VS Code integration!');
}

// CLI interface
if (require.main === module) {
    const projectDir = process.argv[2];
    setupVSCodeEnvironment(projectDir);
}

module.exports = { setupVSCodeEnvironment };
