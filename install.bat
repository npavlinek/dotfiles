@echo off

mklink "%USERPROFILE%\.gitconfig" "%CD%\gitconfig"
mklink "%USERPROFILE%\mercurial.ini" "%CD%\hgrc"
mklink /D "%USERPROFILE%\vimfiles" "%CD%\vim"
