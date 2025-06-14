return {
  {
    -- lazydev configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'williamboman/mason.nvim',           opts = {} },
      { 'williamboman/mason-lspconfig.nvim', opts = {} },

      -- Useful status updates for LSP.
      -- { 'j-hui/fidget.nvim', opts = {} },
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- local lspconfig = require('lspconfig')
      -- lspconfig.lua_ls.setup {}
      -- lspconfig.rust_analyzer.setup {}
      -- lspconfig.basedpyright.setup {}
      -- lspconfig.cssls.setup {}
      -- lspconfig.cssmodules_ls.setup {}
    end,
  }
}
