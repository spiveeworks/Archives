@echo off
title The Creation.

:loop
call :receive line
if not defined line goto :loop

if "%line%"=="create" goto :create
if "%line%"=="look" goto :look
if "%line%"=="science" goto :science

goto :loop

:create
call :receive entity
if "%entity%"=="subject" goto :create.subject
if "%entity%"=="material" goto :create.material
call :dump
goto :loop

:create.subject
call :receive name
set /a world.counts.subject+=1
set subject[%world.counts.subject%]=%name%
goto :loop

:create.material
call :receive form
set /a world.counts.material+=1
set subject[%world.counts.material%]=%form%
goto :loop

:look
echo :: Subjects ::
for /l %%i in (1,1,%world.counts.subject%) do (call :look.subject %%i)

echo :: Materials ::
for /l %%i in (1,1,%world.counts.material%) do (call :look.material %%i)
goto :eof

:look.subject
call set subjectname=%%subject[%1]%%
echo.    %subjectname%
goto :eof

:look.material
call set matform=%%material[%1]%%
echo.    @space %1 %matform%
goto :eof

:science
goto :Eof

:receive
for /f "tokens=1* delims==" %%a in ("%*") do (
 if not defined receivestack (
  call :receive.in %%b
 )
 set receiver=%%a
)
for /f "tokens=1* delims=^&" %%f in ("%receivestack%") do (
set %receiver%=%%f
set receivestack=%%g
)
goto :eof

:receive.in
if not "%*"=="" (
 echo.%*
)
:receive.fallback
set /p receivestack=^>
if not defined receivestack goto :receive.fallback
goto :eof

:dump
if not "%*"=="" (
 echo.%*
)
set receivestack=
goto :eof