@echo off
setlocal
title AstRoo - servidor local
cd /d "%~dp0"

echo.
echo ==========================================
echo       ASTROO - PRUEBA LOCAL
echo ==========================================
echo.
echo Iniciando servidor local...
start "Servidor AstRoo 8019" /min cmd /c "cd /d ""%~dp0"" && py -m http.server 8019 --bind 127.0.0.1"
timeout /t 2 /nobreak >nul

echo Esperando a que el servidor este disponible...
set "READY="
for /l %%i in (1,1,10) do (
  powershell -NoProfile -Command "try { $r = Invoke-WebRequest -UseBasicParsing http://127.0.0.1:8019/index.html -TimeoutSec 1; if ($r.StatusCode -eq 200) { exit 0 } else { exit 1 } } catch { exit 1 }" >nul 2>&1
  if not errorlevel 1 (
    set "READY=1"
    goto :open
  )
  timeout /t 1 /nobreak >nul
)

:open
if not defined READY (
  echo No se pudo confirmar el inicio del servidor.
  echo Comprueba que Python esta instalado y que el puerto 8019 esta libre.
  pause
  exit /b 1
)

echo Servidor listo. Abriendo AstRoo...
start "" http://127.0.0.1:8019/index.html
echo.
echo No cierres la ventana "Servidor AstRoo 8019" mientras uses la web.
echo Para detenerlo, cierra esa ventana.
echo.
pause
