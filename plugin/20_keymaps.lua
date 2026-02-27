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

-- keybinds for plugins
vim.keymap.set('n', '<Leader>ff', '<Cmd>Pick files<CR>', { desc = 'Find Files' })
vim.keymap.set('n', '<Leader>fb', '<Cmd>Pick buffers<CR>', { desc = 'Find Buffers' })
vim.keymap.set('n', '<Leader>fg', '<Cmd>Pick grep_live<CR>', { desc = 'Find (live Grep)' })
vim.keymap.set('n', '<Leader>fm', '<Cmd>Pick marks<CR>', { desc = 'Find Marks' })
vim.keymap.set('n', '<Leader>e', '<Cmd>lua MiniFiles.open()<CR>', { desc = "Explore directory" })
