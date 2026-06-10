# 🍼 오엘베이비 고객관리 시스템

> 아기사진 전문 스튜디오를 위한 완전 자동화 고객 여정 관리 시스템

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?logo=supabase&logoColor=white)](https://supabase.com)
[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-222222?logo=github&logoColor=white)](https://pages.github.com)

## 📸 시스템 개요

오엘베이비 고객관리 시스템은 촬영 예약부터 사후 마케팅까지 **완전 자동화**하여, 고객 만족도 향상과 재방문율 증대를 실현하는 올인원 CRM 솔루션입니다.

### ✨ 핵심 기능 (v2.0 업데이트)

- 📊 **실시간 대시보드**: 고객/예약/설문/할인권 현황 한눈에 확인
- 👥 **고객 DB 관리**: 고객 정보, 아기 정보, 상담 이력 통합 관리
- 📅 **예약 현황 관리**: 월별 캘린더 뷰, 예약 상태별 필터링
- 🤖 **자동 마케팅**: D-1 안내, 당일 혜택, 설문 요청, 할인권 발송 자동화
- 📝 **만족도 조사**: 실시간 설문 수집 및 분석
- 💌 **할인권 관리**: 2개월마다 자동 발송, 재방문 유도
- 📆 **Google Calendar 연동**: 예약 자동 등록 및 알림

### 🎯 5단계 고객 여정 자동화

```
📞 고객 상담
    ↓
👤 고객 등록 + 📅 예약 등록 → Google Calendar 자동 등록
    ↓
📱 D-1 자동 알림 (오전 9시) → 촬영 안내 문자 발송
    ↓
📸 촬영 진행 → 🎁 당일 혜택 문자 (1시간 후)
    ↓
📝 D+1 설문 요청 (오후 3시) → 만족도 조사 + 혜택 지급
    ↓
💌 2개월 후 자동 발송 → 재방문 할인권 발송
    ↓
🔄 반복 (6개월, 돌 촬영 등)
```

## 🚀 빠른 시작

### 1. 데모 버전 즉시 체험

**로컬 서버 실행:**
```bash
node serve.mjs
```

**브라우저에서 접속:**
```
http://localhost:3000/admin-demo.html
```
- 비밀번호: `demo`
- 샘플 데이터로 즉시 체험 가능

### 2. 실서비스 배포 (4단계, 약 20분)

상세한 가이드는 [📘 시작_가이드.md](./시작_가이드.md)를 참고하세요.

#### 2-1. Supabase 설정 (5분)
1. https://supabase.com 회원가입
2. 새 프로젝트 생성 (`olbaby-crm`)
3. SQL Editor에서 `supabase_schema.sql` 실행
4. API 키 복사

#### 2-2. HTML 파일 설정 (3분)
1. `admin.html` 열기
2. Supabase URL/KEY 입력 (18~19번째 줄)
3. 관리자 비밀번호 변경 (15번째 줄)
4. `survey.html`에도 동일하게 설정

#### 2-3. GitHub Pages 배포 (10분)
```bash
git init
git add *.html *.sql *.md .gitignore
git commit -m "Initial commit: Olbaby CRM System"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/olbaby.git
git push -u origin main
```

GitHub 저장소 → Settings → Pages → main branch 선택

#### 2-4. 알리고 SMS 설정 (2분)
1. https://aligo.in 가입
2. API 키 발급
3. `admin.html`에 API 키 입력 (21~23번째 줄)

## 📁 프로젝트 구조

```
olbaby/
├── admin.html              # 관리자 페이지 (프로덕션)
├── admin-demo.html         # 관리자 페이지 (데모, 샘플 데이터)
├── guide.html              # 고객용: 촬영 전 준비 안내
├── offer.html              # 고객용: 촬영 당일 특별 혜택
├── survey.html             # 고객용: 만족도 조사
├── supabase_schema.sql     # 데이터베이스 스키마
├── serve.mjs               # 로컬 개발 서버
├── .env.example            # 환경 변수 예시
├── 시작_가이드.md          # 상세 배포 가이드
└── README.md               # 이 파일
```

## 🛠️ 기술 스택

| 분류 | 기술 |
|------|------|
| **Frontend** | HTML5, CSS3, Vanilla JavaScript |
| **Backend** | Supabase (PostgreSQL) |
| **SMS API** | 알리고 (Aligo) |
| **Hosting** | GitHub Pages |
| **Database** | PostgreSQL (via Supabase) |

## 📊 데이터베이스 스키마

### 테이블 구조

1. **customers** - 고객 정보
   - 기본 정보: 이름, 전화번호
   - 아기 정보: 이름, 생년월일
   - 상담 이력: 상담일, 경로, 내용

2. **reservations** - 예약 관리
   - 예약 정보: 촬영일시, 촬영 유형
   - 상태 관리: 상담중/예약확정/촬영완료/취소
   - 문자 발송 이력

3. **sms_templates** - 문자 템플릿
   - 예약확정, D-1안내, 당일혜택, 설문요청

4. **survey_responses** - 설문 응답
   - 만족도 점수, 개선사항
   - 추천의향, 혜택 지급 여부

5. **events** - 이벤트 관리
   - 쿠폰, 할인 혜택 관리

## 🎨 주요 페이지 스크린샷

### 관리자 대시보드
- 실시간 통계: 고객 수, 예약 수, 오늘 촬영 일정
- 고객 목록: 검색, 필터링, 상세 정보
- 예약 현황: 상태별 필터, 문자 발송 이력
- 문자 발송: 템플릿 선택, 즉시 발송
- 설문 응답: 실시간 만족도 확인

### 고객용 페이지
- **guide.html**: 모바일 최적화, 체크리스트 형태
- **offer.html**: 애니메이션 효과, 할인 혜택 강조
- **survey.html**: 단계별 진행 UI, 프로그레스 바

## 📱 문자 발송 시나리오

### 1단계: 예약 확정 문자
```
[오엘베이비] 김지영님, 예약이 확정되었습니다 ♥

📅 2026년 5월 15일 14:00
📍 오엘베이비 강남점

촬영 전 꼭 확인해주세요!
```

### 2단계: D-1 안내 문자
```
[오엘베이비] 김지영님, 내일 촬영 안내드립니다 ♥

📅 내일 14:00 촬영 예정입니다.

▶ 촬영 전 꼭 확인해주세요!
https://your-username.github.io/olbaby/guide.html

내일 뵙겠습니다 😊
```

### 3단계: 당일 혜택 문자
```
[오엘베이비] 김지영님, 오늘 촬영 감사합니다 ♥

오늘 촬영 고객 특별 혜택!
액자·앨범 할인 구매 안내 ▼
https://your-username.github.io/olbaby/offer.html

✨ 당일 한정 특별가로 만나보세요!
```

### 4단계: 설문 요청 문자
```
[오엘베이비] 김지영님, 촬영은 만족스러우셨나요? ♥

1분 설문에 참여해주시면,
🎁 할인권 + 추가보정 2장을 드립니다!

▶ 설문 참여하기
https://your-username.github.io/olbaby/survey.html
```

## 🔐 보안

- **관리자 인증**: 비밀번호 기반 로그인
- **Row Level Security**: Supabase RLS로 데이터 보호
- **API Key 보호**: 환경 변수로 민감 정보 관리
- **HTTPS**: GitHub Pages 자동 SSL 인증서

## 🧪 테스트

### 로컬 테스트
1. `node serve.mjs` 실행
2. `http://localhost:3000/admin-demo.html` 접속
3. 비밀번호 `demo` 입력
4. 모든 기능 테스트 가능

### 프로덕션 테스트
1. Supabase에 테스트 고객 수동 추가
2. 관리자 페이지에서 데이터 조회 확인
3. survey.html에서 설문 제출 테스트
4. Supabase Table Editor에서 데이터 저장 확인

## 📞 문제 해결

### 설문 제출이 안 될 때
1. `survey.html`의 Supabase URL/Key 확인
2. 브라우저 콘솔(F12) → Console 탭 에러 확인
3. Supabase → Table Editor → `survey_responses` 테이블 확인

### 관리자 페이지 데이터가 안 보일 때
1. `admin.html`의 Supabase URL/Key 확인
2. 브라우저 콘솔(F12) → Network 탭 확인
3. Supabase에서 수동으로 테스트 데이터 추가

### 문자 발송이 안 될 때
1. 알리고 API 키 확인
2. 알리고 포인트 잔액 확인
3. 발신번호 등록 여부 확인

## 🚧 향후 개발 계획

### v2.1.0 (예정)
- [ ] 카카오 알림톡 완전 지원
- [ ] 온라인 예약금 결제 (아임포트)
- [ ] 자동 예약 리마인더 백엔드 cron job

### v3.0.0 (예정)
- [ ] 고객별 촬영 사진 갤러리
- [ ] 매출 분석 대시보드
- [ ] AI 기반 예약 추천
- [ ] 모바일 앱 (React Native)

## 📋 v2.0 업데이트 내역 (2026-06-10)

### ✅ 새로운 기능
- 💌 **할인권 관리 탭** 추가
  - 발송 이력 조회
  - 발송 대상 자동 추출 (2개월 경과 고객)
  - 일괄 발송 기능
  - 통계 및 분석

- 🤖 **자동 마케팅 설정**
  - 5단계 자동화 설정 UI
  - 발송 주기 커스터마이징
  - 할인 내용 편집 기능

- 📅 **월별 캘린더 뷰**
  - 예약 일정 시각화
  - 상태별 색상 구분
  - 날짜 클릭 시 상세 일정

### 🔧 개선사항
- Google Calendar 연동 강화
- 문자 발송 상태 관리 개선
- 대시보드 통계 추가 (할인권)
- UI/UX 개선

### 🐛 버그 수정
- 예약 수정 시 발생하던 오류 수정
- 문자 템플릿 로드 오류 수정

## 📄 라이선스

MIT License

Copyright (c) 2026 오엘베이비

## 🙏 기여

버그 제보 및 기능 제안은 Issues 탭에서 환영합니다!

## 📧 문의

- 이메일: hans97490800@gmail.com
- 시스템 관련 질문: [시작_가이드.md](./시작_가이드.md) 참고

---

**오엘베이비 고객관리 시스템으로 고객 만족도를 높이고, 재방문율을 2배로 올리세요! 📸✨**
