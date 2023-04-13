vim.opt_local.cindent = true
vim.opt_local.cinoptions = {
    "g0", -- No C++ scope declaration indentation.
    "l1", -- Indent case label contents as a scope.
}

vim.opt.formatoptions:remove("c")
