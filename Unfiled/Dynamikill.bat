@echo off
set length=999
for /l %%a in (0,1,%length%) do (
for /l %%b in (0,1,%length%) do (
for /l %%c in (0,1,%length%) do (
for /l %%d in (0,1,%length%) do (
for /l %%e in (0,1,%length%) do (
for /l %%f in (0,1,%length%) do (
for /l %%g in (0,1,%length%) do (
set var[%%a,%%b,%%c,%%d,%%e,%%f,%%g]=%%a %%b %%c %%d %%e %%f %%g
title %%a %%b %%c %%d %%e %%f %%g
)
)
)
)
)
)
)
pause

:kill
set /a kill~=%1-1
if "%kill~%"=="-1" (%4 
set /a kill.end=%3+%2
for /l %%x in (0,1,%kill.end%) do (
call :kill %kill~% %2 %3 %4 %5 %6 %7
)
goto :eof