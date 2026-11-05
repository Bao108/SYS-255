@echo off

for /F "tokens=2" %%d in ('date /t') do set mydate=%%d
set myuser=%username%
set myhost=%computername%
set mytime=%time%
echo You guessed it, %myuser% is on %myhost% currently at %mydata% : %mytime%

pause