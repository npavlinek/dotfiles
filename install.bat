@echo off

mklink      %USERPROFILE%\.gitconfig        %CD%\gitconfig
mklink      %USERPROFILE%\mercurial.ini     %CD%\hgrc
mklink /D   %APPDATA%\.emacs.d              %CD%\emacs
mklink /D   %USERPROFILE%\vimfiles          %CD%\vim
