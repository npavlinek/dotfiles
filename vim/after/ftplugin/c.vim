" Taken from https://cvsweb.openbsd.org/ports/editors/vim/files/openbsd.vim
function! s:IgnoreParenIndent()
	let indent = cindent(v:lnum)
	if indent > 4000
		if cindent(v:lnum - 1) > 4000
			return indent(v:lnum - 1)
		else
			return indent(v:lnum - 1) + 4
		endif
	else
		return (indent)
	endif
endfun

setlocal cindent
setlocal cinoptions+=(4200
setlocal cinoptions+=+0.5s
setlocal cinoptions+=:0
setlocal cinoptions+=E-s
setlocal cinoptions+=N-s
setlocal cinoptions+=U4200
setlocal cinoptions+=g0
setlocal cinoptions+=j1
setlocal cinoptions+=l1
setlocal cinoptions+=t0
setlocal cinoptions+=u4200
setlocal colorcolumn=+1
setlocal foldmethod=marker
setlocal formatoptions+=j
setlocal indentexpr=s:IgnoreParenIndent()
setlocal textwidth=80
