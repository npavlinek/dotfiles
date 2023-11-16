setlocal formatoptions-=t
setlocal textwidth=88

" By default Vim uses 2×shiftwidth for continuation lines. Let's change this to just shiftwidth.
let g:pyindent_open_paren=shiftwidth()
