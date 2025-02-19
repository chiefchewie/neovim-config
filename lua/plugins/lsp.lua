return {
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
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
			-- 'WhoIsSethDaniel/mason-tool-installer.nvim',

			-- Useful status updates for LSP.
			-- { 'j-hui/fidget.nvim', opts = {} },

			-- Allows extra capabilities provided by nvim-cmp
			-- 'hrsh7th/cmp-nvim-lsp',
		},
		config = function()
			require('lspconfig').lua_ls.setup {}
			require('lspconfig').rust_analyzer.setup {}
		end,
	}
}
