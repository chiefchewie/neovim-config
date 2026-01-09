-- [[ general ]]
vim.cmd('filetype plugin indent on')
vim.g.have_nerd_font          = true
vim.g.mapleader               = ' '                              -- Use `<Space>` as <Leader> key
vim.o.mouse                   = 'a'                              -- Enable mouse
vim.o.switchbuf               = 'usetab'                         -- Use already opened buffers when switching
vim.o.undofile                = true                             -- Enable persistent undo
vim.o.shada                   = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file (for startup)

-- ui related
vim.o.number                  = true
vim.o.relativenumber          = true

vim.o.wrap                    = false     -- Don't visually wrap lines (toggle with \w)
vim.o.breakindent             = true      -- Indent wrapped lines to match line start
vim.o.linebreak               = true      -- Wrap lines at 'breakat' (if 'wrap' is set)
vim.o.breakindentopt          = 'list:-1' -- Add padding for lists (if 'wrap' is set)

vim.o.signcolumn              = 'yes'     -- Always show signcolumn (less flicker)
vim.o.cursorline              = true      -- Enable current line highlighting
vim.o.showmode                = false     -- Don't show mode in command line

vim.o.splitbelow              = true      -- Horizontal splits will be below
vim.o.splitright              = true      -- Vertical splits will be to the right
vim.o.splitkeep               = 'screen'  -- Reduce scroll during window split
vim.o.winborder               = 'single'  -- Use border in floating windows

vim.o.list                    = true
vim.o.listchars               = 'trail:·,nbsp:␣,tab:» ,extends:…,precedes:…'
vim.o.fillchars               = 'eob: ,fold:╌'

vim.o.foldlevel               = 10       -- Fold nothing by default; set to 0 or 1 to fold
vim.o.foldmethod              = 'indent' -- Fold based on indent level
vim.o.foldnestmax             = 10       -- Limit number of fold levels
vim.o.foldtext                = ''       -- Show text under fold with its highlighting

-- editing
vim.o.autoindent              = true     -- Use auto indent
vim.o.expandtab               = true     -- Convert tabs to spaces
vim.o.smartindent             = true     -- Make indenting smart
vim.o.tabstop                 = 2        -- Show tab as this number of spaces
vim.o.shiftwidth              = 2        -- Use this number of spaces for indentation

vim.o.incsearch               = true     -- Show search matches while typing
vim.o.ignorecase              = true     -- Ignore case during search
vim.o.smartcase               = true     -- Respect case if search pattern has upper case

vim.o.virtualedit             = 'block'  -- Allow going past end of line in blockwise mode
vim.o.formatoptions           = 'rqnl1j' -- Improve comment editing

-- Providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider    = 0
vim.g.loaded_perl_provider    = 0
vim.g.loaded_node_provider    = 0


-- [[ general keymaps ]]
-- powerful <esc>
vim.keymap.set({ 'i', 's', 'n' }, '<esc>', function()
  if vim.snippet.active() then
    vim.snippet.stop()
  end
  vim.cmd('noh')
  return '<esc>'
end, { desc = 'Escape, clear hlsearch, and stop snippets', expr = true })

-- toggle diagnostic quickfix list
vim.keymap.set('n', '<leader>q', function()
  local loclist_winid = vim.fn.getloclist(0, { winid = 0 }).winid
  if loclist_winid ~= 0 then
    vim.cmd('lclose')
  else
    vim.diagnostic.setloclist()
  end
end, { desc = 'Toggle diagnostic [Q]uickfix list' })

-- enter normal mode with <esc><esc> while in term mode
vim.keymap.set('t', '<esc><esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- see `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- keep the cursor centered
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next result' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous result' })

-- stay in visual mode after indent
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('v', '<', '<gv')

-- yank/paste to system clipboard
vim.keymap.set('n', '<leader>Y', '"+y$', { desc = 'Yank line to system clipboard' })
vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set({ 'n', 'x' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard after cursor' })
vim.keymap.set({ 'n', 'x' }, '<leader>P', '"+P', { desc = 'Paste from system clipboard before cursor' })

-- [[ general autocommands ]]
local augroup = function(name)
  return vim.api.nvim_create_augroup("config_" .. name, { clear = true })
end

local autocmd = vim.api.nvim_create_autocmd

-- switch between relative/absolute line numbers when in normal/insert mode (credit https://github.com/sitiom/nvim-numbertoggle for the code)
local numbertoggle = augroup('numbertoggle')
autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  group = numbertoggle,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})

autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  group = numbertoggle,
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
    end
  end,
})

-- highlight yanked text
autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- a shada file per .git repo
autocmd("BufReadPre", {
  group = augroup("project_shada"),
  callback = function()
    local data_dir = vim.fn.stdpath('data')
    local cwd = vim.fn.getcwd()
    local project_root = vim.fs.root(cwd, ".git")

    if not project_root then return end

    local project_name = vim.fn.fnamemodify(project_root, ":t")
    local path_hash = vim.fn.sha256(project_root):sub(1, 8)
    local filename = project_name .. "_" .. path_hash .. ".shada"
    local shada_dir = vim.fs.joinpath(data_dir, "project_shada")
    vim.fn.mkdir(shada_dir, "p")

    local file = vim.fs.joinpath(shada_dir, filename)
    vim.o.shadafile = file
    if vim.uv.fs_stat(file) then
      vim.cmd.rshada { bang = true }
    end
  end
})

-- check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit", "gitrebase" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].cursor_did_restore then
      return
    end
    vim.b[buf].cursor_did_restore = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = { "checkhealth", "help", "notify", "qf" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- [[ plugins ]]
vim.pack.add({
  "https://github.com/BirdeeHub/lze",
  "https://github.com/nvim-mini/mini.nvim",
  { src = "https://github.com/catppuccin/nvim",                 name = "catppuccin" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", data = { opt = true } },
  { src = "https://github.com/neovim/nvim-lspconfig",           data = { opt = true } },
  { src = "https://github.com/folke/lazydev.nvim",              data = { opt = true } },
  { src = "https://github.com/saghen/blink.cmp",                data = { opt = true }, version = vim.version.range('1.*') },
  { src = "https://github.com/j-hui/fidget.nvim",               data = { opt = true } }
}, {
  load = function(p)
    if not (p.spec.data or {}).opt then
      vim.cmd.packadd(p.spec.name)
    end
  end,
  confirm = false
})

require("lze").load {
  {
    "catppuccin",
    after = function()
      require("catppuccin").setup { background = { dark = "macchiato" } }
      vim.cmd.colorscheme "catppuccin"
    end
  },
  {
    "nvim-treesitter",
    event = "FileType",
    after = function()
      local group = augroup("treesitter")
      autocmd("FileType", {
        group = group,
        callback = function(args)
          local bufnr = args.buf
          local ft = vim.bo[bufnr].filetype
          local lang = vim.treesitter.language.get_lang(ft)
          pcall(vim.treesitter.start, bufnr, lang)
        end
      })
      autocmd("PackChanged", {
        group = group,
        callback = function(ev)
          local name, kind = ev.data.spec.name, ev.data.kind
          if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
            vim.cmd "TSUpdate"
          end
        end
      })
    end
  },
  {
    "nvim-lspconfig",
    event = "FileType",
    after = function()
      vim.lsp.enable({ 'lua_ls', 'basedpyright' })
      require("vim._extui").enable({})

      local group = augroup("lsp")
      autocmd("LspAttach", {
        group = group,
        callback = function(args)
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
          local methods = vim.lsp.protocol.Methods
          if not client:supports_method(methods.textDocument_willSaveWaitUntil)
              and client:supports_method(methods.textDocument_formatting) then
            autocmd('BufWritePre', {
              group = group,
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
              end,
            })
          end
        end
      })
    end
  },
  {
    "lazydev.nvim",
    ft = "lua",
    after = function() require("lazydev").setup() end
  },
  {
    "mini.nvim1",
    load = function() end,
    event = "VimEnter",
    after = function()
      require("mini.icons").setup()
      require("mini.statusline").setup()
    end
  },
  {
    "mini.nvim2",
    load = function() end,
    event = { "BufReadPost", "BufNewFile" },
    after = function()
      require('mini.ai').setup()
      require('mini.move').setup()
      require('mini.surround').setup()
      require('mini.git').setup()
      require('mini.diff').setup()
    end
  },
  {
    "mini.nvim3",
    load = function() end,
    keys = {
      { '<Leader>ff', '<Cmd>Pick files<CR>',           { desc = 'Find Files' } },
      { '<Leader>fb', '<Cmd>Pick buffers<CR>',         { desc = 'Find Buffers' } },
      { '<Leader>fg', '<Cmd>Pick grep_live<CR>',       { desc = 'Find (live Grep)' } },
      { '<Leader>fm', '<Cmd>Pick marks<CR>',           { desc = 'Find Marks' } },
      { '<Leader>e',  '<Cmd>lua MiniFiles.open()<CR>', { desc = "Explore directory" } },
    },
    after = function()
      require("mini.pick").setup()
      require("mini.files").setup()
      require("mini.extra").setup()
    end
  },
  {
    "mini.pairs",
    load = function() end,
    event = "InsertEnter",
    after = function() require("mini.pairs").setup() end
  },
  {
    "blink.cmp",
    event = { "InsertEnter", "LspAttach", "CmdlineEnter" },
    after = function() require('blink.cmp').setup() end,
  },
  {
    "fidget.nvim",
    event = "LspAttach",
    after = function() require("fidget").setup {} end,
  },
}
