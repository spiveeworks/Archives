::@echo off

call :forparts "$" ";" "1;2;3;4;5;6;7;8;9;10;" "call :resetattribute $ density 0.5"

echo %full%


goto :eof

echo #Version 4.6, File subversion 3
echo.

set group[1].name=Powders
set group[1].element[1]=sand
set group[1].element[1]=salt
set group[1].element[1]=dust
set group[1].element[1]=gunpowder

call :initiateelement sand



:initiateelement
::element (element) (r) (g) (b) (gravity) (slip) (density) (conductivity) (visible)
set /a elements+=1
set element[%elements%].name=%1
set element[%elements%].color.red=238
set element[%elements%].color.green=204
set element[%elements%].color.blue=128
set element[%elements%].gravity=0.9
set element[%elements%].slip=0.5
set element[%elements%].density=0.9
set element[%elements%].conductivity=0
set element[%elements%].visible=1
goto :eof

:resetattribute
set element[%1].%2=%3
goto :eof




:getcompleteset
setlocal
set set=
for /l %%i in (1,1,%elements%) do (call :getcompleteset.set %%i)
(endlocal
set %*=%set%)
goto :eof

:getcompleteset.set
set set=%set%%*;
goto :eof


:setAND
setlocal
call set first=%%%1%%
call set backup=%%%2%%
set out=
:setAND.loop
for /f "tokens=1* delims=;" %%f in ("%first%") do (set currenttest=%%f
set first=%%g)
set second=%backup%
:setAND.loop.test
for /f "tokens=1* delims=;" %%f in ("%second%") do (set currentcomp=%%f
set second=%%g)
if "%currentcomp%"=="%currenttest%" (set out=%out%%currenttest%;
set second=)
if not "%second%"=="" goto :setAND.loop.test
if not "%first%"=="" goto :setAND.loop
(endlocal
set %1=%out%
)
goto :eof


































:forparts
::"$" ";" "1;2;3;4;5;6;7;8;9;10;" "call :resetattribute $ density 0.5"
set forparts=%~3
set in=%~1
set do=%~4
for /f "tokens=1* delims=%~2" %%f in ("%forparts%") do (call :forparts.call %%f
set forparts=%%g
)

:forparts.call
call set finaldo=%%do:%in%=%*%%
%finaldo%
goto :eof










