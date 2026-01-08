-- [[ general ]]
vim.g.have_nerd_font = true
vim.g.mapleader      = ' '                              -- Use `<Space>` as <Leader> key
vim.o.mouse          = 'a'                              -- Enable mouse
vim.o.switchbuf      = 'usetab'                         -- Use already opened buffers when switching
vim.o.undofile       = true                             -- Enable persistent undo
vim.o.shada          = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file (for startup)

-- ui related
vim.o.number         = true
vim.o.relativenumber = true

vim.o.wrap           = false     -- Don't visually wrap lines (toggle with \w)
vim.o.breakindent    = true      -- Indent wrapped lines to match line start
vim.o.linebreak      = true      -- Wrap lines at 'breakat' (if 'wrap' is set)
vim.o.breakindentopt = 'list:-1' -- Add padding for lists (if 'wrap' is set)

vim.o.colorcolumn    = '+1'      -- Draw column on the right of maximum width
vim.o.signcolumn     = 'yes'     -- Always show signcolumn (less flicker)
vim.o.cursorline     = true      -- Enable current line highlighting
vim.o.showmode       = false     -- Don't show mode in command line

vim.o.splitbelow     = true      -- Horizontal splits will be below
vim.o.splitright     = true      -- Vertical splits will be to the right
vim.o.splitkeep      = 'screen'  -- Reduce scroll during window split
vim.o.winborder      = 'single'  -- Use border in floating windows

vim.o.list           = true
vim.o.listchars      = 'trail:·,nbsp:␣,tab:» ,extends:…,precedes:…'
vim.o.fillchars      = 'eob: ,fold:╌'

vim.o.foldlevel      = 10       -- Fold nothing by default; set to 0 or 1 to fold
vim.o.foldmethod     = 'indent' -- Fold based on indent level
vim.o.foldnestmax    = 10       -- Limit number of fold levels
vim.o.foldtext       = ''       -- Show text under fold with its highlighting

require("vim._extui").enable({})

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

-- per .git shada
local function get_project_shada()
  local data_dir = vim.fn.stdpath('data')
  local cwd = vim.fn.getcwd()
  local project_root = vim.fs.root(cwd, ".git")

  if not project_root then return "" end

  local project_name = vim.fn.fnamemodify(project_root, ":t")
  local path_hash = vim.fn.sha256(project_root):sub(1, 8)
  local filename = project_name .. "_" .. path_hash .. ".shada"
  local shada_dir = vim.fs.joinpath(data_dir, "project_shada")

  vim.fn.mkdir(shada_dir, "p")
  return vim.fs.joinpath(shada_dir, filename)
end

vim.o.shadafile = get_project_shada()


-- [[ general keymaps ]]
-- powerful <esc>
vim.keymap.set({ 'i', 's', 'n' }, '<esc>', function()
  if vim.snippet.active() then
    vim.snippet.stop()
  end
  vim.cmd('noh')
  return '<esc>'
end, { desc = 'Escape, clear hlsearch, and stop snippets', expr = true })

-- open diagnostic
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- quit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

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

-- ctrl+s save; exit insert mode
vim.keymap.set({ 's', 'i', 'n', 'v' }, '<C-s>', '<esc>:w<cr>', { desc = 'Exit insert mode and save changes' })

-- mini.pick keymaps
vim.keymap.set('n', '<Leader>ff', '<Cmd>Pick files<CR>', { desc = 'Find Files' })
vim.keymap.set('n', '<Leader>fb', '<Cmd>Pick buffers<CR>', { desc = 'Find Buffers' })
vim.keymap.set('n', '<Leader>fg', '<Cmd>Pick grep_live<CR>', { desc = 'Find (live Grep)' })
vim.keymap.set('n', '<Leader>fm', '<Cmd>Pick marks<CR>', { desc = 'Find Marks' })
vim.keymap.set('n', '<Leader>e', '<Cmd>lua MiniFiles.open()<CR>', { desc = "Explore directory" })


-- [[ general autocommands ]]
local augroup = function(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
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


-- [[ plugins ]]
vim.pack.add({
  { src = "https://github.com/catppuccin/nvim", name = "catpuccin" },
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/folke/lazydev.nvim",
})

require("catppuccin").setup { background = { dark = "macchiato" } }
vim.cmd.colorscheme "catppuccin"

local parsers = { "lua" }
local ts = require("nvim-treesitter")
ts.install(parsers)
autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
      ts.update()
    end
  end
})

require('mini.icons').setup()
require('mini.ai').setup()
require('mini.surround').setup()
require('mini.files').setup()
require('mini.extra').setup()
require('mini.pick').setup()

require("lazydev").setup {}


-- [[ lsp ]]
vim.lsp.enable({
  'lua_ls',
})

autocmd("LspAttach", {
  group = augroup("asdf"),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    local methods = vim.lsp.protocol.Methods
    if client:supports_method(methods.textDocument_completion) then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
    end
  end
})
