" By default Vim uses 2×shiftwidth for continuation lines. Let's change this to just shiftwidth.
let g:pyindent_open_paren=shiftwidth()

setlocal colorcolumn=+1
setlocal formatoptions-=t
setlocal textwidth=100
