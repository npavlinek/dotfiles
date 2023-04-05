vim.opt.fileformats = { "unix", "dos" }
vim.opt.guifont = "Fira Mono:h10"
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.listchars = { tab = "→ ", space = "·" }
vim.opt.scrolloff = 8
vim.opt.shortmess:append("I")
vim.opt.sidescrolloff = 8
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.textwidth = 100
vim.opt.wrap = false

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4

require("np.map")
require("np.packer")
