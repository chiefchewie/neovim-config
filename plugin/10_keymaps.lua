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
vim.keymap.set('n', '<Leader>fg', '<Cmd>Pick grep_live<CR>', { desc = 'Live Grep' })
vim.keymap.set('n', '<Leader>fG', '<Cmd>Pick grep pattern="<cword>"<CR>', { desc = 'Grep current word' })
vim.keymap.set('n', '<Leader>fd', '<Cmd>Pick diagnostic scope="all"<CR>', { desc = 'Find Diagnostics (workspace)' })
vim.keymap.set('n', '<Leader>fD', '<Cmd>Pick diagnostic scope="current"<CR>', { desc = 'Find Diagnostics (buffer)' })
vim.keymap.set('n', '<Leader>fm', '<Cmd>Pick marks<CR>', { desc = 'Find Marks' })
vim.keymap.set('n', '<Leader>fh', '<Cmd>Pick help<CR>', { desc = 'Find Help' })
vim.keymap.set('n', '<Leader>/', '<Cmd>Pick history scope="/"<CR>', { desc = "'/' History" })
vim.keymap.set('n', '<Leader>:', '<Cmd>Pick history scope=":"<CR>', { desc = "':' History" })

vim.keymap.set('n', '<Leader>ee', '<Cmd>lua MiniFiles.open()<CR>', { desc = "Explore directory" })
vim.keymap.set('n', '<Leader>ef', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>',
  { desc = "Explore directory at current file" })
