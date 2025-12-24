@echo off
TITLE TechTrack Preview Launcher
echo ==========================================
echo    TECHTRACK - FUTURISMO MINIMALISTA
echo ==========================================
echo.
echo Lanzando previsualización...
echo.
flutter run -t lib/preview_main.dart -d windows --release
if %errorlevel% neq 0 (
    echo.
    echo Intentando modo debug (mas lento)...
    flutter run -t lib/preview_main.dart -d windows
)
pause
