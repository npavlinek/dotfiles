" Based on: https://cgit.freebsd.org/src/tree/tools/tools/editing/freebsd.vim
function! s:GetIndent()
	let indent = cindent(v:lnum)
	if indent > 4000
		if cindent(v:lnum - 1) > 4000
			return indent(v:lnum - 1)
		else
			return indent(v:lnum - 1) + shiftwidth() / 2
		endif
	else
		return indent
	endif
endfunction

setlocal cindent
setlocal cinoptions+=(4200
setlocal cinoptions+=+0.5s	" Half indent for continuation line inside function.
setlocal cinoptions+=:0		" No case label indentation.
setlocal cinoptions+=E-s	" No C++ extern content indentation.
setlocal cinoptions+=N-s	" No C++ namespace content indentation.
setlocal cinoptions+=U4200
setlocal cinoptions+=g0		" No C++ scope declaration indentation.
setlocal cinoptions+=j1
setlocal cinoptions+=l1		" Align case content with label.
setlocal cinoptions+=t0		" No function return type indentation.
setlocal cinoptions+=u4200
setlocal formatoptions+=j
setlocal formatoptions-=c
setlocal indentexpr=s:GetIndent()
setlocal textwidth=79
