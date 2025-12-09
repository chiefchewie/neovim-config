-- inspo: https://www.reddit.com/r/neovim/comments/1hkpgar/a_per_project_shadafile/
-- per 'project' shada file
--  where a 'project' is either a git repo, or the cwd

local function get_project_shada()
  local data_dir = vim.fn.stdpath('data')
  local cwd = vim.fn.getcwd()
  local project_root = vim.fs.root(cwd, ".git") or cwd

  local project_name = vim.fn.fnamemodify(project_root, ":t")
  local path_hash = vim.fn.sha256(project_root):sub(1, 8)
  local filename = project_name .. "_" .. path_hash .. ".shada"

  local shada_dir = vim.fs.joinpath(data_dir, "project_shada")
  vim.fn.mkdir(shada_dir, "p")

  return vim.fs.joinpath(shada_dir, filename)
end

local function switch_project_shada()
  if vim.o.shadafile ~= "" then
    vim.cmd('wshada!')
  end

  vim.o.shadafile = get_project_shada()

  if vim.o.shadafile ~= "" then
    vim.cmd('rshada!')
  end
end

vim.o.shadafile = get_project_shada()

-- Uncomment when ready for dynamic switching:
-- vim.api.nvim_create_autocmd("DirChanged", {
--   callback = switch_project_shada,
-- })
