vim.g.python_indent = {
  -- By default, Python code after parens gets indented 2 * shiftwidth, this changes it to just be
  -- shiftwidth.
  open_paren = "shiftwidth()"
}

vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4
