function SpaceIndent(indent)
  let &l:expandtab = 1
  let &l:shiftwidth = a:indent
  let &l:softtabstop = a:indent
endfunction

function TabIndent(indent)
  let &l:expandtab = 0
  let &l:shiftwidth = a:indent
  let &l:softtabstop = 0
  let &l:tabstop = a:indent
endfunction
