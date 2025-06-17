#!/usr/bin/env node

/**
 * Taskmaster VS Code Environment Setup Script (Global Node.js version)
 * This script copies VS Code instruction files and settings to a new project
 */

const fs = require('fs');
const path = require('path');
const readline = require('readline');

// Colors for output
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
  blue: '\x1b[34m'
};

// Print functions with colors
const print = {
  success: (msg) => console.log(`${colors.green}✓ ${msg}${colors.reset}`),
  warning: (msg) => console.log(`${colors.yellow}⚠ ${msg}${colors.reset}`),
  error: (msg) => console.log(`${colors.red}✗ ${msg}${colors.reset}`),
  info: (msg) => console.log(`${colors.blue}ℹ ${msg}${colors.reset}`)
};

// Template source directory (fixed path for global use)
const TEMPLATE_SOURCE_DIR = '/Users/isy_macair/Projects/taskmaster/.taskmaster/templates';

// Get target project directory (current directory if not specified)
const TARGET_DIR = path.resolve(process.argv[2] || process.cwd());

print.info(`Setting up VS Code environment for project: ${TARGET_DIR}`);
print.info(`Using templates from: ${TEMPLATE_SOURCE_DIR}`);

// Check if template source exists
if (!fs.existsSync(TEMPLATE_SOURCE_DIR)) {
  print.error(`Template source directory not found: ${TEMPLATE_SOURCE_DIR}`);
  print.info('Please ensure the Taskmaster template project exists.');
  process.exit(1);
}

// Check if target is Taskmaster initialized (optional)
if (!fs.existsSync(path.join(TARGET_DIR, '.taskmaster'))) {
  print.warning('Target directory is not Taskmaster initialized.');
  print.info('This is OK - VS Code environment can be set up independently.');
}

// Recursive copy function
function copyRecursive(source, target) {
  if (!fs.existsSync(target)) {
    fs.mkdirSync(target, { recursive: true });
  }

  const files = fs.readdirSync(source);

  for (const file of files) {
    const sourceFile = path.join(source, file);
    const targetFile = path.join(target, file);

    if (fs.statSync(sourceFile).isDirectory()) {
      copyRecursive(sourceFile, targetFile);
    } else {
      fs.copyFileSync(sourceFile, targetFile);
    }
  }
}

// Async function to ask user input
function askQuestion(question) {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      rl.close();
      resolve(answer);
    });
  });
}

async function setupVSCodeEnvironment() {
  try {
    // Create directories
    print.info('Creating directories...');
    
    const githubInstructionsDir = path.join(TARGET_DIR, '.github', 'instructions');
    const vscodeDir = path.join(TARGET_DIR, '.vscode');
    
    fs.mkdirSync(githubInstructionsDir, { recursive: true });
    fs.mkdirSync(vscodeDir, { recursive: true });
    
    print.success('Directories created');

    // Copy GitHub instruction files
    print.info('Copying GitHub instruction files...');
    
    const githubInstructionsSource = path.join(TEMPLATE_SOURCE_DIR, 'github', 'instructions');
    if (fs.existsSync(githubInstructionsSource)) {
      copyRecursive(githubInstructionsSource, githubInstructionsDir);
      print.success('GitHub instruction files copied');
    } else {
      print.warning('GitHub instruction templates not found');
    }

    // Copy Copilot instructions
    const copilotInstructionsSource = path.join(TEMPLATE_SOURCE_DIR, 'github', 'copilot-instructions.md');
    const copilotInstructionsTarget = path.join(TARGET_DIR, '.github', 'copilot-instructions.md');
    
    if (fs.existsSync(copilotInstructionsSource)) {
      fs.copyFileSync(copilotInstructionsSource, copilotInstructionsTarget);
      print.success('Copilot instructions copied');
    } else {
      print.warning('Copilot instructions template not found');
    }

    // Copy VS Code settings
    const vscodeSettingsSource = path.join(TEMPLATE_SOURCE_DIR, 'vscode', 'settings.json');
    const vscodeSettingsTarget = path.join(vscodeDir, 'settings.json');
    
    if (fs.existsSync(vscodeSettingsSource)) {
      if (fs.existsSync(vscodeSettingsTarget)) {
        print.warning('VS Code settings.json already exists');
        const answer = await askQuestion('Do you want to overwrite it? (y/N): ');
        if (answer.toLowerCase() === 'y' || answer.toLowerCase() === 'yes') {
          fs.copyFileSync(vscodeSettingsSource, vscodeSettingsTarget);
          print.success('VS Code settings overwritten');
        } else {
          print.info('VS Code settings skipped');
        }
      } else {
        fs.copyFileSync(vscodeSettingsSource, vscodeSettingsTarget);
        print.success('VS Code settings copied');
      }
    } else {
      print.warning('VS Code settings template not found');
    }

    // List created files
    print.info('Created files and directories:');
    console.log('  📁 .github/');
    console.log('  📁 .github/instructions/');
    
    if (fs.existsSync(githubInstructionsDir)) {
      const instructionFiles = fs.readdirSync(githubInstructionsDir);
      instructionFiles.forEach(file => {
        console.log(`    📄 ${file}`);
      });
    }
    
    if (fs.existsSync(copilotInstructionsTarget)) {
      console.log('  📄 .github/copilot-instructions.md');
    }
    
    console.log('  📁 .vscode/');
    if (fs.existsSync(vscodeSettingsTarget)) {
      console.log('    📄 settings.json');
    }

    print.success('VS Code environment setup complete!');
    print.info('');
    print.info('Next steps:');
    print.info(`1. Open VS Code in this project directory: code ${TARGET_DIR}`);
    print.info('2. Install the GitHub Copilot extension if not already installed');
    print.info('3. Reload VS Code to apply the new settings');
    print.info('4. Start using Taskmaster with enhanced VS Code integration!');

  } catch (error) {
    print.error(`Setup failed: ${error.message}`);
    process.exit(1);
  }
}

// Run the setup
setupVSCodeEnvironment();
