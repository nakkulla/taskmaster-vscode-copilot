#!/bin/bash

# Taskmaster VS Code Environment Functions Installer
# 이 스크립트는 shell 설정 파일에 Taskmaster 함수들을 추가합니다

set -e

# 색상 코드
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ $1${NC}"; }

# Shell 감지
detect_shell() {
    if [ -n "$ZSH_VERSION" ]; then
        echo "zsh"
    elif [ -n "$BASH_VERSION" ]; then
        echo "bash"
    elif [ -n "$SHELL" ]; then
        basename "$SHELL"
    else
        echo "bash"  # 기본값
    fi
}

# Shell 설정 파일 경로 결정
get_shell_config() {
    local shell_type="$1"
    case "$shell_type" in
        "zsh")
            echo "$HOME/.zshrc"
            ;;
        "bash")
            if [ -f "$HOME/.bash_profile" ]; then
                echo "$HOME/.bash_profile"
            else
                echo "$HOME/.bashrc"
            fi
            ;;
        *)
            echo "$HOME/.bashrc"
            ;;
    esac
}

# 메인 실행
main() {
    local shell_type
    local shell_config
    local script_dir
    local functions_file
    
    print_info "🔧 Taskmaster VS Code 환경 도구 설치"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Shell 감지
    shell_type=$(detect_shell)
    shell_config=$(get_shell_config "$shell_type")
    
    print_info "감지된 Shell: $shell_type"
    print_info "설정 파일: $shell_config"
    
    # 스크립트 디렉토리 확인
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    functions_file="$script_dir/bashrc-functions.sh"
    
    if [ ! -f "$functions_file" ]; then
        print_error "함수 파일을 찾을 수 없습니다: $functions_file"
        exit 1
    fi
    
    # 기존 설치 확인
    if grep -q "Taskmaster VS Code Environment Setup Functions" "$shell_config" 2>/dev/null; then
        print_warning "이미 설치되어 있습니다."
        echo "다시 설치하시겠습니까? (y/N)"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            print_info "설치를 취소했습니다."
            exit 0
        fi
        
        # 기존 설치 제거
        print_info "기존 설치를 제거하는 중..."
        sed -i.bak '/# Taskmaster VS Code Environment Setup Functions/,/^$/d' "$shell_config"
        print_success "기존 설치 제거 완료"
    fi
    
    # 설정 파일에 source 라인 추가
    print_info "함수를 $shell_config에 추가하는 중..."
    
    {
        echo ""
        echo "# Taskmaster VS Code Environment Setup Functions"
        echo "source \"$functions_file\""
        echo ""
    } >> "$shell_config"
    
    print_success "설치 완료!"
    
    # 활성화 안내
    echo ""
    print_info "📋 활성화 방법:"
    print_info "  source $shell_config"
    print_info "  또는 새 터미널을 열어주세요."
    
    echo ""
    print_info "🚀 사용 가능한 명령어:"
    echo "  tm-init              - Taskmaster 프로젝트 완전 초기화"
    echo "  setup-vscode         - VS Code 환경 설정 (현재 디렉토리)"
    echo "  setup-vscode-for     - VS Code 환경 설정 (지정 디렉토리)"
    echo "  tm-code              - VS Code 열기 (환경 설정 포함)"
    echo "  tm-status            - 프로젝트 상태 확인"
    echo "  tm-help              - 도움말 보기"
    echo ""
    echo "  tm, tm-list, tm-next - Taskmaster 단축키"
    
    echo ""
    print_info "💡 빠른 시작:"
    print_info "  1. source $shell_config"
    print_info "  2. mkdir my-project && cd my-project"
    print_info "  3. tm-init"
    print_info "  4. tm-code"
    
    # 즉시 활성화 제안
    echo ""
    echo "지금 바로 활성화하시겠습니까? (Y/n)"
    read -r activate_now
    if [[ ! "$activate_now" =~ ^[Nn]$ ]]; then
        print_info "함수를 활성화하는 중..."
        source "$functions_file"
        print_success "활성화 완료! 이제 tm-help 명령어로 도움말을 확인하세요."
    fi
}

# 스크립트 실행
main "$@"
