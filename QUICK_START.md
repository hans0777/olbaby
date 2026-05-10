# ⚡ 오엘베이비 CRM - 원클릭 시작 가이드

> **단 3분 만에 시스템을 체험하세요!**

---

## 🎯 방법 1: 데모 버전 즉시 체험 (추천)

### 1단계: 로컬 서버 실행
```bash
node serve.mjs
```

### 2단계: 브라우저에서 접속
```
http://localhost:3000/admin-demo.html
```

### 3단계: 로그인
- **비밀번호**: `demo`

### 완료! 🎉
샘플 데이터로 모든 기능을 즉시 체험할 수 있습니다.

---

## 🚀 방법 2: 실서비스 배포 (20분)

### A. Supabase 설정 (5분)

1. **https://supabase.com** 접속 → 회원가입
2. **New Project** 클릭
   - Name: `olbaby-crm`
   - Password: 안전한 비밀번호 입력
   - Region: `Northeast Asia (Seoul)`
3. 생성 완료 후 **SQL Editor** → **New query**
4. `supabase_schema.sql` 내용 복사 → 붙여넣기 → **Run**
5. **Settings** → **API** → URL과 Key 복사

### B. 파일 설정 (3분)

#### admin.html 수정 (18~19번째 줄):
```javascript
const SUPABASE_URL = 'https://xxxxxxxxx.supabase.co';  // 복사한 URL
const SUPABASE_ANON_KEY = 'eyJhbGci...';  // 복사한 Key
```

#### survey.html 수정 (955번째 줄 근처):
```javascript
const SUPABASE_URL = 'https://xxxxxxxxx.supabase.co';  // 동일한 URL
const SUPABASE_ANON_KEY = 'eyJhbGci...';  // 동일한 Key
```

### C. GitHub 배포 (10분)

#### 방법 A: 자동 배포 스크립트 (Windows)
```bash
deploy.bat
```

#### 방법 B: 수동 배포
```bash
git remote add origin https://github.com/YOUR_USERNAME/olbaby.git
git push -u origin main
```

GitHub 저장소 → **Settings** → **Pages** → main branch 선택 → **Save**

### D. 알리고 SMS 설정 (선택, 2분)

1. **https://aligo.in** 가입
2. API 키 발급
3. `admin.html` 21~23번째 줄 수정:
```javascript
const ALIGO_API_KEY = 'YOUR_ALIGO_API_KEY';
const ALIGO_USER_ID = 'YOUR_ALIGO_USER_ID';
const ALIGO_SENDER = '01012345678';
```

---

## 🔧 설정 검증 도구

모든 설정이 올바른지 자동으로 확인:

```
http://localhost:3000/check-setup.html
```

**검증 항목**:
- ✅ 필수 파일 존재 확인
- ✅ Supabase 설정 확인
- ✅ 알리고 API 설정 확인
- ✅ 브라우저 호환성 확인
- ✅ 반응형 디자인 확인

---

## 📱 접속 URL

### 로컬 테스트
- 데모 관리자: `http://localhost:3000/admin-demo.html`
- 실서비스 관리자: `http://localhost:3000/admin.html`
- 촬영 안내: `http://localhost:3000/guide.html`
- 당일 혜택: `http://localhost:3000/offer.html`
- 설문 조사: `http://localhost:3000/survey.html`
- 설정 검증: `http://localhost:3000/check-setup.html`

### GitHub Pages 배포 후
```
https://YOUR_USERNAME.github.io/olbaby/admin.html
https://YOUR_USERNAME.github.io/olbaby/guide.html
https://YOUR_USERNAME.github.io/olbaby/offer.html
https://YOUR_USERNAME.github.io/olbaby/survey.html
```

---

## 🎯 즉시 확인할 사항

### 1. 관리자 페이지 로그인
- 데모: 비밀번호 `demo`
- 실서비스: 비밀번호 `olbaby2026` (변경 가능)

### 2. 대시보드 확인
- 전체 고객 수
- 전체 예약 수
- 오늘 촬영 일정
- 설문 응답 수

### 3. 고객 추가 테스트
1. **고객 목록** 탭
2. **+ 고객 추가** 버튼
3. 정보 입력
4. **저장**
5. 목록에서 확인

### 4. 설문 제출 테스트
1. `survey.html` 접속
2. 설문 작성
3. 제출
4. 관리자 페이지 **설문 응답** 탭에서 확인

---

## ❓ 문제 해결

### Q1: 서버가 실행되지 않아요
```bash
# Node.js 설치 확인
node --version

# 없으면 설치: https://nodejs.org
```

### Q2: 관리자 페이지에서 데이터가 안 보여요
1. 브라우저 콘솔(F12) 확인
2. Supabase URL/Key 재확인
3. Supabase Table Editor에서 데이터 직접 확인

### Q3: 설문이 제출되지 않아요
1. `survey.html`의 Supabase 설정 확인
2. 브라우저 콘솔 에러 메시지 확인
3. Supabase → Table Editor → `survey_responses` 테이블 확인

### Q4: GitHub Pages가 작동하지 않아요
1. Settings → Pages에서 Source가 main branch로 설정되었는지 확인
2. 약 1분 후 다시 시도
3. URL이 정확한지 확인 (대소문자 구분)

---

## 📚 더 자세한 가이드

- 📘 [시작_가이드.md](./시작_가이드.md) - 상세 단계별 배포 가이드
- 📖 [README.md](./README.md) - 전체 시스템 문서
- 🔧 [check-setup.html](http://localhost:3000/check-setup.html) - 자동 설정 검증

---

## 🎉 완료 체크리스트

- [ ] 로컬 서버 실행 성공
- [ ] 데모 관리자 페이지 로그인 성공
- [ ] Supabase 프로젝트 생성 완료
- [ ] 데이터베이스 테이블 생성 완료
- [ ] admin.html Supabase 키 입력 완료
- [ ] survey.html Supabase 키 입력 완료
- [ ] GitHub 저장소 생성 완료
- [ ] GitHub Pages 배포 완료
- [ ] 실서비스 관리자 페이지 접속 성공
- [ ] 설문 제출 테스트 성공

**모두 완료하면 즉시 운영 가능합니다! 🚀**
