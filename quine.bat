@echo off
set src[0]=echo @echo off
set src[1]=set p=%%p%%%%p%%%%p%%%%p%%p%%p%%%%p%%%%p%%%%p%%
set src[2]=set src.length=17
set src[3]=call :copy vars
set src[4]=set p=%%p%%%%p%%
set src[5]=echo.
set src[6]=call :copy comms
set src[7]=goto :eof
set src[8]=:copy
set src[9]=set i=0
set src[10]=:copy_loop
set src[11]=call call set src=%%p%%%%p%%src[%%p%%i%%p%%]%%p%%%%p%%
set src[12]=if %%p%%1==vars echo set src[%%p%%i%%p%%]=%%p%%src%%p%%
set src[13]=if %%p%%1==comms echo %%p%%src%%p%%
set src[14]=set /a i=i+1
set src[15]=if not %%p%%i%%p%%==%%p%%src.length%%p%% goto :copy_loop
set src[16]=:eof

echo @echo off
set p=%%%%p%%%%
set src.length=17
call :copy vars
set p=%%
echo.
call :copy comms
goto :eof
:copy
set i=0
:copy_loop
call call set src=%%src[%i%]%%
if %1==vars echo set src[%i%]=%src%
if %1==comms echo %src%
set /a i=i+1
if not %i%==%src.length% goto :copy_loop
:eof
