::@echo off
::level specs::
call :preparevars
call :fillgrid.line %tile.cave%
call :fill.line 0 32
set cell[1,32]=@
call :addlabel exit 1 32
set cell[40,32]=X
call :addlabel exit 40 32
call :printlevel %cd%\gentest.lvl
goto :eof

:preparevars

call :defaultvar level.author=SPELUNKYGEN.BAT
call :defaultvar level.music=CAVE

call :defaultvar level.life=4
call :defaultvar level.bombs=4
call :defaultvar level.rope=4

call :defaultvar level.defaultexit=NONE

			 ::DO NOT CHANGE THESE::
	  ::maps have a set size in Spelunky::
	::tiles have a set encoding in Spelunky::
::this is only here for testing and readability::

set level.width=40
set level.height=32
set /a level.volume=level.height*level.width

set level.eventlabels=0
set level.signlabels=0
call :getchars
goto :eof

:getchars
for /f "tokens=1* usebackq eol=; delims==" %%f in ("%cd%\chars.ini") do (
call :getchars.takeline %%f "%%g"
)
goto :eof

:getchars.takeline
if "%~2"=="" goto :getchars.parameter
set %getchars.type%.%1=^^^%~2
goto :eof

:getchars.parameter
set getchars.parameter=%1
if not "%getchars.parameter:~0,1%"=="[" (goto :eof)
if not "%getchars.parameter:~-1%"=="]" (goto :eof)
set getchars.type=%getchars.parameter:~1,-1%
set getchars.parameter=
goto :eof


:fillgrid.line
for /l %%i in (1,1,%level.height%) do (
call :fill.line %1 %%i
)
goto :eof

:fillgrid.column
for /l %%i in (1,1,%level.width%) do (
call :fill.column %1 %%i
)
goto :eof

:fill.line
for /l %%i in (1,1,%level.width%) do (
set cell[%%i,%2]=%1
)
goto :eof

:fill.column
for /l %%i in (1,1,%level.height%) do (
set cell[%2,%%i]=%1
)
goto :eof

:genstring.horizontal
set line=
for /l %%i in (1,1,%level.width%) do (
call set cell=%%cell[%%i,%1]%%
call set line=%%line%%%%cell%%
)
set line[%1]=%line%
goto :eof

:genstring.vertical
set column=
for /l %%i in (1,1,%level.height%) do (
call set cell=%%cell[%1,%%i]%%
call set column=%%column%%%%cell%%
)
set column[%1]=%column%
goto :eof

:printlevel
set printlevel.file=%*
if exist "%printlevel.file%" (echo File confliction detected.
echo Move the following file before continuing:
echo %*
pause
goto :printlevel
)
for /l %%i in (1,1,%level.height%) do (
call :genstring.horizontal %%i
)
set line=0
:printlevel.maploop
set /a line+=1
call set string=%%line[%line%]%%
call :printlevel.printline "%string%"
if not "%line%"=="%level.height%" goto :printlevel.maploop

call :printlevel.printline %level.author%
call :printlevel.printline %level.music%

call :printlevel.printline %level.life%
call :printlevel.printline %level.bombs%
call :printlevel.printline %level.rope%

call :printlevel.printline %level.defaultexit%

call :printlevel.printline %level.exitlabels%
for /l %%i in (1,1,%level.exitlabels%) do (
call :printlevel.label exit %%i
)

call :printlevel.printline %level.signlabels%
for /l %%i in (1,1,%level.signlabels%) do (
call :printlevel.label sign %%i
)
set printline.file=
set printline.truncate=
set printline.label=
goto :eof


:printlevel.label
call set print.label=%%%1label[%2]%%
call :printlevel.printline %print.label%
goto :eof

:printlevel.printline
if exist "%printlevel.file%" (set printlevel.truncate=^>^>) else set printlevel.truncate=^>
if "%~2"=="" (
 if "%~1"=="" (
   echo.%printlevel.truncate%"%printlevel.file%"
 ) else (
  echo %~1%printlevel.truncate%"%printlevel.file%"
 )
) else (
 echo %*%printlevel.truncate%"%printlevel.file%"
)
goto :eof

:addlabel
for /f "tokens=2,3*" %%a in ("%*") do (
set /a addlabel.volumeindex=%%a*level.width+%%b
set addlabel.prevlabel=%%c
)
call set addlabel.labels=%%level.%1labels%%
for /l %%i in (1,1,%addlabel.labels%) do (
call :addlabel.findlabel %1 %%i
)
set /a addlabel.labels+=1
set %1label[%addlabel.labels%].VI=%addlabel.volumeindex%
set %1label[%addlabel.labels%]=%addlabel.prevlabel%
set level.%1labels=%addlabel.labels%
goto :eof
:addlabel.findlabel
call set addlabel.currentindex=%%%1label[%2].VI%%
if %addlabel.volumeindex% gtr %addlabel.currentindex% goto :eof
set %1label[%2].VI=%addlabel.volumeindex%
set addlabel.volumeindex=%addlabel.currentindex%
set addlabel.currentindex=
(
 call set addlabel.prevlabel=%%%1label[%2]%%
 set %1label[%2]=%addlabel.prevlabel%
)
goto :eof

::FUNCTIONS::

:appendstring
for /f "tokens=1* delims=/" %%f in ("%*") do (
set appendstring.path=%%f
set appendstring.string=%%g
)
if not exist "%appendstring.path%" (call :nofeedfileecho /t %*
goto :eof)
echo. >> "%appendstring.path%"
call :nofeedfileecho %*
goto :eof

:nofeedfileecho
set nofeedfileecho.full=%*
if /i "%nofeedfileecho.full:~0,3%"=="/t " (set nofeedfileecho.truncate=^>
set nofeedfileecho.full=%nofeedfileecho.full:~3%) else (set nofeedfileecho.truncate=^>^>)
for /f "tokens=1* delims=/" %%f in ("%nofeedfileecho.full%") do (
set nofeedfileecho.path=%%f
set nofeedfileecho.string=%%g
)
set nofeedfileecho.full=
echo. | set /p nul=%nofeedfileecho.string% %nofeedfileecho.truncate% "%nofeedfileecho.path%"
set nofeedfileecho.path=
set nofeedfileecho.string=
set nofeedfileecho.truncate=
goto :eof

:defaultvar
for /f "tokens=1* delims==" %%f in ("%*") do (
if not defined "%%f" (set %%f=%%g)
)
goto :eof