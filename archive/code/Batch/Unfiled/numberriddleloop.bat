call "%appdata%\spivee\batch\path\consoleextensions.bat"

:loop
for /f "tokens=5" %%x in ('call numberriddle.bat') do (echo %%x)
goto :loop