@echo off
set /p in=Enter file to grouplines^>
set /p out=Enter file to dump to^>
set width=8
call :process > "%out%"
goto :eof

:process
set count=
for /f "tokens=* usebackq delims=" %%f in ("%in%") do (
call :readline "%%f"
)
goto :eof

:readline
set /a count+=1
if %count%==%width% (echo %group% %~1
set count=
set group=
) else (
set group=%group% %~1
)