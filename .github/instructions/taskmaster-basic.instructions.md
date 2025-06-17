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
   2. PRD 작성 (.taskmaster/docs/prd.txt)
   3. parse_prd로 초기 작업 생성
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
- MCP 도구를 CLI보다 우선 사용
- 하위 작업은 부모 작업을 통해서만 조회 가능
- AI 기반 도구들은 처리 시간이 필요함을 사용자에게 안내


