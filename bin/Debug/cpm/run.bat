@echo off
if exist dump.txt del dump.txt
for /f %%a in ('dir /b *.*') do echo %%a >> dump.txt& ..\v80 -v -cpm -sdc %%a >> dump.txt
start notepad dump.txt
