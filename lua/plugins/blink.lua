return {
  'saghen/blink.cmp',
  event = 'VimEnter',
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = '1.*',
  opts = {
    keymap = { preset = 'default' },
    appearance = {
      nerd_font_variant = 'mono'
    },
  },
  opts_extend = { "sources.default" },
  cond = (function() return not vim.g.vscode end)
}
