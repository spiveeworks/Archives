@echo off

echo You are in a %place%.
title %stencil[3]%

:Inputloop
set /p input=^
>
if "%input%"=="look" call :look
if "%input:~0,4%"=="use " call :use
if "%input%"=="debug" call :debug
goto :Inputloop

:debug
if "%interpret.object[spoon]%"=="" echo There is no spoon.
goto :eof

:look
set look.counter=
call :look.loop
goto :eof

:look.loop
set /a look.counter=look.counter+1
call :set name=%%object[%look.counter%]%%
call :set name=%%stencil[%name%]%%
call :set location=%%object.location[%look.counter%]%%
if "%name%"=="" (title %look.counter%
goto :eof)
set interpret.object[%name%]=%look.counter%
echo There is a %name% %location%.
goto :look.loop

:use
for /f "tokens=2,3" %%f in ("%input%") do (
set inst=%%f
set target=%%g
)
call :set subject=%%interpret.object[%inst%]%%
call :set object=%%interpret.object[%target%]%%
call :set subid=%%object[%subject%]%%
call :set obid=%%object[%object%]%%
call :set event=%%stencil[%subid%].uses[%obid%]%%
call :set output=%%event.text[%event%]%%
echo %output%
call :set transform=%%event[%event%].target.transform%%
if not "%transform%"=="" set object[%obid%]=%transform%
goto :eof

:set
set %*
goto :eof