-- [[ options ]]
vim.g.have_nerd_font          = true
vim.g.mapleader               = ' '                              -- Use `<Space>` as <Leader> key
vim.o.mouse                   = 'a'                              -- Enable mouse
vim.o.undofile                = true                             -- Enable persistent undo
vim.o.shada                   = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file (for startup)

vim.o.number                  = true
vim.o.relativenumber          = true

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

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider    = 0
vim.g.loaded_perl_provider    = 0
vim.g.loaded_node_provider    = 0


-- [[ keybinds ]]
-- powerful <esc>
vim.keymap.set({ 'i', 's', 'n' }, '<esc>', function()
  if vim.snippet.active() then vim.snippet.stop() end
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


-- [[ auto commands ]]
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
autocmd({ "DirChanged", "VimEnter" }, {
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

-- [[ plugins ]]
vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

require('mini.deps').setup()

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local now_if_args = vim.fn.argc(-1) > 0 and MiniDeps.now or MiniDeps.later

now(function() require('mini.icons').setup() end)
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
later(function() require('mini.extra').setup() end)
later(function() require('mini.diff').setup() end)
later(function() require('mini.git').setup() end)
later(function() require('mini.move').setup() end)
later(function() require('mini.pick').setup() end)
later(function() require('mini.splitjoin').setup() end)
later(function() require('mini.surround').setup() end)

now(function()
  add({
    source = 'catppuccin/nvim',
    name = 'catppuccin'
  })
  vim.cmd('color catppuccin')
end)

now_if_args(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  add('nvim-treesitter/nvim-treesitter-textobjects')
end)

now_if_args(function()
  add('neovim/nvim-lspconfig')
  vim.lsp.enable({
    'basedpyright',
    'lua_ls',
    'clangd'
  })
end)

now_if_args(function() 
  add({
    source = 'saghen/blink.cmp',
    depends = { 'rafamadriz/friendly-snippets' },
    checkout = "v1.9.1"
  })
  require('blink.cmp').setup()
end)

later(function()
  add('stevearc/conform.nvim')
  require('conform').setup({
    default_format_opts = {
      lsp_format = 'fallback',
    },
    formatters_by_ft = {
      python = { "isort", "ruff_format" },
    },
  })
end)

later(function() add('rafamadriz/friendly-snippets') end)
