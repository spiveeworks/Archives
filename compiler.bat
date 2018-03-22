@echo off
set TK=C:\Windows\System32\taskkill
set root=%cd%
cd exec
goto :getmode

:nomode
echo Invalid mode name.
echo Press any key to retry . . .
pause>nul

:getmode
cls
set mode=
set /p mode=Compile mode^>
if "%mode%"=="" set /p mode=< .mode > nul
echo.%mode%> .mode

if not exist "%mode%.ini" goto :nomode

for /f "usebackq tokens=* eol=;" %%L in ("%mode%.ini") do call :takeline %%L
path %_path%
goto :loop

:takeline
for /f "tokens=1* delims==" %%A in ("%*") do (
 set name=%%A
 set line=%%B
)
call set _%name%=%%line:$r=%root%%%
goto :eof

:loop
set /p c=^> 
if "%c%"=="c" call :compile
if "%c%"=="l" call :compile 2> log.log
if "%c%"=="r" start %_bin%\%_fname%
if "%c%"=="k" %TK% /IM %_fname% /F
if "%c%"=="d" delete %_bin%\%_fname%
if "%c:~0,1%"=="n" rename %_bin%\%_fname% %c:~2%.exe
if "%c%"=="x" goto :end
goto :loop


:compile
cls
call %_command%
echo. 
echo COMPILATION COMPLETE
echo.
goto :eof

:end
cd ..
