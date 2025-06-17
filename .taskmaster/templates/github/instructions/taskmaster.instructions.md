---
description: "Taskmaster MCP 및 개발 워크플로우 핵심 가이드"
applyTo: "**"
---

# Taskmaster MCP 개발 가이드

## 🚀 핵심 원칙

- **한국어 우선**: 모든 작업, 주석, 문서는 한국어로 작성
- **MCP 도구 우선**: CLI보다 MCP 도구를 먼저 활용
- **체계적 워크플로우**: PRD → 브리핑 → 승인 → 개발 순서 준수
- **AI 도구 적극 활용**: sequentialthinking, research, complexity 분석 활용

## 📋 Taskmaster 필수 도구

### 프로젝트 관리
- **`initialize_project`**: 새 프로젝트 초기화
- **`parse_prd`**: PRD 문서로부터 작업 생성
- **`get_tasks`**: 작업 목록 조회
- **`get_task`**: 특정 작업 상세 조회 (쉼표로 다중 조회 가능)
- **`next_task`**: 다음 작업 추천

### 작업 상태 관리
- **`set_task_status`**: 작업 상태 변경 (pending, in-progress, done, review, cancelled)
- **`add_task`**: 새 작업 추가 (AI 기반, 한국어 프롬프트)
- **`update_task`**: 작업 내용 업데이트 (AI 기반)
- **`update_subtask`**: 하위 작업에 진행사항 추가
- **`expand_task`**: 복잡한 작업을 하위 작업으로 분해

### 분석 및 최적화
- **`analyze_project_complexity`**: 작업 복잡도 분석 (--research 옵션 활용)
- **`complexity_report`**: 복잡도 분석 결과 조회
- **`research`**: AI 기반 최신 정보 수집

## 🔄 핵심 워크플로우

### 1. 프로젝트 시작 (필수 단계)
```typescript
// 1. 프로젝트 초기화
initialize_project

// 2. 한국어 PRD 작성 (.taskmaster/docs/prd.txt)
// - 프로젝트 개요와 목표를 명확한 한국어로 작성
// - 기능 요구사항은 사용자 관점에서 한국어로 서술

// 3. PRD 기반 작업 생성
parse_prd

// 4. 작업 브리핑 및 피드백 (⚠️ 중요: 바로 개발 시작하지 말 것!)
get_tasks                              // 전체 작업 목록 확인
analyze_project_complexity --research  // 복잡도 분석
complexity_report                      // 분석 결과 검토

// 5. 사용자 브리핑 제공
/*
"PRD를 기반으로 총 X개의 작업이 생성되었습니다.
복잡도 분석 결과를 포함해 전체 작업 계획을 브리핑드리겠습니다:

[고우선순위 작업들] (복잡도 8-10점)
- 작업 1: 제목 (복잡도: X/10)
- 작업 2: 제목 (복잡도: X/10)

[중간우선순위 작업들] (복잡도 5-7점)
- 작업 3: 제목 (복잡도: X/10)

[저우선순위 작업들] (복잡도 1-4점)
- 작업 4: 제목 (복잡도: X/10)

전체 프로젝트 복잡도: [평가]
예상 소요 시간: [추정]

이 계획에 대해 피드백을 주시면 필요한 조정을 하겠습니다."
*/

// 6. 피드백 반영
move_task    // 우선순위 변경
add_task     // 새 작업 추가
remove_task  // 불필요한 작업 제거
update_task  // 작업 내용 수정

// 7. 최종 승인 후 개발 시작
next_task
```

### 2. 일반적인 개발 사이클
```typescript
// 1. 다음 작업 확인
next_task

// 2. 작업 상세 분석 (복잡한 작업의 경우)
get_task --id=X
expand_task --id=X --force --research  // 하위 작업으로 분해

// 3. 작업 시작
set_task_status --id=X --status="in-progress"

// 4. 구현 진행 (MCP 도구 활용)
// - sequentialthinking으로 복잡한 문제 분석
// - mcp_tavily-search로 최신 정보 조사
// - mcp_context7로 라이브러리 문서 참조
// - 코드 작성 (한국어 주석 필수)

// 5. 진행 상황 기록
update_subtask --id=X.Y --prompt="구체적인 진행 상황 (한국어)"

// 6. 작업 완료
set_task_status --id=X --status="done"
```

## 🛠️ 주요 MCP 도구 활용

### Sequential Thinking (복잡한 문제 해결)
```typescript
// 다음 상황에서 적극 활용:
// - 아키텍처 설계 결정
// - 복잡한 버그 분석
// - 기술 선택 및 비교
// - 리팩터링 계획 수립
// - 성능 최적화 전략

// 사용 후 결과를 반드시 Taskmaster에 기록:
update_subtask --id=X.Y --prompt="sequential thinking 결과: [분석 내용]"
```

### Tavily 검색 (최신 정보 수집)
```typescript
// 새로운 기술 도입 전 조사 워크플로우:
// 1. mcp_tavily-mcp_tavily-search로 최신 정보 검색
// 2. mcp_tavily-mcp_tavily-extract로 상세 문서 추출  
// 3. research 도구로 프로젝트 컨텍스트에 맞는 구체적 가이드 생성
// 4. add_task로 도입 작업 생성
```

### Context7 (라이브러리 문서)
```typescript
// 새 라이브러리 사용 전:
// 1. mcp_context7_resolve-library-id로 라이브러리 ID 확인
// 2. mcp_context7_get-library-docs로 최신 문서 획득
// 3. 문서 기반으로 구현 계획 수립
// 4. expand_task로 구현 단계 세분화
```

### GitHub MCP (협업 관리)
```typescript
// 완전한 GitHub 워크플로우:
// 1. mcp_github_create_issue로 이슈 생성
// 2. mcp_github_create_branch로 개발 브랜치 생성
// 3. 개발 진행 (update_subtask로 진행 상황 기록)
// 4. mcp_github_create_pull_request로 PR 생성
// 5. set_task_status로 작업 완료 표시
```

### Obsidian MCP (지식 관리)
```typescript
// 개발 과정에서 얻은 인사이트 문서화:
// 1. mcp_obsidian-mcp-_obsidian_update_file로 노트 생성
// 2. mcp_obsidian-mcp-_obsidian_manage_tags로 태그 관리
// 3. update_subtask로 Taskmaster에 문서 링크 추가
```

## 💻 코딩 가이드라인

### TypeScript/JavaScript 필수 규칙
```typescript
// ✅ 권장: 명확한 타입 정의와 한국어 주석
interface UserData {
  id: string;          // 사용자 고유 식별자
  email: string;       // 이메일 주소
  createdAt: Date;     // 생성 날짜
}

const fetchUserProfile = async (userId: string): Promise<UserData> => {
  try {
    const response = await fetch(`/api/users/${userId}`);
    if (!response.ok) {
      throw new Error(`사용자 조회 실패: ${response.status}`);
    }
    return await response.json();
  } catch (error) {
    console.error('사용자 프로필 조회 오류:', error);
    throw error;
  }
};

// ❌ 지양: 타입이 불명확하고 주석 없음
const fetchUser = async (id) => {
  const res = await fetch(`/api/users/${id}`);
  return res.json();
};
```

### 파일 헤더 및 주석 규칙
```typescript
/**
 * 사용자 인증 서비스
 * JWT 토큰 기반 인증 및 권한 관리를 담당
 * 
 * @author 개발자명
 * @since 2025-06-17
 */
```

### 오류 처리 패턴
```typescript
// 표준 오류 처리 패턴
class ServiceError extends Error {
  constructor(
    message: string,
    public code: string,
    public statusCode: number = 500
  ) {
    super(message);
    this.name = 'ServiceError';
  }
}

const handleApiError = (error: unknown): never => {
  if (error instanceof ServiceError) {
    console.error(`서비스 오류 [${error.code}]:`, error.message);
    throw error;
  }
  
  console.error('예상치 못한 오류:', error);
  throw new ServiceError(
    '내부 서비스 오류가 발생했습니다.',
    'INTERNAL_ERROR'
  );
};
```

## 🎯 중요 체크포인트

### PRD 후 브리핑 필수 확인사항
- [ ] 모든 핵심 기능이 작업으로 포함되었는가?
- [ ] 작업 간 의존성이 올바르게 설정되었는가?
- [ ] 우선순위가 비즈니스 요구사항과 일치하는가?
- [ ] 복잡도가 높은 작업들의 분해 계획이 있는가?
- [ ] 예상 일정이 현실적인가?

### 코드 구현 시 체크리스트
- [ ] TypeScript 타입 정의 완료
- [ ] 한국어 주석 및 문서화
- [ ] 오류 처리 로직 구현
- [ ] update_subtask로 진행 상황 기록
- [ ] 작업 완료 후 set_task_status 업데이트

### Taskmaster ID 처리 규칙
```typescript
// ✅ 올바른 사용
get_task --id=4        // 부모 작업 조회 (하위 작업 포함)
get_task --id=1,2,3    // 여러 작업 한 번에 조회
set_task_status --id=4.1 --status="done"  // 하위 작업 상태 변경
update_subtask --id=4.7 --prompt="진행 상황"

// ❌ 잘못된 사용
get_task --id=4.1      // 하위 작업 독립 조회 불가
```

## ⚠️ 주의사항

- **AI 도구 처리 시간**: parse_prd, analyze_project_complexity, research 등은 1분 정도 소요
- **하위 작업 조회**: 부모 작업을 통해서만 조회 가능 (독립 조회 불가)
- **의존성 관리**: 작업 순서를 올바르게 유지하여 체인이 작동하도록 관리
- **한국어 우선**: 모든 작업 제목, 설명, 주석은 반드시 한국어로 작성

## 🔧 환경 설정

필수 API 키들을 MCP 설정에 포함:
```json
{
  "env": {
    "ANTHROPIC_API_KEY": "your-key",
    "PERPLEXITY_API_KEY": "your-key",
    "OPENAI_API_KEY": "your-key"
  }
}
```

---

이 통합 가이드를 통해 핵심 기능들을 효율적으로 활용하여 체계적인 개발 워크플로우를 구축하세요!
