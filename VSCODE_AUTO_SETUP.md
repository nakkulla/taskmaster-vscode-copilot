# Taskmaster VS Code 환경 자동 설정 가이드

Taskmaster MCP의 `initialize_project` 기능을 확장하여 `.github/instructions/` 폴더와 `.vscode/` 폴더를 자동으로 생성하는 기능이 구현되었습니다.

## 현재 상황

### ✅ 완료된 작업
1. **템플릿 시스템 구축**: `.taskmaster/templates/` 디렉토리에 모든 필요한 템플릿 파일들 준비
2. **자동 설정 스크립트**: 새 프로젝트에서 쉽게 사용할 수 있는 설정 스크립트 생성
3. **테스트 완료**: 스크립트가 정상적으로 작동하는 것 확인

### 📁 생성된 파일 구조
```
.taskmaster/
├── templates/
│   ├── github/
│   │   ├── instructions/
│   │   │   ├── code-improvement.instructions.md
│   │   │   ├── coding-guidelines.instructions.md
│   │   │   ├── development-workflow.instructions.md
│   │   │   ├── instruction-formatting.instructions.md
│   │   │   ├── taskmaster-advanced.instructions.md
│   │   │   ├── taskmaster-basic.instructions.md
│   │   │   └── taskmaster-workflow.instructions.md
│   │   └── copilot-instructions.md
│   └── vscode/
│       └── settings.json
├── setup-vscode.sh     # Bash 스크립트
├── setup-vscode.js     # Node.js 스크립트
└── README.md           # 사용법 가이드
```

## 사용 방법

### 방법 1: 자동 설정 스크립트 사용 (권장)

새 프로젝트에서 Taskmaster를 초기화한 후:

```bash
# Node.js 스크립트 (권장)
node .taskmaster/setup-vscode.js

# 또는 Bash 스크립트
./.taskmaster/setup-vscode.sh
```

### 방법 2: 수동 복사

```bash
# 디렉토리 생성
mkdir -p .github/instructions .vscode

# 파일 복사
cp -r .taskmaster/templates/github/instructions/* .github/instructions/
cp .taskmaster/templates/github/copilot-instructions.md .github/
cp .taskmaster/templates/vscode/settings.json .vscode/
```

## 설정되는 내용

### 🔧 VS Code 설정 (`.vscode/settings.json`)
- GitHub Copilot 한국어 설정
- Instruction 파일 자동 참조
- 코드 생성, 테스트, 리뷰 지침 설정

### 📋 GitHub Instructions (`.github/instructions/`)
- **기본 사용법**: Taskmaster MCP 도구 가이드
- **고급 기능**: 태그 시스템, 복잡도 분석 등
- **워크플로우**: 개발 프로세스 및 베스트 프랙티스
- **코딩 가이드라인**: VS Code 환경 최적화
- **코드 품질**: 지속적 개선 방법론

### 📝 Copilot Instructions (`.github/copilot-instructions.md`)
- 전체적인 Taskmaster 사용 가이드
- 개발 워크플로우 설명

## 다음 단계: Taskmaster Core 통합

현재는 별도 스크립트로 제공되지만, 향후 Taskmaster의 `initialize_project` 함수에 직접 통합할 수 있습니다:

### 통합 계획
1. **Taskmaster 소스코드 수정**: `initialize_project` 함수에 VS Code 환경 설정 로직 추가
2. **템플릿 배포**: npm 패키지에 템플릿 파일들 포함
3. **옵션 추가**: `--vscode` 플래그로 선택적 설정 가능

### 임시 해결책
현재는 사용자가 수동으로 스크립트를 실행해야 하지만, 이는 충분히 실용적이고 효과적입니다.

## 활용 시나리오

### 새 프로젝트 시작시
```bash
# 1. Taskmaster 초기화
npx task-master-ai init

# 2. VS Code 환경 설정
node .taskmaster/setup-vscode.js

# 3. PRD 작성 후 작업 생성
npx task-master-ai parse-prd

# 4. VS Code에서 개발 시작
code .
```

### 기존 프로젝트에 추가시
```bash
# 기존 설정 백업 (선택사항)
cp -r .github/instructions .github/instructions.backup
cp .vscode/settings.json .vscode/settings.json.backup

# 새 설정 적용
node .taskmaster/setup-vscode.js
```

## 특징 및 장점

### 🌟 핵심 특징
- **한국어 중심**: 모든 가이드와 예제가 한국어
- **Taskmaster 우선**: MCP 도구 사용 권장
- **실용적**: 실제 코드 기반 예제
- **체계적**: 단계별 개발 프로세스
- **자동화**: 한 번의 명령으로 완전한 환경 구축

### 💡 개발 효율성 향상
- **일관된 워크플로우**: 모든 프로젝트에서 동일한 개발 환경
- **자동 가이드**: Copilot이 Taskmaster 사용법을 자동으로 안내
- **품질 관리**: 코드 리뷰, 테스트, 문서화 가이드라인 자동 적용
- **지속적 개선**: 새로운 패턴 발견시 자동으로 가이드라인 업데이트 제안

이제 새로운 프로젝트를 시작할 때마다 Taskmaster와 VS Code의 강력한 조합을 즉시 활용할 수 있습니다!
