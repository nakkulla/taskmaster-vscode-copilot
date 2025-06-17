---
description: "VS Code 개발 환경을 위한 코딩 가이드라인 및 문서화 규칙"
applyTo: "**/*.{js,ts,jsx,tsx,py,md,json,yaml,yml}"
---

# VS Code 개발 환경 코딩 가이드라인

## 필수 코드 구조 및 형식

### 파일 헤더 및 주석 규칙
모든 파일은 명확하고 간결한 주석으로 시작해야 합니다:

```typescript
/**
 * 사용자 인증 서비스
 * JWT 토큰 기반 인증 및 권한 관리를 담당
 * 
 * @author 개발자명
 * @since 2025-06-15
 */
```

### 변수 및 함수 명명 규칙
- **함수명**: camelCase 사용, 동작을 명확히 표현
- **변수명**: 의미있는 이름 사용, 약어 지양
- **상수**: UPPER_SNAKE_CASE 사용
- **인터페이스**: PascalCase, 'I' 접두사 지양

```typescript
// ✅ 좋은 예
const getUserProfile = async (userId: string) => {
  const MAX_RETRY_COUNT = 3;
  // 구현...
};

// ❌ 나쁜 예
const getUsrProf = async (id: string) => {
  const maxRetry = 3;
  // 구현...
};
```

## 코드 예제 작성 가이드

### TypeScript/JavaScript 패턴
```typescript
// ✅ 권장: 명확한 타입 정의
interface UserData {
  id: string;
  email: string;
  createdAt: Date;
}

const fetchUserData = async (userId: string): Promise<UserData> => {
  try {
    const response = await fetch(`/api/users/${userId}`);
    if (!response.ok) {
      throw new Error(`사용자 데이터 조회 실패: ${response.status}`);
    }
    return await response.json();
  } catch (error) {
    console.error('사용자 데이터 조회 중 오류:', error);
    throw error;
  }
};

// ❌ 지양: 타입이 불명확하고 오류 처리 미흡
const fetchUser = async (id) => {
  const res = await fetch(`/api/users/${id}`);
  return res.json();
};
```

### React 컴포넌트 패턴
```jsx
// ✅ 권장: 명확한 Props 인터페이스와 상태 관리
interface UserCardProps {
  userId: string;
  showEmail?: boolean;
}

const UserCard: React.FC<UserCardProps> = ({ userId, showEmail = false }) => {
  const [user, setUser] = useState<UserData | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const loadUser = async () => {
      setLoading(true);
      setError(null);
      
      try {
        const userData = await fetchUserData(userId);
        setUser(userData);
      } catch (err) {
        setError('사용자 정보를 불러오는데 실패했습니다.');
      } finally {
        setLoading(false);
      }
    };

    loadUser();
  }, [userId]);

  if (loading) return <div>로딩 중...</div>;
  if (error) return <div className="error">오류: {error}</div>;
  if (!user) return <div>사용자를 찾을 수 없습니다.</div>;

  return (
    <div className="user-card">
      <h3>{user.name}</h3>
      {showEmail && <p>이메일: {user.email}</p>}
    </div>
  );
};
```

## 문서화 및 주석 가이드라인

### 함수 및 클래스 문서화
```typescript
/**
 * 사용자 데이터를 캐시와 함께 조회합니다.
 * 
 * @param userId - 조회할 사용자의 고유 ID
 * @param options - 조회 옵션 설정
 * @param options.useCache - 캐시 사용 여부 (기본값: true)
 * @param options.timeout - 요청 타임아웃 (밀리초, 기본값: 5000)
 * @returns 사용자 데이터와 캐시 정보
 * @throws {UserNotFoundError} 사용자를 찾을 수 없는 경우
 * @throws {NetworkError} 네트워크 오류 발생 시
 * 
 * @example
 * ```typescript
 * const user = await getUserWithCache('user-123', { useCache: false });
 * console.log(user.data.email);
 * ```
 */
async function getUserWithCache(
  userId: string,
  options: {
    useCache?: boolean;
    timeout?: number;
  } = {}
): Promise<{
  data: UserData;
  fromCache: boolean;
}> {
  // 구현...
}
```

### 인라인 주석 가이드
```typescript
// 복잡한 비즈니스 로직에는 한국어 주석 추가
const calculateUserScore = (user: UserData): number => {
  // 기본 점수: 가입일 기준 (1일 = 1점)
  const baseScore = Math.floor(
    (Date.now() - user.createdAt.getTime()) / (1000 * 60 * 60 * 24)
  );
  
  // 활동 보너스: 최근 30일 로그인 횟수 * 2
  const activityBonus = user.recentLoginCount * 2;
  
  // 프리미엄 사용자 보너스: 50점
  const premiumBonus = user.isPremium ? 50 : 0;
  
  return baseScore + activityBonus + premiumBonus;
};
```

## 오류 처리 및 로깅

### 표준 오류 처리 패턴
```typescript
// ✅ 권장: 구체적인 오류 타입과 메시지
class UserServiceError extends Error {
  constructor(
    message: string,
    public code: string,
    public statusCode: number = 500
  ) {
    super(message);
    this.name = 'UserServiceError';
  }
}

const handleApiError = (error: unknown): never => {
  if (error instanceof UserServiceError) {
    console.error(`사용자 서비스 오류 [${error.code}]:`, error.message);
    throw error;
  }
  
  if (error instanceof Error) {
    console.error('예상치 못한 오류:', error.message);
    throw new UserServiceError(
      '사용자 서비스에서 내부 오류가 발생했습니다.',
      'INTERNAL_ERROR'
    );
  }
  
  console.error('알 수 없는 오류:', error);
  throw new UserServiceError(
    '알 수 없는 오류가 발생했습니다.',
    'UNKNOWN_ERROR'
  );
};
```

## 테스트 코드 작성 규칙

### 테스트 케이스 명명 및 구조
```typescript
describe('사용자 인증 서비스', () => {
  describe('로그인 기능', () => {
    it('유효한 자격증명으로 로그인에 성공해야 한다', async () => {
      // Given: 유효한 사용자 정보
      const validCredentials = {
        email: 'test@example.com',
        password: 'validPassword123'
      };
      
      // When: 로그인 시도
      const result = await authService.login(validCredentials);
      
      // Then: 성공적인 로그인 결과 확인
      expect(result.success).toBe(true);
      expect(result.token).toBeDefined();
      expect(result.user.email).toBe(validCredentials.email);
    });

    it('잘못된 비밀번호로 로그인에 실패해야 한다', async () => {
      // Given: 잘못된 비밀번호
      const invalidCredentials = {
        email: 'test@example.com',
        password: 'wrongPassword'
      };
      
      // When & Then: 로그인 실패 예상
      await expect(authService.login(invalidCredentials))
        .rejects
        .toThrow('잘못된 자격증명입니다');
    });
  });
});
```

## VS Code 작업 환경 최적화

### 권장 확장 프로그램 설정
```json
// .vscode/extensions.json
{
  "recommendations": [
    "ms-vscode.vscode-typescript-next",
    "esbenp.prettier-vscode",
    "ms-vscode.eslint",
    "bradlc.vscode-tailwindcss",
    "ms-vscode.vscode-json"
  ]
}
```

### 워크스페이스 설정 가이드
```json
// .vscode/settings.json 추가 권장 설정
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true,
    "source.organizeImports": true
  },
  "typescript.preferences.importModuleSpecifier": "relative",
  "typescript.suggest.autoImports": true
}
```

## Taskmaster 연동 개발 워크플로우

### 개발 작업 관리
```typescript
// 새 기능 개발 시 Taskmaster 활용 예시
// 1. add_task로 기능 개발 작업 생성
// 2. expand_task로 세부 구현 사항 분해
// 3. set_task_status로 진행 상황 추적

/**
 * API 엔드포인트 구현 완료 시 체크리스트:
 * □ 타입 정의 완료 (Taskmaster: update_subtask로 기록)
 * □ 단위 테스트 작성 완료
 * □ 통합 테스트 작성 완료  
 * □ API 문서 업데이트 완료
 * □ 오류 처리 로직 구현 완료
 */
```

## 코드 리뷰 가이드라인

### 리뷰 체크포인트
1. **타입 안정성**: TypeScript 타입 정의가 정확한가?
2. **오류 처리**: 예외 상황이 적절히 처리되었는가?
3. **성능**: 불필요한 렌더링이나 API 호출이 없는가?
4. **가독성**: 코드 의도가 명확하게 전달되는가?
5. **테스트**: 주요 로직에 대한 테스트가 포함되었는가?

### 리뷰 댓글 템플릿
```markdown
**제안사항**: 더 명확한 변수명 사용
현재: `data` → 제안: `userProfileData`

**보안 이슈**: 사용자 입력 검증 필요
XSS 공격 방지를 위한 입력값 sanitization 추가 필요

**성능 개선**: useMemo 사용 고려
복잡한 계산이 불필요하게 반복되고 있음
```

이 가이드를 통해 일관된 코드 품질과 개발 효율성을 유지하세요.
