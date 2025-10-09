cmd /c "mklink `"%USERPROFILE%\.gitconfig`" `"%CD%\gitconfig`""
cmd /c "mklink `"%USERPROFILE%\mercurial.ini`" `"%CD%\hgrc`""
cmd /c "mklink /d `"%USERPROFILE%\vimfiles`" `"%CD%\vim`""
cmd /c "mklink /d `"%USERPROFILE%\AppData\Local\nvim`" `"%CD%\nvim`""
