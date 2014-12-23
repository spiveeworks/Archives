set mode=lead
set string=#define VERSION_MAJOR_NUMBER   3 (version number (3333)  it );  // declaration. 
set out=test.txt
:loop
set char=%string:~0,1%
set string=%string:~1%
call :route[%mode%]
if not "%string%"=="" if not "%mode%"=="end" goto :loop
echo %secstring%>>"%out%"
goto :eof

:route[lead]
if "%char%"=="(" (set mode=mid
goto :eof)
set secstring=%secstring%%char%
goto :eof

:route[mid]
if "%char%"==")" (set mode=testclose
goto :eof)
set secstring=%secstring%%char%
goto :eof

:route[testclose]
if "%char%"==";" (set mode=end
goto :eof)
set secstring=%secstring%)%char%
set mode=mid
goto :eof
