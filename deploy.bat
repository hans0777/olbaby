@echo off
chcp 65001 >nul
echo.
echo ============================================
echo 🚀 오엘베이비 CRM 시스템 배포 스크립트
echo ============================================
echo.

REM 1. Git 저장소 확인
if not exist ".git\" (
    echo 📦 Git 저장소를 초기화합니다...
    git init
    git config user.name "오엘베이비"
    git config user.email "hans97490800@gmail.com"
    echo ✅ Git 초기화 완료
) else (
    echo ✅ Git 저장소가 이미 존재합니다
)

echo.
echo 📋 필수 파일을 확인합니다...

set missing=0

if not exist "admin.html" (
    echo ❌ admin.html 파일이 없습니다
    set missing=1
)
if not exist "survey.html" (
    echo ❌ survey.html 파일이 없습니다
    set missing=1
)
if not exist "guide.html" (
    echo ❌ guide.html 파일이 없습니다
    set missing=1
)
if not exist "offer.html" (
    echo ❌ offer.html 파일이 없습니다
    set missing=1
)
if not exist "supabase_schema.sql" (
    echo ❌ supabase_schema.sql 파일이 없습니다
    set missing=1
)

if %missing%==1 (
    echo.
    echo ⚠️  경고: 필수 파일이 누락되었습니다!
    pause
    exit /b 1
)

echo ✅ 모든 필수 파일이 존재합니다

REM Supabase 설정 확인
echo.
echo 🔐 Supabase 설정을 확인합니다...

findstr /C:"YOUR_SUPABASE_URL" admin.html >nul
if %errorlevel%==0 (
    echo ⚠️  admin.html에 Supabase 키가 설정되지 않았습니다
    echo.
    echo 배포 전에 시작_가이드.md의 1~2단계를 완료해주세요.
    echo.
    set /p continue="그래도 배포하시겠습니까? (Y/N): "
    if /i not "%continue%"=="Y" (
        echo 배포를 취소합니다.
        pause
        exit /b 1
    )
) else (
    echo ✅ Supabase 설정 완료
)

REM 알리고 API 확인
echo.
echo 📱 알리고 API 설정을 확인합니다...

findstr /C:"YOUR_ALIGO_API_KEY" admin.html >nul
if %errorlevel%==0 (
    echo ⚠️  알리고 API 키가 설정되지 않았습니다 (선택사항)
) else (
    echo ✅ 알리고 API 설정 완료
)

REM Git 커밋
echo.
echo 💾 변경사항을 커밋합니다...

git add *.html *.sql *.md .gitignore serve.mjs deploy.sh deploy.bat check-setup.html .env.example 2>nul

git diff --cached --quiet
if %errorlevel%==0 (
    echo ⚠️  커밋할 변경사항이 없습니다
) else (
    git commit -m "Deploy: Olbaby CRM System - %date:~0,10%"
    echo ✅ 커밋 완료
)

REM GitHub 원격 저장소 확인
echo.
echo 🌐 GitHub 원격 저장소를 확인합니다...

git remote | findstr "origin" >nul
if %errorlevel%==0 (
    for /f "tokens=*" %%i in ('git remote get-url origin') do set remote_url=%%i
    echo ✅ 원격 저장소: %remote_url%
    echo.

    set /p do_push="GitHub에 푸시하시겠습니까? (Y/N): "
    if /i "%do_push%"=="Y" (
        echo.
        echo 📤 GitHub에 푸시합니다...

        for /f "tokens=*" %%i in ('git branch --show-current') do set current_branch=%%i

        if "%current_branch%"=="" (
            git checkout -b main
            set current_branch=main
        )

        git push -u origin %current_branch%

        if %errorlevel%==0 (
            echo.
            echo ✅ GitHub 푸시 완료!
            echo.
            echo 🎉 배포가 완료되었습니다!
            echo.
            echo 다음 단계:
            echo 1. GitHub 저장소 → Settings → Pages
            echo 2. Source: %current_branch% branch 선택
            echo 3. Save 클릭
            echo 4. 약 1분 후 URL 확인
            echo.
            echo 배포 URL 예시:
            echo https://YOUR_USERNAME.github.io/olbaby/admin.html
        ) else (
            echo.
            echo ❌ GitHub 푸시 실패
            echo 오류를 확인하고 다시 시도해주세요.
        )
    )
) else (
    echo ⚠️  원격 저장소가 설정되지 않았습니다
    echo.
    echo GitHub 저장소를 추가하려면:
    echo git remote add origin https://github.com/YOUR_USERNAME/olbaby.git
    echo.
    echo 그 후 다시 이 스크립트를 실행해주세요.
)

echo.
echo ✨ 배포 스크립트를 종료합니다.
echo.
pause
