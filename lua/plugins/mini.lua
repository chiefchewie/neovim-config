return
{
  'nvim-mini/mini.nvim',
  version = false,
  config = function()
    -- text editing
    require('mini.ai').setup()
    require('mini.move').setup()
    require('mini.pairs').setup()
    require('mini.surround').setup()

    -- general
    require('mini.diff').setup()
    require('mini.git').setup()
    require('mini.pick').setup()
    require('mini.extra').setup()

    -- appearance
    require('mini.icons').setup()
    require('mini.statusline').setup()
  end,
  keys = {
    { "<leader>ff", function() MiniPick.builtin.files() end,                            desc = "Find Files" },
    { "<leader>fb", function() MiniPick.builtin.buffers() end,                          desc = "Find Buffers" },
    { "<leader>fg", function() MiniPick.builtin.grep_live() end,                        desc = "Live Grep" },
    { "<leader>fG", function() MiniPick.builtin.grep({ pattern = '<cword>' }) end,      desc = "Find Grep" },
    { "<leader>fd", function() MiniExtra.pickers.diagnostic({ scope = 'all' }) end,     desc = "Find Diagnostics (all)" },
    { "<leader>fD", function() MiniExtra.pickers.diagnostic({ scope = 'current' }) end, desc = "Find Diagnostics (buf)" },
    { "<leader>fm", function() MiniExtra.pickers.marks() end,                           desc = "Find Marks" },
    { "<leader>fh", function() MiniPick.builtin.help() end,                             desc = "Find Help" },

    { "<leader>/",  function() MiniExtra.pickers.history({ scope = '/' }) end,          desc = "'/' History" },
    { "<leader>:",  function() MiniExtra.pickers.history({ scope = ':' }) end,          desc = "':' History" },
    { "<leader>e",  function() MiniExtra.pickers.explorer() end,                        desc = "File Explorer" },
  }
}
