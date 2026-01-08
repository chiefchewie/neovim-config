-- [[ general ]]
vim.g.have_nerd_font = true
vim.g.mapleader      = ' '                              -- Use `<Space>` as <Leader> key
vim.o.mouse          = 'a'                              -- Enable mouse
vim.o.switchbuf      = 'usetab'                         -- Use already opened buffers when switching
vim.o.undofile       = true                             -- Enable persistent undo
vim.o.shada          = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file (for startup)

-- ui related
vim.o.number         = true          -- Show line numbers
vim.o.relativenumber = true

vim.o.wrap           = false              -- Don't visually wrap lines (toggle with \w)
vim.o.breakindent    = true               -- Indent wrapped lines to match line start
vim.o.linebreak      = true               -- Wrap lines at 'breakat' (if 'wrap' is set)
vim.o.breakindentopt = 'list:-1'          -- Add padding for lists (if 'wrap' is set)

vim.o.colorcolumn    = '+1'               -- Draw column on the right of maximum width
vim.o.signcolumn     = 'yes'              -- Always show signcolumn (less flicker)
vim.o.cursorline     = true               -- Enable current line highlighting
vim.o.showmode       = false              -- Don't show mode in command line

vim.o.splitbelow     = true               -- Horizontal splits will be below
vim.o.splitright     = true               -- Vertical splits will be to the right
vim.o.splitkeep      = 'screen'           -- Reduce scroll during window split
vim.o.winborder      = 'single'           -- Use border in floating windows

vim.o.list           = true
vim.o.listchars      = 'trail:·,nbsp:␣,tab:» ,extends:…,precedes:…'
vim.o.fillchars      = 'eob: ,fold:╌'

vim.o.foldlevel      = 10                -- Fold nothing by default; set to 0 or 1 to fold
vim.o.foldmethod     = 'indent'          -- Fold based on indent level
vim.o.foldnestmax    = 10                -- Limit number of fold levels
vim.o.foldtext       = ''                -- Show text under fold with its highlighting

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


-- global for passing some utils around
G = {}
G.augroup = function(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end
G.autocmd = vim.api.nvim_create_autocmd
