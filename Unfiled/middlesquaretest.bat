@echo off
call scriptextensions
set max=20
set seed=12345
echo Generating %max% numbers
echo Starting seed: %seed%

call length infosize=%max%
cls
:loop
set /a count=count+1
set outcount=%count%
call length num=%count%
set /a num=infosize-num
for /l %%n in (1,1,%num%) do (
call set outcount=0%%outcount%%
)
call middlesquare seed=%seed%
echo %outcount%: %seed%
if not "%count%"=="%max%" (goto :loop)
pause
exit