@echo on
title Loading . . .
call :header
start ^
avencha
rem ^
pause>nul
goto :eof

:stencil
set /a stencilcounter=stencilcounter+1
set /a propertycounter=0
for /f "tokens=1* delims=;" %%f in ("%*") do (
set name=%%f
set rest=%%g
)
:stencilloop
set /a propertycounter=propertycounter+1
for /f "tokens=1* delims=}" %%f in ("%rest%") do (set property=%%f
set rest=%%g)
for /f "tokens=1* delims={" %%f in ("%property%") do (set property=%%f
set list=%%g
)
set debug.stencil[%stencilcounter%].property[%property%]=%propertycounter%
set adjcounter=0
:stencil.listloop
for /f "tokens=1* delims=;" %%f in ("%list%") do (
set adj=%%f
set list=%%g
)
set interpret.adjective[%adj%].stencil[%stencilcounter%].property=%propertycounter%
set interpret.adjective[%adj%].stencil[%stencilcounter%]=%adjcounter%
set console.stencil[%stencilcounter%].property[%propertycounter%].adjective[%adjcounter%]=%adj%
set /a adjcounter=adjcounter+1
if not "%list%"=="" goto :stencil.listloop
if not "%rest%"=="" goto :stencilloop
set console.stencil[%stencilcounter%]=%name%
set interpret.stencil[%name%]=%stencilcounter%
set stencil[%stencilcounter%].properties=%propertycounter%
goto :eof


:object
set /a objectcounter=objectcounter+1
for /f "tokens=1* delims=;" %%f in ("%*") do (
set standard=%%f
set description=%%g
)
for /f "tokens=1*" %%f in ("%standard%") do (
set name=%%f
set location=%%g
)
call :set stencil=%%interpret.stencil[%name%]%%
set object[%objectcounter%]=%stencil%
set object.location[%objectcounter%]=%location%
call :object.loop
goto :eof

:object.loop
if "%description%"=="" goto :eof
for /f "tokens=1* delims=;" %%f in ("%description%") do (
set adj=%%f
set description=%%g
)
call :set property=%%interpret.adjective[%adj%].stencil[%stencil%].property%%
call :set adj=%%interpret.adjective[%adj%].stencil[%stencil%]%%
set object[%objectcounter%].property[%property%]=%adj%
goto :object.loop

:event
set /a eventcounter=eventcounter+1
set eventcounter.outs=
set brace=0
for /f "tokens=1,2,3*" %%a in ("%*") do (
set name=%%a
set object=%%b
set instrument=%%c
set script=%%d
)
set debug.event[%eventcounter%]=%name%
call :set oid=%%interpret.stencil[%object%]%%
call :set iid=%%interpret.stencil[%instrument%]%%
set event[%eventcounter%].object=%oid%
set event[%eventcounter%].instrument=%iid%
call :set action=%%interpret.hook.action[%name%]%%
if "%action%"=="" (set /a actioncounter=actioncounter+1
call :set action=%%actioncounter%%)
set interpret.hook.action[%name%]=%actioncounter%
set hook.action[%actioncounter%].using[%oid%,%iid%]=%eventcounter%
set code=
call :eventloop
set event[%eventcounter%]=%code%
goto :eof

:eventloop
if "%script%"=="" goto :eventloop.tail
for /f "tokens=1*" %%f in ("%script%") do (
set action=%%f
set script=%%g
)
if "%script%"=="" (call :comerror)
if "%action%"=="if" (call :eventloop.if) else (
 if "%action%"=="destroy" (call :eventloop.destroy) else (
  if "%action%"=="set" (call :eventloop.set) else (
   if "%action%"=="print" (call :eventloop.print) else (
    call :comerror %action%
   )
  )
 )
)
goto :eventloop
:eventloop.tail
if "%brace%"=="0" goto :eof
set code=%code%}
call :set script=%%tail[%brace%]%%
call :set type=%%type[%brace%]%%
set /a brace=brace-1
if "%type%"=="else" goto :eventloop
for /f %%f in ("%script%") do (set else=%%f)
if not "%else%"=="else" goto :eventloop
set code=%code%{
for /f "tokens=1* delims={" %%f in ("%script%") do (set discard=%%f
set script=%%g
)
for /f "tokens=1,2" %%f in ("%discard%") do (set discard=%%g)
if not "%discard%"=="" call :comerror %discard%
set /a brace=brace+1
call :eventloop.findclose
set type[%brace%]=else
goto :eventloop

:eventloop.findclose
set body=%script%
set script=
set count=1
:eventloop.findcloseloop
set char=%body:~0,1%
set body=%body:~1%
if "%char%"=="{" (set /acount=count+1)
if "%char%"=="}" (set /a count=count-1)
if "%count%"=="0" (
set tail[%brace%]=%body%
goto :eof
)
set script=%script%%char%
if "%body%"=="" (set set tail[%brace%]=
goto :eof)
goto :eventloop.findcloseloop


:eventloop.if
set code=%code%?
for /f "tokens=1,2,3*" %%h in ("%script%") do (
set lhs=%%h
set compareop=%%i
set rhs=%%j
set script=%%k
)
call :eventloop.giveterm %lhs%
if "%compareop%"=="==" (set code=%code%=) else (
 if "%compareop%"=="!=" (set code=%code%~) else (
  call :comerror %compareop%
 )
)
call :eventloop.giveterm %rhs%
if not "%script:~0,1%"=="{" call :comerror %script%
set script=%script:~1%
set code=%code%{
set /a brace=brace+1
call :eventloop.findclose
set type[%brace%]=if
goto :eof

:eventloop.destroy
set code=%code%~
for /f "tokens=1* delims=;" %%f in ("%script%") do (
 set line=%%f
 set script=%%g
)
for /f "tokens=1,2" %%f in ("%line%") do (
 set part=%%f
 set discard=%%g
)
if not "%discard%"=="" call :comerror %discard%
if "%part%"=="object" (set code=%code%1) else (
 if "%part%"=="instrument" (set code=%code%2) else (
  call :comerror %part%
 )
)
set code=%code%;
goto :eof

:eventloop.set
set code=%code%!
for /f "tokens=1* delims=;" %%f in ("%script%") do (
set line=%%f
set script=%%g
)
for /f "tokens=1,2,3*" %%f in ("%line%") do (
set left=%%f
set op=%%g
set right=%%h
set discard=%%i
)
if not "%discard%"=="" call :comerror %discard%
call :eventloop.giveterm %left%
if "%op%"=="=" (set code=%code%=) else (
 if "%op%"=="+=" (set code=%code%+) else (
  if "%op%"=="-=" (set code=%code%-) else (
   call :comerror %op%
  )
 )
)
call :eventloop.giveterm %right%
set code=%code%;
goto :eof

:eventloop.print
set code=%code%:
for /f "tokens=1* delims=;" %%f in ("%script%") do (
set line=%%f
set script=%%g
)
for /f "tokens=1*" %%f in ("%line%") do (
set output=%%f
set discard=%%g
)
if not "%discard%"=="" call :comerror %discard%
call :set string=%%debug.event.output[%output%]%%
set /a eventcounter.outs=eventcounter.outs+1
set event[%eventcounter%].output[%eventcounter.outs%]=%string%
set code=%code%%eventcounter.outs%;
goto :eof

:eventloop.giveterm
for /f "tokens=1* delims=." %%f in ("%*") do (
set part=%%f
set property=%%g
)
if "%property%"=="" (goto :eventloop.givenum)
set code=%code%@
if "%part%"=="object" (set code=%code%1
set rid=%oid%) else (
 if "%part%"=="instrument" (set code=%code%2
set rid=%iid%) else (
  call :comerror %part%
 )
)
call :set pid=%%debug.stencil[%rid%].property[%property%]%%
call :set code=%code%.$%pid%
goto :eof

:eventloop.givenum
call :set npid=%%interpret.adjective[%part%].stencil[%rid%].property%%
if not "%npid%"=="%pid%" call :comerror %part%
call :set value=%%interpret.adjective[%part%].stencil[%rid%]%%
set code=%code%#%value%
goto :eof

:comerror
echo off
cls
title Sorry, I had to.
if "%*"=="" (echo The syntax of the command is incorrect.
) else (echo %* was unexpected at this time.)
echo Press any key to exit . . .
pause>nul
exit

:output
for /f "tokens=1*" %%f in ("%*") do (set name=%%f
set content=%%g
)
set debug.event.output[%name%]=%content%
goto :eof

:set
set %*
goto :eof

:header

rem ### Put room code here ###
set place=room
call :stencil door;protection{unlocked;locked}
call :stencil key;condition{stable;fragile}

call :output disintegrate The key disintegrated.
call :output unlock The door unlocked :D
call :output already This door is already unlocked.

call :event unlock door key if object.protection == locked {set object.protection = unlocked; if instrument.condition == fragile {destroy instrument; print disintegrate;} print unlock;} else {print already;}

call :object door in the wall;locked
call :object key on the floor;fragile