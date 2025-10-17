return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = 'VimEnter',
  config = function()
    local configs = require('nvim-treesitter.configs')
    configs.setup({
      ensure_installed = { 'c', 'cpp', 'lua', 'vim', 'vimdoc', 'query', 'javascript', 'typescript', 'html', 'python', 'rust', 'zig' },
      sync_install = false,
      auto_install = false,
      ignore_install = {},
      modules = {},
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = false },
    })
  end,
  cond = (function() return not vim.g.vscode end)
}
