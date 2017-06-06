@echo off

path %appdata%\spivee\batch\spelunkygen;%appdata%\spivee\batch\scriptfuncs

call preparevars
call fillgrid.row %tile.cave%
call fill.row 0 32
call placespecial 1 32 @
call placespecial 40 32 X
set /a x=%random%%%30+5
call placespecial %x% 32 I THIS SIGN WAS PLACED RANDOMLY
call printlevel %cd%\gentest.lvl
exit