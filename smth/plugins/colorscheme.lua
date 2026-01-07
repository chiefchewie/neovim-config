return {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup {
      flavour = "auto",
      background = {
        light = "latte",
        dark = "macchiato",
      }
    }
    vim.cmd.colorscheme "catppuccin"
  end,
}
