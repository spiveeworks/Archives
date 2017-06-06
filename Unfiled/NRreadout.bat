call "%appdata%\spivee\batch\path\scriptextensions.bat"

call getouts >tmp.tmp
call readoutput <tmp.tmp
goto :eof