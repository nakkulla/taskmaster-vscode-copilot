# Taskmaster VS Code Environment Setup Functions
# 이 파일을 ~/.bashrc 또는 ~/.zshrc에 source하여 사용하세요
# 
# 설치 방법:
# echo "source /path/to/taskmaster/.taskmaster/bashrc-functions.sh" >> ~/.bashrc
# 또는 install-aliases.sh 스크립트를 실행하세요

# 색상 코드
TM_GREEN='\033[0;32m'
TM_YELLOW='\033[1;33m'
TM_RED='\033[0;31m'
TM_BLUE='\033[0;34m'
TM_NC='\033[0m' # No Color

# 출력 함수들
tm_success() { echo -e "${TM_GREEN}✓ $1${TM_NC}"; }
tm_warning() { echo -e "${TM_YELLOW}⚠ $1${TM_NC}"; }
tm_error() { echo -e "${TM_RED}✗ $1${TM_NC}"; }
tm_info() { echo -e "${TM_BLUE}ℹ $1${TM_NC}"; }

# Taskmaster 설치 경로 자동 감지
_find_taskmaster_path() {
    # 일반적인 설치 경로들을 확인
    local paths=(
        "/Users/isy_macair/Projects/taskmaster"
        "$HOME/Projects/taskmaster"
        "$HOME/taskmaster"
        "$(which task-master-ai | xargs dirname | xargs dirname 2>/dev/null)"
    )
    
    for path in "${paths[@]}"; do
        if [ -d "$path/.taskmaster/templates" ]; then
            echo "$path"
            return 0
        fi
    done
    
    # 현재 디렉토리에서 상위로 검색
    local current_dir="$(pwd)"
    while [ "$current_dir" != "/" ]; do
        if [ -d "$current_dir/.taskmaster/templates" ]; then
            echo "$current_dir"
            return 0
        fi
        current_dir="$(dirname "$current_dir")"
    done
    
    return 1
}

# VS Code 환경 설정 함수
setup-vscode() {
    local target_dir="${1:-$(pwd)}"
    local taskmaster_path
    
    tm_info "VS Code 환경 설정을 시작합니다..."
    
    # Taskmaster 경로 찾기
    if ! taskmaster_path=$(_find_taskmaster_path); then
        tm_error "Taskmaster 설치 경로를 찾을 수 없습니다."
        tm_info "다음 중 하나를 실행해주세요:"
        tm_info "  1. npm install -g task-master-ai"
        tm_info "  2. git clone https://github.com/taskmaster-ai/taskmaster"
        return 1
    fi
    
    tm_info "Taskmaster 경로: $taskmaster_path"
    
    # 절대 경로로 변환
    target_dir=$(cd "$target_dir" && pwd)
    
    # 템플릿 복사
    if [ -d "$taskmaster_path/.taskmaster/templates" ]; then
        tm_info "VS Code 설정 파일을 복사합니다..."
        
        # .github/instructions/ 디렉토리 생성 및 복사
        if [ -d "$taskmaster_path/.taskmaster/templates/github/instructions" ]; then
            mkdir -p "$target_dir/.github/instructions"
            cp -r "$taskmaster_path/.taskmaster/templates/github/instructions/"* "$target_dir/.github/instructions/"
            tm_success "GitHub instructions 복사 완료"
        fi
        
        # .github/copilot-instructions.md 복사
        if [ -f "$taskmaster_path/.taskmaster/templates/github/copilot-instructions.md" ]; then
            mkdir -p "$target_dir/.github"
            cp "$taskmaster_path/.taskmaster/templates/github/copilot-instructions.md" "$target_dir/.github/"
            tm_success "GitHub copilot-instructions.md 복사 완료"
        fi
        
        # .vscode/settings.json 복사
        if [ -f "$taskmaster_path/.taskmaster/templates/vscode/settings.json" ]; then
            mkdir -p "$target_dir/.vscode"
            cp "$taskmaster_path/.taskmaster/templates/vscode/settings.json" "$target_dir/.vscode/"
            tm_success "VS Code settings.json 복사 완료"
        fi
        
        # 다른 에디터 설정 정리
        tm_info "다른 에디터 설정 파일을 확인하는 중..."
        local editor_configs=(
            ".cursor:Cursor AI editor:dir"
            ".roo:Roo.dev:dir"
            ".roomodes:Roo editor modes file:file"
            ".windsurf:Windsurf editor:dir"
            ".windsurfrules:Windsurf rules file:file"
            ".v0:V0:dir"
            ".bolt:Bolt:dir"
            ".replit:Replit:dir"
        )
        
        local found_configs=()
        for config_entry in "${editor_configs[@]}"; do
            local config_path="${config_entry%%:*}"
            local config_rest="${config_entry#*:}"
            local config_desc="${config_rest%%:*}"
            local config_type="${config_rest##*:}"
            
            if [ "$config_type" = "dir" ] && [ -d "$target_dir/$config_path" ]; then
                found_configs+=("$config_entry")
            elif [ "$config_type" = "file" ] && [ -f "$target_dir/$config_path" ]; then
                found_configs+=("$config_entry")
            fi
        done
        
        if [ ${#found_configs[@]} -gt 0 ]; then
            tm_warning "다른 에디터 설정들이 발견되었습니다:"
            for config_entry in "${found_configs[@]}"; do
                local config_path="${config_entry%%:*}"
                local config_rest="${config_entry#*:}"
                local config_desc="${config_rest%%:*}"
                local config_type="${config_rest##*:}"
                
                if [ "$config_type" = "dir" ]; then
                    echo "  - $config_path/ ($config_desc directory)"
                else
                    echo "  - $config_path ($config_desc file)"
                fi
            done
            
            echo "이 설정들을 제거하시겠습니까? (y/N)"
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                for config_entry in "${found_configs[@]}"; do
                    local config_path="${config_entry%%:*}"
                    local config_rest="${config_entry#*:}"
                    local config_desc="${config_rest%%:*}"
                    local config_type="${config_rest##*:}"
                    
                    if [ "$config_type" = "dir" ]; then
                        if rm -rf "$target_dir/$config_path" 2>/dev/null; then
                            tm_success "$config_path/ 디렉토리 제거됨 ($config_desc)"
                        else
                            tm_error "$config_path/ 디렉토리 제거 실패"
                        fi
                    else
                        if rm -f "$target_dir/$config_path" 2>/dev/null; then
                            tm_success "$config_path 파일 제거됨 ($config_desc)"
                        else
                            tm_error "$config_path 파일 제거 실패"
                        fi
                    fi
                done
            else
                tm_info "다른 에디터 설정들을 유지합니다"
            fi
        fi
        
        tm_success "VS Code 환경 설정이 완료되었습니다!"
        tm_info "다음 단계:"
        tm_info "  1. code . (VS Code 열기)"
        tm_info "  2. GitHub Copilot 확장 프로그램 설치"
        tm_info "  3. 한국어 instruction 확인"
        
    else
        tm_error "템플릿 파일을 찾을 수 없습니다."
        return 1
    fi
}

# 특정 디렉토리에 VS Code 환경 설정
setup-vscode-for() {
    if [ -z "$1" ]; then
        tm_error "사용법: setup-vscode-for <디렉토리>"
        tm_info "예시: setup-vscode-for /path/to/my/project"
        return 1
    fi
    
    if [ ! -d "$1" ]; then
        tm_error "디렉토리가 존재하지 않습니다: $1"
        return 1
    fi
    
    setup-vscode "$1"
}

# Taskmaster 프로젝트 완전 초기화
tm-init() {
    local project_dir="${1:-$(pwd)}"
    
    tm_info "🚀 Taskmaster 프로젝트 초기화를 시작합니다..."
    
    # 디렉토리로 이동
    if ! cd "$project_dir"; then
        tm_error "디렉토리에 접근할 수 없습니다: $project_dir"
        return 1
    fi
    
    # Taskmaster 초기화
    tm_info "📦 Taskmaster 초기화 중..."
    if command -v task-master-ai &> /dev/null; then
        task-master-ai init --yes
    elif command -v npx &> /dev/null; then
        npx task-master-ai init --yes
    else
        tm_error "task-master-ai 또는 npx를 찾을 수 없습니다."
        tm_info "다음 중 하나를 실행해주세요:"
        tm_info "  npm install -g task-master-ai"
        tm_info "  npm install task-master-ai"
        return 1
    fi
    
    # VS Code 환경 설정
    tm_info "⚙️ VS Code 환경 설정 중..."
    setup-vscode "$project_dir"
    
    tm_success "✅ 프로젝트 초기화 완료!"
    tm_info "📝 다음 단계:"
    tm_info "   1. PRD 파일 작성: .taskmaster/docs/prd.txt"
    tm_info "   2. PRD 파싱: tm parse-prd"
    tm_info "   3. VS Code 열기: code ."
}

# Taskmaster 명령어 단축키
alias tm='task-master-ai'
alias tm-list='task-master-ai list'
alias tm-next='task-master-ai next'
alias tm-add='task-master-ai add'
alias tm-get='task-master-ai get'
alias tm-expand='task-master-ai expand'
alias tm-parse='task-master-ai parse-prd'

# 함수 단축키 (하이픈 지원)
alias tm-status='tm_status'
alias tm-help='tm_help'

# VS Code + Taskmaster 통합 함수
tm-code() {
    local current_dir="$(pwd)"
    
    # 현재 디렉토리에 .taskmaster가 없으면 VS Code 환경만 설정
    if [ ! -d ".taskmaster" ]; then
        tm_warning "Taskmaster가 초기화되지 않은 프로젝트입니다."
        tm_info "VS Code 환경만 설정합니다..."
        setup-vscode
    fi
    
    # VS Code 열기
    if command -v code &> /dev/null; then
        code .
        tm_success "VS Code를 열었습니다."
    else
        tm_error "VS Code (code 명령어)를 찾을 수 없습니다."
        tm_info "VS Code를 설치하고 PATH에 추가해주세요."
    fi
}

# 프로젝트 상태 확인
tm_status() {
    local current_dir="$(pwd)"
    
    tm_info "📊 프로젝트 상태 확인"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Taskmaster 상태
    if [ -d ".taskmaster" ]; then
        tm_success "Taskmaster: 초기화됨"
        if [ -f ".taskmaster/tasks/tasks.json" ]; then
            local task_count=$(jq '.tasks | length' .taskmaster/tasks/tasks.json 2>/dev/null || echo "0")
            tm_info "작업 수: $task_count"
        fi
    else
        tm_warning "Taskmaster: 초기화 필요"
    fi
    
    # VS Code 설정 상태
    if [ -d ".vscode" ] && [ -f ".vscode/settings.json" ]; then
        tm_success "VS Code 설정: 존재함"
    else
        tm_warning "VS Code 설정: 필요함"
    fi
    
    # GitHub Copilot instructions 상태
    if [ -d ".github/instructions" ]; then
        local instruction_count=$(find .github/instructions -name "*.md" | wc -l)
        tm_success "GitHub Instructions: $instruction_count 개 파일"
    else
        tm_warning "GitHub Instructions: 필요함"
    fi
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # 추천 액션
    if [ ! -d ".taskmaster" ]; then
        tm_info "💡 추천: tm-init (완전 초기화)"
    elif [ ! -d ".vscode" ] || [ ! -d ".github/instructions" ]; then
        tm_info "💡 추천: setup-vscode (VS Code 환경 설정)"
    else
        tm_info "💡 추천: tm-code (VS Code 열기)"
    fi
}

# 도움말 함수
tm_help() {
    echo "🔧 Taskmaster VS Code 환경 설정 도구"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    echo "📦 프로젝트 초기화:"
    echo "  tm-init [디렉토리]     - Taskmaster + VS Code 완전 초기화"
    echo "  setup-vscode [디렉토리] - VS Code 환경만 설정"
    echo
    echo "🔧 개발 도구:"
    echo "  tm-code               - VS Code 열기 (환경 설정 포함)"
    echo "  tm-status             - 프로젝트 상태 확인"
    echo
    echo "📋 Taskmaster 단축키:"
    echo "  tm                    - task-master-ai"
    echo "  tm-list               - 작업 목록 보기"
    echo "  tm-next               - 다음 작업 확인"
    echo "  tm-add                - 작업 추가"
    echo "  tm-get                - 작업 상세 보기"
    echo "  tm-expand             - 작업 확장"
    echo "  tm-parse              - PRD 파싱"
    echo
    echo "❓ 도움말:"
    echo "  tm-help               - 이 도움말 보기"
    echo
}

# 초기 메시지 (함수 로드 시)
tm_info "🔧 Taskmaster VS Code 환경 도구가 로드되었습니다."
tm_info "사용법: tm-help"
