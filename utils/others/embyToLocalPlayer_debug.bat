@echo OFF
chcp 65001
:BEGIN
cls

set pythonPath="python"
set pythonEmbed="%~dp0python_embed\python.exe"
if exist %pythonEmbed% (
    echo use python embed. %pythonEmbed%
    set pythonPath=%pythonEmbed%
)

for /F "usebackq tokens=*" %%A in (`%pythonPath% --version 2^>^&1`) do set PYTHON_VERSION=%%A

if "%PYTHON_VERSION:~0,6%" == "Python" (
    echo %PYTHON_VERSION%
    %pythonPath% -c "import sys; print(sys.executable)"
    echo press a number
    echo 1: run in console
    echo 2: register etlp:// protocol handler
    echo 3: unregister etlp:// protocol handler
    echo 4: path translate helper
    echo 5: copy script path to clipboard
    echo 6: update to latest version
    choice /N /C:123456 /M "press a number"%1
    IF ERRORLEVEL ==6 GOTO SIX
    IF ERRORLEVEL ==5 GOTO FIVE
    IF ERRORLEVEL ==4 GOTO FOUR
    IF ERRORLEVEL ==3 GOTO THREE
    IF ERRORLEVEL ==2 GOTO TWO
    IF ERRORLEVEL ==1 GOTO ONE
    GOTO END
) else (
    echo ERROR: python not found, reinstall it and add to path!
    GOTO END
)


:SIX
echo you have pressed six
%pythonPath% "%~dp0utils/update.py"
GOTO END


:FIVE
echo you have pressed five
set mainCmd=%pythonPath% "%~dp0embyToLocalPlayer.py"
echo %mainCmd%
echo already copied, run in cmd, not powershell. paste command is "Ctrl + V"
echo %mainCmd%|clip
GOTO END


:FOUR
echo you have pressed four
%pythonPath% "%~dp0utils/conf_helper.py"
GOTO END


:THREE
echo you have pressed three
reg delete "HKCU\SOFTWARE\Classes\etlp" /f >nul 2>&1
GOTO END


:TWO
echo you have pressed two
reg add "HKCU\SOFTWARE\Classes\etlp" /d "etlp Protocol" /f >nul
reg add "HKCU\SOFTWARE\Classes\etlp" /v "URL Protocol" /f >nul
reg add "HKCU\SOFTWARE\Classes\etlp\DefaultIcon" /f >nul
set powershell_command=$param = '%%1' -replace '^^^^.*?://' -replace '/$'; if ($param -eq 'start') { Start-Process -WorkingDirectory '%~dp0' -FilePath '%pythonPath:~1,-1%' -ArgumentList 'embyToLocalPlayer.py' -WindowStyle Hidden; }
reg add "HKCU\SOFTWARE\Classes\etlp\shell\open\command" /d "powershell.exe -NoProfile -NoLogo -NonInteractive -Sta -WindowStyle Hidden -ExecutionPolicy Bypass -Command \"%powershell_command%\"" /f >nul
GOTO END


:ONE
echo you have pressed one
%pythonPath% "%~dp0embyToLocalPlayer.py"
GOTO END


:END
echo all tasks are finished.
pause
