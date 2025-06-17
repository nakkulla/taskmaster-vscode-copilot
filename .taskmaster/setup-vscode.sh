#!/bin/bash

# Taskmaster VS Code 환경 설정 스크립트 v2.1
# 이 스크립트는 현재 Taskmaster 프로젝트의 실제 .github과 .vscode 설정을 새 프로젝트에 복사합니다
# 한국어 PRD 및 작업 생성을 위한 환경을 설정합니다
# 2025-06-17: templates 폴더 대신 실제 프로젝트 폴더를 참조하도록 수정됨
# 
# 주요 특징:
# - taskmaster.instructions.md 단일 통합 가이드
# - PRD → 브리핑 → 피드백 → 승인 → 개발 워크플로우
# - 주요 MCP 도구(Sequential Thinking, Tavily, Context7, GitHub, Obsidian) 통합 활용
# - 현재 프로젝트의 실제 설정 파일을 소스로 사용

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
            echo "사용법: $0 [대상-디렉토리] [옵션]"
            echo ""
            echo "옵션:"
            echo "  --clean-all   모든 다른 에디터 설정을 자동으로 제거"
            echo "  --clean-none  다른 에디터 설정 정리 건너뛰기"
            echo "  --help        이 도움말 메시지 표시"
            echo ""
            echo "옵션 없이 실행하면 각 설정에 대해 제거 여부를 묻습니다."
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

print_info "프로젝트를 위한 VS Code 환경을 설정합니다: $PROJECT_DIR"

# Check if Taskmaster is initialized
if [ ! -d "$PROJECT_DIR/.taskmaster" ]; then
    print_error "이 프로젝트에서 Taskmaster가 초기화되지 않았습니다."
    print_info "먼저 'taskmaster init'을 실행해주세요."
    exit 1
fi

# Get the source directory (current script location and find the actual source files)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
SOURCE_GITHUB_DIR="$SOURCE_PROJECT_DIR/.github"
SOURCE_VSCODE_DIR="$SOURCE_PROJECT_DIR/.vscode"

# Check if source directories exist
if [ ! -d "$SOURCE_GITHUB_DIR" ] && [ ! -d "$SOURCE_VSCODE_DIR" ]; then
    print_error "소스 설정 파일을 찾을 수 없습니다."
    print_info "Taskmaster 프로젝트의 .github 또는 .vscode 폴더가 필요합니다."
    exit 1
fi

# Create directories
print_info "디렉토리 생성 중..."

mkdir -p "$PROJECT_DIR/.github/instructions"
mkdir -p "$PROJECT_DIR/.vscode"

print_success "디렉토리가 생성되었습니다"

# Copy GitHub instruction files
print_info "GitHub instruction 파일 복사 중..."

if [ -d "$SOURCE_GITHUB_DIR/instructions" ]; then
    # Count instruction files in source
    source_files_count=$(find "$SOURCE_GITHUB_DIR/instructions" -name "*.instructions.md" 2>/dev/null | wc -l)
    if [ "$source_files_count" -gt 0 ]; then
        cp -r "$SOURCE_GITHUB_DIR/instructions/"* "$PROJECT_DIR/.github/instructions/"
        print_success "GitHub instruction 파일이 복사되었습니다"
        print_info "복사된 파일: $source_files_count개"
    else
        print_warning "소스 instruction 파일이 비어있습니다."
    fi
else
    print_warning "소스 GitHub instructions 디렉토리를 찾을 수 없습니다: $SOURCE_GITHUB_DIR/instructions"
fi

# Copy Copilot instructions
print_info "Copilot 지침 파일 복사 중..."
if [ -f "$SOURCE_GITHUB_DIR/copilot-instructions.md" ]; then
    cp "$SOURCE_GITHUB_DIR/copilot-instructions.md" "$PROJECT_DIR/.github/"
    print_success "Copilot 지침이 복사되었습니다"
else
    print_warning "소스 Copilot 지침을 찾을 수 없습니다: $SOURCE_GITHUB_DIR/copilot-instructions.md"
fi

# Copy VS Code settings
print_info "VS Code 설정 파일 복사 중..."
if [ -f "$SOURCE_VSCODE_DIR/settings.json" ]; then
    if [ -f "$PROJECT_DIR/.vscode/settings.json" ]; then
        print_warning "VS Code settings.json이 이미 존재합니다"
        read -p "덮어쓰시겠습니까? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cp "$SOURCE_VSCODE_DIR/settings.json" "$PROJECT_DIR/.vscode/"
            print_success "VS Code 설정이 덮어쓰여졌습니다"
        else
            print_info "VS Code 설정을 건너뛰었습니다"
        fi
    else
        cp "$SOURCE_VSCODE_DIR/settings.json" "$PROJECT_DIR/.vscode/"
        print_success "VS Code 설정이 복사되었습니다"
    fi
else
    print_warning "소스 VS Code 설정을 찾을 수 없습니다: $SOURCE_VSCODE_DIR/settings.json"
fi

# Clean up other editor configurations
if [ "$CLEANUP_MODE" != "none" ]; then
    print_info "다른 에디터 설정 정리 중..."
    
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
            print_info "모든 다른 에디터 설정을 자동으로 제거합니다..."
            for config_entry in "${FOUND_CONFIGS[@]}"; do
                config_path="${config_entry%%:*}"
                config_rest="${config_entry#*:}"
                config_desc="${config_rest%%:*}"
                config_type="${config_rest##*:}"
                
                rm -rf "$PROJECT_DIR/$config_path"
                if [ "$config_type" = "dir" ]; then
                    print_success "$config_path 디렉토리가 제거되었습니다 ($config_desc)"
                else
                    print_success "$config_path 파일이 제거되었습니다 ($config_desc)"
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
                    print_warning "$config_path 디렉토리를 발견했습니다 ($config_desc)"
                    read -p "$config_path 디렉토리를 제거하시겠습니까? (y/N): " -n 1 -r
                else
                    print_warning "$config_path 파일을 발견했습니다 ($config_desc)"
                    read -p "$config_path 파일을 제거하시겠습니까? (y/N): " -n 1 -r
                fi
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    rm -rf "$PROJECT_DIR/$config_path"
                    if [ "$config_type" = "dir" ]; then
                        print_success "$config_path 디렉토리가 제거되었습니다"
                    else
                        print_success "$config_path 파일이 제거되었습니다"
                    fi
                else
                    if [ "$config_type" = "dir" ]; then
                        print_info "$config_path 디렉토리를 유지합니다"
                    else
                        print_info "$config_path 파일을 유지합니다"
                    fi
                fi
            done
        fi
    else
        print_info "다른 에디터 설정을 찾을 수 없습니다"
    fi
else
    print_info "다른 에디터 설정 정리를 건너뜁니다 (--clean-none 옵션)"
fi

print_info ""

# List created files
print_info "생성된 파일 및 디렉토리:"
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

print_success "VS Code 환경 설정이 완료되었습니다!"
print_info ""
print_info "🎉 Taskmaster 설정이 현재 프로젝트 구성을 기반으로 복사되었습니다!"
print_info ""
print_info "다음 단계:"
print_info "1. 이 프로젝트 디렉토리에서 VS Code를 실행하세요"
print_info "2. GitHub Copilot 확장이 설치되어 있지 않다면 설치하세요"
print_info "3. 새 설정을 적용하기 위해 VS Code를 재시작하세요"
print_info "4. 향상된 VS Code 통합 기능과 함께 Taskmaster 사용을 시작하세요!"
print_info ""
print_info "📋 주요 기능:"
print_info "  • taskmaster.instructions.md - 모든 핵심 기능 통합 가이드"
print_info "  • instruction-formatting.instructions.md - instruction 파일 작성 가이드"
print_info "  • PRD → 브리핑 → 승인 → 개발 워크플로우"
print_info "  • Sequential Thinking, Tavily, Context7, GitHub, Obsidian MCP 도구 활용"
print_info "  • 한국어 기반 작업 관리 및 코딩 가이드라인"
print_info "  • TypeScript 타입 정의 및 오류 처리 패턴"
print_info ""
print_info "💡 팁: PRD 파일 작성 시 한국어로 작성하면 자동으로 한국어 작업이 생성됩니다"
print_info "🎯 이 스크립트는 현재 Taskmaster 프로젝트의 실제 설정을 다른 프로젝트에 복사합니다"
