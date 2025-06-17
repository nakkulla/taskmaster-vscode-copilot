---
description: "Taskmaster MCP 기본 사용법 및 주요 도구 가이드"
applyTo: "**"
---

# Taskmaster MCP 기본 사용법

## 필수 도구들

### 프로젝트 관리
- **initialize_project**: 새 프로젝트 초기화
- **parse_prd**: PRD 문서로부터 작업 생성
- **get_tasks**: 작업 목록 조회
- **get_task**: 특정 작업 상세 조회
- **next_task**: 다음 작업 추천

### 작업 상태 관리
- **set_task_status**: 작업 상태 변경 (pending, in-progress, done, review, cancelled)
- **add_task**: 새 작업 추가
- **update_task**: 작업 내용 업데이트
- **update_subtask**: 하위 작업에 진행사항 추가

### 작업 구조화
- **expand_task**: 복잡한 작업을 하위 작업으로 분해
- **add_subtask**: 수동으로 하위 작업 추가
- **move_task**: 작업 위치 변경

## 기본 워크플로우

1. **프로젝트 시작**
   ```
   1. initialize_project로 프로젝트 초기화
   2. 한국어 PRD 작성 (.taskmaster/docs/prd.txt)
   3. parse_prd로 한국어 초기 작업 생성
   ```

2. **작업 진행**
   ```
   1. next_task로 다음 작업 확인
   2. set_task_status로 'in-progress'로 설정
   3. 작업 수행
   4. update_subtask로 진행사항 기록
   5. set_task_status로 'done'으로 변경
   ```

3. **복잡한 작업 처리**
   ```
   1. expand_task로 작업 분해
   2. 각 하위 작업 순차 처리
   3. update_task로 전체 상황 업데이트
   ```

## Taskmaster MCP Task ID 처리 방식

### ID 전송 형식
- **모든 ID는 숫자로 전송**: 메인 작업과 하위 작업 모두 숫자 형식 사용
- **메인 작업**: 1, 15, 3,4,5 (다중 조회 시 쉼표 구분)
- **하위 작업**: 4.1, 4.7, 15.2 형식

### 하위 작업 제한사항
- **독립 조회 불가**: `get_task --id=4.1` 지원하지 않음
- **부모 통해 조회**: `get_task --id=4`로 부모 작업 조회 후 subtasks 배열에서 확인
- **전용 도구 사용**: `set_task_status`, `update_subtask` 등 전용 도구로 조작

### 올바른 사용 예시
```typescript
// ✅ 하위 작업 상태 확인
get_task --id=4  // 부모 작업 조회하여 subtasks에서 확인

// ✅ 하위 작업 조작
set_task_status --id=4.1 --status="done"
update_subtask --id=4.7 --prompt="진행 상황"

// ❌ 잘못된 사용
get_task --id=4.1  // 오류 발생
```

## 중요 사항

- 모든 응답과 설명은 한국어로 작성
- 작업 제목, 설명, 세부사항은 반드시 한국어로 작성
- PRD 문서는 한국어로 작성하여 자연스러운 한국어 작업 생성
- MCP 도구를 CLI보다 우선 사용
- 하위 작업은 부모 작업을 통해서만 조회 가능
- AI 기반 도구들은 처리 시간이 필요함을 사용자에게 안내

## PRD 및 작업 작성 가이드라인

### PRD 작성 원칙
- 프로젝트 개요와 목표를 명확한 한국어로 작성
- 기능 요구사항은 사용자 관점에서 한국어로 서술
- 기술적 제약사항과 가정도 한국어로 명시
- 우선순위와 일정은 구체적으로 한국어로 표현

### 작업 생성 시 한국어 사용
- `add_task --prompt="사용자 로그인 기능 구현"` (한국어 프롬프트)
- `update_task --prompt="데이터베이스 연결 오류 해결 방안 추가"` (한국어 업데이트)
- `expand_task --prompt="React 컴포넌트를 세부 작업으로 분해"` (한국어 확장 지시)

### 작업 내용 한국어화 예시
```
작업 제목: "사용자 인증 시스템 구현"
작업 설명: "JWT 토큰 기반 로그인/로그아웃 기능을 개발하여 사용자 인증을 처리합니다."
세부사항: "1. 로그인 API 엔드포인트 생성
          2. JWT 토큰 생성 및 검증 로직 구현
          3. 프론트엔드 로그인 폼 개발
          4. 토큰 저장 및 자동 로그인 처리"
```

# Taskmaster MCP 도구 사용 가이드

## 기본 원칙

- 한국어로 응답하고 설명합니다
- Taskmaster MCP 도구를 우선적으로 사용하여 작업을 관리합니다
- CLI 명령어보다 MCP 도구를 권장합니다
- 체계적인 작업 관리 및 개발 워크플로우를 사용합니다

## 프로젝트 초기화 및 설정

### 1. 프로젝트 초기화 (`initialize_project`)
새로운 Taskmaster 프로젝트를 설정할 때 사용합니다.
- 프로젝트 루트 디렉토리에 기본 파일 구조와 설정을 생성합니다
- PRD 파일을 파싱하기 전에 반드시 실행해야 합니다

### 2. PRD 파싱 (`parse_prd`)
Product Requirements Document를 분석하여 초기 작업 목록을 생성합니다.
- `.taskmaster/docs/prd.txt` 파일을 기반으로 작업을 자동 생성
- AI 처리가 필요하여 완료까지 1분 정도 소요됩니다

## 작업 관리

### 작업 조회
- `get_tasks`: 전체 작업 목록 조회
- `get_task`: 특정 작업의 상세 정보 조회 (여러 ID를 쉼표로 구분하여 한 번에 조회 가능)
- `next_task`: 다음에 수행할 작업 찾기

### 작업 생성 및 수정
- `add_task`: 새 작업 추가 (AI 기반)
- `add_subtask`: 하위 작업 추가
- `update_task`: 특정 작업 업데이트 (AI 기반)
- `update_subtask`: 하위 작업에 타임스탬프와 함께 정보 추가
- `set_task_status`: 작업 상태 변경 (pending, in-progress, done, review, cancelled 등)

### 작업 구조 관리
- `expand_task`: 복잡한 작업을 하위 작업으로 분해 (AI 기반)
- `expand_all`: 모든 적격 작업을 하위 작업으로 확장
- `move_task`: 작업 위치 이동
- `remove_task`: 작업 삭제

## 의존성 관리

- `add_dependency`: 작업 간 의존성 추가
- `remove_dependency`: 의존성 제거
- `validate_dependencies`: 의존성 문제 확인
- `fix_dependencies`: 의존성 문제 자동 수정

## 분석 및 리포팅

- `analyze_project_complexity`: 작업 복잡도 분석 (AI 기반)
- `complexity_report`: 복잡도 분석 결과 조회
- `research`: AI 기반 연구 수행 (최신 정보 수집)

## 태그 관리

여러 컨텍스트(브랜치, 기능 등)에서 작업을 분리하여 관리할 수 있습니다.

- `list_tags`: 사용 가능한 태그 목록 조회
- `add_tag`: 새 태그 생성
- `use_tag`: 활성 태그 변경
- `copy_tag`: 태그 복사
- `delete_tag`: 태그 삭제

## 파일 관리

- `generate`: tasks.json을 기반으로 개별 마크다운 파일 생성

## 모델 설정

- `models`: AI 모델 설정 조회 및 변경

## 사용 예시

### 새 프로젝트 시작
1. `initialize_project` - 프로젝트 초기화
2. PRD 파일 작성 (`.taskmaster/docs/prd.txt`)
3. `parse_prd` - PRD를 기반으로 작업 생성
4. `get_tasks` - 생성된 작업 확인

### 일반적인 개발 워크플로우
1. `next_task` - 다음 작업 확인
2. `set_task_status` - 작업을 'in-progress'로 변경
3. 코딩 작업 수행
4. `update_subtask` - 진행 상황 기록
5. `set_task_status` - 작업을 'done'으로 변경

### 복잡한 작업 처리
1. `expand_task` - 복잡한 작업을 하위 작업으로 분해
2. 각 하위 작업을 순차적으로 처리
3. `update_task` - 전체 작업 상태 업데이트

## 주의사항

- AI 기반 도구들(`parse_prd`, `add_task`, `update_task`, `expand_task`, `research` 등)은 처리 시간이 필요합니다
- 여러 작업 정보가 필요한 경우 `get_task`에서 쉼표로 구분된 ID를 사용하여 한 번에 조회하세요
- 작업 상태는 정확히 관리하여 의존성 체인이 올바르게 작동하도록 하세요
- 연구 도구(`research`)를 적극 활용하여 최신 정보를 바탕으로 작업하세요

## 환경 변수 설정

필요한 API 키들을 `.env` 파일에 설정하거나 MCP 설정에 포함해야 합니다:
- `ANTHROPIC_API_KEY`
- `PERPLEXITY_API_KEY` (연구 기능용)
- `OPENAI_API_KEY`
- 기타 사용하는 AI 모델의 API 키

이 가이드를 참고하여 Taskmaster MCP 도구를 효과적으로 활용하세요


