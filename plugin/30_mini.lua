local now, later = MiniDeps.now, MiniDeps.later
local now_if_args = vim.fn.argc(-1) > 0 and MiniDeps.now or MiniDeps.later

-- Step one ===================================================================
now(function() vim.cmd('colorscheme miniwinter') end)
now(function() require('mini.notify').setup() end)
now(function() require('mini.statusline').setup() end)
now(function() require('mini.tabline').setup() end)

now_if_args(function()
  require('mini.files').setup({ windows = { preview = true } })
end)

now_if_args(function()
  require('mini.misc').setup()
  MiniMisc.setup_auto_root()
  MiniMisc.setup_restore_cursor()
end)

-- Step two ===================================================================
later(function() require('mini.extra').setup() end)
later(function() require('mini.bracketed').setup() end)
later(function() require('mini.cmdline').setup({ autocomplete = { enable = false} }) end)
later(function() require('mini.cursorword').setup() end)
later(function() require('mini.diff').setup() end)
later(function() require('mini.git').setup() end)
later(function() require('mini.move').setup() end)
later(function() require('mini.pairs').setup() end)
later(function() require('mini.pick').setup() end)
later(function() require('mini.splitjoin').setup() end)
later(function() require('mini.surround').setup() end)
