-- [[ general ]]
vim.g.have_nerd_font = true
vim.g.mapleader      = ' '                              -- Use `<Space>` as <Leader> key
vim.o.mouse          = 'a'                              -- Enable mouse
vim.o.switchbuf      = 'usetab'                         -- Use already opened buffers when switching
vim.o.undofile       = true                             -- Enable persistent undo
vim.o.shada          = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file (for startup)

-- enable all filetype plugins and syntax (if not enabled, for better startup)
vim.cmd('filetype plugin indent on')
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

-- ui related
vim.o.number                  = true -- Show line numbers
vim.o.relativenumber          = true

vim.o.wrap                    = false     -- Don't visually wrap lines (toggle with \w)
vim.o.breakindent             = true      -- Indent wrapped lines to match line start
vim.o.linebreak               = true      -- Wrap lines at 'breakat' (if 'wrap' is set)
vim.o.breakindentopt          = 'list:-1' -- Add padding for lists (if 'wrap' is set)

vim.o.colorcolumn             = '+1'      -- Draw column on the right of maximum width
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
vim.o.autoindent              = true                  -- Use auto indent
vim.o.expandtab               = true                  -- Convert tabs to spaces
vim.o.smartindent             = true                  -- Make indenting smart
vim.o.tabstop                 = 2                     -- Show tab as this number of spaces
vim.o.shiftwidth              = 2                     -- Use this number of spaces for indentation

vim.o.incsearch               = true                  -- Show search matches while typing
vim.o.ignorecase              = true                  -- Ignore case during search
vim.o.smartcase               = true                  -- Respect case if search pattern has upper case

vim.o.spelloptions            = 'camel'               -- Treat camelCase word parts as separate words
vim.o.virtualedit             = 'block'               -- Allow going past end of line in blockwise mode
vim.o.iskeyword               = '@,48-57,_,192-255,-' -- Treat dash as `word` textobject part
vim.o.formatoptions           = 'rqnl1j'              -- Improve comment editing

-- providers
vim.g.loaded_node_provider    = 0
vim.g.loaded_perl_provider    = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider    = 0

require("vim._extui").enable({})


-- [[ keymaps ]]
local map = vim.keymap
map.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- diagnostic keymaps
map.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- exit terminal mode
map.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- see `:help wincmd` for a list of all window commands
map.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- stay in visual mode after indent
map.set('v', '>', '>gv')
map.set('v', '<', '<gv')

-- <leader> prefix for copy/paste from system clipboard
map.set('n', '<leader>Y', '"+y$', { desc = 'Yank line to system clipboard' })
map.set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
map.set({ 'n', 'x' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard after cursor' })
map.set({ 'n', 'x' }, '<leader>P', '"+P', { desc = 'Paste from system clipboard before cursor' })


-- [[ generl autocommands ]]
local augroup = function(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

local autocmd = vim.api.nvim_create_autocmd

-- switch between relative/absolute line numbers when in normal/insert mode (credit https://github.com/sitiom/nvim-numbertoggle for the code)
local numbertoggle = augroup('numbertoggle')
autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  pattern = "*",
  group = numbertoggle,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})

autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  pattern = "*",
  group = numbertoggle,
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
      vim.cmd "redraw"
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

-- don't auto-wrap comments and don't insert comment leader after hitting 'o'
autocmd("FileType", {
  pattern = '*',
  group = augroup("formatopts"),
  callback = function()
    vim.cmd('setlocal formatoptions-=c formatoptions-=o')
  end,
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

-- close some filetypes with <q>
autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      map.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- resize splits if window got resized
autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})


-- [[ plugins ]]
vim.pack.add({
  { src = "https://github.com/catppuccin/nvim",  name = "catpuccin" },
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/folke/lazydev.nvim",
  { src = 'https://github.com/Saghen/blink.cmp', version = vim.version.range('*') }
})


require("catppuccin").setup {
  background = { light = "latte", dark = "macchiato" }
}
vim.cmd.colorscheme "catppuccin"

local ts_parsers = {
  "lua"
}
local ts = require("nvim-treesitter")
ts.install(ts_parsers)

require("lazydev").setup {}

require("blink.cmp").setup {}


-- lsp
vim.lsp.enable({
  'lua_ls',
})
