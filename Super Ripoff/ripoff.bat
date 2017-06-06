@echo off
setlocal

for /f "tokens=1 delims==" %%f in ('set') do (set %%f=)

if not "%*"=="" goto :argrun

echo Press any key to roll . . .
pause>nul
:forever
call :run
echo Press any key to reroll . . .
pause>nul
goto :forever

:argrun
set /a defaultdecksize=%~1
set heroes=%~2
set villains=%~3
set buffs=%~4
set debuffs=%~5
set /a chars=%~2+%~3
set /a attrs=%~4+%~5
call :init "%~6" "%~7" "%~8" "%~9"

set /a defaultnum=defaultdecksize-buffs
~

::fix up init and argrun to work all good like
::get it to determine usable. nums and maxable. nums
::do something else which is important






:print
cls
for /l %%n in (1,1,%decksize%) do (
	call :print.card %%n
)

goto :eof
:print.card
call set attrAid=%%card[%~1].attrA%%
call set attrBid=%%card[%~1].attrB%%
call set charid=%%card[%~1].char%%
call set Atype=%%card[%~1].Atype%%
call set Btype=%%card[%~1].Btype%%
call set Ctype=%%char[%charid%].type%%
call set attrA=%%%Atype%[%attrAid%].text%%
call set attrB=%%%Btype%[%attrBid%].text%%
call set char=%%char[%charid%].text%%

if "%Ctype%"=="hero" (
	set unit=H
) else (
	set unit=V
)
if "%Atype%"=="buff" (
	set unit=%unit%+
) else (
	set unit=%unit%-
)
if "%Btype%"=="buff" (
	set unit=%unit%+
) else (
	set unit=%unit%-
)

echo %unit%: %char% with %attrA% and %attrB%.
goto :eof

:print.verses
echo.
echo  %twentyeightspaces%- - - - Verses - - - -
echo.
goto :eof








::::::::::
:: Init ::
::::::::::








:init



::only if six cards are available




set /a num.team=defaultdecksize/3

call :readfile char    hero="heroes.spf"
call :readfile char    villain="villains.spf"
call :readfile buff    buff="buffs.spf"
call :readfile debuff  debuff="debuffs.spf"

set small=default
set decksize=%defaultdecksize%

call :compare 1 %heroes%	%chars%		hero
call :compare 1 %villains%	%chars%		villain
call :compare 2 %buffs%		%attrs%		buff
call :compare 2 %debuffs%	%attrs%		debuff

goto :eof
::Usage:: CALL :compare <types of this type's thing> <things per card> <itemtype>
::			The second and third parameter are so that the subroutine can calculate how many cards the defined objects could support.
:compare
call set num=%%max.type.%~2%%
set /a num*=%~1
set /a num/=%~2
if %num% lss %decksize% (
	set small=%~2
	set decksize=%num%
)
if %decksize% equ 0 (
	set small=%~2
	set decksize=%num%
)
goto :eof


:readfile
for /f "tokens=1,2* delims== " %%a in ("%*") do (
	set thing=%%a
	set type=%%b
	set source=%%~c
)
call set num=%%max.thing.%thing%%%
for /f "tokens=* usebackq eol=#" %%f in ("%source%") do (
	call :readfile.line %%f
)

set /a max.type.%type%=num-max.thing.%thing%
set max.thing.%thing%=%num%

goto :eof
:readfile.line
set /a num+=1
set %thing%[%num%].type=%type%
set %thing%[%num%].text=%*
goto :eof








:::::::::
:: Run ::
:::::::::








:run
::prep/resetting
::Reset the number of all of the things that can be chosen from
for /f "tokens=1,2,3* delims=.=" %%a in ('set max.') do (
	set num.%%b.%%c=%%d
)
set usable.buff=%decksize%
set usable.debuff=%decksize%

set isused.dummy=Just so that the next for loop won't throw silly errors
::Re-mark all available things as being unused
for /f "tokens=1* delims==" %%a in ('set isused.') do (
	set %%a=
)

set left=%decksize%
set count=
:loop
set /a count+=1
call :picktype Atype
call :picktype Btype
call :determinecard %count% %Atype% %Btype%
set /a left-=1
if not "%left%"=="0" goto :loop
call :print

goto :eof
:picktype
call set type=%%card[%count%].%~1%%
if "%type%"=="" (
	call :picktype.random %~1
)
set /a usable.%type%-=1
set %~1=%type%

goto :eof
:picktype.random
set /a num=usable.buff+usable.debuff
call :random type=1,%num%
if %type% gtr %usable.buff% (
	set type=debuff
) else (
	set type=buff
)
set card[%count%].%~1=%type%
goto :eof

:determinecard
call :pickthing char
set card[%~1].char=%term%
call :pickthing %~2
set card[%~1].attrA=%term%
call :pickthing %~3
set card[%~1].attrB=%term%

goto :eof
:pickthing
call set num=%%num.thing.%~1%%
set /a num.thing.%~1-=1
call :random id=1,%num%
call :findassociatedterm %~1 %id%
set isused.%~1[%term%]=true

goto :eof
:findassociatedterm
set term=0
set associd=0
:findassociatedterm.loop
set /a term+=1
call set isused=%%isused.%~1[%term%]%%
if not "%isused%"=="" goto :findassociatedterm.loop
set /a associd+=1
if not "%associd%"=="%~2" goto :findassociatedterm.loop
set associd=
goto :eof








:::::::::::::::::::::::::::::::::::::::
:: Batch Functions                   ::
::       i.e. random number selector ::
:::::::::::::::::::::::::::::::::::::::








:random
setlocal
for /f "tokens=1,2* delims==, " %%a in ("%*") do (
	set var=%%a
	set min=%%b
	set max=%%c
)
set /a out=%random% %% (max - min + 1) + min
(endlocal
set %var%=%out%)
goto :eof
