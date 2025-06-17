# Taskmaster VS Code Copilot Instructions

한국어 기반 VS Code GitHub Copilot instruction 환경 자동화 시스템입니다.

## 🎯 주요 기능

### 📁 체계화된 파일 구조
- **`.github/instructions/`**: GitHub Copilot instruction 파일들
- **`.vscode/settings.json`**: VS Code Copilot 설정 및 instruction 파일 참조
- **템플릿 시스템**: 재사용 가능한 프로젝트 템플릿

### 🤖 AI 기반 개발 가이드
- **Taskmaster MCP 통합**: 체계적인 작업 관리 워크플로우
- **한국어 코딩 가이드라인**: 실용적인 개발 모범 사례
- **코드 품질 개선**: 지속적 개선 및 패턴 인식

### ⚡ 자동화 도구
- **One-liner 설치**: 빠른 환경 설정
- **타 에디터 설정 정리**: 안전한 자동 정리 (Cursor, Windsurf, Roo 등)
- **Shell 함수**: 편리한 명령어 접근

## 🚀 빠른 시작

### 1. 환경 설정 함수 설치
```bash
curl -sSL https://raw.githubusercontent.com/your-repo/taskmaster/main/.taskmaster/install-functions.sh | bash
```

### 2. VS Code 환경 설정
```bash
# 현재 프로젝트에 설정
setup-vscode

# 특정 프로젝트에 설정  
setup-vscode-for /path/to/project

# 홈 디렉토리에 전역 설정
setup-vscode-global
```

### 3. 타 에디터 설정 정리 (선택사항)
```bash
# 모든 다른 에디터 설정 자동 삭제
setup-vscode --clean-all

# 정리 없이 VS Code만 설정
setup-vscode --clean-none

# 기본: 개별 확인 후 삭제
setup-vscode
```

## 📚 포함된 Instruction 파일들

### 🔧 Taskmaster MCP 가이드
- **`taskmaster-basic.instructions.md`**: 기본 사용법 및 주요 도구
- **`taskmaster-advanced.instructions.md`**: 고급 기능 및 전문 도구  
- **`taskmaster-workflow.instructions.md`**: 개발 워크플로우 및 작업 관리

### 💻 개발 가이드라인
- **`development-workflow.instructions.md`**: VS Code 개발 환경 가이드
- **`code-improvement.instructions.md`**: 코드 품질 향상 및 지속적 개선
- **`instruction-formatting.instructions.md`**: Instruction 파일 작성 규칙

## 🛠️ 자동 정리되는 에디터 설정

### 삭제 대상 (폴더)
- `.cursor` - Cursor AI 에디터
- `.roo` - Roo.dev
- `.windsurf` - Windsurf 에디터
- `.v0` - V0
- `.bolt` - Bolt  
- `.replit` - Replit

### 삭제 대상 (파일)
- `.roomodes` - Roo 에디터 모드 파일
- `.windsurfrules` - Windsurf 규칙 파일

### 보존 대상
- `.anthropic` - Anthropic 설정 (보존)
- `.claude` - Claude 설정 (보존)
- `.vscode` - VS Code 설정 (보존)
- `.github` - GitHub 설정 (보존)

## 📖 사용 가이드

### VS Code Copilot 설정 확인
1. VS Code에서 GitHub Copilot 확장 프로그램 설치
2. `.vscode/settings.json`에서 instruction 파일 참조 확인
3. Copilot Chat에서 한국어 가이드라인 동작 확인

### Taskmaster MCP 연동
1. Taskmaster MCP 서버 설정
2. `initialize_project`로 프로젝트 초기화
3. `get_tasks`, `add_task` 등으로 작업 관리
4. Copilot과 함께 체계적인 개발 진행

## 🎨 주요 특징

- **🇰🇷 한국어 우선**: 모든 주석, 문서, 가이드라인이 한국어
- **🤝 Taskmaster 통합**: MCP 기반 작업 관리와 완벽 연동
- **🔄 자동화**: 번거로운 설정 과정을 one-liner로 해결
- **🧹 깔끔한 환경**: 다른 에디터 설정을 안전하게 정리
- **📝 실용적 가이드**: 실제 개발에서 사용할 수 있는 구체적인 예제

## 🔧 고급 사용법

### 커스텀 instruction 파일 추가
1. `.github/instructions/` 디렉토리에 `.instructions.md` 파일 생성
2. frontmatter에 `description`과 `applyTo` 지정
3. `.vscode/settings.json`에서 `github.copilot.chat.instructionFiles` 배열에 추가

### 템플릿 커스터마이징
1. `.taskmaster/templates/` 디렉토리 수정
2. `setup-vscode.sh` 스크립트로 새 프로젝트에 적용

## 📄 라이선스

MIT License

## 🤝 기여하기

Issues와 Pull Requests를 환영합니다!

---

**Taskmaster + VS Code + GitHub Copilot = 🚀 한국어 개발 환경의 완성**
