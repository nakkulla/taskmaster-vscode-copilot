---
description: "Taskmaster 기반 개발 워크플로우 및 작업 관리 가이드"
applyTo: "**"
---

# Taskmaster 기반 개발 워크플로우 가이드

## 기본 개발 원칙

### 기본 자세
- **기본 컨텍스트**: 대부분의 프로젝트에서 사용자는 `master` 태그 컨텍스트에서 작업할 수 있습니다
- **초기 행동**: 멀티 컨텍스트 작업의 명확한 패턴이 나타나지 않는 한 기본 컨텍스트에서 작업하세요
- **목표**: 적절한 컨텍스트를 감지했을 때 **태그 기반 작업 목록**과 같은 고급 기능을 지능적으로 도입하여 사용자의 워크플로우를 향상시키는 것입니다

## 기본 개발 사이클

Taskmaster를 사용한 효율적인 개발 사이클:

1. **`get_tasks`**: 현재 해야 할 작업 목록 확인
2. **`next_task`**: 다음에 작업할 항목 결정  
3. **`get_task`**: 특정 작업의 상세 정보 조회
4. **`expand_task`**: 복잡한 작업을 관리 가능한 하위 작업으로 분해
5. **구현**: 코드 작성 및 테스트
6. **`update_subtask`**: 진행 상황과 발견사항 기록
7. **`set_task_status`**: 완료된 작업을 'done'으로 표시
8. **반복**

모든 표준 명령 실행은 사용자의 현재 작업 컨텍스트에서 작동하며, 기본값은 `master`입니다.

## 기본 워크플로우 (단순 프로젝트)

### 프로젝트 시작
새 프로젝트나 사용자가 시작할 때는 `master` 태그 컨텍스트에서 작업합니다:

- `initialize_project` 또는 `parse_prd`로 새 프로젝트 시작
- `get_tasks`로 현재 작업, 상태, ID 확인
- `next_task`로 다음 작업 결정
- `analyze_project_complexity --research`로 작업 분해 전 복잡도 분석
- `complexity_report`로 복잡도 분석 결과 검토
- 의존성(모두 'done' 표시), 우선순위, ID 순서를 기반으로 작업 선택
- `get_task`으로 구현 요구사항 파악
- `expand_task --force --research`로 복잡한 작업 분해
- 작업 세부사항, 의존성, 프로젝트 표준에 따라 코드 구현
- `set_task_status --status=done`으로 완료 작업 표시
- 구현이 원래 계획과 다를 경우 `update` 또는 `update_task`로 의존 작업 업데이트

### 작업 복잡도 분석
```typescript
// 작업 분해 전 복잡도 분석 필수
// 1. analyze_project_complexity --research 실행
// 2. complexity_report로 결과 검토
// 3. 높은 복잡도(8-10점) 작업 우선 분해
```

### 작업 진행 프로세스
```typescript
// 1. 작업 상세 정보 확인
// get_task로 구현 요구사항 파악

// 2. 복잡한 작업 분해
// expand_task --force --research로 하위 작업 생성

// 3. 코드 구현
// 작업 세부사항, 의존성, 프로젝트 표준 준수

// 4. 완료 표시
// set_task_status --status=done으로 완료 처리

// 5. 의존 작업 업데이트
// 구현이 원래 계획과 다를 경우 update 또는 update_task 사용
```

## 고급 워크플로우 (태그 기반 관리)

### 태그 시스템 활용 시기

태그 도입은 프로젝트가 단순한 작업 관리를 넘어선 것을 감지했을 때만 제안합니다:

#### 1. Git 브랜치 기반 개발
```bash
# 새 브랜치 생성 시
git checkout -b feature/user-auth

# 대응하는 태그 생성 제안
# "브랜치 작업을 위한 별도 태그를 생성하여 
# 작업을 분리하고 나중에 merge 충돌을 방지하겠습니다."
```

#### 2. 팀 협업
```typescript
// 팀원과 함께 작업할 때
// "Alice와 협업하는 동안 별도 작업 컨텍스트를 생성하여
// 충돌을 방지하겠습니다."
// add_tag my-work --copy-from-current
```

#### 3. 실험적 작업
```typescript
// 리스크가 있는 실험이나 리팩터링
// "실험적 작업을 위한 임시 태그를 생성하여
// 메인 작업 목록과 분리하겠습니다."
// add_tag experiment-zustand
```

#### 4. 대규모 기능 개발 (PRD 기반)
```typescript
// 주요 기능 개발 시
// 1. add_tag feature-xyz 전용 태그 생성
// 2. 상세한 PRD 문서 작성
// 3. parse_prd로 태그에 작업 생성
// 4. analyze_project_complexity 및 expand_all 실행
```

### 버전별 개발 접근법

#### 프로토타입/MVP 태그 (`prototype`, `mvp`, `v0.x`)
- **접근 방식**: 속도와 기능성 우선
- **작업 생성**: "작동하게 만들기" 중심
- **복잡도**: 낮은 복잡도, 적은 하위 작업
- **연구 프롬프트**: "이는 프로토타입이므로 최적화보다 속도와 기본 기능을 우선시"

#### 프로덕션/안정 태그 (`v1.0+`, `production`, `stable`)
- **접근 방식**: 견고성, 테스트, 유지보수성 강조
- **작업 생성**: 포괄적인 오류 처리, 테스트, 문서화 포함
- **복잡도**: 높은 복잡도, 상세한 하위 작업
- **연구 프롬프트**: "이는 프로덕션이므로 신뢰성, 성능, 유지보수성 우선시"

## 작업 세부 관리

### 작업 구조 이해
```typescript
interface Task {
  id: number;             // JSON에서는 숫자 (예: 1, 4.1)
  title: string;          // 간단한 설명 제목
  description: string;    // 작업 내용 요약
  status: string;         // 현재 상태 ("pending", "done", "deferred")
  dependencies: number[]; // 선행 작업 ID 목록
  priority: string;       // 중요도 ("high", "medium", "low")
  details: string;        // 상세 구현 지침
  testStrategy: string;   // 검증 방법
  subtasks: Task[];       // 하위 작업 목록
}

// MCP 전송 시 모든 ID는 숫자로 사용
// 예: 4.1, 15
```

### 하위 작업 조회 및 조작
```typescript
// ✅ 올바른 하위 작업 조회 방법
get_task --id=4  // 부모 작업 조회 (하위 작업 포함)
// 응답의 subtasks 배열에서 원하는 하위 작업 확인

// ✅ 하위 작업 상태 변경
set_task_status --id=4.1 --status="done"

// ✅ 하위 작업 진행 상황 업데이트  
update_subtask --id=4.7 --prompt="68개 파일 분류 진행 중"

// ❌ 지원하지 않는 방식
get_task --id=4.1  // 하위 작업 독립 조회 불가
```
```

### 의존성 관리
```typescript
// 의존성 추가
// add_dependency --id=<작업ID> --depends-on=<선행작업ID>

// 의존성 제거  
// remove_dependency --id=<작업ID> --depends-on=<선행작업ID>

// 순환 의존성 방지 및 중복 항목 자동 검사
// 의존성 변경 후 작업 파일 자동 재생성
```

### 작업 재구성
```typescript
// 작업 위치 이동
// move_task --from=<원본ID> --to=<대상ID>

// 지원되는 이동 유형:
// - 독립 작업을 하위 작업으로 (5 → 7)
// - 하위 작업을 독립 작업으로 (5.2 → 7)
// - 하위 작업을 다른 부모로 (5.2 → 7.3)
// - 같은 부모 내 순서 변경 (5.2 → 5.4)
// - 여러 작업 일괄 이동 (10,11,12 → 16,17,18)
```

## 하위 작업 구현 프로세스

### 반복적 구현 사이클
```typescript
// 1. 목표 이해
// get_task <부모ID>로 하위 작업 요구사항 파악
// 예: get_task --id=4로 조회 후 subtasks에서 4.7 확인

// 2. 초기 탐색 및 계획
// - 코드베이스 탐색하여 수정할 파일/함수 식별
// - 구체적인 코드 변경사항 결정
// - 모든 관련 세부사항 수집

// 3. 계획 기록
// update_subtask --id=4.7 --prompt='<상세 계획>'
// 파일 경로, 라인 번호, 제안된 diff, 추론, 잠재적 문제점 포함

// 4. 계획 검증
// get_task --id=4로 계획이 성공적으로 기록되었는지 확인
// subtasks 배열에서 해당 하위 작업의 details 확인

// 5. 구현 시작
// set_task_status --id=4.7 --status="in-progress"

// 6. 진행 상황 기록 (지속적)
// update_subtask로 다음 내용 기록:
// - 작동한 것 ("근본적 진실" 발견사항)
// - 작동하지 않은 것과 이유
// - 성공한 구체적 코드 스니펫
// - 내린 결정들
// - 초기 계획에서의 편차와 그 이유

// 7. 규칙 검토 및 업데이트
// 구현 완료 후 새로운 패턴이나 관습 식별 및 문서화

// 8. 작업 완료 표시
// set_task_status --id=4.7 --status="done"

// 9. Git 커밋
// 코드 변경사항과 규칙 업데이트를 포함한 포괄적 커밋

// 10. 다음 하위 작업으로 진행
// next_task로 다음 작업 식별
```

## 구현 편차 처리

### 계획 변경이 필요한 경우
```typescript
// 구현이 계획과 크게 다를 때
// 미래 작업이 현재 구현 선택에 따라 수정이 필요할 때
// 새로운 의존성이나 요구사항이 나타날 때

// 여러 미래 작업 업데이트
// update --from=<미래작업ID> --prompt='<설명>' --research

// 특정 작업 하나만 업데이트  
// update_task --id=<작업ID> --prompt='<설명>' --research
```

## 작업 상태 관리

### 상태 유형별 활용
```typescript
// 'pending': 작업 준비 완료
// 'in-progress': 현재 진행 중
// 'done': 완료 및 검증됨
// 'review': 검토 대기 중
// 'deferred': 연기됨
// 'cancelled': 취소됨
// 프로젝트별 커스텀 상태 추가 가능
```

## 구성 관리

### 설정 파일 구조
```typescript
// .taskmaster/config.json (주요 설정)
// - AI 모델 선택 (main, research, fallback)
// - 매개변수 (max tokens, temperature)
// - 로깅 레벨
// - 태그 시스템 설정

// .env / .cursor/mcp.json (API 키)
// - 민감한 API 키들만 환경 변수로 관리
// - CLI 사용 시: .env 파일
// - MCP/Cursor 사용 시: mcp.json의 env 섹션

// .taskmaster/state.json (태그 시스템 상태)
// - 현재 태그 컨텍스트 추적
// - 마이그레이션 상태
```

## 최적화된 작업 흐름

### 효율적인 명령어 사용
```typescript
// 작업 조회 최적화
// get_task 1,2,3 (여러 작업 한 번에 조회)

// 연구 도구 적극 활용
// research --tree --files로 최신 정보 수집

// 복잡도 분석 우선 실행
// 프로젝트 초기에 analyze_project_complexity 실행

// 태그별 작업 분리
// 큰 프로젝트는 기능별로 태그 분리하여 관리
```

### 성능 고려사항
```typescript
// AI 처리 도구는 약 1분 소요됨을 안내
// 의존성 체인 관리로 올바른 작업 순서 유지
// 태그 삭제 시 해당 태그의 모든 작업이 함께 삭제됨에 주의
```

## 코드 분석 및 리팩터링

### 최상위 함수 검색
```bash
# 모듈 구조 이해나 리팩터링 계획 시 유용
rg "export (async function|function|const) \w+"

# 파일 간 함수 비교, 네이밍 충돌 식별에 활용
```

이 가이드를 통해 Taskmaster를 활용한 체계적이고 효율적인 개발 워크플로우를 구축하세요.
