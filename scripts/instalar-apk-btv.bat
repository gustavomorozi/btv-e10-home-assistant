@echo off
rem Instala um APK na TV box via ADB. Arraste o arquivo .apk em cima deste atalho.
rem Defina antes (Painel de Controle > Variaveis de ambiente) ou edite aqui:
rem   BTV  = IP:PORTA da caixa (ex.: 192.168.0.X:11993)
rem   ADB  = caminho do adb.exe (se nao estiver no PATH)
setlocal
chcp 65001 >nul
if "%BTV%"=="" set "BTV=192.168.0.X:11993"
if "%ADB%"=="" set "ADB=adb"

echo.
echo  Instalar APK na TV box (%BTV%)
echo  ------------------------------
if "%~1"=="" (
  echo  Arraste um arquivo .apk em cima deste atalho.
  echo.
  pause
  exit /b 1
)
if /i not "%~x1"==".apk" (
  echo  Isso nao e um .apk: %~nx1
  echo.
  pause
  exit /b 1
)
echo  Arquivo: %~nx1
echo  Confira no VirusTotal se nao conhece a origem!
echo.
"%ADB%" connect %BTV%
echo.
"%ADB%" -s %BTV% install -r "%~1"
echo.
echo  Se aparecer "Success", o app ja esta na caixa.
echo.
pause
