setlocal noexpandtab
setlocal shiftwidth=4
setlocal softtabstop=0
setlocal tabstop=4

" By default Vim uses 2×shiftwidth for continuation lines. Let's change this to just shiftwidth.
let g:pyindent_open_paren=shiftwidth()
