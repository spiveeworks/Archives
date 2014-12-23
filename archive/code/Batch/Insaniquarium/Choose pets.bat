@echo off
set path=%appdata%\spivee\batch\scriptfuncs
for /f "tokens=1,2 eol=; delims==" %%a in (petnames.ini) do (set petnames[%%a]=%%b)
set /a num=%random% %% 6840
call getkperm combo=%num% 20 3
for /f "tokens=1,2,3" %%a in ("%combo%") do (
set one=%%a
set two=%%b
set three=%%c
)
call set one=%%petnames[%one%]%%
call set two=%%petnames[%two%]%%
call set three=%%petnames[%three%]%%
echo Choice one:        %one%
echo Choice two:        %two%
echo Choice three:      %three%
pause