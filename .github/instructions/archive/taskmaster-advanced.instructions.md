---
description: "Taskmaster MCP 고급 기능 및 전문 도구 가이드"
applyTo: "**/*.{js,ts,py,md,json}"
---

# Taskmaster MCP 고급 기능

## 분석 및 연구 도구

### 복잡도 분석
- **analyze_project_complexity**: 작업 복잡도 분석 및 확장 추천
- **complexity_report**: 복잡도 분석 결과 확인
- **research**: AI 기반 최신 정보 연구 (Perplexity 활용)

### 외부 MCP 도구와의 연계
```typescript
// 고급 연구 및 분석 워크플로우
// 1. sequentialthinking으로 분석 방향 설정
// 2. mcp_tavily-search로 최신 트렌드 조사
// 3. mcp_context7로 기술 문서 상세 분석
// 4. research로 프로젝트별 맞춤 인사이트 도출
// 5. analyze_project_complexity로 구체적 복잡도 측정
// 6. mcp_obsidian으로 분석 결과 체계적 문서화
```

### 의존성 관리
- **add_dependency**: 작업 간 의존관계 설정
- **remove_dependency**: 의존관계 제거
- **validate_dependencies**: 의존성 순환 참조 등 문제 검증
- **fix_dependencies**: 의존성 문제 자동 수정

## 태그 시스템

### 멀티 컨텍스트 관리
- **list_tags**: 사용 가능한 태그 목록
- **add_tag**: 새 태그 생성 (브랜치별, 기능별 분리)
- **use_tag**: 활성 태그 변경
- **copy_tag**: 태그 복사
- **delete_tag**: 태그 삭제

### 태그 활용 시나리오
```
feature/user-auth 브랜치 작업:
1. add_tag --from-branch (브랜치 이름으로 태그 생성)
2. 해당 태그에서 작업 수행
3. 메인 브랜치 병합 후 태그 정리
```

## 고급 작업 관리

### 일괄 작업 처리
- **expand_all**: 모든 적격 작업을 일괄 확장
- **update**: 특정 ID 이후 모든 작업 일괄 업데이트
- **clear_subtasks**: 하위 작업 일괄 제거

### 작업 재구성
- **move_task**: 작업 위치 이동 (부모-자식 관계 변경)
- **remove_subtask**: 하위 작업 제거 또는 독립 작업으로 승격
- **remove_task**: 작업 완전 삭제

## 모델 및 설정 관리

### AI 모델 설정
- **models**: 사용 중인 AI 모델 확인 및 변경
- 지원 모델: Claude, GPT-4, Perplexity 등
- 역할별 모델 설정: main, research, fallback

### 파일 관리
- **generate**: tasks.json 기반 마크다운 파일 생성
- 자동 생성되는 개별 작업 파일들

## 성능 최적화 팁

### 효율적인 도구 사용
1. **배치 조회**: get_task에서 쉼표로 구분된 ID 사용
2. **연구 활용**: 최신 기술 정보가 필요할 때 research 도구 적극 활용
3. **복잡도 분석**: 프로젝트 초기에 analyze_project_complexity 실행
4. **태그 분리**: 큰 프로젝트는 기능별로 태그 분리하여 관리

### 주의사항
- AI 처리 도구들은 1분 정도 소요됨을 사용자에게 미리 안내
- 의존성 체인 관리에 주의하여 작업 순서 유지
- 태그 삭제 시 해당 태그의 모든 작업이 함께 삭제됨
