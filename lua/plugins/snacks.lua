return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    zen = { enabled = true, toggles = { dim = false, }, },
  },
  keys = {
    { "<leader>z", function() Snacks.zen() end,      desc = "Toggle Zen Mode" },
    { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
  }
}
