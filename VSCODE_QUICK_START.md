# 🚀 Taskmaster VS Code 환경 자동화 - 빠른 시작 가이드

## 설치 및 사용법

### 1. 함수 설치 (한 번만 실행)
```bash
cd /Users/isy_macair/Projects/taskmaster
./.taskmaster/install-functions.sh
```

### 2. 활성화 (터미널 재시작 또는)
```bash
source ~/.bashrc  # 또는 ~/.zshrc (Mac)
```

### 3. 사용하기
```bash
# 새 프로젝트 생성
mkdir my-awesome-project && cd my-awesome-project

# Taskmaster + VS Code 환경 완전 초기화
tm-init

# VS Code 열기
tm-code

# 또는 기존 프로젝트에 VS Code 환경만 추가
cd existing-project
setup-vscode
```

## 주요 명령어

### 🏗️ 프로젝트 관리
- `tm-init` - Taskmaster 프로젝트 완전 초기화
- `tm-status` - 프로젝트 상태 확인
- `setup-vscode` - VS Code 환경 설정

### 🔧 개발 도구  
- `tm-code` - VS Code 열기 (환경 설정 포함)
- `tm-help` - 도움말 보기

### 📋 Taskmaster 단축키
- `tm` = `task-master-ai`
- `tm-list` - 작업 목록
- `tm-next` - 다음 작업
- `tm-add` - 작업 추가
- `tm-get` - 작업 상세
- `tm-parse` - PRD 파싱

### 🗑️ 자동 정리 기능
- **다른 에디터 설정 폴더 자동 정리** - VS Code 환경 설정 시 다른 에디터 설정 자동 제거
- **지원되는 설정들**: `.cursor`, `.roo`, `.windsurf`, `.anthropic`, `.claude`, `.v0`, `.bolt`, `.replit`
- **정리 옵션**: 
  - 기본: 각 폴더별로 확인 후 삭제
  - `--clean-all`: 모든 폴더 자동 삭제
  - `--clean-none`: 정리 건너뛰기

## 자동 설정되는 내용

### 📁 `.github/instructions/` (GitHub Copilot용)
- 한국어 코딩 가이드라인
- Taskmaster 워크플로우 가이드
- 코드 품질 개선 규칙
- 개발 환경 최적화

### ⚙️ `.vscode/settings.json`
- GitHub Copilot 한국어 환경
- Instruction 파일 자동 참조
- 개발 최적화 설정

### 🎯 주요 특징
- **자동 경로 감지** - Taskmaster 설치 위치 자동 찾기
- **Shell 호환성** - Bash, Zsh 모두 지원
- **한국어 지원** - 모든 가이드와 메시지 한국어
- **완전 자동화** - 한 번 설치로 모든 프로젝트에 적용

## 문제 해결

### 함수가 로드되지 않는 경우
```bash
# 설치 확인
grep "Taskmaster" ~/.bashrc

# 수동 로드
source ~/.bashrc
```

### 권한 문제
```bash
chmod +x /Users/isy_macair/Projects/taskmaster/.taskmaster/*.sh
```

---

**🎉 이제 모든 설정이 완료되었습니다!**

`tm-help` 명령어로 언제든 도움말을 확인하세요.
