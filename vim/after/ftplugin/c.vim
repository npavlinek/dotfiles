setlocal cindent
setlocal cinoptions+=(0,Ws
setlocal cinoptions+=:0     " No switch case label indentation.
setlocal cinoptions+=E-s    " No C++ extern content indentation.
setlocal cinoptions+=Ls
setlocal cinoptions+=N-s    " No C++ namespace content indentation.
setlocal cinoptions+=g0     " No C++ scope declaration indentation.
setlocal cinoptions+=j1     " C++ lambda indentation
setlocal cinoptions+=l1     " Align case content with label.
setlocal formatoptions+=j
setlocal formatoptions-=c
