local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-P>", builtin.find_files)
vim.keymap.set("n", "<Leader>f", builtin.git_files)
