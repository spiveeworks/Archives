:add
set /a "$a=%~1^%~2"
set /a $b=%~1^&%~2
set /a "$b<<=1"
if "%$b%"=="0" (set return=%$a%
echo %$a%) else (call :add %$a% %$b%)
goto :eof