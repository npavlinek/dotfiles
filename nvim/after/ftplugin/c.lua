vim.opt_local.cindent = true

vim.opt_local.cinoptions:append({
    "(0",   -- Align function arguments to opening paren.
    ":0",   -- Don't indent switch case labels.
    "E-s",  -- Don't indent extern block contents.
    "N-s",  -- Don't indent C++ namespace contents.
    "g0",   -- Don't indent C++ scope declarations.
    "j1",   -- ???
    "l1",   -- Align switch case contents with label.
    "t0",   -- Don't indent function return, if on its own line.
})
