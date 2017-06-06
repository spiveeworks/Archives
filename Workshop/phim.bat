@echo on
title Phim Text Editor
setlocal enabledelayedexpansion
set /p name=^>
if "%name%"=="new" goto :start
set i=0
for /f "tokens=*" %%a in (%name%) do (
set /a "i+=1"
set line[%%A]=%%a
)
:start
set lineno=1
:loop
cls
for /l %%a in (1,1,%lineno%) do (
if defined line[%%a] echo %%a: !line[%%a]!
)
set /p line=%lineno%:^>
for /f "tokens=1,2*" %%a in ("%line%") do (
	if "%%a"==":g" (
		set line[%%b]=%%c
	) else if "%line%"==":q"
if not defined name (
	echo Please choose a filename (with an extension),
	echo or type :e to cancel.
	set /p name=^>
	if "%name%"==":e" goto :loop
		for /l %%a in (1,1,%lineno%) do (
			echo line[%%a]>>%name%
		)
	)
) else (
set line[%lineno%]=%line%
set /a "lineno+=1"
)
)
goto :loop