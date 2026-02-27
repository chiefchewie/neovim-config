return {
  cmd = {
    '/usr/libexec/lua-language-server/lua-language-server',
    -- '/usr/libexec/lua-language-server/main.lua'
  },
  settings = {
    Lua = {
      workspace = {
        library = { vim.env.VIMRUNTIME },
      },
    },
  },
}
