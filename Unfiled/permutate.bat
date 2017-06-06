@echo off
setlocal
set path=%appdata%\spivee\batch\scriptfuncs
echo Permutate how many items?
set /p p=^>
call factorial fp=%p%
set /a fp-=1
for /l %%i in (0,1,%fp%) do (
call getperm var=%%i %p% ,
call :print
)
pause
goto :eof

:print
echo %var%