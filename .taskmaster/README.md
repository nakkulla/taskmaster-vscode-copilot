# Taskmaster VS Code 환경 자동화 도구

이 디렉토리는 Taskmaster 프로젝트에서 VS Code 개발 환경을 자동으로 설정하는 도구들을 포함합니다.

## 🚀 빠른 설치 (권장)

### 1. Shell 함수 설치
```bash
# 한 번만 실행하면 됩니다
cd /path/to/taskmaster
./.taskmaster/install-functions.sh
```

### 2. 활성화
```bash
# 새 터미널을 열거나
source ~/.bashrc  # 또는 ~/.zshrc
```

### 3. 사용하기
```bash
# 새 프로젝트 생성 및 초기화
mkdir my-project && cd my-project
tm-init

# 기존 프로젝트에 VS Code 환경 설정
cd existing-project
setup-vscode

# VS Code 열기 (환경 설정 포함)
tm-code

# 도움말 보기
tm-help
```

## 📋 주요 명령어

### 프로젝트 관리
- `tm-init [디렉토리]` - Taskmaster 프로젝트 완전 초기화
- `tm-status` - 프로젝트 상태 확인
- `tm-help` - 도움말 보기

### VS Code 환경 설정
- `setup-vscode [디렉토리]` - VS Code 환경 설정 + 다른 에디터 설정 정리
  - `--clean-all`: 모든 다른 에디터 설정 자동 삭제
  - `--clean-none`: 다른 에디터 설정 삭제 건너뛰기
- `setup-vscode-for <디렉토리>` - 특정 디렉토리에 VS Code 환경 설정
- `tm-code` - VS Code 열기 (환경 설정 포함)

### Taskmaster 단축키
- `tm` - task-master-ai 명령어
- `tm-list` - 작업 목록 보기
- `tm-next` - 다음 작업 확인
- `tm-add` - 작업 추가
- `tm-get` - 작업 상세 보기
- `tm-expand` - 작업 확장
- `tm-parse` - PRD 파싱

## 🔧 수동 설치 (고급 사용자)

### 개별 스크립트 실행
```bash
# VS Code 환경만 설정
./setup-vscode.sh [target-directory]

# Node.js 버전 (Windows 호환)
node setup-vscode.js [target-directory]

# 글로벌 설치 (다른 프로젝트에서도 사용 가능)
./setup-vscode-global.sh [target-directory]
node setup-vscode-global.js [target-directory]
```

### 기존 Alias 설치 (레거시)
```bash
./install-aliases.sh
```

## 📁 포함된 파일

### 🏗️ 설치 스크립트
- `install-functions.sh` - **Shell 함수 설치 (권장)**
- `install-aliases.sh` - 기존 alias 설치 (레거시)

### 🔧 VS Code 환경 설정 스크립트
- `setup-vscode.sh` - 로컬 Bash 스크립트
- `setup-vscode.js` - 로컬 Node.js 스크립트
- `setup-vscode-global.sh` - 글로벌 Bash 스크립트
- `setup-vscode-global.js` - 글로벌 Node.js 스크립트

### 📦 Shell 통합
- `bashrc-functions.sh` - **현대적인 Shell 함수들 (권장)**
- `bashrc-aliases.sh` - 기존 alias 정의 (레거시)

### 📋 템플릿
- `templates/github/instructions/` - GitHub Copilot instruction 파일들
- `templates/github/copilot-instructions.md` - 메인 instruction 파일
- `templates/vscode/settings.json` - VS Code 설정 파일

## 🎯 설정되는 내용

### GitHub Copilot Instructions
- 한국어 코딩 가이드라인
- Taskmaster 기반 워크플로우
- 코드 품질 및 개선 가이드
- 개발 환경 최적화 규칙

### VS Code 설정
- GitHub Copilot 한국어 환경
- Instruction 파일 자동 참조
- 개발 최적화 설정

### 자동화 기능
- 템플릿 파일 자동 복사
- 디렉토리 구조 자동 생성
- 설정 파일 자동 적용

## 🧹 자동 정리 기능
설정 중에 다른 에디터의 설정 폴더들을 자동으로 정리합니다:
- `.cursor` (Cursor AI editor)
- `.roo` (Roo.dev)  
- `.windsurf` (Windsurf editor)
- `.anthropic`, `.claude`, `.v0` (AI 도구들)
- `.bolt`, `.replit` (기타 개발 환경)

## 🔍 트러블슈팅

### 함수가 로드되지 않는 경우
```bash
# 설치 상태 확인
grep -n "Taskmaster" ~/.bashrc  # 또는 ~/.zshrc

# 수동 활성화
source ~/.bashrc  # 또는 ~/.zshrc

# 함수 파일 직접 로드
source /path/to/taskmaster/.taskmaster/bashrc-functions.sh
```

### 경로 문제
```bash
# Taskmaster 경로 확인
which task-master-ai

# 또는 npm 글로벌 설치
npm install -g task-master-ai
```

### 권한 문제
```bash
# 실행 권한 확인 및 부여
chmod +x .taskmaster/*.sh
```

## 🤝 지원되는 환경

- **Shell**: Bash, Zsh
- **OS**: macOS, Linux
- **Node.js**: v16+ (Node.js 스크립트 사용 시)
- **VS Code**: 최신 버전 권장
- **GitHub Copilot**: 확장 프로그램 설치 필요

## 📚 추가 정보

- [Taskmaster 공식 문서](https://github.com/taskmaster-ai/taskmaster)
- [VS Code GitHub Copilot 가이드](https://docs.github.com/en/copilot)
- [GitHub Copilot Instructions 문서](https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot)

---

문제가 있거나 개선 사항이 있으시면 이슈를 등록해주세요!
