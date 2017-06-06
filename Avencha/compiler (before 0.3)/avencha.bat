
>"file.bat" echo @echo off
call :printby debug
call :printby place
call :printby interpret
call :printby console
call :printby stencil
call :printby object
call :printby event
call :printby hook
>>"file.bat" echo start avencha.bat
goto :eof

:print
>>"file.bat" echo set %*
goto :eof

:printby
for /f "tokens=*" %%f in ('set %*') do (call :print %%f)
goto :eof