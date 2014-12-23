:Inputloop
set input=
set /p input=^
>
if "%input%"=="" goto :inputloop
call :interpret %input%
if "%event%"=="" goto :Inputloop
goto :eof


:hook.handle
for /f "tokens=1,2,3" %%f in ("%*") do (
set verb=%%f
set direct=%%g
set indirect=%%h
)
call :set directis=%%object[%direct%]%%
if "%indirect%"=="" (
set punc=.
set indirectis=
) else (
set punc=.
call :set indirectis=%%object[%indirect%]%%
)
call :set event=%%hook.action[%verb%].using[%directis%%punc%%indirectis%]%%
goto :eof

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
call :set id=%%object[%look.counter%]%%
call :set name=%%console.type[%id%]%%
call :set location=%%object.location[%look.counter%]%%
if "%name%"=="" (if "%look.test%"=="%objectcounter%" (goto :eof) else (goto :look.loop) )
rem set perspective[%look.seen%]=%look.counter%
rem set /a look.seen=look.seen+1
call :set mprop=%%type[%id%].properties%%
set prop=0
call :look.adj.loop
echo There is a %list%%name% %location%.
set look.test=%look.counter%
goto :look.loop

:look.adj.loop
if "%prop%"=="%mprop%" (goto :eof)
set /a prop=prop+1
call :set adj=%%object[%look.counter%].property[%prop%]%%
call :set adj=%%console.type[%id%].property[%prop%].adjective[%adj%]%%
if not "%adj%"=="" (set list=%list%%adj% )
goto :look.adj.loop

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
call :hook.handle %$verb% %$direct%
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
call :set $type=%%interpret.type[%$noun%]%%
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
if not "%$testtype%"=="%$type%" goto :eof
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
call :set $property=%%interpret.adjective[%$adjective%].type[%$type%].property%%
call :set $adjective=%%interpret.adjective[%$adjective%].type[%$type%]%%
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

:pexit
if not "%*"=="" (echo %*)
echo Press any key to exit . . .
pause>nul
exit
