@echo off
call :getconverts
set /p file=Enter file to binariise^>
call :process > bits.txt
goto :eof

:process
for /f "tokens=* usebackq delims=" %%f in ("%file%") do (
call :readline "%%f"
)
goto :eof

:readline
set line=%~1
:readline.loop
if not defined line goto :eof
call :usechar "%line:~0,1%"
set line=%line:~1%
goto :readline.loop

:usechar
call set value=%%binofhex[%~1]%%
if not defined value goto :eof
if defined left (echo %left%%value%
set left=) else (set left=%value%)
goto :eof

:getconverts

::Numeric Nibbles
set binofhex[0]=0000
set binofhex[1]=0001
set binofhex[2]=0010
set binofhex[3]=0011
set binofhex[4]=0100
set binofhex[5]=0101
set binofhex[6]=0110
set binofhex[7]=0111
set binofhex[8]=1000
set binofhex[9]=1001

::Upper case Alpha Nibbles
set binofhex[A]=1010
set binofhex[B]=1011
set binofhex[C]=1100
set binofhex[D]=1101
set binofhex[E]=1110
set binofhex[F]=1111

::Lower case Alpha Nibbles
set binofhex[a]=1010
set binofhex[b]=1011
set binofhex[c]=1100
set binofhex[d]=1101
set binofhex[e]=1110
set binofhex[f]=1111