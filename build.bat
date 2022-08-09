@echo off
call cl -nologo -O2 -W4 -Fewin32_install install.c -link -incremental:no
