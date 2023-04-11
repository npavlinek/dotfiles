return require("packer").startup(function(use)
    use { "gruvbox-community/gruvbox" }
    use { "nvim-telescope/telescope.nvim", tag = "0.1.1", requires = { "nvim-lua/plenary.nvim" } }
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
    use { "wbthomason/packer.nvim" }
end)
