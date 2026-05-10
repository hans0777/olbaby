-- ============================================
-- 오엘베이비 고객관리 시스템
-- Supabase 데이터베이스 스키마
-- ============================================

-- 1. 고객DB (customers)
CREATE TABLE customers (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  customer_id TEXT UNIQUE NOT NULL,           -- 고객ID (OL-0001 형식)
  name TEXT NOT NULL,                         -- 고객명
  phone TEXT NOT NULL,                        -- 연락처
  baby_name TEXT,                             -- 아기이름
  baby_birth_date DATE,                       -- 아기생년월일
  consultation_date DATE,                     -- 상담일
  consultation_channel TEXT,                  -- 상담채널 (전화/카톡)
  consultation_content TEXT,                  -- 상담내용
  inflow_source TEXT,                         -- 유입경로
  memo TEXT,                                  -- 메모
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. 예약관리 (reservations)
CREATE TABLE reservations (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  customer_id TEXT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
  name TEXT NOT NULL,                         -- 고객명 (자동불러오기)
  phone TEXT NOT NULL,                        -- 연락처
  shoot_date DATE NOT NULL,                   -- 촬영일
  shoot_time TEXT,                            -- 촬영시간 (10:00 형식)
  product TEXT,                               -- 촬영상품
  status TEXT DEFAULT '상담중',               -- 예약상태 (상담중/예약확정/촬영완료/취소)
  sms_confirmed BOOLEAN DEFAULT FALSE,        -- 확정문자 발송 여부
  sms_d1_sent BOOLEAN DEFAULT FALSE,          -- D-1안내 발송 여부
  sms_dayof_sent BOOLEAN DEFAULT FALSE,       -- 당일혜택 발송 여부
  sms_survey_sent BOOLEAN DEFAULT FALSE,      -- 설문발송 여부
  survey_completed BOOLEAN DEFAULT FALSE,     -- 설문완료 여부
  note TEXT,                                  -- 비고
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. 문자템플릿 (sms_templates)
CREATE TABLE sms_templates (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  template_id TEXT UNIQUE NOT NULL,           -- 템플릿ID (T01, T02 등)
  send_stage TEXT NOT NULL,                   -- 발송단계
  message_type TEXT NOT NULL,                 -- 문자유형 (SMS/LMS)
  message_content TEXT NOT NULL,              -- 문자내용
  link_url TEXT,                              -- 포함링크
  last_modified TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. 설문응답 (survey_responses)
CREATE TABLE survey_responses (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,                         -- 고객명
  phone TEXT NOT NULL,                        -- 연락처
  satisfaction_score INTEGER CHECK (satisfaction_score BETWEEN 1 AND 5), -- 만족도 (1~5)
  liked_most TEXT,                            -- 가장 좋았던 점
  improvement TEXT,                           -- 개선 희망사항
  inflow_source TEXT,                         -- 유입경로
  recommendation_score INTEGER CHECK (recommendation_score BETWEEN 1 AND 5), -- 추천의향 (1~5)
  benefit_given TEXT DEFAULT '미지급',        -- 혜택지급 (지급완료/미지급)
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. 이벤트관리 (events)
CREATE TABLE events (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  event_name TEXT NOT NULL,                   -- 이벤트명
  target_audience TEXT,                       -- 대상 (전체/기촬영고객/특정기간)
  send_date DATE,                             -- 발송예정일
  message_content TEXT,                       -- 문자내용
  send_status TEXT DEFAULT '준비중',          -- 발송상태 (준비중/발송완료)
  send_count INTEGER DEFAULT 0,               -- 발송건수
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- 인덱스 생성 (성능 최적화)
-- ============================================

CREATE INDEX idx_customers_customer_id ON customers(customer_id);
CREATE INDEX idx_customers_phone ON customers(phone);
CREATE INDEX idx_customers_name ON customers(name);

CREATE INDEX idx_reservations_customer_id ON reservations(customer_id);
CREATE INDEX idx_reservations_shoot_date ON reservations(shoot_date);
CREATE INDEX idx_reservations_status ON reservations(status);

CREATE INDEX idx_survey_responses_phone ON survey_responses(phone);
CREATE INDEX idx_survey_responses_created_at ON survey_responses(created_at);

-- ============================================
-- Row Level Security (RLS) 설정
-- ============================================

-- 모든 테이블에 RLS 활성화
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservations ENABLE ROW LEVEL SECURITY;
ALTER TABLE sms_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE survey_responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;

-- 공개 정책: 설문 제출은 누구나 가능
CREATE POLICY "Anyone can insert survey responses"
  ON survey_responses FOR INSERT
  WITH CHECK (true);

-- 관리자 정책: 인증된 사용자만 모든 데이터 조회/수정 가능
CREATE POLICY "Authenticated users can view all customers"
  ON customers FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can modify customers"
  ON customers FOR ALL
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can view all reservations"
  ON reservations FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can modify reservations"
  ON reservations FOR ALL
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can view all templates"
  ON sms_templates FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can modify templates"
  ON sms_templates FOR ALL
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can view all survey responses"
  ON survey_responses FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can view all events"
  ON events FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can modify events"
  ON events FOR ALL
  USING (auth.role() = 'authenticated');

-- ============================================
-- 샘플 데이터 삽입
-- ============================================

-- 고객 샘플 데이터
INSERT INTO customers (customer_id, name, phone, baby_name, baby_birth_date, consultation_date, consultation_channel, consultation_content, inflow_source, memo) VALUES
('OL-0001', '김영미', '010-1234-5678', '이서진', '2023-01-15', '2026-03-10', '전화', '신생아 패키지 상담', '인스타그램', '첫 방문, 매우 친절함'),
('OL-0002', '박지은', '010-2345-6789', '박준호', '2023-06-22', '2026-03-12', '카톡', '6개월 기념 촬영', '지인추천', '오후 4시 선호'),
('OL-0003', '이수진', '010-3456-7890', '정민준', '2024-02-08', '2026-03-14', '전화', '돌 촬영 예약', '블로그', '이전 고객 재방문');

-- 예약 샘플 데이터
INSERT INTO reservations (customer_id, name, phone, shoot_date, shoot_time, product, status, sms_confirmed, sms_d1_sent, sms_dayof_sent, sms_survey_sent, survey_completed, note) VALUES
('OL-0001', '김영미', '010-1234-5678', '2026-04-05', '14:00', '신생아 기본패키지', '예약확정', TRUE, FALSE, FALSE, FALSE, FALSE, ''),
('OL-0002', '박지은', '010-2345-6789', '2026-04-12', '15:00', '6개월 프리미엄', '상담중', FALSE, FALSE, FALSE, FALSE, FALSE, '추가 옷 준비'),
('OL-0003', '이수진', '010-3456-7890', '2026-03-25', '10:00', '돌 촬영 풀패키지', '촬영완료', TRUE, TRUE, TRUE, TRUE, FALSE, '');

-- 문자템플릿 샘플 데이터
INSERT INTO sms_templates (template_id, send_stage, message_type, message_content, link_url) VALUES
('T01', '예약확정', 'LMS', '[오엘베이비] {고객명}님, 촬영 예약이 확정되었습니다 ♥

📅 촬영일: {촬영일} {촬영시간}
📍 위치: (스튜디오 주소)
📸 상품: {촬영상품}

※ 준비물: 아기 여벌옷 2벌, 간식, 기저귀
※ 변경/취소는 촬영 2일 전까지 연락 부탁드립니다.', NULL),

('T02', 'D-1안내', 'LMS', '[오엘베이비] {고객명}님, 내일 촬영 안내드립니다 ♥

📅 내일 {촬영시간} 촬영 예정입니다.

▶ 촬영 전 꼭 확인해주세요!
{안내페이지_링크}

내일 뵙겠습니다 😊', 'https://YOUR_USERNAME.github.io/olbaby/guide.html'),

('T03', '당일혜택', 'LMS', '[오엘베이비] {고객명}님, 오늘 촬영 감사합니다 ♥

오늘 촬영 고객 특별 혜택!
액자·앨범 할인 구매 안내 ▼
{할인페이지_링크}

✨ 당일 한정 특별가로 만나보세요!', 'https://YOUR_USERNAME.github.io/olbaby/offer.html'),

('T04', '설문요청', 'LMS', '[오엘베이비] {고객명}님, 촬영은 만족스러우셨나요? ♥

1분 설문에 참여해주시면,
🎁 할인권 + 추가보정 2장을 드립니다!

▶ 설문 참여하기
{설문지_링크}', 'https://YOUR_USERNAME.github.io/olbaby/survey.html');

-- ============================================
-- 자동 업데이트 트리거
-- ============================================

-- updated_at 자동 업데이트 함수
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 트리거 적용
CREATE TRIGGER update_customers_updated_at
  BEFORE UPDATE ON customers
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_reservations_updated_at
  BEFORE UPDATE ON reservations
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
