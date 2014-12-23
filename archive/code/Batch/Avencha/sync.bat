@echo off
set here=%~dp0
set this=%~0
call :header
type "%data.collate%" >"%~0"
call :footer
goto :eof

:header
title Avencha updater
if not exist "%appdata%\Spivee\avencha.db" (echo You must be on Jarvis's computer to update Avencha!
echo Press any key to exit . . .
pause>nul
exit
)

for /f "tokens=1* delims== usebackq" %%f in ("%appdata%\Spivee\avencha.db") do (
set data.%%f=%%g
)

if "%data.collate%"=="%this%"  (echo You must copy this directory to a different location first :P
echo Press any key to exit . . .
pause>nul
exit
)

goto :eof



:footer
call :parsedir %here%ideas
call :parsedir %here%reports
call :parsedir %here%sent\ideas
call :parsedir %here%sent\reports

for /d %%f in ("%data.location%\Version *") do (
call :copyversion %%f
)
for %%f in ("%here%ideas\*.txt") do (
echo.>>"%data.location%\%data.data%\idealist.txt"
echo [%%~nf~@%date% %time%]>>"%data.location%\%data.data%\idealist.txt"
type "%%~f">>"%data.location%\%data.data%\idealist.txt"
move "%%~f" "%here%sent\ideas\%%~nxf"
)
for %%f in ("%here%reports\*.txt") do (
echo.>>"%data.location%\%data.data%\reportlist.txt"
echo [%%~nf~@%date% %time%]>>"%data.location%\%data.data%\reportlist.txt"
type "%%~f">>"%data.location%\%data.data%\reportlist.txt"
move "%%~f" "%here%sent\reports\%%~nxf"
)
goto :eof

:copyversion
call :cut %*
if exist "%here%%target%" goto :eof
call :copyd "%*" "%here%"
goto :eof

:parsedir
if not exist "%*" (md "%*")
goto :eof

:cut
for /f "tokens=*" %%n in ("%*") do (set string=%%~n)
:cutloop
for /f "tokens=1* delims=\" %%f in ("%string%") do (
set target=%%f
set string=%%g
)
if not "%string%"=="" goto :cutloop
goto :eof

:copyd
call :cut "%~1"
if not exist "%~2\%target%" md "%~2\%target%"
copy "%~1" "%~2\%target%\"
for /d %%a in ("%~1\*") do (call :copyd "%%a" "%~2\%target%")
goto :eof