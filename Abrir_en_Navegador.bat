@echo off
TITLE TechTrack Web Preview
echo ==========================================
echo    TECHTRACK - LANZADOR WEB (CHROME)
echo ==========================================
echo.
echo 1. Iniciando servidor de previsualizacion...
echo 2. Abriendo en tu navegador...
echo.
echo * Por favor, espera unos segundos a que cargue *
echo.
flutter run -t lib/preview_main.dart -d chrome --web-renderer canvaskit
pause
