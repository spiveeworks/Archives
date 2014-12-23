set foo=bar
call test %%foo%%
pause
exit

:test
echo %1
goto :eof