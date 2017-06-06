@echo off
:inputloop
set /p input=












:definething
set names=%*
set /a nextid=nextid+1
set id=%nextid%
set thing.name[%id%]=%1
:definething.nameloop
for /f "tokens=1*" %%f in ("%names%") do (
set thing[%%f]=%id%
set names=%%g
)
if not "%names%"=="" goto :definething.nameloop
set id=
goto :eof