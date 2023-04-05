vim.g.mapleader = " "

vim.keymap.set("i", "<C-C>", "<Esc>")

vim.keymap.set("n", "<C-D>", "<C-D>zz")
vim.keymap.set("n", "<C-U>", "<C-U>zz")
vim.keymap.set("n", "<Leader>p", [["*p]])
vim.keymap.set("n", "<Leader>q", "<Cmd>set list!<CR>")
vim.keymap.set("n", "<Leader>y", [["*y]])
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "n", "nzz")

vim.keymap.set("v", "<Leader>p", [["*p]])
vim.keymap.set("v", "<Leader>s", ":sort<CR>")
vim.keymap.set("v", "<Leader>y", [["*y]])
