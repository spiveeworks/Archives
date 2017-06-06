::echo off
for /f "delims==" %%f in ('set') do (set %%f=)
set object[1].value[1]=0

call :pexit It's not finished yet!
~








:::::::::::::::
:: TODO LIST ::
:::::::::::::::

::::::::::::::::::::::::::::::::::::
::    DO NOT STRAY KEEP ORDER     ::
:: OF EVENTS DEFINED IN THIS LIST ::
::::::::::::::::::::::::::::::::::::

::Make stimuli record a holistic id

::make object constructors and destructors

::debugging

::make a default hook and update default compiler

::Add new variable names to notes

::::::::::::::::::::::
:::::::: DONE ::::::::
::::::::::::::::::::::

::Insert a thing in :dreaming that makes an unoptimized stimcheck + recheck happen

::Make stimulus affect hooks when available

::make hooks trigger hook actions at some point too

::Make commands for opening and closing stimuli

::make the pass function (<) use an actually existing exception in the enum Fset








::::::::::::::
:: Dreaming ::
::::::::::::::








:dreaming
set cevent=
set bevent=0
call :getnextevent
if "%error%"=="1" call :endmsg Nothing happens.
set dream.ticks=%beventtime%
call :event %bevent%
call :adhocstimcheck
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


::Note: ad-hoc
:adhocstimtest
for /l %%n in (1,1,%dream.objects%) do (
	call :adhocstimtest.doublecheckstims %%n
)
for /f "tokens=1 delims==" %%f in (set adhocstimtest) do (
	set %%f=
)
goto :eof
:adhocstimtest.doublecheckstims
call set type=%%object[%~1]%%
call set stims=%%type[%type%].stimuli%%
for /l %%n in (1,1,%stims%) do (
	call :fullstimcheck %~1 %%n
)
goto :eof
::TRIVIA : The :fullstimcheck function used to be a subpart of this function, the label was just called :adhocstimtest.doublecheckstim
:: but when I realized that I could actually use a full check when the stimulus was starting up for the first time, even when (if) I make things dynamimagical, I just renamed all of the labels as such, and it conveniently made things kind of nicer.

~









::::::::::::::::
:: Stim Stuff ::
::::::::::::::::








::checkreceptor <object to check> <receptor to check with> <object projecting stimulus> <stimulus slot of said object> [any string (nowhitespace) if you wish to treat the stimulus as seen (ie. checking for the end of the stimulus)]
:checkreceptor
call set type=%%object[%~1]%%
call set receptor=%%type[%type%].receptor[%~2].type%%
call set express=%%type[%type%].receptor[%receptor%].exp%%
set $part[0]=%~1
call :unpackstimulus 1 %~3 %~4
call set $script=%%type[%type%].receptor[%receptor%].exp%%
set $task=getvalue
set $purpose=evaluate
set $evaluout=receive
call :event.scriptloop
if not "%~5"=="" (set /a receive=!%receive%)
if "%receive%"=="1" call :queuestimresponse %*
goto :eof


::unpackstimulus <tupleident> <stim_object> <stim_slot>
:::::: copies all relevant data from stim_object.stim_slot to the holographic tuple specified for event scripts to use.
:unpackstimulus
call set otype=%%object[%~2]%%
call set stype=%%type[%otype%].stimulus[%~3]%%

call set num=%%stimulus[%stype%].pointers%%
for /l %%n in (1,1,%num%) do (
call set $tuple[%~1].pointer[%%n]=%%object[%~2].stimulus[%~3].pointer[%%n]%%
)

call set num=%%stimulus[%stype%].values%%
for /l %%n in (1,1,%num%) do (
call set $tuple[%~1].value[%%n]=%%object[%~2].stimulus[%~3].value[%%n]
)
goto :eof



::Takes the same arguments as :checkreceptor for future simplicity.
:queuestimresponse
set string=0
call set rtype=%%object[%~1]%%
call set otype=%%object[%~3]%%
call set stype=%%type[%otype%].stimulus[%~4]%%
set string=%string%;1,%~1;1

if "%~5"=="" (
	call set script=%%type[%rtype%].receptor[%~2].detectevent%%
	call set object[%~3].stimulus[%~4].watchlist=%%object[%~3].stimulus[%~4].watchlist%%%~1,%~2;
) else (
	call set script=%%type[%rtype%].receptor[%~2].undetectevent%%
)

call :queuestring.handlepart %~1 %~2 %~3 %~4 value
call :queuestring.handlepart %~1 %~2 %~3 %~4 pointer

::note that queueevent accepts input as such:
:: <delay (milliseconds)>;[[partident,partvalue][,etc]];[[tupleident,numberofvalues,numberofpointers[,values][,pointers]][,etc]];<full event script>
call :queueevent %string%;%num%

goto :eof
:queuestring.handlepart
call set num=%%stimulus[%stype%].%~5s%%
set string=%string%,%num%

for /l %%n in (1,1,%num%) do (
	call :queuestimresponse.append %%object[%~3].stimulus[%~4].%~5[%%n]%%
)
goto :eof
:queuestimresponse.append
set %string%,%*
goto :eof



:closestimulus
call set list=%%object[%~1].stimulus[%~2].watchlist%%
:closestimulus.loop
for /f "tokens=1,2* delims=;," %%a in ("%list%") do (
call :queuestimresponse %%a %%b %~1 %~2 ending
set list=%%c
)
if not "%list%"=="" goto :closestimulus.loop
goto :eof

:doublecheckstimulus
call set list=%%object[%~1].stimulus[%~2].watchlist%%
:doublecheckstimulus.loop
for /f "tokens=1,2* delims=;," %%a in ("%list%") do (
set object=%%a
set receptor=%%b
set list=%%c
)
call :checkreceptor %object% %receptor% %~1 %~2 checking
if "%return%"=="0" (set list'=%list'%%object%,%receptor%;)
if not "%list%"=="" goto :doublecheckstimulus.loop
set object[%~1].stimulus[%~2].watchlist=%list'%
goto :eof

::Basically calls a doublecheckstimulus, and then checks every object which wasn't doublechecked, to see if they can start being aware of the stimulus.
::This subroutine will abort if the stimulus being used is not 'visible', this is because it is hard to include the if statement inside the for loop I was originally calling this function from. If this is a problem for any modders, the simple solution would be to rework things to use delayed expansion.

:fullstimcheck
call set visible=%%object[%~1].stimulus[%~2].visible%%
if "%visible%"=="false" goto :eof
call set list=%%object[%~1].stimulus[%~2].watchlist%%
call :doublecheckstimulus %~1 %~2
:fullstimcheck.listloop
for /f "tokens=1,2* delims=;," %%a in ("%list%") do (
	set fullstimcheck.ischeck[%%a,%%b]=true
	set list=%%c
)
if not "%list%"=="" goto :fullstimcheck.listloop
for /l %%n in (1,1,%dream.objects%) do (
	if not "%~1"=="%%n" (
		call :fullstimcheck.checkrecepts %~1 %~2 %%n
	)
)
goto :eof
:fullstimcheck.checkrecepts
call set type=%%object[%~3]%%
call set recepts=%%type[%type%].receptors%%
for /l %%n in (1,1,%recepts%) do (
	call :fullstimcheck.checkrecept %~3 %%n %~1 %~2
)
goto :eof
:fullstimcheck.checkrecept
call set test=%%adhocstimtest.ischeck[%~1,%~2,%~3,%~4]%%
if "%test%"=="true" goto :eof
call :checkreceptor %~1 %~2 %~3 %~4
set fullstimcheck.ischeck[%~1,%~2,%~3,%~4]=true
goto :eof


:openstimulus
for /f "tokens=1,2,3,4 delims=;" %%a in ("%*") do (
	set object=%%a
	set stimulus=%%b
	set values=%%c
	set pointers=%%d
)
set object[%object%].stimulus[%stimulus%].visible=true
set object[%object%].stimulus[%stimulus%].watchlist=
call :openstimulus.placedata value "%values%"
call :openstimulus.placedata pointer "%pointers%"
call :fullstimcheck %object% %stimulus%
goto :eof

:openstimulus.placedata
if "%~2"=="~" goto :eof
set list=%~2
set npart=
:openstimulus.placedata.loop
set /a npart+=1
for /f "tokens=1* delims=," %%f in ("%list%") do (
	set part=%%f
	set list=%%g
)
set object[%object%].stimulus[%stimulus%].%~1[%npart%]=%part%
if not "%list%"=="" goto :openstimulus.placedata.loop
goto :eof








:prephook
set /a dream.RT.hookactions+=1
set $this=%dream.RT.hookactions%
set dream.RT.hookaction[%$this%].context=%~1
set dream.RT.hookaction[%$this%].location=%~2
set dream.RT.hookaction[%$this%].data=%~3
goto :eof

:flushhooks
for /l %%n in (1,1,%dream.RT.hookactions%) do (
	call :flushhook.prep %%n
)
for /f "tokens=1 delims==" %%x in ('set dream.RT.hookaction') do (
	set %%x=
)
goto :eof
:flushhook.prep
call set id=%%dream.RT.hookaction[%~1].context%%
call set slot=%%dream.RT.hookaction[%~1].location%%
call set out=%%dream.RT.hookaction[%~1].data%%
call set type=%%object[%id%]%%
call set hookfile=%%type[%type%].hook[%slot%].command%%
call %hookfile% %id%:%out%
for /f "tokens=1* delims=:" %%a in ("%HR%") do (
	set action=%%a
	set reply=%%b
)
call :counttokens , sum=%reply%
call set delay=%%type[%type%].hook[%slot%].action[%action%].delay%%
call set script=%%type[%type%].hook[%slot%].action[%action%].script%%
call :queueevent %delay%;0,%id%;1,%sum%,0,%reply%;%script%
goto :eof

~















::::::::::::::::::::::::::::::::
::        Event Stuff         ::
:: and associated subsections ::
::::::::::::::::::::::::::::::::








:event.script.close[end]
goto :eof

:event
call set $script=%%dream.event[%*]%%
call set $part[0]=%%dream.event[%*].part[0]%%
set $task=action
:event.scriptloop
set $char=%$script:~0,1%
set $script=%$script:~1%
call :event.script.track[%$task%]
if not "%$script%"=="" goto :event.scriptloop
call :flushhooks
for /f "tokens=1 delims==" %%f in ('set dream.event[%*]') do (
set %%f=
)
goto :eof

:event.script.track[action]
set $enumstacksize=0
if "%$char%"=="?" (
	set $task=getvalue
	set $purpose=if
	set $close={
)
if "%$char%"=="*" (echo hit)
if "%$char%"=="f" (
	set $task=rnumber
	set $purpose=for
	set $phase=1
	set $close=:
)
if "%$char%"=="!" (
	set $task=partnum
	set $purpose=dataleft
	set $enum.close=dynamic
	set $enum.raw=true
)
if "%$char%"=="-" (
	set $task=partnum
	set $purpose=delete
	set $enum.bound=id
	set $close=;
)
if "%$char%"=="+" (
	set $task=number
	set $purpose=create
	set $close=:
)
if "%$char%"=="<" (
	set $task=getterm
	set $purpose=pass.hook
	set $close=:
	set $enum.raw=true
)
::	if "%$char%"=="I" (set $task=getterm
::	set $purpose=inhibit)
if "%$char%"==":" (
	set $task=getterm
	set $purpose=openstim
	set $enum.raw=true
	set $close=;
)
if "%$char%"=="~" (
	set $task=getterm
	set $purpose=closestim
	set $enum.raw=true
	set $close=;
)
if "%$char%"=="{" (
	if "%$purpose%"=="testelse" (
		set /a $nest=$nest+1
		call set $layer[%%$nest%%]=else
	)
	if "%$purpose%"=="skipelse" (
		set $task=skipbrace
		set $brace=1
		set $purpose=else
	)
)
set $return=
if "%$char%"=="}" (call :event.script.track[action].handlenest)
goto :eof








::::::::::::::
:: Handling ::
::::::::::::::








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






::::::::::::::::::
:: BC Functions ::
::::::::::::::::::








:event.script.close[if]
if "%$return%"=="1" (
 set /a $nest=$nest+1
 set $task=action
 call set $layer[%%$nest%%]=if
) else (
 set $task=skipbrace
 set $brace=1
 set $purpose=if
)
set $return=
goto :eof

:event.script.close[for]
if "%$phase%"=="1" (set /a $nest+=$nest)
set $for[%$phase%]=%$return%
set $return=
set /a $phase+=1
if "%$phase%"=="4" (
set $close={
set $task=partnum
set $enum.bound=id
set $enum.raw=true
set $purpose=four
)
goto :eof

:event.script.close[four]
set $layer[%$nest%]=for
set $for[%$nest%].part=%$for[1]%
set $for[%$nest%].type=%$for[2]%
set $for[%$nest%].slot=%$for[3]%
set $for[%$nest%].sbj=%$num%
set $for[%$nest%].obj=
set $for[%$nest%]=%$script%
call :event.script.handlefor
if "%$end%"=="" (set $task=skipbrace
set $brace=1
set $purpose=for) else (set $task=action)
set $for[1]=
set $for[2]=
set $for[3]=
goto :eof

:event.script.close[dataleft]
set $base=%$return%
set $op=%$char%
set $data.id=%$rid%
set $data.type=%$dtype%
set $data.slot=%$slotid%
set $slotid=
set $purpose=dataright
set $task=getvalue
set $close=;
set $enum.close=
set $enum.raw=
goto :eof

:event.script.close[dataright]
if "%$op%"=="="(set /a $base=) else (
if "%$op%"=="-"(set /a $return*=-1))
set /a object[%$data.id%].%$data.type%[%$data.slot%]=$base+$return
set $base=
set $return=
set $slotid=
set $task=action
set $purpose=
goto :eof

:event.script.close[delete]
call :destroy %$return%
set $task=action
set $purpose=
set $return=
goto :eof

:event.script.close[create]
set $purpose=createtype
set $close=;
set $createnum=%$return%
set $return=
goto :eof

:event.script.close[createtype]
set $task=action
set $purpose=
call :instantiate %$return%
set $part[%$createnum%]=%dream.environment.objects%
set $return=
set $createnum=
goto :eof

:event.script.close[evaluate]
set $task=getvalue
set $purpose=evaluate
set %$evaluout%=%$return%
set $return=
goto :eof

:event.script.close[pass.hook]

set $pass.id=%$rid%
set $pass.slot=%$slotid%
	set $enum.close=dynamic
	set $enum.raw=
set $task=getvalue
set $purpose=pass.tuple
set $close=,
set $pass.out=
set $return=
goto :eof

:event.script.close[pass.tuple]
set $pass.out=%$pass.out%%$return%,
if "%$char%"==";" (
set $task=action
set $purpose=
call :prephook %$pass.id% %$pass.slot% %$pass.out%
set $pass.id=
set $pass.slot=
set $pass.out=
set $enum.close=
)
set $return=
goto :eof

:event.script.close[closestim]
set $enum.raw=
call :closestimulus %$rid% %$slotid%
set $task=action
set $purpose=end
goto :eof

::Block of Code FTW
:event.script.close[openstim]
set $openstim.id=%$rid%
set $openstim.slot=%$slotid%
set $enum.raw=

call set $openstim.type=%%object[%$openstim.id%]%%
call set $openstim.stimtype=%%type[%openstim.type%].stimulus[%$openstim.slot%]%%

call set $openstim.values=%%stimulus[%$openstim.stimtype%].values%%
call set $openstim.pointers=%%stimulus[%$openstim.stimtype%].pointers%%

set $openstim.current=1
set $openstim.mode=value
if "%$openstim.values%"=="0" (
	if "%$openstim.pointers%"=="0" (
		goto :event.script.close[openstim].endit
	) else (
		set $openstim.mode=pointer
	)
)
set $task=getvalue
set $purpose=openstim.thing
goto :eof

:event.script.close[openstim.thing]
goto :event.script.close[openstim.%$openstim.mode%]
:event.script.close[openstim.value]

set object[%$openstim.id%].stimulus[%$openstim.slot%].value[%$openstim.current%]=%$return%
set $return=if "%$openstim.values%"=="%$openstim.current%" (
	if "%$openstim.pointers%"=="0" (
		goto :event.script.close[openstim].endit
	) else (
		set $openstim.current=1
		set $openstim.mode=pointer
	)
)
set $openstim.current+=1
goto :eof
:event.script.close[openstim.pointer]
set object[%$openstim.id%].stimulus[%$openstim.slot%].pointer[%$openstim.current%]=%$return%
set $return=
if "%$openstim.values%"=="%$openstim.current%" (
	goto :event.script.close[openstim].endit
)
set $openstim.current+=1
if "%$openstim.values%"=="%$openstim.current%" (
	set $close=;
)
goto :eof

:event.script.close[openstim].endit
::nevermind the fact that the :openstim function is fully capable of handling the data into the object[].stimulus[].data[] stuff
call :openstimulus %$openstim.id% %$openstim.slot%
set $openstim.id=
set $openstim.slot=
set $openstim.current=
set $openstim.values=
set $openstim.pointers=
set $openstim.current=
set $openstim.type=
set $openstim.stype=

set $task=action
set $purpose=end
goto :eof

~








::::::::::::::::::::
:: Get Value FSet ::
::::::::::::::::::::








:: collects chars until an end is met. Doesn't seem to deal with commands that use contextual closing characters. (yet) This subroutine is seperate to the rest of the value Fset, and is for manual use without complicated handlers which I find hard to remember how to use.
:event.script.track[number]
if "%$char%"=="%$close%" goto :event.script.close[%$purpose%]
::	if "%$purpose%"=="speak" (if "%$char%"==";" (goto :event.script.track[close[speak]]))
::	if "%$purpose%"=="delete" (if "%$char%"==";" (goto :event.script.track[close[delete]]))
::	if "%$purpose%"=="dataright" (if "%$char%"==";" (goto :event.script.track[close[dataright]]))
::	if "%$purpose%"=="for" (if "%$char%"==":" (goto :event.script.track[close[for].%$phase%]))
::	if "%$purpose%"=="create" (if "%$char%"==":" (goto :event.script.track[close[create]]))
::	if "%$purpose%"=="createtype" (if "%$char%"==";" (goto :event.script.track[close[createtype]]))
::	if "%$purpose%"=="call" (if "%$char%"==";" (goto :event.script.track[close[call]]))
::	if "%$purpose%"=="inhibit" (if "%$char%"=="I" (goto :event.script.track[close[inhibit]]))
set $return=%$return%%$char%
goto :eof

::Simply checks to see if the term it is looking for is a constant, an object's field, or another expression
:event.script.track[getvalue]
if "%$char%"=="@" (set $task=partnum)
if "%$char%"=="#" (set $task=enumber)
if "%$char%"=="(" (call :event.script.enum.push)
set $return=
goto :eof

::Pushes the stack forward one, presumably at the start of a sub-expression. Thus for now the close is always a close-paren
:event.script.enum.push
set $enumstack[%$enumstacksize%].close=%$close%
set /a $enumstacksize+=1
set $enumstack[%$enumstacksize%].cside=left
set $cside=left
set $close=)
goto :eof


:event.script.track[enumber]
call :event.script.enum.checkcontinue
if not "%$estate%"=="maintain" (
	if "%$estate%"=="close" (
		goto :event.script.closeenum.raw
	) else (
		goto :event.script.switchenumside.raw
	)
)
set $return=%$return%%$char%
goto :eof

:event.script.track[partnum]
if "%$char%"=="." (
set $task=field
call set $rid=%%$part[%$part%]%%
set $part=
goto :eof
)
call :event.script.enum.checkcontinue
if not "%$estate%"=="maintain" (
	set $hold=
	set $part=
	call set $return=%%$part[%$part%]%%
	if "%$estate%"=="close" (
		goto :event.script.closeenum.raw
	) else (
		goto :event.script.switchenumside.raw
	)
)
set $part=%$part%%$char%
goto :eof

::When a field is being sought, (Syntax "@<partnum>[.<pointer>[...]].<fieldtype><field id>" ) the fieldtype is found using this check.
:event.script.track[field]
if not "%$enum.bound%"=="id" (
	if "%$char%"=="$" ( 
		set $task=getslotid
		set $dtype=property
		goto :eof 
	)
	if "%$char%"=="!" ( 
		set $task=getslotid
		set $dtype=state
		goto :eof 
	)
	if "%$char%"=="#" ( 
		set $task=getslotid
		set $dtype=value
		goto :eof 
	)
	if "%$char%"=="@" ( 
		set $task=closeterm.id
		goto :eof 
	)
	if "%$char%"=="*" ( 
		set $task=closeterm.type
		goto :eof 
	)
	if "%$char%"==">" ( 
		set $task=getslotid
		set $dtype=hook
		goto :eof 
	)
	if "%$char%"==":" ( 
		set $task=getslotid
		set $dtype=stimulus
		goto :eof 
	)
)
set $task=nextfield
set $point=%$char%
goto :eof

::collects the next pointer id. (Passed to from track[field] after a static field is not found)
:event.script.track[nextfield]
if "%$char%"=="." (
	call set $rid=%%object[%$rid%].pointer[%$point%]%%
	set $point=
	set $task=field
	goto :eof
)
call :event.script.enum.checkcontinue
if not "%$estate%"=="maintain" (
	set $slotid=%$point%
	set $dtype=pointer
	call set $return=%%object[%$rid%].pointer[%$point%]%%
	if "%$estate%"=="close" (
		goto :event.script.closeenum.raw
	) else (
		goto :event.script.switchenumside.raw
	)
)
set $point=%$point%%$char%
goto :eof

::Collects the id of whatever field type :event.script.track[field] chose; this is the last part of this kind of value, so this command passes it's value back to the expression handler.
:event.script.track[getslotid]
call :event.script.enum.checkcontinue
if not "%$estate%"=="maintain" (
	if "%$estate%"=="close" (
		goto :event.script.closeenum
	) else (
		goto :event.script.switchenumside
	)
)
set $slotid=%$slotid%%$char%
goto :eof

::Handles the check for an operator, when on the left side of a product. For example, in #1+@0.#1 it would be looking for the + to check if it can close the constant on the left.
:event.script.track[getenumop]
call :event.script.enum.readop
if defined $enumoperator (
 if "%$enumoperator%"=="end" (
  goto :event.script.closeenum.raw
 ) else (
  goto :event.script.switchenumside.raw
 )
)
goto :eof

::When an operator is met, it feeds the operator and the left value into the stack and switches to the right hand side.
:event.script.switchenumside
call set $return=%%object[%$rid%].%$dtype%[%$slotid%]%%
:event.script.switchenumside.raw
set $enumstack[%$enumstacksize%].operator=%$enumoperator%
set $cside=right
set $task=getvalue
set $left=%$return%
set $enumstack[%$enumstacksize%].cside=right
set $enumstack[%$enumstacksize%].left=%$left%
set $return=
goto :eof

::Evaluates the expression being handled, and then pops the stack once. If this expression was the rhs of another expression it recurses without waiting for another close-paren, meaning (#1+(@0.#1+@0.#2) is a correct expression, but (#1+(@0.#1+@0.#2)) is not.
:event.script.closeenum
call set $return=%%object[%$rid%].%$dtype%[%$slotid%]%%
:event.script.closeenum.raw
set $right=%$return%
call :event.script.closenum.operator[%$enumoperator%]
if "%$enumstacksize%"=="0" (
	set $enum.raw=
	set $enum.bound=
	goto :event.script.close[%$purpose%]
)
set /a $enumstacksize-=1
call set $cside=%%$enumstack[%$enumstacksize%].cside%%
call set $close=%%$enumstack[%$enumstacksize%].close%%
if "%$cside%"=="left" (set $task=getenumop
goto :eof)
call set $left=%%$enumstack[%$enumstacksize%].left%%
call set $enumoperator=%%$enumstack[%$enumstacksize%].operator%%
if "%$enumstacksize%"=="0" (goto :eof)
goto :event.script.closeenum.raw

::All of the hard-coded functions to which operators like +-*/%= etc, refer.
:event.script.closenum.operator[end]
set $return=%$right%
goto :eof
:event.script.closenum.operator[equ]
if "%$left%"=="%$right%" (
 set $return=1
) else (
 set $return=0
)
goto :eof
:event.script.closenum.operator[neq]
if "%$left%"=="%$right%" (
 set $return=0
) else (
 set $return=1
)
goto :eof
:event.script.closenum.operator[pls]
set /a $return=$left+$right
goto :eof
:event.script.closenum.operator[mns]
set /a $return=$left-$right
goto :eof
:event.script.closenum.operator[tms]
set /a $return=$left*$right
goto :eof
:event.script.closenum.operator[int]
set /a $return=$left/$right
goto :eof
:event.script.closenum.operator[mod]
set /a $return=$left%%$right
goto :eof
:event.script.closenum.operator[and]
set /a $return=$left^&$right
goto :eof
:event.script.closenum.operator[xor]
set /a $return=$left^^$right
goto :eof
:event.script.closenum.operator[bor]
set /a $return=$left^|$right
goto :eof

::Hard-coded check to see if the current char is an operator.
:event.script.enum.readop
set $enumoperator=
call :event.script.enum.checkclose
if "%$check%"=="true" set $enumoperator=end
	if not "%$enum.raw%"=="true" (
if "%$char%"=="="  set $enumoperator=equ
if "%$char%"=="~"  set $enumoperator=neq
if "%$char%"=="+"  set $enumoperator=pls
if "%$char%"=="-"  set $enumoperator=mns
if "%$char%"=="*"  set $enumoperator=tms
if "%$char%"=="/"  set $enumoperator=int
if "%$char%"=="%%" set $enumoperator=mod
if "%$char%"=="&"  set $enumoperator=and
if "%$char%"=="^"  set $enumoperator=xor
if "%$char%"=="|"  set $enumoperator=bor
	)
goto :eof

::Hard-coded check for closing characters.
:event.script.enum.checkclose
set $check=false
if not "%$enum.close%"=="dynamic" (
	if "%$close%"=="%$char%" set $check=true
	goto :eof
)

if "%$purpose%"=="dataleft" (
	if "%$char%"=="=" set $check=true
	if "%$char%"=="+" set $check=true
	if "%$char%"=="-" set $check=true
)
if "%purpose%"=="pass.tuple" (
	if "%$char%"=="," set $check=true
	if "%$char%"==";" set $check=true
)
goto :eof

::Checks to see if an operator or a close-character has been met.
:event.script.enum.checkcontinue
set $estate=maintain
set $estate.cr=
if "%$cside%"=="right" (
 call :event.script.enum.checkclose
)
if "%$cside%"=="right" (
 if "%$check%"=="true" (
  set $estate=close
 )
 goto :eof
)
call :event.script.enum.readop
if defined $enumoperator (
 if "%$enumoperator%"=="end" (
  set $estate=close
  set $estate.cr=.raw
 ) else (
  set $estate=switch
 )
)
goto :eof









:::::::::::::::::::::
:: Dream Functions ::
:::::::::::::::::::::







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
set $tuples=%%c
set $toqueue=%%d
)
set /a dream.events+=1
set /a dream.event[%dream.events%].stime=$offset+dream.ticks
set dream.event[%dream.events%]=%$toqueue%
call :queueevent.partloop
call :queueevent.tupleloop
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

:queueevent.tupleloop
for /f "tokens=1,2,3* delims==," %%w in ("%$tuples%") do (
set $tuple=%%w
set $tuple.values=%%x
set $tuple.pointers=%%y
set $tuples=%%z
)
for /l %%n in (1,1,%$tuple.values%) do (call :queueevent.tuple.part value %%n)
for /l %%n in (1,1,%$tuple.pointers%) do (call :queueevent.tuple.part pointer %%n)
set dream.event[%dream.events%].tuple[%$tuple%].pointers=%$tuple.pointers%
set dream.event[%dream.events%].tuple[%$tuple%].values=%$tuple.values%
if not "%$tuples%"=="" (goto :queueevent.tupleloop)
goto :eof
:queueevent.tuple.part
for /f "tokens=1* delims==," %%x in ("%$tuples%") do (
set $tuples=%%y

set dream.event[%dream.events%].tuple[%$tuple%].%~1[%~2]=%%x
)
goto :eof









:::::::::::::::::::::
:: Batch Functions ::
:::::::::::::::::::::

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
::should be
::set /a n=%random% %% (max-min) + min

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
