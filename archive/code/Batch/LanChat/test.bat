@echo off
rem for /f "tokens=1 delims==" %%f in ('set') do (set %%f=)
set /p runtype=Run under format: 
cmd /c "LeCom.bat %runtype%/%cd%\Public/%cd%\Dat\%runtype%"
echo press any key to exit . . .
pause>nul