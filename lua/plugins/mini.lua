return
{
  'nvim-mini/mini.nvim',
  version = false,
  config = function()
    -- text editing
    require('mini.surround').setup()

    -- general
    require('mini.git').setup()
    require('mini.diff').setup()

    -- appearance
    require('mini.icons').setup()
    if not vim.g.vscode then
      require('mini.statusline').setup()
    end
  end
}
