@echo off
rem -- Run Vim --

SET scriptdir=%~dp0
SET scriptdir=%scriptdir:~0,-1%

setlocal
set PROGRAM_FILES_VIM_EXE_DIR=C:\Program Files (x86)\Vim\vim81

if exist "%VIM%\vim81\gvim.exe" set PROGRAM_FILES_VIM_EXE_DIR=%VIM%\vim81

if exist "%VIMRUNTIME%\gvim.exe" set PROGRAM_FILES_VIM_EXE_DIR=%VIMRUNTIME%

if exist "%PROGRAM_FILES_VIM_EXE_DIR%\gvim.exe" goto hasgvimdotexe
echo could not find the program "%PROGRAM_FILES_VIM_EXE_DIR%\gvim.exe"
goto eof



:hasgvimdotexe
rem collect the arguments in VIMARGS for Win95
set VIMARGS=
set VIMNOFORK=
:findnofork
if .%1==. goto loopend
if NOT .%1==.--nofork goto noforklongarg
set VIMNOFORK=1
:noforklongarg
if NOT .%1==.-f goto noforkarg
set VIMNOFORK=1
:noforkarg
set VIMARGS=%VIMARGS% %1
shift
goto findnofork
:loopend

rem for WinNT we can use %*
if .%VIMNOFORK%==.1 goto nofork
 
set VIMBOX_OVERRIDING_INIT=1 && start "dummy" /b "%PROGRAM_FILES_VIM_EXE_DIR%\gvim.exe" -u "%scriptdir%\..\dotVimRc " %*
goto eof

:nofork
set VIMBOX_OVERRIDING_INIT=1 && start "dummy" /b /wait "%PROGRAM_FILES_VIM_EXE_DIR%\gvim.exe" -u "%scriptdir%\..\dotVimRc " %*

:eof
set VIMARGS=
set VIMNOFORK=
