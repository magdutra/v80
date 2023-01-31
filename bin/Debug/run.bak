@echo off
echo Running tests. Please wait...

rem Delete previous log
if exist run.txt del run.txt

rem Check whether testbed dir exists
if exist testbed rd /s /q testbed
if not exist testbed md testbed

rem Change to testbed dir
cd testbed

rem Run tests for each sample file
for /f %%a in ('dir ..\samples\*.* /b /on') do call :Test %%a

rem Leave testbed dir
cd ..

rem Show test results
echo Done! Showing results...
start notepad run.txt

rem Exit
goto :eof

:Test

rem Print header with filename
echo -------------------------------------------->>..\run.txt
echo Testing %1>>..\run.txt
echo -------------------------------------------->>..\run.txt
echo. >>..\run.txt

rem Copy sample file to testbed
copy ..\samples\%1 . >nul

rem List files
..\V80 %1 -x -s -i>>..\run.txt 2>&1
echo. >>..\run.txt

rem Extract files
..\V80 %1 -r -s -i>>..\run.txt 2>&1
echo. >>..\run.txt

rem Delete files
..\v80 %1 -k */*>>..\run.txt 2>&1
echo. >>..\run.txt

rem Write new file
..\V80 %1 -w ..\F220.TXT >>..\run.txt 2>&1
echo. >>..\run.txt

rem Extract file
..\V80 %1 -r >>..\run.txt 2>&1
echo. >>..\run.txt

goto :eof
