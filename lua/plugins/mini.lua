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
    require('mini.git').setup()
    require('mini.diff').setup()
    require('mini.sessions').setup()

    -- appearance
    require('mini.icons').setup()
    require('mini.starter').setup()
    require('mini.statusline').setup()
  end
}
