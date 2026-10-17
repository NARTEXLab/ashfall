@echo off
cd /d "%~dp0"
echo ============================================
echo  ASHFALL - servidor local en http://localhost:8000/
echo  Cierra esta ventana para detener el servidor.
echo ============================================
start "" cmd /c "timeout /t 2 >nul & start http://localhost:8000/"
where py >nul 2>nul
if %errorlevel%==0 (
  py -m http.server 8000
  goto fin
)
where python >nul 2>nul
if %errorlevel%==0 (
  python -m http.server 8000
  goto fin
)
echo.
echo No se ha encontrado Python. Instalalo desde https://www.python.org/downloads/
echo (marca la casilla "Add python.exe to PATH") y vuelve a ejecutar este archivo.
pause
:fin
