# Cursor Rules → VS Code Settings 변환 가이드

이 문서는 Taskmaster 프로젝트의 Cursor rules를 VS Code Copilot 설정으로 변환하는 과정과 결과를 설명합니다.

## 변환 개요

### 원본 파일
- `.cursor/rules/taskmaster.mdc` - Cursor 전용 rules 파일

### 변환된 파일들
- `.vscode/settings.json` - VS Code Copilot 기본 설정
- `.github/copilot-instructions.md` - 워크스페이스 전체 커스텀 인스트럭션
- `.github/instructions/taskmaster-basic.instructions.md` - 기본 사용법 가이드
- `.github/instructions/taskmaster-advanced.instructions.md` - 고급 기능 가이드
- `.github/instructions/development-workflow.instructions.md` - 개발 워크플로우 가이드

## 변환 전략

### 1. VS Code Settings.json
GitHub Copilot의 기본 설정을 구성했습니다:

```json
{
  "github.copilot.chat.localeOverride": "ko",
  "github.copilot.chat.codeGeneration.useInstructionFiles": true,
  "github.copilot.enable": {
    "*": true,
    "plaintext": false,
    "markdown": true
  }
}
```

### 2. 커스텀 인스트럭션 구조
VS Code의 여러 인스트럭션 옵션을 활용했습니다:

- **워크스페이스 전체 적용**: `.github/copilot-instructions.md`
- **특정 파일 타입별 적용**: `.github/instructions/*.instructions.md`
- **작업 유형별 설정**: `settings.json`의 각 작업별 instructions

### 3. 한국어 지원
- `localeOverride: "ko"` 설정으로 한국어 응답 강제
- 모든 인스트럭션을 한국어로 번역
- 코드 주석과 문서도 한국어로 작성하도록 지시

## 주요 기능 매핑

### Taskmaster MCP 도구 가이드
- 32개 주요 MCP 도구의 사용법을 한국어로 번역
- CLI 대신 MCP 도구 우선 사용 지침
- 실제 워크플로우 예시 제공

### 작업 관리 워크플로우
1. **프로젝트 초기화**: `initialize_project` → `parse_prd`
2. **작업 진행**: `next_task` → `set_task_status` → `update_subtask`
3. **복잡한 작업**: `expand_task` → 하위 작업 처리 → `update_task`

### 개발 가이드라인
- 커밋 메시지 형식: `[작업유형] 변경사항 요약 (Task #ID)`
- 테스트 케이스명 한국어 작성
- 코드 리뷰 결과를 Taskmaster로 추적

## 설정 활성화 방법

### 1. VS Code에서 GitHub Copilot 확장 설치
```bash
code --install-extension GitHub.copilot
code --install-extension GitHub.copilot-chat
```

### 2. 설정 확인
- `Ctrl/Cmd + ,`로 설정 열기
- "copilot" 검색하여 설정 확인
- `settings.json`에서 직접 설정도 가능

### 3. 인스트럭션 파일 활성화
- `.github/copilot-instructions.md`는 자동으로 인식됨
- `.instructions.md` 파일들은 Chat에서 수동으로 선택 가능
- 설정에서 `useInstructionFiles: true`로 자동 적용 활성화

## 사용법

### 코드 생성 시
- 모든 주석과 설명이 한국어로 생성됨
- Taskmaster MCP 도구 사용 가이드가 자동 포함됨
- 체계적인 개발 워크플로우 적용

### 채팅 사용 시
- 한국어로 질문하고 답변 받기
- `/taskmaster`로 특정 도구 가이드 조회
- 작업 관리 관련 질문에 MCP 도구 우선 추천

### 커밋 메시지 생성 시
- 자동으로 한국어 커밋 메시지 생성
- Taskmaster 작업 ID 포함 형태로 생성
- 작업 유형별 분류 ([기능], [수정], [문서] 등)

## 제한사항 및 차이점

### VS Code vs Cursor 차이점
1. **적용 범위**: VS Code는 특정 파일 타입별 세밀한 제어가 더 어려움
2. **자동 적용**: Cursor의 `alwaysApply`와 달리 수동 선택이 필요한 경우가 있음
3. **성능**: 인스트럭션 파일이 많을 때 로딩 시간이 길어질 수 있음

### 주의사항
- 인스트럭션 파일들이 충돌하지 않도록 주의
- 너무 많은 인스트럭션은 토큰 제한에 걸릴 수 있음
- 설정 변경 후 VS Code 재시작 권장

## 향후 개선사항
- 더 세밀한 파일 타입별 인스트럭션 추가
- 프로젝트별 커스터마이징 가이드 제공
- 팀 단위 설정 동기화 방법 개발

## 문의 및 지원
이 변환 과정이나 사용법에 대한 문의는 프로젝트 이슈로 등록해 주세요.
