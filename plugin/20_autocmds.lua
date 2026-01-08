-- switch between relative/absolute line numbers when in normal/insert mode (credit https://github.com/sitiom/nvim-numbertoggle for the code)
local numbertoggle = G.augroup('numbertoggle')
G.autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  group = numbertoggle,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})

G.autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  group = numbertoggle,
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
      vim.cmd "redraw"
    end
  end,
})

-- highlight yanked text
G.autocmd("TextYankPost", {
  group = G.augroup("highlight_yank"),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- don't auto-wrap comments and don't insert comment leader after hitting 'o'
G.autocmd("FileType", {
  group = G.augroup("formatopts"),
  callback = function()
    vim.cmd('setlocal formatoptions-=c formatoptions-=o')
  end,
})

-- check if we need to reload the file when it changed
G.autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = G.augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- close some filetypes with <q>
G.autocmd("FileType", {
  group = G.augroup("close_with_q"),
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
      vim.keymap.set("n", "q", function()
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
G.autocmd({ "VimResized" }, {
  group = G.augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})
