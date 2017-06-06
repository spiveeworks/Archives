@echo off
set path=%appdata%\spivee\batch\scriptfuncs
for /f "tokens=1,2 eol=; delims==" %%a in (petnames.ini) do (set petnames[%%a]=%%b)
set /a num=%random% %% 362880
call getkperm combo=%num% 9 9
echo %combo%
pause