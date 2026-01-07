-- thanks to https://github.com/xaaha/dev-env/blob/main/nvim/.config/nvim/lua/xaaha/plugins/lsp-nvim-treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    event = "BufRead",
    branch = "main",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "c",
        "css",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "json5",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
        "ruby",
      },
    },
    config = function(_, opts)
      if not (opts.ensure_installed and #opts.ensure_installed > 0) then
        return
      end

      require("nvim-treesitter").install(opts.ensure_installed)
      for _, parser in ipairs(opts.ensure_installed) do
        -- the parser we specified *is* the filetype/language name
        local filetypes = parser
        vim.treesitter.language.register(parser, filetypes)
        vim.api.nvim_create_autocmd({ "FileType" }, {
          pattern = filetypes,
          callback = function(event)
            -- highlight
            vim.treesitter.start(event.buf, parser)

            -- fold
            -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            -- vim.wo.foldmethod = 'expr'

            -- indent
            -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end,
        })
      end
    end,
  }
}
