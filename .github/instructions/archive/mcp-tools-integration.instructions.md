---
description: "MCP 도구들을 최대한 활용한 개발 워크플로우 가이드"
applyTo: "**"
---

# MCP 도구 통합 활용 가이드

## 기본 원칙

- **모든 작업에 MCP 도구 우선 활용**: CLI 명령어보다 MCP 도구를 먼저 고려
- **복합 도구 활용**: 여러 MCP 도구를 조합하여 효율적인 워크플로우 구성
- **AI 기반 도구 적극 활용**: 연구, 분석, 자동화 도구들을 최대한 활용
- **한국어 기반 작업**: 모든 MCP 도구 사용 시 한국어로 프롬프트 및 설명 작성

## 사고 과정 및 문제 해결

### Sequential Thinking 활용
복잡한 문제 해결이나 계획 수립 시 `sequentialthinking` 도구를 적극 활용:

```typescript
// 복잡한 아키텍처 결정이 필요할 때
// 1. sequentialthinking으로 단계별 분석
// 2. 각 단계에서 발견한 인사이트를 기록
// 3. 최종 결정을 Taskmaster 작업으로 생성
// 4. 결정 과정을 update_subtask로 문서화
```

#### 활용 시나리오
- **아키텍처 설계**: 복잡한 시스템 설계 결정
- **버그 분석**: 다단계 디버깅 과정
- **기술 선택**: 라이브러리나 프레임워크 선택
- **리팩터링 계획**: 대규모 코드 변경 계획
- **성능 최적화**: 병목 지점 분석 및 해결책 도출

## 연구 및 정보 수집

### Tavily 검색 도구 활용
최신 기술 정보 수집과 트렌드 분석:

```typescript
// 새로운 기술 도입 전 조사
// 1. mcp_tavily-mcp_tavily-search로 최신 정보 검색
// 2. mcp_tavily-mcp_tavily-extract로 상세 문서 추출
// 3. sequentialthinking으로 정보 분석 및 결정
// 4. research 도구로 프로젝트 컨텍스트에 맞는 구체적 가이드 생성
// 5. add_task로 도입 작업 생성
```

### Context7 라이브러리 문서 활용
라이브러리 사용 시 정확한 문서 참조:

```typescript
// 새 라이브러리 사용 전
// 1. mcp_context7_resolve-library-id로 라이브러리 ID 확인
// 2. mcp_context7_get-library-docs로 최신 문서 획득
// 3. 문서 기반으로 구현 계획 수립
// 4. expand_task로 구현 단계 세분화
```

## GitHub 통합 워크플로우

### 이슈 및 PR 관리
GitHub MCP 도구를 활용한 완전한 개발 워크플로우:

```typescript
// 새 기능 개발 시 GitHub 통합 워크플로우
// 1. mcp_github_create_issue로 GitHub 이슈 생성
// 2. add_task로 Taskmaster 작업 생성 (GitHub 이슈 번호 포함)
// 3. mcp_github_create_branch로 개발 브랜치 생성
// 4. 개발 진행 (update_subtask로 진행 상황 기록)
// 5. mcp_github_create_or_update_file로 파일 업데이트
// 6. mcp_github_create_pull_request로 PR 생성
// 7. mcp_github_add_issue_comment로 진행 상황 업데이트
// 8. set_task_status로 작업 완료 표시
```

### 코드 분석 및 검토
```typescript
// 기존 코드베이스 분석 시
// 1. mcp_github_search_code로 관련 코드 검색
// 2. mcp_github_get_file_contents로 파일 내용 분석
// 3. sequentialthinking으로 개선점 도출
// 4. research로 최신 베스트 프랙티스 조사
// 5. update_task로 리팩터링 계획 수립
```

## Obsidian 지식 관리 통합

### 프로젝트 문서화
개발 과정에서 생성되는 지식을 체계적으로 관리:

```typescript
// 개발 과정에서 얻은 인사이트 문서화
// 1. mcp_obsidian-mcp-_obsidian_update_file로 노트 생성
// 2. mcp_obsidian-mcp-_obsidian_manage_tags로 태그 관리
// 3. mcp_obsidian-mcp-_obsidian_manage_frontmatter로 메타데이터 설정
// 4. update_subtask로 Taskmaster에 문서 링크 추가
```

### 지식 검색 및 재활용
```typescript
// 이전 경험 재활용
// 1. mcp_obsidian-mcp-_obsidian_global_search로 관련 노트 검색
// 2. 기존 해결책 분석 및 적용
// 3. 새로운 인사이트를 update_subtask로 기록
```

## 코드 생성 및 리팩터링

### 단계별 코드 개선
```typescript
// 복잡한 리팩터링 과정
// 1. sequentialthinking으로 리팩터링 계획 수립
// 2. mcp_tavily-mcp_tavily-search로 최신 패턴 조사
// 3. expand_task로 단계별 작업 분해
// 4. 각 단계마다 update_subtask로 진행 상황 기록
// 5. GitHub MCP로 변경사항 추적 및 PR 관리
```

### 테스트 및 검증
```typescript
// 품질 보증 프로세스
// 1. research로 테스트 전략 수립
// 2. mcp_context7로 테스트 라이브러리 문서 참조
// 3. 테스트 구현 후 update_subtask로 결과 기록
// 4. GitHub MCP로 테스트 결과 공유
```

## 프로젝트 관리 통합

### 작업 우선순위 결정
```typescript
// 복잡한 우선순위 결정 시
// 1. sequentialthinking으로 다각도 분석
// 2. research로 업계 트렌드 조사
// 3. analyze_project_complexity로 작업 복잡도 분석
// 4. 결과를 바탕으로 작업 우선순위 재정렬
```

### 팀 협업 최적화
```typescript
// 팀 작업 시 MCP 도구 활용
// 1. GitHub MCP로 이슈 및 PR 상태 추적
// 2. Obsidian MCP로 팀 지식 공유
// 3. Taskmaster로 개인 작업 관리
// 4. 정기적으로 update_subtask로 팀 현황 공유
```

### PRD 후 작업 브리핑 워크플로우
```typescript
// PRD 파싱 후 체계적 브리핑 프로세스
// 1. parse_prd로 초기 작업 생성
// 2. get_tasks로 전체 작업 목록 확인
// 3. analyze_project_complexity --research로 복잡도 분석
// 4. complexity_report로 상세 분석 결과 검토
// 5. sequentialthinking으로 작업 계획 전체적 분석
// 6. 사용자에게 종합 브리핑 제공:
//    - 총 작업 수 및 분류별 현황
//    - 복잡도별 작업 분포
//    - 예상 개발 기간 및 리스크 요소
//    - 권장 우선순위 및 의존성 구조
// 7. 피드백 반영: add_task, remove_task, update_task, move_task
// 8. 최종 승인 후 next_task로 개발 시작
```

## 학습 및 개발 역량 향상

### 지속적 학습 프로세스
```typescript
// 새로운 기술 학습 시
// 1. mcp_tavily-mcp_tavily-search로 최신 트렌드 파악
// 2. mcp_context7로 공식 문서 학습
// 3. sequentialthinking으로 학습 계획 수립
// 4. 실습 프로젝트를 Taskmaster 작업으로 관리
// 5. 학습 결과를 Obsidian으로 문서화
// 6. GitHub에 예제 코드 및 경험 공유
```

### 문제 해결 패턴 구축
```typescript
// 반복되는 문제 해결 패턴 구축
// 1. 문제 발생 시 sequentialthinking으로 분석
// 2. 해결 과정을 update_subtask로 상세 기록
// 3. 성공한 해결책을 Obsidian에 패턴으로 문서화
// 4. 유사한 문제 발생 시 검색하여 재활용
```

## 자동화 및 효율성 최적화

### 반복 작업 자동화
```typescript
// 반복되는 작업 패턴 식별 및 자동화
// 1. get_tasks로 반복 패턴 분석
// 2. sequentialthinking으로 자동화 방안 도출
// 3. GitHub Actions나 스크립트로 자동화 구현
// 4. 자동화 결과를 update_subtask로 추적
```

### 워크플로우 최적화
```typescript
// 개발 워크플로우 지속적 개선
// 1. 정기적으로 complexity_report 검토
// 2. 비효율적인 패턴을 sequentialthinking으로 분석
// 3. 개선 방안을 research로 조사
// 4. 최적화 작업을 add_task로 계획
// 5. 효과를 측정하여 Obsidian에 기록
```

## 오류 처리 및 디버깅

### 체계적 디버깅
```typescript
// 복잡한 버그 해결 시
// 1. sequentialthinking으로 문제 분석
// 2. mcp_tavily-mcp_tavily-search로 유사 사례 검색
// 3. GitHub MCP로 관련 이슈 검색
// 4. 단계별 해결 과정을 update_subtask로 기록
// 5. 해결책을 Obsidian에 패턴으로 저장
```

### 성능 최적화
```typescript
// 성능 문제 해결 시
// 1. research로 성능 분석 도구 조사
// 2. sequentialthinking으로 최적화 전략 수립
// 3. 각 최적화 시도를 update_subtask로 추적
// 4. 결과를 측정하여 효과적인 방법 문서화
```

## 도구별 활용 시나리오 매트릭스

| 상황 | Primary MCP | Secondary MCP | Tertiary MCP |
|------|-------------|---------------|--------------|
| 복잡한 문제 해결 | sequentialthinking | research | update_subtask |
| 새 기술 도입 | tavily-search | context7 | add_task |
| 코드 리뷰 | github_* | obsidian_* | set_task_status |
| 문서화 | obsidian_* | update_task | manage_frontmatter |
| 버그 수정 | sequentialthinking | tavily-search | update_subtask |
| 팀 협업 | github_* | taskmaster_* | obsidian_* |
| 학습 | context7 | obsidian_* | add_task |
| 리팩터링 | sequentialthinking | research | expand_task |
| PRD 후 브리핑 | get_tasks | analyze_project_complexity | complexity_report |

## 성과 측정 및 개선

### 도구 활용 효과 측정
```typescript
// MCP 도구 활용 효과 정기 검토
// 1. get_tasks로 작업 완료율 분석
// 2. complexity_report로 작업 품질 평가
// 3. Obsidian 검색으로 지식 재활용률 측정
// 4. GitHub 메트릭으로 코드 품질 추적
// 5. 개선 방안을 sequentialthinking으로 도출
```

### 지속적 개선 사이클
```typescript
// 월간 개선 사이클
// 1. 각 MCP 도구 사용 빈도 및 효과 분석
// 2. 미활용 도구의 잠재적 활용 방안 탐색
// 3. 새로운 도구 조합 실험
// 4. 팀 전체의 MCP 도구 활용 수준 향상 계획
// 5. 모든 개선사항을 Taskmaster로 관리
```

이 가이드를 통해 사용 가능한 모든 MCP 도구를 최대한 활용하여 개발 효율성과 품질을 극대화하세요.
