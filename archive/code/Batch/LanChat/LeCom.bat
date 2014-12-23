@echo off
cls
set #self#=%~f0
set #break#=¤

for /f "tokens=1,2* delims=/" %%f in ("%*") do (
set line=%%f
set public=%%g
set data=%%h
)

for /f "tokens=1* delims=." %%f in ("%line%") do (
set line=%%f
set param=%%g
)

if "%line%"=="server" goto :server
if "%line%"=="client" goto :client
if "%line%"=="debug" goto :debug

if "%line%"=="" (cmd)

goto :eof

:debug
set /p debug=
call %debug%
goto :debug
:client
if "%param%"=="console" goto :client.console
if "%param%"=="handler" goto :client.handler

call :sendfile sping/spong/%public%/Ping
if "%error%"=="1" (echo server address invalid . . .
goto :eof) 
if "%error%"=="2" (echo Server is either offline or doesn't exist . . .
goto :eof) 
title %sendfile%
:user
cls
set user=
echo Username:
set /p user=^
> 
if "%user%"=="" goto :user
:pass
cls
echo Username:
echo - %user%
echo Password:
set /p pass=^
> 
if "%pass%"=="" goto :pass
:connect
cls
echo Connecting under username "%user%" . . .
call :sendfile lin/lnr/%public%/%user%¤%pass%
for /f "tokens=1* delims=%#break#%" %%f in ("%sendfile%") do (
set response=%%f
set didreg=%%g)
set sendfile=
if "%response%"=="failed" (echo Login failed . . .
pause>nul
goto :pass)
if "%response%"=="double" (echo This account is already online!
pause>nul
goto :user)
if "%didreg%"=="1" (echo Username successfully registered!) else (echo You are now online)

set private=%public%\trans.%user%
call :closed client.handler


pause>nul
:client.console
set line=
set /p line=
if "%line%"=="" goto :client.console
call :sendfile sping/spong/%public%/%line%
goto :client.console

:client.handler
for %%i in ("%private%") do (
set tag=%%~ni
set ext=%%~xi
call :client.checkmsg
)
goto :client.handler

:client.checkmsg
if "%ext%"=="ping" goto :client.pingong
goto :eof

:client.pingong
ren "%private%\%tag%.ping" %tag%.pong
goto :eof
:server
if "%param%"=="log" goto :server.logstart
set log=call :server.log
set server.name=The Debug Room
set server.ping.freq=200000
set server.ping.timeout=2000

for /d %%a in ("%data%\users\*.user") do (
call :server.readuser %%~na
)
:clearserver
for /d %%f in ("%public%\*") do (
del /q %%f
rd %%f)
del /q "%public%"
call :closed server.log


:server.consoleloop
set /p meeple=
goto :server.consoleloop


:server.logstart

if not exist "%data%\server.log" (echo Server log for %server.name%>"%data%\server.log")
%log% Server started

set lasttick=%time%
call :gettime %lasttick%


:servloop
call :servtick
call :serv.checkres
goto :servloop

:servtick

for %%f in ("%public%\*.*") do (
call :testfile %%~nf.%%~xf
)
set time=%time%
set tick=%time%
call :gettime tick
call :subtracttime tick lasttick
set tick=%tick.msec%
set lasttick=%time%
call :gettime lasttick
set time=
goto :eof

:serv.checknext
set /a since=since+tick
if /i %since% geq %server.ping.freq% (goto :serv.sendping)
goto :eof

:serv.sendping
set since=0
set tocheck=-1
for /f "tokens=1* delims==" %%f in ('set check[') do (call :serv.sendping.send %%g)
if "%tocheck%"=="-1" set tocheck=
goto :eof

:serv.sendping.send
set /a tocheck=tocheck+1
set tag=%random%
echo.>"%public%\trans.%*\%tag%.ping"
set ping.%tocheck%=%public%\trans.%*\%tag%.pong
set ping.%tocheck%.user=%*
goto :eof

:serv.checkres
if "%tocheck%"=="" goto :serv.checknext
for /l %%n in (0,1,%tocheck%) do (
call :serv.checkres.check %%n)
set /a since=since+tick
if /i %since% lss %server.ping.timeout% (goto :eof)
rem kill those who didn't respond here, 
rem and clean out associated variables
for /l %%n in (0,1,%tocheck%) do (
call :serv.checkres.kill %%n)
goto :eof

:serv.checkres.check
call :set file=%%ping.%*%%
if "%file%"=="" goto :eof
if exist "%file%" (del "%file%"
set ping.%*=
set ping.%*.user=)
goto :eof

:serv.checkres.kill
call :set cuser=%%ping.%*.user%%
if "%cuser%"=="" goto :eof
call :serv.cleanuser %cuser%
call :set check[%%user[%cuser%]%%]=
set user[%cuser%]=
set ping.%*=
set ping.%*.user=
%log% User %cuser% has timed out.
goto :eof

:serv.cleanuser
del /q %public%\trans.%*\*
rd %public%\trans.%*
goto :eof

:testfile
for /f "tokens=1* delims=." %%f in ("%*") do (
set tag=%%f
set ext=%%g
)
if "%ext%"=="lin" (goto :testfile.lin)
if "%ext%"=="sping" (goto :testfile.sping)
goto :eof

:testfile.sping
call :readfile message=%public%\%tag%.sping
%log% ~%message%
set message=
echo %server.name%>"%public%\%tag%.spong"
goto :eof

:testfile.lin
call :readfile user=%public%\%tag%.lin
for /f "tokens=1,2* delims=%#break#%" %%f in ("%user%") do (
set user=%%f
set pass=%%g
set junk=%%h
)
call :server.testuser
set user=
set pass=
set junk=
goto :eof

:server.testuser
set error=
call :set apass=%%username.pass[%user%]%%
if "%apass%"=="" (set error=1
goto :server.register)
if "%pass%"=="%apass%" goto :server.login
call :writefile %public%\%tag%.lnr/failed
%log% Failed attempt to log in as %user% via %pass%
goto :eof

:server.register
md "%data%\users\%user%.user"
echo %pass%>"%data%\users\%user%.user\pass.db"
call :server.log User %user% registered.
goto :server.login

:server.login
call :set check=%%user[%user%]%%
if not "%check%"=="" goto :server.login.double
set check=%random%
set user[%user%]=%check%
set check[%check%]=%user%
md "%public%\trans.%user%"
call :writefile %public%\%tag%.lnr/%check%%#break#%%error%
%log% User %user% logged in succesfully at %check%
set check=
goto :eof

:server.login.double
call :writefile %public%\%tag%.lnr/double
%log% Failed double login as %user% while already under %check%
set check=
goto :eof

:server.readuser
set /p username.pass[%*]=<"%data%\users\%*.user\pass.db"
goto :eof

:server.log
echo [%date% %time%] %*
echo [%date% %time%] %*>>"%data%\server.log"
goto :eof

rem |==============================================================================|
rem |Time                                                                          |
rem |==============================================================================|

:open
start "" "%#self#%" %*/%public%/%data%
goto :eof

:closed
start "" /min "%#self#%" %*/%public%/%data%
goto :eof

:gettime
call :set %*.hour=%%%*:~0,2%%
call :set %*.min=%%%*:~3,2%%
call :set %*.sec=%%%*:~6,2%%
call :set %*.msec=%%%*.sec%%%%%*:~9,2%%
call :cleantime %*
goto :eof

:cleantime
set cleantime.name=%*
call :cleantime.clean hour
call :cleantime.clean min
call :cleantime.clean sec
call :cleantime.clean msec
goto :eof
:cleantime.clean
call :set cleantime=%%%cleantime.name%.%*%%
if "%cleantime:~0,1%"=="0" (
set %cleantime.name%.%*=%cleantime:~1%
call :cleantime.clean %*)
goto :eof

:addtime
for /f "tokens=1,2*" %%x in ("%*") do (
set addtime.one=%%x
set addtime.two=%%y
set addtime.error=%%z
)
set /a %addtime.one%.hour=%addtime.one%.hour+%addtime.two%.hour
set /a %addtime.one%.min=%addtime.one%.min+%addtime.two%.min
set /a %addtime.one%.sec=%addtime.one%.sec+%addtime.two%.sec
set /a %addtime.one%.msec=%addtime.one%.msec+%addtime.two%.msec
call :carrytime %addtime.one%
set addtime.one=
set addtime.two=
set addtime.error=
goto :eof

:subtracttime
for /f "tokens=1,2*" %%x in ("%*") do (
set subtracttime.one=%%x
set subtracttime.two=%%y
set subtracttime.error=%%z
)
set /a %subtracttime.one%.hour=%subtracttime.one%.hour-%subtracttime.two%.hour
set /a %subtracttime.one%.min=%subtracttime.one%.min-%subtracttime.two%.min
set /a %subtracttime.one%.sec=%subtracttime.one%.sec-%subtracttime.two%.sec
set /a %subtracttime.one%.msec=%subtracttime.one%.msec-%subtracttime.two%.msec
call :carrytime %subtracttime.one%
set subtracttime.one=
set subtracttime.two=
set subtracttime.error=
goto :eof

:carrytime
call :carry %*.min %*.sec 60
call :carry carrytime.nul %*.msec 6000
call :carry %*.hour %*.min 60
call :carry carrytime.nul %*.hour 24
set carrytime.nul=
goto :eof

:carry
if "%~1"=="/m" (set carry.com=gtr
set carry.com-=leq
set carry.tok=2,3,4,5*) else (set carry.com=geq
set carry.com-=lss
set carry.tok=1,2,3,4*)
for /f "tokens=%carry.tok%" %%r in ("%*") do (
set carry.crate=%%r
set carry.fruit=%%s
set carry.size=%%t
set carry.error=%%u
)
call :set carry.apples=%%%carry.fruit%%%
if /i %carry.apples% %carry.com% %carry.size% (call :carry.carry) else (
if /i %carry.apples% %carry.com-% 0 (call :carry.inverse)               )
set carry.crate=
set carry.fruit=
set carry.size=
set carry.error=
set carry.apples=
set carry.com=
set carry.com-=
goto :eof
:carry.carry
set /a carry.apples=carry.apples-carry.size
set /a %carry.crate%=%carry.crate%+1
set %carry.fruit%=%carry.apples%
if /i %carry.apples% %carry.com% %carry.size% (call :carry %carry.crate% %carry.fruit% %carry.size%)
goto :eof
:carry.inverse
set /a carry.apples=carry.apples+carry.size
set /a %carry.crate%=%carry.crate%-1
set %carry.fruit%=%carry.apples%
if /i %carry.apples% %carry.com-% %carry.size% (call :carry %carry.crate% %carry.fruit% %carry.size%)
goto :eof

rem |==============================================================================|
rem |Functions                                                                     |
rem |==============================================================================|

:set
set %*
goto :eof

:readfile
for /f "tokens=1* delims==" %%c in ("%*") do (
set readfile.name=%%c
set readfile.file=%%d
)
set /p %readfile.name%=<"%readfile.file%"
for /f "usebackq skip=1 tokens=*" %%b in ("%readfile.file%") do (
call :set %readfile.name%=%%%readfile.name%%%¤%%b
)
del "%readfile.file%"
set readfile.name=
set readfile.file=
goto :eof

:writefile
for /f "tokens=1* delims=/" %%f in ("%*") do (
set writefile.address=%%~dpf
set writefile.file=%%~nxf
set writefile.line=%%g
)
for /f "tokens=1* delims=¤" %%f in ("%writefile.line%") do (set writefile.cur=%%f
set writefile.line=%%g)
set error=
>"%writefile.address%%writefile.file%.temp" echo ^
%writefile.cur%
if not exist "%writefile.address%%writefile.file%.temp" (set error=1)
if not "%writefile.line%"=="" call :writefile.loop
ren "%writefile.address%%writefile.file%.temp" %writefile.file%
set writefile.cur=
set writefile.address=
set writefile.file=
goto :eof

:writefile.loop
for /f "tokens=1* delims=¤" %%f in ("%writefile.line%") do (set writefile.cur=%%f
set writefile.line=%%g)
>>"%writefile.address%%writefile.file%.temp" echo ^
%writefile.cur%
if not "%writefile.line%"=="" call :writefile.loop
goto :eof


:sendfile
for /f "tokens=1,2,3* delims=/" %%f in ("%*") do (
set sendfile.extension=%%f
set sendfile.returnext=%%g
set sendfile.address=%%h
set sendfile.message=%%i
)
set sendfile.name=%random%
set error=
call :sendfile.catch
if exist "%sendfile.address%\%sendfile.name%.%sendfile.extension%" del "%sendfile.address%\%sendfile.name%.%sendfile.extension%"
set sendfile.extension=
set sendfile.returnext=
set sendfile.address=
set sendfile.message=
goto :eof

:sendfile.catch
call :writefile %sendfile.address%\%sendfile.name%.%sendfile.extension%/%sendfile.message%
if "%error%"=="1" (goto :eof)
set sendfile.stime=%time%
call :gettime sendfile.stime
call :sendfile.loop
if "%error%"=="2" (goto :eof)
call :readfile sendfile=%sendfile.address%\%sendfile.name%.%sendfile.returnext%
goto :eof

:sendfile.loop
set sendfile.ctime=%time%
call :gettime sendfile.ctime
call :subtracttime sendfile.ctime sendfile.stime
if exist "%sendfile.address%\%sendfile.name%.%sendfile.returnext%" (goto :eof)
if "%sendfile.ctime.sec%"=="0" goto :sendfile.loop
set error=2
goto :eof
:eof
