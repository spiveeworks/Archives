@if "%*"=="" (@echo off)

rem for /f "delims==" %%f in ('set') do (
rem set %%f=
rem )
set place=Who knows?
if "%place%"=="" call compilerer ~


::call language.bat

title The Dream Engine
if 1 neq 1 (
	set event[1]=I#100I:1;
	set dream.ticks=0
	set dream.events=1
	set dream.event[1].stime=0
	set dream.event[1].part[0]=1
	set dream.event[1]=:1;


set type[1]=player

set object[1]=1

set hook[1].file=%cd%\hook.bat
set hook[1].loop[1].object=1
set hook[1].effect[
)

set counter=
:loop
set /a counter+=1

goto :loop

:checkreceptors
call set type=%%object[%~1]%%
call set receptors=%%type[%type%].receptors%%
for /l %%r in (1,1,%receptors%) do (call :checkreceptors.check %%r)

:checkreceptors.check


:enumconditional


pause
:dreaming
set cevent=
set bevent=0
call :getnextevent
if "%error%"=="1" call :endmsg Nothing happens.
set dream.ticks=%beventtime%
call :event %bevent%
goto :dreaming

:getnextevent
if "%cevent%"=="%dream.events%" (set error=1
goto :eof)
set /a cevent+=1
call set ceventtime=%%dream.event[%cevent%].stime%%
if "%ceventtime%"=="" goto :getnextevent
set bevent=%cevent%
set beventtime=%ceventtime%

:getnextevent.
if "%cevent%"=="%dream.events%" (set cevent=
goto :eof)
set /a cevent+=1
call set ceventtime=%%dream.event[%cevent%].stime%%
if "%ceventtime%"=="" goto :getnextevent.
if %ceventtime% gtr %beventtime% goto :getnextevent.
if %ceventtime% equ %beventtime% (
if %cevent% gtr %bevent% goto :getnextevent.
)
set bevent=%cevent%
set beventtime=%ceventtime%
goto :getnextevent.

	for /f "tokens=1,2,3,4" %%a in ("%*") do (
	set $id=%%a
	set $part[0]=%%b
	set $part[1]=%%c
	set $part[2]=%%d
	)
	call set $sb=%%object[%$part[0]%]%%
	call set $ob=%%object[%$part[1]%]%%
	call set $in=%%object[%$part[2]%]%%
	call set $sb=%%console.type[%$sb%]%%
	call set $ob=%%console.type[%$ob%]%%
	call set $in=%%console.type[%$in%]%%
	call set $script=%%event[%$id%]%%

:event
call set $script=%%dream.event[%*]%%
call set $part[0]=%%dream.event[%*].part[0]%%
set $task=action
:event.scriptloop
set $char=%$script:~0,1%
set $script=%$script:~1%
call :event.script.track[%$task%]
if not "%$script%"=="" goto :event.scriptloop
for /f "tokens=1 delims==" %%f in ('set dream.event[%*]') do (
set %%f=
)
goto :eof

:event.script.track[action]
if "%$char%"=="?" (set $task=getterm
set $purpose=enumconditional)
if "%$char%"=="f" (set $task=number
set $purpose=for
set $phase=1)
if "%$char%"=="!" (set $task=getterm
set $purpose=dataleft)
if "%$char%"=="-" (set $task=number
set $purpose=delete)
if "%$char%"=="+" (set $task=number
set $purpose=create)
if "%$char%"=="I" (set $task=getterm
set $purpose=inhibit)
if "%$char%"==":" (set $task=number
set $purpose=call)
if "%$char%"=="{" (
if "%$purpose%"=="testelse" (set /a $nest=$nest+1
call set $layer[%%$nest%%]=else)
if "%$purpose%"=="skipelse" (set $task=skipbrace
set $brace=1
set $purpose=else)
)
set $num=
if "%$char%"=="}" (call :event.script.track[action].handlenest)
goto :eof

:event.script.track[action].handlenest
call set $layer=%%$layer[%$nest%]%%
if "%$layer%"=="for" goto :event.script.handlefor
if "%$layer%"=="if" (set $purpose=skipelse) else (set $purpose=)
set /a $nest=$nest-1
goto :eof

:event.script.handlefor
call :event.script.handlefor.
set $part=
set $obj=
set $sbj=
set $type=
set $slot=
goto :eof

:event.script.handlefor.
call set $obj=%%$for[%$nest%].obj%%
call set $type=%%$for[%$nest%].type%%
call set $slot=%%$for[%$nest%].slot%%
call set $sbj=%%$for[%$nest%].sbj%%
set $end=false
call :event.script.handlefor.getid
if "%$end%"=="" (set /a $nest=$nest-1
goto :eof)
call set $script=%%$for[%$nest%]%%
call set $part=%%$for[%$nest%].part%%
set $part[%$part%]=%$obj%
set $for[%$nest%].obj=%$obj%
goto :eof

:event.script.handlefor.getid
if "%$obj%"=="%dream.environment.objects%" (set $end=
goto :eof)
set /a $obj=$obj+1
call set $test=%%object[%$obj%]%%
if "%$test%"=="" goto :event.script.handlefor.getid
call :dream.testsub %$type% %$test%
if "%error%"=="1" goto :event.script.handlefor.getid
call set $num=%%object[%$obj%].pointer[%$slot%]%%
if "%$num%"=="%$sbj%" (goto :eof)
goto :event.script.handlefor.getid

:event.script.track[getterm]
if "%$char%"=="@" (set $task=partnum)
if "%$char%"=="#" (if not "%$purpose%"=="dataleft" (
set $task=number))
goto :eof

:event.script.track[partnum]
if "%$char%"=="." (set $task=field
call set $rid=%%$part[%$part%]%%
set $part=
goto :eof
)
set $part=%$part%%$char%
goto :eof

:event.script.track[field]
if "%$char%"=="$" (set $task=getslotid
set $dtype=property
goto :eof)
if "%$char%"=="!" (set $task=getslotid
set $dtype=state
goto :eof)
if "%$char%"=="#" (set $task=getslotid
set $dtype=value
goto :eof)
if "%$char%"=="@" (set $task=closeterm.id
goto :eof)
if "%$char%"=="*" (set $task=closeterm.type
goto :eof)
if "%$char%"=="." (set $hold=%$rid%
call set $rid=%%object[%$rid%].pointer[%$point%]%%
set $pslot=%$point%
set $point=
goto :eof
)
set $point=%$point%%$char%
goto :eof

:event.script.track[getslotid]

	if "%$purpose%"=="lhs" (
	if "%$char%"=="=" (goto :event.script.track[closeterm])
	if "%$char%"=="~" (goto :event.script.track[closeterm])
	)
	if "%$purpose%"=="rhs" (if "%$char%"=="{" (goto :event.script.track[closeterm]))
	if "%$purpose%"=="inhibit" (if "%$char%"=="{" (goto :event.script.track[closeterm]))
	if "%$purpose%"=="dataright" (if "%$char%"==";" (goto :event.script.track[closeterm]))
	if "%$purpose%"=="dataleft" (
	if "%$char%"=="=" (goto :event.script.track[close[dataleft]])
	if "%$char%"=="+" (goto :event.script.track[close[dataleft]])
	if "%$char%"=="-" (goto :event.script.track[close[dataleft]])
	)
	set $slotid=%$slotid%%$char%
	goto :eof

:event.script.track[number]
if "%$purpose%"=="lhs" (
if "%$char%"=="=" (goto :event.script.track[closeterm])
if "%$char%"=="~" (goto :event.script.track[closeterm])
)
if "%$purpose%"=="rhs" (if "%$char%"=="{" (goto :event.script.track[close[rhs]]))
if "%$purpose%"=="speak" (if "%$char%"==";" (goto :event.script.track[close[speak]]))
if "%$purpose%"=="delete" (if "%$char%"==";" (goto :event.script.track[close[delete]]))
if "%$purpose%"=="dataright" (if "%$char%"==";" (goto :event.script.track[close[dataright]]))
if "%$purpose%"=="for" (if "%$char%"==":" (goto :event.script.track[close[for].%$phase%]))
if "%$purpose%"=="create" (if "%$char%"==":" (goto :event.script.track[close[create]]))
if "%$purpose%"=="createtype" (if "%$char%"==";" (goto :event.script.track[close[createtype]]))
if "%$purpose%"=="call" (if "%$char%"==";" (goto :event.script.track[close[call]]))
if "%$purpose%"=="inhibit" (if "%$char%"=="I" (goto :event.script.track[close[inhibit]]))
set $num=%$num%%$char%
goto :eof

:event.script.track[closeterm]
if "%$purpose%"=="four" (call :pexit unexpected corruption met in core. terminating)
call set $num=%%object[%$rid%].%dtype%[%$slotid%]%%
if not "%$purpose%"=="dataleft%" (set $slotid=)
if "%$num%"=="" set $num=0
goto :event.script.track[close[%$purpose%]]

:event.script.track[closeterm.id]
set $num=%$rid%
if "%$purpose%"=="dataleft" (set $slotid=@)
goto :event.script.track[close[%$purpose%]]

:event.script.track[closeterm.type]
call set $num=%%object[%$rid%]%%
if "%$purpose%"=="dataleft" (set $slotid=*)
goto :event.script.track[close[%$purpose%]]

:event.script.track[close[lhs]]
if "%$char%"=="=" (set $lhs.if=true) else (set $lhs.if=false)
set $lhs=%$num%
set $num=
set $purpose=rhs
set $task=getterm
goto :eof

:event.script.track[close[rhs]]
if "%$num%"=="%$lhs%" (set $num=true) else (set $num=false)
if "%$num%"=="%$lhs.if%" (set /a $nest=$nest+1
set $task=action
call set $layer[%%$nest%%]=if) else (
set $task=skipbrace
set $brace=1
set $purpose=if)
goto :eof

:event.script.track[skipbrace]
if "%$char%"=="{" (set /a $brace=$brace+1)
if "%$char%"=="}" (set /a $brace=$brace-1)

if "%$brace%"=="0" (
    set $task=action
    if "%$purpose%"=="if" (
        set $purpose=testelse
    ) else (
        set $purpose=
    )
)
goto :eof

:event.script.track[close[dataleft]]
if "%$slotid%"=="@" (set $target.slot=%$pslot%
set $target.id=%$hold%
set $dtype=pointer
) else (
set $target.id=%$rid%
set $target.slot=%$slotid%
)
call set $base=%%object[%$target.id%].%$dtype%[%$slotid%]%%
set $op=%$char%
set $slotid=
set $purpose=dataright
set $task=getterm
goto :eof

:event.script.track[close[dataright]]
if "%$op%"=="="(set /a $base=) else (
if "%$op%"=="-"(set /a $num=$num*-1))
set /a object[%$target.id%].%$dtype%[%$target.slot%]=$base+$num
set $base=
set $num=
set $part=
set $slotid=
set $task=action
set $purpose=
goto :eof

:event.script.track[close[inhibit]]
set $parse=0=%$part[0]%
for /f "tokens=2,3* delims=[=]" %%a in ('set $part[') do (
if not "%%a"=="0" if not "%%c"=="" (
call set $parse=%%$parse%%,%%a=%%c
))
call :queueevent %$num%;%$parse%;%$string%
set $string=
set $parse=
set $task=action
set $purpose=
set $num=
goto :eof

:event.script.track[close[call]]
call set $script=%%event[%$num%]%%%$script%
set $num=
set $task=action
set $purpose=
goto :eof

	call set $output=%%event[%$id%].output[%$num%]%%
	call set $output=%%$output:$ob=%$ob%%%
	call set $output=%%$output:$sb=%$sb%%%
	if not "%$in%"=="" (call set $output=%%$output:$in=%$in%%%)
	echo %$output%
	set $task=action
	set $purpose=
	set $num=
	goto :eof

:event.script.track[close[delete]]
call set $num=%%$part[%$num%]%%
call :destroy %$num%
set $task=action
set $purpose=
set $num=
goto :eof

:event.script.track[close[create]]
set $purpose=createtype
set $createnum=%$num%
set $num=
goto :eof

:event.script.track[close[createtype]]
set $task=action
set $purpose=
call :instantiate %$num%
set $part[%$createnum%]=%dream.environment.objects%
set $num=
goto :eof

:event.script.track[close[for].1]
set /a $nest=$nest+1
set $for[%$nest%].part=%$num%
set $num=
set $phase=2
goto :eof

:event.script.track[close[for].2]
set $for[%$nest%].type=%$num%
set $num=
set $phase=3
goto :eof

:event.script.track[close[for].3]
set $for[%$nest%].slot=%$num%
set $num=
set $task=getterm
set $purpose=four
goto :eof

:event.script.track[close[four]]
set $layer[%$nest%]=for
set $for[%$nest%].sbj=%$num%
set $for[%$nest%].obj=
set $for[%$nest%]=%$script%
call :event.script.handlefor
if "%$end%"=="" (set $task=skipbrace
set $brace=1
set $purpose=for) else (set $task=action)
goto :eof

:: Dream Functions ::

:instantiate
set /a dream.environment.objects=dream.environment.objects+1
set object[%dream.environment.objects%]=%*
goto :eof

:destroy
for /f "tokens=1 delims==" %%f in ('set object[%*]') do (
set %%f=)
goto :eof



:dream.testsub
set $test=%2
:dream.testsub.loop
if "%$test%"=="%1" (set error=0
goto :eof)
call set $test=%%type[%$test%].super%%
if "%$test%"=="0" (set error=1
goto :eof)
goto :dream.testsub.loop

:queueevent
for /f "tokens=1,2* delims=;" %%a in ("%*") do (
set $offset=%%a
set $parts=%%b
set $toqueue=%%c
)
set /a dream.events+=1
set /a dream.event[%dream.events%].stime=$offset+dream.ticks
set dream.event[%dream.events%]=%$toqueue%
call :queueevent.partloop
set $offset=
set $part=
set $toqueue=
set $part.object=
goto :eof
:queueevent.partloop
for /f "tokens=1,2* delims==," %%x in ("%$parts%") do (
set $part=%%x
set $part.object=%%y
set $parts=%%z
)
set dream.event[%dream.events%].part[%$part%]=%$part.object%
if not "%$parts%"=="" (goto :queueevent.partloop)
goto :eof

:: Batch Functions ::

:token
for /f "tokens=1*" %%f in ("%*") do (
set token.num=%%f
set token.remainder=%%g
)
for /f "tokens=1* delims==" %%f in ("%token.remainder%") do (
set token.var=%%f
set token.remainder=%%g
)
for /f "tokens=%token.num%" %%f in ("%token.remainder%") do (set %token.var%=%%f)
goto :eof

:random
for /f "tokens=1* delims==" %%f in ("%*") do (
set random.var=%%f
set random.max=%%g
)
for /f "tokens=1*" %%f in ("%random.max%") do (
set random.min=%%f
set random.max=%%g
)
set /a %random.var%=(random.max-random.min+1)*%random%/32768+random.min
set random.var=
set random.min=
set random.max=
goto :eof

:pexit
if not "%*"=="" (echo %*)
echo Press any key to exit . . .
pause>nul
exit

:endmsg
if not "%*"=="" (echo %*)
@echo off
:endmsg.loop
goto :endmsg.loop
