vim.pack.add({
  { src = "https://github.com/catppuccin/nvim",  name = "catpuccin" },
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/folke/lazydev.nvim",
  { src = 'https://github.com/Saghen/blink.cmp', version = vim.version.range('*') },
})

-- require("catppuccin").setup { background = { dark = "macchiato" } }
-- vim.cmd.colorscheme "catppuccin"
--
-- local ts = require("nvim-treesitter")
-- local parsers = { "lua" }
-- ts.install(parsers)
--
-- require("lazydev").setup {}
-- require("blink.cmp").setup {}
