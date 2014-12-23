@echo off
call :header

start avencha
rem pause>nul
goto :eof

:stencil
set /a stencilcounter=stencilcounter+1
set stencil[%stencilcounter%]=%*
set ofname[%*]=%stencilcounter%
goto :eof


:object
set /a objectcounter=objectcounter+1
for /f "tokens=1*" %%f in ("%*") do (
set name=%%f
set location=%%g
)
call :set stencil=%%ofname[%name%]%%
set object[%objectcounter%]=%stencil%
set object.location[%objectcounter%]=%location%
goto :eof

:event
set /a eventcounter=eventcounter+1
for /f "tokens=1,2*" %%f in ("%*") do (
set name=%%f
set transform=%%g
set description=%%h
)
set event.text[%eventcounter%]=%description%
call :set transform=%%ofname[%transform%]%%
set event[%eventcounter%].target.transform=%transform%
set event.id[%name%]=%eventcounter%
goto :eof

:usage
for /f "tokens=1,2,3" %%f in ("%*") do (
set subjectname=%%f
set objectname=%%g
set verbname=%%h
)
call :set subject=%%ofname[%subjectname%]%%
call :set object=%%ofname[%objectname%]%%
call :set event=%%event.id[%name%]%%
set stencil[%subject%].uses[%object%]=%event%
goto :eof

:set
set %*
goto :eof

:header

rem ### Put room code here ###
set place=room
call :stencil door
call :stencil key
call :stencil open_door
call :event opens open_door The door unlocked :D
call :usage key door opens
call :event displayopen ~ This door is already unlocked.
call :usage key open_door displayopen
call :object door in the wall
call :object key on the floor