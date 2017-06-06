@echo off
echo File to use?
set /p write=^
> 
if not "%write:~-4%"==".alc" set write=%write%.alc
if not exist "%write%" call :makewrite
for /f "tokens=* usebackq" %%f in ("%write%") do (
call :set /a counter=counter+1
call :set line[%%counter%%]=%%f
)

:extractloop
set /a scounter=scounter+1
call :set line=%%line[%scounter%]%%
for /f "tokens=1* delims==" %%f in ("%line%") do (
call :extract %%f
)
if not "%scounter%"=="%counter%" goto :extractloop
set scounter=



cls
type %write%

for /f "tokens=1* delims==" %%f in ("%line%") do (
for /f "tokens=1* delims=+" %%h in ("%%g") do (
set run=%%h
set clear=%%i
))
call :set run=%%num[%run%]%%
call :set clear=%%num[%clear%]%%
if "%run%"=="%clear%" (set run=) else if defined clear (set /a clear=clear-1)
:clearloop
set /a clear=clear+1
call :set clearing=%%thing[%clear%]%%
:runloop
set /a run=run+1
call :set running=%%thing[%run%]%%
set product=
echo %running%+%clearing%=
set /p product=^
>
call :setthing %product%=%running%+%clearing%
cls
type %write%
if not "%run%"=="%clear%" goto :runloop
set run=
if not "%clear%"=="%max%" goto :clearloop
echo End reached . . .
pause>nul
exit


:set
set %*
goto :eof

:extract
call :set test=%%num[%*]%%
if not "%test%"=="" (set test=
goto :eof)
set /a max=max+1
set thing[%max%]=%*
set num[%*]=%max%
goto :eof

:setthing
for /f "tokens=1* delims==" %%f in ("%*") do (
set st.product=%%f
set st.reagents=%%g
)
if not "%st.reagents%"=="" goto :setloop
set st.product=
goto :eof

:setloop
for /f "tokens=1* delims=+" %%f in ("%st.product%") do (
call :extract %%f
echo %%f=%st.reagents%>>"%write%"
set st.product=%%g
)
if not "%st.product%"=="" goto :setloop
set st.reagents=
goto :eof

:makewrite
 > "%write%" echo air
>> "%write%" echo earth
>> "%write%" echo fire
>> "%write%" echo water
goto :eof