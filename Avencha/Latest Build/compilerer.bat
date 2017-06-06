@echo off
title [The Dream Engine ~dev 0.5] Compiler

for /f "delims==" %%v in ('set') do (
 if not "%%v"=="comspec" (
  set %%v=
 )
)

echo What file do you want to use?
set /p name=^
>

for /f "tokens=1* delims=." %%f in ("%name%") do (set test=%%g)
if "%test%"=="" (if not exist "%name%" (set name=%name%.txt))

set interpret.type[nul]=0

set purpose=root
set layer=0
for /f "tokens=* usebackq delims=~" %%f in ("%name%") do (call :readline .%%f)
set indent=0
call :readline.lowerindent

echo @if "%*"=="" (@echo off) >file.bat

for /f "tokens=1* delims==" %%v in ('set') do (
 if not "%%v"=="comspec" (
  >>file.bat echo ^
set %%v=%%w
 )
)

>>file.bat echo if exist "Avencha.bat" ^(
>>file.bat echo  Avencha.bat
>>file.bat echo ) else (
>>file.bat echo  pushd ..
>>file.bat echo  if exist "Avencha.bat" ^(
>>file.bat echo   Avencha.bat
>>file.bat echo  ) else (
>>file.bat echo   echo This needs to be in the same directory as Avencha ^^^>,^^^<
>>file.bat echo   echo     ^^^(Or . . . at least in a subdirectory of such a directory^^^)
>>file.bat echo   echo.
>>file.bat echo   echo Press any key to exit . . .
>>file.bat echo   pause^>nul
>>file.bat echo  )
>>file.bat echo )
echo Process complete.

if "%~1"=="" goto :compileend
echo Press any key to begin your avencha :D
pause>nul
cls
goto :eof

::helpmeeeeeeeeeeeeeeeeeeeeeeeee::

:compileend

echo Press any key to exit . . .
pause>nul
goto :eof

:type.giveproperty
for /f "tokens=1,2*" %%f in ("%*") do (set $type=%%f
set $property=%%g
set $list=%%h
)
call :set $type=%%interpret.type[%$type%]%%
call :set $props=%%type[%$type%].properties%%
set /a $props=$props+1
set type[%$type%].properties=%$props%
set debug.type[%$type%].property[%$property%]=%$props%
set debug.type[%$type%].property[%$props%].name=%$property%
set $value=
:type.giveproperty.adjloop
for /f "tokens=1* delims=, " %%f in ("%$list%") do (
set $adj=%%f
set $list=%%g
)
set /a $value=$value+1
set interpret.adjective[%$adj%].type[%$type%]=%$value%
set interpret.adjective[%$adj%].type[%$type%].property=%$props%
set console.type[%$type%].property[%$props%].adjective[%$value%]=%$adj%
if not "%$list%"=="" goto :type.giveproperty.adjloop
set type[%$type%].property[%$props%].highest=%$value%
goto :eof


:type.givestate
for /f "tokens=1,2,3,4" %%f in ("%*") do (set $type=%%f
set $state=%%g
set $zero=%%h
set $one=%%i
)
call :set $type=%%interpret.type[%$type%]%%
call :set $states=%%type[%$type%].states%%
set /a $states=$states+1
set type[%$type%].states=%$states%
set debug.type[%$type%].state[%$state%]=%$states%
set debug.type[%$type%].state[%$states%].name=%$state%

set interpret.adjective[%$zero%].type[%$type%]=0
set interpret.adjective[%$zero%].type[%$type%].state=%$states%
set console.type[%$type%].state[%$states%].adjective[0]=%$zero%
set interpret.adjective[%$one%].type[%$type%]=1
set interpret.adjective[%$one%].type[%$type%].state=%$states%
set console.type[%$type%].state[%$states%].adjective[1]=%$one%

goto :eof

:type.givevalue
for /f "tokens=1,2*" %%f in ("%*") do (set $type=%%f
set $value=%%g
)
call :set $type=%%interpret.type[%$type%]%%
call :set $values=%%type[%$type%].values%%
set /a $values=$values+1
set type[%$type%].values=%$values%
set debug.type[%$type%].value[%$value%]=%$values%
set debug.type[%$type%].value[%$values%].name=%$value%
set $value=
goto :eof

:type.givepointer
for /f "tokens=1,2*" %%f in ("%*") do (set $type=%%f
set $pointer=%%g
set $pointtype=%%h
)
call :set $type=%%interpret.type[%$type%]%%
call :set $pointid=%%interpret.type[%$pointtype%]%%
call :set $points=%%type[%$type%].pointers%%
set /a $points=$points+1
set type[%$type%].pointers=%$points%
set debug.type[%$type%].pointer[%$pointer%]=%$points%
set debug.type[%$type%].pointer[%$points%].name=%$pointer%
set type[%$type%].pointer[%$points%]=%$pointid%
goto :eof

:type.expand
set type[%2].super=%1
call :set type[%1].sub=%%type[%1].sub%%%2;
set $counter=
call :set $max=%%type[%1].properties%%
call :type.expand.property %*
set type[%2].properties=%$max%

set $counter=
call :set $max=%%type[%1].states%%
call :type.expand.state %*
set type[%2].states=%$max%

set $counter=
call :set $max=%%type[%1].values%%
call :type.expand.value %*
set type[%2].values=%$max%

set $counter=
call :set $max=%%type[%1].pointers%%
call :type.expand.pointer %*
set type[%2].pointers=%$max%

goto :eof

:type.expand.property
if "%$counter%"=="%$max%" goto :eof
set /a $counter=$counter+1
set $adjcounter=
call :set $adjmax=%%type[%1].property[%$counter%].highest%%
:type.expand.property.value
set /a $adjcounter=$adjcounter+1
call :set $term=%%console.type[%1].property[%$counter%].adjective[%$adjcounter%]%%
set interpret.adjective[%$term%].type[%2]=%$adjcounter%
set interpret.adjective[%$term%].type[%2].property=%$counter%
set console.type[%2].property[%$counter%].adjective[%$adjcounter%]=%$term%
if not "%$adjcounter%"=="%$adjmax%" goto :type.expand.property.value
set type[%2].property[%$counter%].highest=%$adjmax%
call :set $debug=%%debug.type[%1].property[%$counter%].name%%
set debug.type[%2].property[%$debug%]=%$counter%
set debug.type[%2].property[%$counter%].name=%$debug%
goto :type.expand.property

:type.expand.state
if "%$counter%"=="%$max%" goto :eof
set /a $counter=$counter+1
call :set $term=%%console.type[%1].state[%$counter%].adjective[0]%%
set interpret.adjective[%$term%].type[%2]=0
set interpret.adjective[%$term%].type[%2].state=%$counter%
set console.type[%2].state[%$counter%].adjective[0]=%$term%
call :set $term=%%console.type[%1].state[%$counter%].adjective[1]%%
set interpret.adjective[%$term%].type[%2]=1
set interpret.adjective[%$term%].type[%2].state=%$counter%
set console.type[%2].state[%$counter%].adjective[1]=%$term%
call :set $debug=%%debug.type[%1].state[%$counter%].name%%
set debug.type[%2].state[%$debug%]=%$counter%
set debug.type[%2].state[%$counter%].name=%$debug%
goto :type.expand.state

:type.expand.value
if "%$counter%"=="%$max%" goto :eof
set /a $counter=$counter+1
call :set $debug=%%debug.type[%1].value[%$counter%].name%%
set debug.type[%2].value[%$debug%]=%$counter%
set debug.type[%2].value[%$counter%].name=%$debug%
goto :type.expand.value

:type.expand.pointer
if "%$counter%"=="%$max%" goto :eof
set /a $counter=$counter+1
call :set $debug=%%debug.type[%1].pointer[%$counter%].name%%
set debug.type[%2].pointer[%$debug%]=%$counter%
set debug.type[%2].pointer[%$counter%].name=%$debug%
call :set type[%2].pointer[%$counter%]=%%type[%1].pointer[%$counter%]%%
goto :type.expand.pointer

:dream.testsub
set $test=%2
:dream.testsub.loop
if "%$test%"=="%1" (set error=0
goto :eof)
call :set $test=%%type[%$test%].super%%
if "%$test%"=="0" (set error=1
goto :eof)
goto :dream.testsub.loop

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

:set
set %*
goto :eof

:pexit
if not "%*"=="" (echo %*)
echo Press any key to exit . . .
pause>nul
exit

### File Reader ###

:readline
set steeze=%*
set steeze=%steeze:~1%
title %steeze%
set indent=0
call :readline.indent
if %indent% gtr %layer% goto :eof
if %indent% lss %layer% call :readline.lowerindent
goto :readline.seek[%purpose%]

:readline.indent
set bit=%steeze:~0,1%
if not "%bit%"==" " goto :eof
set /a indent=indent+1
set steeze=%steeze:~1%
goto :readline.indent

:readline.lowerindent
call :set last=%%layer[%layer%]%%
call :readline.close[%purpose%]
set /a layer=layer-1
if %indent% lss %layer% goto :readline.lowerindent
call :set purpose=%%purpose[%layer%]%%
goto :eof

:readline.seek[root]
for /f "tokens=1*" %%f in ("%steeze%") do (set name=%%f
set steeze=%%g)
set purpose[0]=root
if "%name%"=="type" (goto :readline.open[typedata])
if "%name%"=="event" (goto :readline.open[eventdata])
if "%name%"=="reality" (set place=%steeze%
set purpose=reality
set purpose[0]=reality
goto :eof)
call :pexit How does do %steeze%?

:readline.open[typedata]
set /a layer=layer+1
set layer[%layer%]=%steeze%
set super=%this%
set this=%steeze%
if "%super%"=="" (set super=nul)
call :set superid=%%interpret.type[%super%]%%
set /a dream.environment.types=dream.environment.types+1
set thisid=%dream.environment.types%
set interpret.type[%this%]=%thisid%
set console.type[%thisid%]=%this%
call :type.expand %superid% %thisid%
set safe=true
set purpose=typedata
set purpose[%layer%]=typedata
goto :eof

:readline.seek[typedata]
for /f "tokens=1*" %%f in ("%steeze%") do (set token=%%f
set steeze=%%g)
if "%token%"=="property" (call :type.giveproperty %this% %steeze%
goto :eof)
if "%token%"=="state" (call :type.givestate %this% %steeze%
goto :eof)
if "%token%"=="value" (call :type.givevalue %this% %steeze%
goto :eof)
if "%token%"=="pointer" (call :type.givepointer %this% %steeze%
goto :eof)
if "%token%"=="type" (goto :readline.open[typedata])
call :pexit What's a %token%?

:readline.close[typedata]
set safe=
set this=%super%
set thisid=%superid%
call :set superid=%%type[%thisid%].super%%
call :set super=%%console.type[%superid%]%%
goto :eof

:readline.open[eventdata]
for /f "tokens=1,2,3,4" %%a in ("%steeze%") do (
set name=%%a
set subject=%%b
set object=%%c
set instrument=%%d)
set layer=1
set layer[1]=
set /a dream.environment.events=dream.environment.events+1
set name[0]=%name%
set this=%steeze%
set purpose=eventdata
set purpose[1]=eventdata
set parts=-1
call :readline.event.definepart subject %subject%
call :readline.event.definepart object %object%
set event[%dream.environment.events%].subject=%type[0]%
set event[%dream.environment.events%].object=%type[1]%
if not "%instrument%"=="" (
call :readline.event.definepart instrument %instrument%
set event[%dream.environment.events%].instrument=%type[2]%
)
set debug.event[%name%]=%dream.environment.events%
goto :eof

:readline.seek[eventdata]
for /f "tokens=1*" %%f in ("%steeze%") do (set token=%%f
set steeze=%%g)
if "%token%"=="if" (goto :readline.event.if)
if "%token%"=="loop" (goto :readline.event.for)
if "%token%"=="destroy" (goto :readline.event.destroy)
if "%token%"=="create" (goto :readline.event.instantiate)
if "%token%"=="print" (goto :readline.event.print)
if "%token%"=="define" (goto :readline.event.set.basic)
if "%token%"=="align" (goto :readline.event.set.dynamic)
if "%token%"=="set" (set op==
goto :readline.event.set.value)
if "%token%"=="increase" (set op=+
goto :readline.event.set.value)
if "%token%"=="decrease" (set op=-
goto :readline.event.set.value)
if "%token%"=="else" (if "%else%"=="true" (
set code=%code%{
set /a layer=layer+1
call :set layer[%%layer%%]=else
call :set purpose[%%layer%%]=eventdata
goto :eof
))
call :pexit How does expect %token%?

:readline.event.definepart
set /a parts=parts+1
set part[%1]=%parts%
set part~[%parts%]=%1
call :set parttype=%%interpret.type[%2]%%
set type[%parts%]=%parttype%
call :set tokill[%layer%]=%%tokill[%layer%]%%%parts%;
goto :eof

:readline.close[eventdata]
call :readline.event.close.killparts
if "%last%"=="" (goto :readline.event.close.final)
set code=%code%}
if "%last%"=="if" (set else=true) else (set else=)
goto :eof

:readline.event.close.killparts
call :set kills=%%tokill[%layer%]%%
set tokill[%layer%]=
:readline.event.close.killloop
if "%kills%"=="" goto :eof
for /f "tokens=1* delims=;" %%f in ("%kills%") do (
set kill=%%f
set kills=%%g
)
call :set part=%%part~[%kill%]%%
set part~[%kill%]=
set part[%part%]=
set type[%kill%]=
set kill=
goto :readline.event.close.killloop

:readline.event.close.final
set event[%dream.environment.events%]=%code%
set code=
set event.outputcounter=
set parts=
goto :eof

:readline.event.if
set code=%code%?
for /f "tokens=1-2,3*" %%a in ("%steeze%") do (
 if "%%b"=="not" (
  set useop=~
  set steeze=%%a %%c
 ) else (
  set useop==
 )
)
for /f "tokens=1,2,3*" %%h in ("%steeze%") do (
set lhs=%%h
set compareop=%%i
set rhs=%%j
set junk=%%k
)
set /a layer=layer+1
set layer[%layer%]=if
set purpose[%layer%]=eventdata
if "%compareop%"=="mirrors" goto :readline.event.if.dynamic
if "%compareop%"=="equals" goto :readline.event.if.direct
call :readline.event.giveterm %lhs% %rhs%
if "%compareop%"=="is" (set code=%code%=) else (
  call :pexit Which way is %compareop%?
)
call :readline.event.closeterm
set code=%code%{
goto :eof

:readline.event.if.dynamic
call :readline.event.giveterm %lhs%
set code=%code%%useop%
call :readline.event.giveterm %rhs%
set code=%code%{
goto :eof

:readline.event.if.direct
call :readline.event.giveterm %lhs%
set code=%code%%useop%#%rhs%{
goto :eof

:readline.event.for
for /f "tokens=1,2*" %%f in ("%steeze%") do (
set partname=%%f
if "%%g"=="using" (set steeze=%%h) else (set steeze=%%g%%h)
)
for /f "tokens=1,2*" %%h in ("%steeze%") do (
set parttypen=%%h
if "%%i"=="with" (set steeze=%%j) else (set steeze=%%i%%j)
)
for /f "tokens=1,2,3" %%h in ("%steeze%") do (
set pointer=%%h
if "%%i"=="as" (set target=%%j) else (set target=%%i)
)
set /a layer=layer+1
set layer[%layer%]=for
set purpose[%layer%]=eventdata

call :readline.event.definepart %partname% %parttypen%
if "%parttype%"=="" call :pexit How does loop using %parttypen%?
call :set slotid=%%debug.type[%parttype%].pointer[%pointer%]%%
if "%slotid%"=="" call :pexit Which way does %pointer% point?
set code=%code%f%parts%:%parttype%:%slotid%:
call :readline.event.giveterm %target%
if not "%value%"=="" call :pexit How does pointer compatible?
set code=%code%{
goto :eof

:readline.event.destroy
set code=%code%-
for /f "tokens=1,2" %%f in ("%steeze%") do (
 set part=%%f
 set discard=%%g
)
if not "%discard%"=="" (
call :pexit Kill a %part% what?
)
call :set partid=%%part[%part%]%%
if "%partid%"=="" call :pexit Which one is the %part%?
set code=%code%%partid%;
goto :eof

:readline.event.instantiate
for /f "tokens=1*" %%a in ("%steeze%") do (if "%%a"=="a" (set steeze=%%b))
for /f "tokens=1,2,3" %%a in ("%steeze%") do (
set typen=%%a
if "%%b"=="called" (set name=%%c) else (set name=%%b)
)
call :readline.event.definepart %name% %typen%
if "%parttype%"=="" call :pexit How make %typen%?
set code=%code%+%parts%:%parttype%;
goto :eof

:readline.event.print
set /a event.outputcounter=event.outputcounter+1
set event[%dream.environment.events%].output[%event.outputcounter%]=%steeze%
set code=%code%:%event.outputcounter%;
goto :eof

:readline.event.set.basic
set code=%code%!
for /f "tokens=1,2,3*" %%a in ("%steeze%") do (
set left=%%a
if "%%b"=="as" (set right=%%c) else (set right=%%b)
)
call :readline.event.giveterm %left% %right%
set code=%code%=
call :readline.event.closeterm
set code=%code%;
goto :eof

:readline.event.set.dynamic
set code=%code%!

for /f "tokens=1,2,3*" %%a in ("%steeze%") do (
set left=%%a
if "%%b"=="with" (set right=%%c) else (set right=%%b)
)
call :readline.event.giveterm %left%
set code=%code%=
call :readline.event.giveterm %right%
set code=%code%;
goto :eof

:readline.event.set.value
set code=%code%!
if "%op%"=="=" (set read=to) else (set read=by)
for /f "tokens=1,2,3*" %%a in ("%steeze%") do (
set left=%%a
if "%%b"=="%read%" (set right=%%c) else (set right=%%b)
)
call :readline.event.giveterm %left%
set code=%code%%op%#%right%
set code=%code%;
goto :eof



:readline.event.giveterm
for /f "tokens=1* delims=." %%f in ("%1") do (
set partname=%%f
set array=%%g
)
set code=%code%@
call :readline.event.givepart %partname%
call :set cid=%%type[%part%]%%
if "%2"=="" (if "%array%"=="" (set code=%code%.@))
call :readline.event.giveterm.pointloop %2
if "%2"=="" (goto :eof)
call :set property=%%interpret.type[%2]%%
if not "%property%"=="" (
 set code=%code%.*
 goto :eof
)
call :set property=%%interpret.adjective[%2].type[%cid%].property%%
if not "%property%"=="" (
 set code=%code%.$%property%
 call :set property=%%interpret.adjective[%2].type[%cid%]%%
 goto :eof
)
call :set property=%%interpret.adjective[%2].type[%cid%].state%%
if not "%property%"=="" (
 set code=%code%.$%property%
 call :set property=%%interpret.adjective[%2].type[%cid%]%%
 goto :eof
)
call :pexit What's a %2?


:readline.event.giveterm.pointloop
if "%array%"=="" goto :eof
for /f "tokens=1* delims=." %%f in ("%array%") do (
set pointname=%%f
set array=%%g
)
if "%array%"=="" if "%1"=="" (goto :readline.event.giveterm.pointloop.test)
call :set pointid=%%debug.type[%cid%].pointer[%pointname%]%%
call :set cid=%%type[%cid%].pointer[%pointid%]%%
set code=%code%.%pointid%
goto :readline.event.giveterm.pointloop

:readline.event.giveterm.pointloop.test
if "%pointname%"=="type" (set value=%cid%
set code=%code%.*
)
call :readline.event.giveterm.pointloop.testvalue $ property
if not "%value%"=="" goto :eof
call :readline.event.giveterm.pointloop.testvalue ! state
if not "%value%"=="" goto :eof
call :readline.event.giveterm.pointloop.testvalue # value
if not "%value%"=="" goto :eof
call :set code=%code%.%%debug.type[%cid%].pointer[%pointname%]%%.@
goto :eof

:readline.event.giveterm.pointloop.testvalue
call :set value=%%debug.type[%cid%].%2[%pointname%]%%
if "%value%"=="" (goto :eof)
set code=%code%.%1%value%
goto :eof


:readline.event.closeterm
set code=%code%#%property%
goto :eof

:readline.event.givepart
call :set part=%%part[%*]%%
if "%part%"=="" (call :pexit Which one is a %*?)
set code=%code%%part%
goto :eof

:readline.seek[reality]
for /f "tokens=1*" %%f in ("%steeze%") do (set type=%%f
set debug=%%g
)
if "%type%"=="controlhook" (
call :set hook.controlgroup=%%debug.object[%debug%]%%
set purpose=hook
goto :eof)
call :set id=%%interpret.type[%type%]%%
if "%id%"=="" (call :pexit what's a %type%?)
set purpose=defineobject
set /a dream.environment.objects=dream.environment.objects+1
set object[%dream.environment.objects%]=%id%
set debug.object[%debug%]=%dream.environment.objects%
set /a layer=layer+1
set purpose[%layer%]=defineobject
goto :eof

:readline.close[defineobject]
goto :eof

:readline.seek[defineobject]
for /f "tokens=1*" %%f in ("%steeze%") do (set head=%%f
set foot=%%g)

set dtype=value
call :set slot=%%debug.type[%id%].value[%head%]%%
set data=%foot%
if not "%slot%"=="" goto :readline.defineobject

set dtype=pointer
call :set slot=%%debug.type[%id%].pointer[%head%]%%
call :set data=%%debug.object[%foot%]%%
if not "%slot%"=="" (if "%data%"=="" (call :pexit What %foot%?) else (goto :readline.defineobject))
call :set data=%%interpret.adjective[%head%].type[%id%]%%

set dtype=state
call :set slot=%%interpret.adjective[%head%].type[%id%].state%%
if not "%slot%"=="" goto :readline.defineobject

set dtype=property
call :set slot=%%interpret.adjective[%head%].type[%id%].property%%
if not "%slot%"=="" goto :readline.defineobject

call :pexit What kind of thing is %head%?
:readline.defineobject
if "%dtype%"=="pointer" call :readline.defineobject.test
set object[%dream.environment.objects%].%dtype%[%slot%]=%data%
goto :eof

:readline.defineobject.test
call :set test=%%object[%data%]%%
call :set right=%%type[%id%].pointer[%slot%]%%
:readline.defineobject.test.loop
if "%test%"=="%right%" goto :eof
call :set test=%%type[%test%].super%%
if "%test%"=="0" (call :pexit What kind of %right% is a %%object[%data%]%%?
goto :readline.defineobject.test.loop

:readline.close[hook]
goto :eof

:readline.seek[hook]
for /f "tokens=1*" %%f in ("%steeze%") do (
set verb=%%f
set eventname=%%g
)
call :set event=%%debug.event[%eventname%]%%
if "%event%"=="" (call :pexit How do I %eventname%?)
call :set action=%%interpret.hook.action[%verb%]%%
if "%action%"=="" (set /a hook.actions=hook.actions+1
call :set action=%%hook.actions%%)
set interpret.hook.action[%verb%]=%action%
call :set ob=%%event[%event%].object%%
call :set in=%%event[%event%].instrument%%
if "%in%"=="" (call :readline.seek.hook.ob
goto :eof)
call :readline.seek.hook.in
call :readline.seek.hook.ob
set in.touse=
goto :eof


:readline.seek.hook.ob.mark
if "%ob.tosub%"=="" goto :eof
for /f "tokens=1* delims=;" %%f in ("%ob.tosub%") do (set ob=%%f
set ob.tosub=%%g
)

:readline.seek.hook.ob
call :readline.seek.hook.roll
call :set ob.sub=%%type[%ob%].sub%%
set ob.tosub=%ob.tosub%%ob.sub%
goto :readline.seek.hook.ob.mark



:readline.seek.hook.in.mark
if "%in.tosub%"=="" goto :eof
for /f "tokens=1* delims=;" %%f in ("%in.tosub%") do (set in=%%f
set in.tosub=%%g
)

:readline.seek.hook.in
call :set in.sub=%%type[%in%].sub%%
set in.tosub=%in.tosub%%in.sub%
set in.touse=%in.touse%%in.sub%
goto :readline.seek.hook.in.mark

:readline.seek.hook.roll
if "%in.touse%"=="" (set hook.action[%action%].using[%ob%.]=%event%
goto :eof)
set touse=%in.touse%
:readline.seek.hook.rolling
for /f "tokens=1* delims=;" %%f in ("%touse%") do (set in=%%f
set touse=%%g
)
set hook.action[%action%].using[%ob%,%in%]=%event%
if "%touse%"=="" goto :eof
goto :readline.seek.hook.rolling