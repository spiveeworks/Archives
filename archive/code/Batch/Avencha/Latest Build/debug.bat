@echo on
@title Loading . . .
@prompt $G
@set /p var=^>
@"%var%" echo>log.log

@pause>nul
@goto :eof