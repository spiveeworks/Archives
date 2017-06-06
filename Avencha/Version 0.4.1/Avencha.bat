@echo off

rem for /f "delims==" %%f in ('set') do (
rem set %%f=
rem )

call language.bat

title The Dream Engine
echo What file do you want to use?
set /p name=^
>

set interpret.type[nul]=0

for /f "tokens=1* delims=." %%f in ("%name%") do (set test=%%g)
if "%test%"=="" (if not exist "%name%" (set name=%name%.txt))
set purpose=root
set layer=0
for /f "tokens=* usebackq delims=~" %%f in ("%name%") do (call :readline .%%f)
set indent=0
call :readline.lowerindent

title The %place%.
echo You are in a %place%.


rem ###Hook###

:Inputloop
set input=
set /p input=^
>
if "%input%"=="" goto :inputloop
call :interpret %input%
goto :Inputloop

:debug
set debug
set interpret
set console
set hook
set type
set object
set event
goto :eof

:look
set look.counter=
set look.seen=
call :look.loop
goto :eof

:look.loop
set /a look.counter=look.counter+1
set list=
call set id=%%object[%look.counter%]%%
call set name=%%console.type[%id%]%%
call set location=%%object.location[%look.counter%]%%
if "%name%"=="" (if "%look.test%"=="%objectcounter%" (goto :eof) else (goto :look.loop) )
rem set perspective[%look.seen%]=%look.counter%
rem set /a look.seen=look.seen+1
call set mprop=%%type[%id%].properties%%
set prop=0
call :look.adj.loop
echo There is a %list%%name% %location%.
set look.test=%look.counter%
goto :look.loop

:look.adj.loop
if "%prop%"=="%mprop%" (goto :eof)
set /a prop=prop+1
call set adj=%%object[%look.counter%].property[%prop%]%%
call set adj=%%console.type[%id%].property[%prop%].adjective[%adj%]%%
if not "%adj%"=="" (set list=%list%%adj% )
goto :look.adj.loop

:hook.handle
for /f "tokens=1,2,3" %%f in ("%*") do (
set verb=%%f
set direct=%%g
set indirect=%%h
)
call set directis=%%object[%direct%]%%
if "%indirect%"=="" (
set punc=.
set indirectis=
) else (
set punc=.
call set indirectis=%%object[%indirect%]%%
)
call set event=%%hook.action[%verb%].using[%directis%%punc%%indirectis%]%%
call :event %event% %hook.controlgroup% %direct% %indirect%
goto :eof

:interpret
set $string=%*
call :token 1 $verb=%$string%
call set $command=%%interpret.hook.command[%$verb%]%%
if "%$command%"=="1" (goto :look)
if "%$command%"=="2" (goto :debug)
call set $verb=%%interpret.hook.action[%$verb%]%%
set $parse=2
call :interpret.getobject
if "%$error%"=="1" (echo There doesn't seem to be any of those
goto :eof)
if "%$error%"=="2" (echo There is more than one of those
goto :eof)
set $direct=%$return%

call :token %$parse% $trans=%$string%
if "%$trans%"=="" (set $indirect=
call :hook.handle %$verb% %$direct%
goto :eof)
call set $trans=%%interpret.lang.transterm[%$trans%]%%
set /a $parse=$parse+1
call :interpret.getobject
if "%$error%"=="1" (echo There doesn't seem to be any of those
goto :eof)
if "%$error%"=="2" (echo There is more than one of those
goto :eof)
set $indirect=%$return%
call :hook.handle %$verb% %$direct% %$indirect%
goto :eof

:interpret.getobject
set $error=0
set $isexp=true
call :token %$parse% $choicetype=%$string%
call set $choicetype=%%interpret.lang.choicetype[%$choicetype%]%%
if "%$choicetype%"=="" (set $choicetype=1) else (set /a $parse=$parse+1)
set $transcheck=%$parse%
call :interpret.getobject.transloop
set /a $transcheck=$transcheck-1
call :token %$transcheck% $noun=%$string%
call set $type=%%interpret.type[%$noun%]%%
if "%$transcheck%"=="%$parse%" (set $isexp=) else (call :interpret.getobject.adjloop)
set /a $parse=$parse+1
set $success=0
for /f "tokens=1* delims==" %%f in ('set object[') do (
for /f "tokens=2,3 delims=[]" %%h in ("%%f") do (set $test=%%h
set $junk=%%i)
set $testtype=%%g
call :interpret.getobject.compare)
if "%$success%"=="0" (set $error=1
goto :eof)
call :interpret.getobject.type[%$choicetype%]
for /f "tokens=1 delims==" %%f in ('set $success') do (
set %%f=
)
goto :eof

:interpret.getobject.type[1]
if not "%$success%"=="1" (set $error=2
goto :eof)
:interpret.getobject.type[2]
call set $return=%%$success[1]%%
goto :eof

:interpret.getobject.type[3]
call :random $success=1 %$success%
call set $return=%%$success[%$success%]%%
goto :eof

:interpret.getobject.compare
if not "%$junk%"=="" (goto :eof)
if not "%$testtype%"=="%$type%" goto :eof
set $failed=0
if "%$isexp%"=="true" (
 for /f "tokens=1* delims==" %%f in ('set $describe[') do (set $lhs=%%f
 set $rhs=%%g
 call :interpret.getobject.compare.test)
)
if "%$failed%"=="0" (set /a $success=$success+1
call set $success[%%$success%%]=%$test%)
goto :eof

:interpret.getobject.compare.test
for /f "tokens=2 delims=[]" %%f in ("%$lhs%") do (set $lhs=%%f)
call set $lhs=%%object[%$test%].property[%$lhs%]%%
if not "%$lhs%"=="%$rhs%" set $failed=1
goto :eof


:interpret.getobject.adjloop
if "%$parse%"=="%$transcheck%" goto :eof
call :token %$parse% $adjective=%$string%
call set $property=%%interpret.adjective[%$adjective%].type[%$type%].property%%
call set $adjective=%%interpret.adjective[%$adjective%].type[%$type%]%%
set $describe[%$property%]=%$adjective%
set /a $parse=$parse+1
goto :interpret.getobject.adjloop


:interpret.getobject.transloop
set /a $transcheck=$transcheck+1
set $attempt=
call :token %$transcheck% $attempt=%$string%
if "%$attempt%"=="" goto :eof
call set $attempt=%%interpret.lang.transterm[%$attempt%]%%
if not "%$attempt%"=="" goto :eof
goto :interpret.getobject.transloop

:dream.testsub
set $test=%2
:dream.testsub.loop
if "%$test%"=="%1" (set error=0
goto :eof)
call set $test=%%type[%$test%].super%%
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

:pexit
if not "%*"=="" (echo %*)
echo Press any key to exit . . .
pause>nul
exit


rem ###engine###

:event
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
set $task=action
:event.scriptloop
set $char=%$script:~0,1%
set $script=%$script:~1%
call :event.script.track[%$task%]
if not "%$script%"=="" goto :event.scriptloop
goto :eof

:event.script.track[action]
if "%$char%"=="?" (set $task=getterm
set $purpose=lhs)
if "%$char%"=="f" (set $task=number
set $purpose=for
set $phase=1)
if "%$char%"=="!" (set $task=getterm
set $purpose=dataleft)
if "%$char%"=="-" (set $task=number
set $purpose=delete)
if "%$char%"=="+" (set $task=number
set $purpose=create)
if "%$char%"==":" (set $task=number
set $purpose=speak)
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
set $num=%$num%%$char%
goto :eof

:event.script.track[closeterm]
if "%$purpose%"=="four" (call :pexit unexpected corruption met in core. terminating)
call set $num=%%object[%$rid%].%$dtype%[%$slotid%]%%
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

:event.script.track[close[speak]]
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

:instantiate
set /a dream.environment.objects=dream.environment.objects+1
set object[%dream.environment.objects%]=%*
goto :eof

:destroy
for /f "tokens=1 delims==" %%f in ('set object[%*]') do (
set %%f=)
goto :eof

rem ###functions###



:type.giveproperty
for /f "tokens=1,2*" %%f in ("%*") do (set $type=%%f
set $property=%%g
set $list=%%h
)
call set $type=%%interpret.type[%$type%]%%
call set $props=%%type[%$type%].properties%%
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
call set $type=%%interpret.type[%$type%]%%
call set $states=%%type[%$type%].states%%
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
call set $type=%%interpret.type[%$type%]%%
call set $values=%%type[%$type%].values%%
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
call set $type=%%interpret.type[%$type%]%%
call set $pointid=%%interpret.type[%$pointtype%]%%
call set $points=%%type[%$type%].pointers%%
set /a $points=$points+1
set type[%$type%].pointers=%$points%
set debug.type[%$type%].pointer[%$pointer%]=%$points%
set debug.type[%$type%].pointer[%$points%].name=%$pointer%
set type[%$type%].pointer[%$points%]=%$pointid%
goto :eof

:type.expand
set type[%2].super=%1
call set type[%1].sub=%%type[%1].sub%%%2;
set $counter=
call set $max=%%type[%1].properties%%
call :type.expand.property %*
set type[%2].properties=%$max%

set $counter=
call set $max=%%type[%1].states%%
call :type.expand.state %*
set type[%2].states=%$max%

set $counter=
call set $max=%%type[%1].values%%
call :type.expand.value %*
set type[%2].values=%$max%

set $counter=
call set $max=%%type[%1].pointers%%
call :type.expand.pointer %*
set type[%2].pointers=%$max%

goto :eof

:type.expand.property
if "%$counter%"=="%$max%" goto :eof
set /a $counter=$counter+1
set $adjcounter=
call set $adjmax=%%type[%1].property[%$counter%].highest%%
:type.expand.property.value
set /a $adjcounter=$adjcounter+1
call set $term=%%console.type[%1].property[%$counter%].adjective[%$adjcounter%]%%
set interpret.adjective[%$term%].type[%2]=%$adjcounter%
set interpret.adjective[%$term%].type[%2].property=%$counter%
set console.type[%2].property[%$counter%].adjective[%$adjcounter%]=%$term%
if not "%$adjcounter%"=="%$adjmax%" goto :type.expand.property.value
set type[%2].property[%$counter%].highest=%$adjmax%
call set $debug=%%debug.type[%1].property[%$counter%].name%%
set debug.type[%2].property[%$debug%]=%$counter%
set debug.type[%2].property[%$counter%].name=%$debug%
goto :type.expand.property

:type.expand.state
if "%$counter%"=="%$max%" goto :eof
set /a $counter=$counter+1
call set $term=%%console.type[%1].state[%$counter%].adjective[0]%%
set interpret.adjective[%$term%].type[%2]=0
set interpret.adjective[%$term%].type[%2].state=%$counter%
set console.type[%2].state[%$counter%].adjective[0]=%$term%
call set $term=%%console.type[%1].state[%$counter%].adjective[1]%%
set interpret.adjective[%$term%].type[%2]=1
set interpret.adjective[%$term%].type[%2].state=%$counter%
set console.type[%2].state[%$counter%].adjective[1]=%$term%
call set $debug=%%debug.type[%1].state[%$counter%].name%%
set debug.type[%2].state[%$debug%]=%$counter%
set debug.type[%2].state[%$counter%].name=%$debug%
goto :type.expand.state

:type.expand.value
if "%$counter%"=="%$max%" goto :eof
set /a $counter=$counter+1
call set $debug=%%debug.type[%1].value[%$counter%].name%%
set debug.type[%2].value[%$debug%]=%$counter%
set debug.type[%2].value[%$counter%].name=%$debug%
goto :type.expand.value

:type.expand.pointer
if "%$counter%"=="%$max%" goto :eof
set /a $counter=$counter+1
call set $debug=%%debug.type[%1].pointer[%$counter%].name%%
set debug.type[%2].pointer[%$debug%]=%$counter%
set debug.type[%2].pointer[%$counter%].name=%$debug%
call set type[%2].pointer[%$counter%]=%%type[%1].pointer[%$counter%]%%
goto :type.expand.pointer

:dream.testsub
set $test=%2
:dream.testsub.loop
if "%$test%"=="%1" (set error=0
goto :eof)
call set $test=%%type[%$test%].super%%
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
if "%steeze%"=="" goto :eof
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
call set last=%%layer[%layer%]%%
call :readline.close[%purpose%]
set /a layer=layer-1
if %indent% lss %layer% goto :readline.lowerindent
call set purpose=%%purpose[%layer%]%%
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
call set superid=%%interpret.type[%super%]%%
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
call set superid=%%type[%thisid%].super%%
call set super=%%console.type[%superid%]%%
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
call set layer[%%layer%%]=else
call set purpose[%%layer%%]=eventdata
goto :eof
))
call :pexit How does expect %token%?


:readline.event.definepart
set /a parts=parts+1
set part[%1]=%parts%
set part~[%parts%]=%1
call set parttype=%%interpret.type[%2]%%
set type[%parts%]=%parttype%
call set tokill[%layer%]=%%tokill[%layer%]%%%parts%;
goto :eof

:readline.close[eventdata]
call :readline.event.close.killparts
if "%last%"=="" (goto :readline.event.close.final)
set code=%code%}
if "%last%"=="if" (set else=true) else (set else=)
goto :eof

:readline.event.close.killparts
call set kills=%%tokill[%layer%]%%
set tokill[%layer%]=
:readline.event.close.killloop
if "%kills%"=="" goto :eof
for /f "tokens=1* delims=;" %%f in ("%kills%") do (
set kill=%%f
set kills=%%g
)
call set part=%%part~[%kill%]%%
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
call set slotid=%%debug.type[%parttype%].pointer[%pointer%]%%
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
call set partid=%%part[%part%]%%
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
call set cid=%%type[%part%]%%
if "%2"=="" if "%array%"=="" (set code=%code%.@)
call :readline.event.giveterm.pointloop %2
if "%2"=="" (goto :eof)
call set property=%%interpret.type[%2]%%
if not "%property%"=="" (
 set code=%code%.*
 goto :eof
)
call set property=%%interpret.adjective[%2].type[%cid%].property%%
if not "%property%"=="" (
 set code=%code%.$%property%
 call set property=%%interpret.adjective[%2].type[%cid%]%%
 goto :eof
)
call set property=%%interpret.adjective[%2].type[%cid%].state%%
if not "%property%"=="" (
 set code=%code%.$%property%
 call set property=%%interpret.adjective[%2].type[%cid%]%%
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
call set pointid=%%debug.type[%cid%].pointer[%pointname%]%%
call set cid=%%type[%cid%].pointer[%pointid%]%%
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
call set code=%code%.%%debug.type[%cid%].pointer[%pointname%]%%.@
goto :eof

:readline.event.giveterm.pointloop.testvalue
call set value=%%debug.type[%cid%].%2[%pointname%]%%
if "%value%"=="" (goto :eof)
set code=%code%.%1%value%
goto :eof


:readline.event.closeterm
set code=%code%#%property%
goto :eof

:readline.event.givepart
call set part=%%part[%*]%%
if "%part%"=="" (call :pexit Which one is a %*?)
set code=%code%%part%
goto :eof

:readline.seek[reality]
for /f "tokens=1*" %%f in ("%steeze%") do (set type=%%f
set debug=%%g
)
if "%type%"=="controlhook" (
call set hook.controlgroup=%%debug.object[%debug%]%%
set purpose=hook
goto :eof)
call set id=%%interpret.type[%type%]%%
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
call set slot=%%debug.type[%id%].value[%head%]%%
set data=%foot%
if not "%slot%"=="" goto :readline.defineobject

set dtype=pointer
call set slot=%%debug.type[%id%].pointer[%head%]%%
call set data=%%debug.object[%foot%]%%
if not "%slot%"=="" (if "%data%"=="" (call :pexit What %foot%?) else (goto :readline.defineobject))
call set data=%%interpret.adjective[%head%].type[%id%]%%

set dtype=state
call set slot=%%interpret.adjective[%head%].type[%id%].state%%
if not "%slot%"=="" goto :readline.defineobject

set dtype=property
call set slot=%%interpret.adjective[%head%].type[%id%].property%%
if not "%slot%"=="" goto :readline.defineobject

call :pexit What kind of thing is %head%?
:readline.defineobject
if "%dtype%"=="pointer" call :readline.defineobject.test
set object[%dream.environment.objects%].%dtype%[%slot%]=%data%
goto :eof

:readline.defineobject.test
call set test=%%object[%data%]%%
call set right=%%type[%id%].pointer[%slot%]%%
:readline.defineobject.test.loop
if "%test%"=="%right%" goto :eof
call set test=%%type[%test%].super%%
if "%test%"=="0" (call :pexit What kind of %right% is a %%object[%data%]%%?
goto :readline.defineobject.test.loop

:readline.close[hook]
goto :eof

:readline.seek[hook]
for /f "tokens=1*" %%f in ("%steeze%") do (
set verb=%%f
set eventname=%%g
)
call set event=%%debug.event[%eventname%]%%
if "%event%"=="" (call :pexit How do I %eventname%?)
call set action=%%interpret.hook.action[%verb%]%%
if "%action%"=="" (set /a hook.actions=hook.actions+1
call set action=%%hook.actions%%)
set interpret.hook.action[%verb%]=%action%
call set ob=%%event[%event%].object%%
call set in=%%event[%event%].instrument%%
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
call set ob.sub=%%type[%ob%].sub%%
set ob.tosub=%ob.tosub%%ob.sub%
goto :readline.seek.hook.ob.mark



:readline.seek.hook.in.mark
if "%in.tosub%"=="" goto :eof
for /f "tokens=1* delims=;" %%f in ("%in.tosub%") do (set in=%%f
set in.tosub=%%g
)

:readline.seek.hook.in
call set in.sub=%%type[%in%].sub%%
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