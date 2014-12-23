:readoutput
set /p line=
for /f "tokens=5" %%f in ("%line%") do (
echo %%f)
goto :eof