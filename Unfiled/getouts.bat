:getouts
for /l %%n in (
echo %%n ^| call numberriddle.bat
)
goto :eof