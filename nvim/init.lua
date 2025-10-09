vim.opt.fileformats = { "unix", "dos", "mac" }
vim.opt.listchars:append({ space = "·" })
vim.opt.shortmess:append("I")

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 8

vim.cmd.colorscheme("retrobox")

vim.g.mapleader = " "

vim.keymap.set("n", "<Leader><Leader>", "<Cmd>nohlsearch<CR>")
vim.keymap.set("n", "<Leader>q", "<Cmd>set list!<CR>")
vim.keymap.set("n", "<Leader>yy", '"*yy')
vim.keymap.set("n", "<Leader>z", "<Cmd>set spell!<CR>")
vim.keymap.set("v", "<Leader>s", ":sort<CR>")
vim.keymap.set("v", "<Leader>y", '"*y')
vim.keymap.set({ "n", "v" }, "<Leader>P", '"*P')
vim.keymap.set({ "n", "v" }, "<Leader>p", '"*p')
