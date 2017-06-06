@echo off
call language.bat
title The %place%.
echo You are in a %place%.
call :look

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
set stencil
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
call :set id=%%object[%look.counter%]%%
call :set name=%%console.stencil[%id%]%%
call :set location=%%object.location[%look.counter%]%%
if "%name%"=="" (if "%look.test%"=="%objectcounter%" (goto :eof) else (goto :look.loop) )
rem set perspective[%look.seen%]=%look.counter%
rem set /a look.seen=look.seen+1
call :set mprop=%%stencil[%id%].properties%%
set prop=0
call :look.adj.loop
echo There is a %list%%name% %location%.
set look.test=%look.counter%
goto :look.loop

:look.adj.loop
if "%prop%"=="%mprop%" (goto :eof)
set /a prop=prop+1
call :set adj=%%object[%look.counter%].property[%prop%]%%
call :set adj=%%console.stencil[%id%].property[%prop%].adjective[%adj%]%%
if not "%adj%"=="" (set list=%list%%adj% )
goto :look.adj.loop

:hook.handle
for /f "tokens=1,2,3" %%f in ("%*") do (
set verb=%%f
set direct=%%g
set indirect=%%h
)
call :set directis=%%object[%direct%]%%
call :set indirectis=%%object[%indirect%]%%
call :set event=%%hook.action[%verb%].using[%directis%,%indirectis%]%%
call :event %event% 0 %direct% %indirect%
goto :eof

:event
for /f "tokens=1,2,3,4" %%a in ("%*") do (
set $id=%%a
set $part[0]=%%b
set $part[1]=%%c
set $part[2]=%%d
)
call :set $script=%%event[%$id%]%%
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
if "%$char%"=="!" (set $task=getterm
set $purpose=dataleft)
if "%$char%"=="~" (set $task=number
set $purpose=delete)
if "%$char%"==":" (set $task=number
set $purpose=speak)
if "%$char%"=="{" (
if "%$purpose%"=="testelse" (set /a $nest=$nest+1
call :set $layer[%%$nest%%]=else)
if "%$purpose%"=="skipelse" (set $task=skipbrace
set $purpose=else)
)
set $num=
if "%$char%"=="}" (call :event.script.track[action].handlenest)
goto :eof

:event.script.track[action].handlenest
call :set $layer=%%$layer[%$nest%]%%
if "%$layer%"=="if" (set $purpose=skipelse) else (set $purpose=)
goto :eof

:event.script.track[getterm]
if "%$char%"=="@" (set $task=partnum)
if "%$char%"=="#" (if not "%$purpose%"=="dataleft" (
set $task=number))
goto :eof

:event.script.track[partnum]
if "%$char%"=="." (set $task=field
goto :eof)
set $part=%$part%%$char%
goto :eof

:event.script.track[field]
if "%$char%"=="$" (set $task=getpropid)
if "%$char%"=="@" (
set $task=closeterm.id)
goto :eof

:event.script.track[getpropid]
if "%$purpose%"=="lhs" (
if "%$char%"=="=" (set $lhs.if=true
goto :event.script.track[closeterm])
if "%$char%"=="~" (set $lhs.if=false
goto :event.script.track[closeterm])
)
if "%$purpose%"=="rhs" (if "%$char%"=="{" (goto :event.script.track[closeterm]))
if "%$purpose%"=="dataright" (if "%$char%"==";" (goto :event.script.track[closeterm]))
if "%$purpose%"=="dataleft" (
if "%$char%"=="=" (goto :event.script.track[close[dataleft]])
if "%$char%"=="+" (goto :event.script.track[close[dataleft]])
if "%$char%"=="-" (goto :event.script.track[close[dataleft]])
)
set $propid=%$propid%%$char%
goto :eof

:event.script.track[number]
if "%$purpose%"=="lhs" (
if "%$char%"=="=" (set $lhs.if=true
goto :event.script.track[close[lhs]])
if "%$char%"=="~" (set $lhs.if=false
goto :event.script.track[close[lhs]])
)
if "%$purpose%"=="rhs" (if "%$char%"=="{" (goto :event.script.track[close[rhs]]))
if "%$purpose%"=="speak" (if "%$char%"==";" (goto :event.script.track[close[speak]]))
if "%$purpose%"=="delete" (if "%$char%"==";" (goto :event.script.track[close[delete]]))
if "%$purpose%"=="dataright" (if "%$char%"==";" (goto :event.script.track[close[dataright]]))
set $num=%$num%%$char%
goto :eof

:event.script.track[closeterm]
call :set $partid=%%$part[%$part%]%%
call :set $num=%%object[%$partid%].property[%$propid%]%%
set $partid=
set $part=
set $propid=
if "%$num%"=="" set $num=0
goto :event.script.track[close[%$purpose%]]

:event.script.track[closeterm.id]
$target.id=%%$part[%$part%]%%
call :set $num=%%object[%$target.id%]%%
set $part=
if "%$purpose%"=="dataleft" (set $propid=@
goto :event.script.track[close[dataleft]]
) else (goto :event.script.track[close[%$purpose%]])

:event.script.track[close[lhs]]
set $lhs=%$num%
set $num=
set $purpose=rhs
set $task=getterm
goto :eof

:event.script.track[close[rhs]]
if "%$num%"=="%$lhs%" (set $num=true) else (set $num=false)
if "%$num%"=="%$lhs.if%" (set /a $nest=$nest+1
set $task=action
call :set $layer[%%$nest%%]=if) else (
set $task=skipbrace
set $brace=1
set $purpose=if)
goto :eof

:event.script.track[skipbrace]
if "%$char%"=="{" (set /a $brace=$brace+1)
if "%$char%"=="}" (set /a $brace=$brace-1)
if "%$brace%"=="0" (set $task=action
if "%$purpose%"=="if" (set $purpose=testelse) else (set $purpose=))
goto :eof

:event.script.track[close[dataleft]]
if "%$propid%"=="@" (set $target.prop=@) else (
call :set $target.id=%%$part[%$part%]%%
set $target.prop=%$propid%
call :set $num=%%object[%$target.id%].property[%$propid%]%%
)
if "%$char%"=="="(set /a $base=) else (
if "%$char%"=="+"(set /a $base=$num) else (
if "%$char%"=="-"(set /a $base=$num*-1)))
set $num=
set $part=
set $propid=
set $purpose=dataright
set $task=getterm
goto :eof

:event.script.track[close[dataright]]
if "%$target.prop%"=="@" (set /a object[%$target.id%]=$base+$num) else (
set /a object[%$target.id%].property[%$target.prop%]=$base+$num
)
set $num=
set $part=
set $propid=
set $task=action
set $purpose=
goto :eof

:event.script.track[close[speak]]
call :set $output=%%event[%$id%].output[%$num%]%%
echo %$output%
set $task=action
set $purpose=
set $num=
goto :eof

:event.script.track[close[delete]]
call :set $num=%%$part[%$num%]%%
call :destroy %$num%
set $task=action
set $purpose=
set $num=
goto :eof

:destroy
for /f "tokens=1 delims==" %%f in ('set object[%*]') do (
set %%f=)
goto :eof

:interpret
set $string=%*
call :token 1 $verb=%$string%
call :set $command=%%interpret.hook.command[%$verb%]%%
if "%$command%"=="1" (goto :look)
if "%$command%"=="2" (goto :debug)
call :set $verb=%%interpret.hook.action[%$verb%]%%
set $parse=2
call :interpret.getobject
if "%$error%"=="1" (echo There doesn't seem to be any of those
goto :eof)
if "%$error%"=="2" (echo There is more than one of those
goto :eof)
set $direct=%$return%

call :token %$parse% $trans=%$string%
if "%$trans%"=="" (set $indirect=
goto :eof)
call :set $trans=%%interpret.lang.transterm[%$trans%]%%
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
call :set $choicetype=%%interpret.lang.choicetype[%$choicetype%]%%
if "%$choicetype%"=="" (set $choicetype=1) else (set /a $parse=$parse+1)
set $transcheck=%$parse%
call :interpret.getobject.transloop
set /a $transcheck=$transcheck-1
call :token %$transcheck% $noun=%$string%
call :set $stencil=%%interpret.stencil[%$noun%]%%
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
call :set $return=%%$success[1]%%
goto :eof

:interpret.getobject.type[3]
call :random $success=1 %$success%
call :set $return=%%$success[%$success%]%%
goto :eof

:interpret.getobject.compare
if not "%$junk%"=="" (goto :eof)
if not "%$testtype%"=="%$stencil%" goto :eof
set $failed=0
if "%$isexp%"=="true" (
 for /f "tokens=1* delims==" %%f in ('set $describe[') do (set $lhs=%%f
 set $rhs=%%g
 call :interpret.getobject.compare.test)
)
if "%$failed%"=="0" (set /a $success=$success+1
call :set $success[%%$success%%]=%$test%)
goto :eof

:interpret.getobject.compare.test
for /f "tokens=2 delims=[]" %%f in ("%$lhs%") do (set $lhs=%%f)
call :set $lhs=%%object[%$test%].property[%$lhs%]%%
if not "%$lhs%"=="%$rhs%" set $failed=1
goto :eof


:interpret.getobject.adjloop
if "%$parse%"=="%$transcheck%" goto :eof
call :token %$parse% $adjective=%$string%
call :set $property=%%interpret.adjective[%$adjective%].stencil[%$stencil%].property%%
call :set $adjective=%%interpret.adjective[%$adjective%].stencil[%$stencil%]%%
set $describe[%$property%]=%$adjective%
set /a $parse=$parse+1
goto :interpret.getobject.adjloop


:interpret.getobject.transloop
set /a $transcheck=$transcheck+1
set $attempt=
call :token %$transcheck% $attempt=%$string%
if "%$attempt%"=="" goto :eof
call :set $attempt=%%interpret.lang.transterm[%$attempt%]%%
if not "%$attempt%"=="" goto :eof
goto :interpret.getobject.transloop

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