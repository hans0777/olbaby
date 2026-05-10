#!/bin/bash

# ============================================
# 오엘베이비 고객관리 시스템 - 배포 자동화 스크립트
# ============================================

echo "🚀 오엘베이비 CRM 시스템 배포를 시작합니다..."
echo ""

# 1. Git 저장소 확인
if [ ! -d ".git" ]; then
    echo "📦 Git 저장소를 초기화합니다..."
    git init
    echo "✅ Git 초기화 완료"
else
    echo "✅ Git 저장소가 이미 존재합니다"
fi

# 2. 필수 파일 존재 확인
echo ""
echo "📋 필수 파일을 확인합니다..."

required_files=(
    "admin.html"
    "survey.html"
    "guide.html"
    "offer.html"
    "supabase_schema.sql"
    "README.md"
)

missing_files=()

for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        missing_files+=("$file")
        echo "❌ $file 파일이 없습니다"
    else
        echo "✅ $file"
    fi
done

if [ ${#missing_files[@]} -ne 0 ]; then
    echo ""
    echo "⚠️  경고: 필수 파일이 누락되었습니다!"
    echo "누락된 파일: ${missing_files[*]}"
    exit 1
fi

# 3. Supabase 설정 확인
echo ""
echo "🔐 Supabase 설정을 확인합니다..."

check_supabase_config() {
    local file=$1
    if grep -q "YOUR_SUPABASE_URL" "$file" || grep -q "YOUR_SUPABASE_ANON_KEY" "$file"; then
        return 1
    fi
    return 0
}

supabase_configured=true

if ! check_supabase_config "admin.html"; then
    echo "⚠️  admin.html에 Supabase 키가 설정되지 않았습니다"
    supabase_configured=false
fi

if ! check_supabase_config "survey.html"; then
    echo "⚠️  survey.html에 Supabase 키가 설정되지 않았습니다"
    supabase_configured=false
fi

if [ "$supabase_configured" = false ]; then
    echo ""
    echo "⚠️  경고: Supabase 설정이 완료되지 않았습니다!"
    echo "배포 전에 시작_가이드.md의 1~2단계를 완료해주세요."
    read -p "그래도 배포하시겠습니까? (y/N): " continue_deploy
    if [[ ! "$continue_deploy" =~ ^[Yy]$ ]]; then
        echo "배포를 취소합니다."
        exit 1
    fi
else
    echo "✅ Supabase 설정 완료"
fi

# 4. 알리고 API 설정 확인
echo ""
echo "📱 알리고 API 설정을 확인합니다..."

if grep -q "YOUR_ALIGO_API_KEY" "admin.html"; then
    echo "⚠️  알리고 API 키가 설정되지 않았습니다 (선택사항)"
else
    echo "✅ 알리고 API 설정 완료"
fi

# 5. Git 커밋
echo ""
echo "💾 변경사항을 커밋합니다..."

git add *.html *.sql *.md .gitignore serve.mjs 2>/dev/null

if git diff --cached --quiet; then
    echo "⚠️  커밋할 변경사항이 없습니다"
else
    git commit -m "Deploy: Olbaby CRM System - $(date +%Y-%m-%d)"
    echo "✅ 커밋 완료"
fi

# 6. GitHub 원격 저장소 확인
echo ""
echo "🌐 GitHub 원격 저장소를 확인합니다..."

if git remote | grep -q "origin"; then
    remote_url=$(git remote get-url origin)
    echo "✅ 원격 저장소: $remote_url"

    read -p "GitHub에 푸시하시겠습니까? (y/N): " do_push
    if [[ "$do_push" =~ ^[Yy]$ ]]; then
        echo "📤 GitHub에 푸시합니다..."

        # 현재 브랜치 확인
        current_branch=$(git branch --show-current)

        if [ -z "$current_branch" ]; then
            # 브랜치가 없으면 main 생성
            git checkout -b main
            current_branch="main"
        fi

        git push -u origin "$current_branch"

        if [ $? -eq 0 ]; then
            echo "✅ GitHub 푸시 완료!"
            echo ""
            echo "🎉 배포가 완료되었습니다!"
            echo ""
            echo "다음 단계:"
            echo "1. GitHub 저장소 → Settings → Pages"
            echo "2. Source: $current_branch branch 선택"
            echo "3. Save 클릭"
            echo "4. 약 1분 후 URL 확인"
            echo ""
            echo "배포 URL 예시:"
            echo "https://YOUR_USERNAME.github.io/olbaby/admin.html"
        else
            echo "❌ GitHub 푸시 실패"
            echo "오류를 확인하고 다시 시도해주세요."
            exit 1
        fi
    fi
else
    echo "⚠️  원격 저장소가 설정되지 않았습니다"
    echo ""
    echo "GitHub 저장소를 추가하려면:"
    echo "git remote add origin https://github.com/YOUR_USERNAME/olbaby.git"
    echo ""
    echo "그 후 다시 이 스크립트를 실행해주세요."
fi

echo ""
echo "✨ 배포 스크립트를 종료합니다."
