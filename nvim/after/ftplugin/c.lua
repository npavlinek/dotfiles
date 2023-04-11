vim.opt_local.cindent = true
vim.opt_local.cinoptions = {
  "g0", -- No C++ scope declaration indentation.
  "l1", -- Indent case label contents as a scope.
}

vim.opt.formatoptions:remove("c")

vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2
