-- [[ general ]]
vim.g.have_nerd_font          = true
vim.g.mapleader               = ' '                              -- Use `<Space>` as <Leader> key
vim.o.mouse                   = 'a'                              -- Enable mouse
vim.o.switchbuf               = 'usetab'                         -- Use already opened buffers when switching
vim.o.undofile                = true                             -- Enable persistent undo

-- ui related
vim.o.scrolloff               = 3
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

-- providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider    = 0
vim.g.loaded_perl_provider    = 0
vim.g.loaded_node_provider    = 0

-- autocommands
local augroup = function(name)
  return vim.api.nvim_create_augroup("config_" .. name, { clear = true })
end

local autocmd = vim.api.nvim_create_autocmd


-- autostart treesitter
autocmd("FileType", {
  group = augroup("treesitter"),
  callback = function(args)
    local bufnr = args.buf
    local ft = vim.bo[bufnr].filetype
    local lang = vim.treesitter.language.get_lang(ft)
    pcall(vim.treesitter.start, bufnr, lang)
  end
})

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
