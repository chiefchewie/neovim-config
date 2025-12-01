local centered_window_config = function()
  -- took this from :h MiniPick-examples
  -- 0.618 is 1/phi, which is aesthetically pleasing or something
  local height = math.floor(0.618 * vim.o.lines)
  local width = math.floor(0.618 * vim.o.columns)
  return {
    anchor = 'NW',
    height = height,
    width = width,
    row = math.floor(0.5 * (vim.o.lines - height)),
    col = math.floor(0.5 * (vim.o.columns - width)),
  }
end

return
{
  'nvim-mini/mini.nvim',
  version = false,
  config = function()
    -- text editing
    require('mini.ai').setup()
    require('mini.move').setup()
    require('mini.pairs').setup()
    require('mini.surround').setup()

    -- general
    require('mini.diff').setup()
    require('mini.git').setup()
    require('mini.pick').setup({
      window = {
        config = centered_window_config
      }
    })
    require('mini.files').setup()
    require('mini.extra').setup()

    -- appearance
    require('mini.icons').setup()
    require('mini.statusline').setup()

    -- keymaps
    local nmap_leader = function(suffix, rhs, desc)
      vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc })
    end

    nmap_leader('ff', '<Cmd>Pick files<CR>', 'Find Files')
    nmap_leader('fb', '<Cmd>Pick buffers<CR>', 'Find Buffers')
    nmap_leader('fg', '<Cmd>Pick grep_live<CR>', 'Live Grep')
    nmap_leader('fG', '<Cmd>Pick grep pattern="<cword>"<CR>', 'Grep current word')
    nmap_leader('fd', '<Cmd>Pick diagnostic scope="all"<CR>', 'Find Diagnostics (workspace)')
    nmap_leader('fD', '<Cmd>Pick diagnostic scope="current"<CR>', 'Find Diagnostics (buffer)')
    nmap_leader('fm', '<Cmd>Pick marks<CR>', 'Find Marks')
    nmap_leader('fh', '<Cmd>Pick help<CR>', 'Find Help')

    nmap_leader('/', '<Cmd>Pick history scope="/"<CR>', "'/' History")
    nmap_leader(':', '<Cmd>Pick history scope=":"<CR>', "':' History")
    nmap_leader('e', '<Cmd>Pick explorer<CR>', 'File Explorer')
  end
}
