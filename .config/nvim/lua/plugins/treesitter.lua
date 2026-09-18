vim.pack.add({
        "https://github.com/romus204/tree-sitter-manager.nvim",
        "https://github.com/nvim-treesitter/nvim-treesitter",
        "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
})
require("tree-sitter-manager").setup({
      -- Optional: custom paths
      -- parser_dir = vim.fn.stdpath("data") .. "/site/parser",
      -- query_dir = vim.fn.stdpath("data") .. "/site/queries",
})
-- require("nvim-treesitter").setup()
-- require("nvim-treesitter-textobjects").setup()

-- On the `main` branch, setup() only honours `install_dir` — highlight,
-- indent, incremental_selection and textobjects are wired up by hand below.
require('nvim-treesitter').setup()

require('nvim-treesitter-textobjects').setup({
  select = { lookahead = true },
})

local select = require('nvim-treesitter-textobjects.select')

-- vim uses m for methods e.g. [m; `a`/`c`/`s` are taken by argument/call/scope
local textobjects = {
  ['a='] = '@assignment.outer',
  ['i='] = '@assignment.inner',
  ['am'] = '@function.outer',
  ['im'] = '@function.inner',
  ['ac'] = '@call.outer',
  ['ic'] = '@call.inner',
  ['aC'] = '@class.outer',
  ['iC'] = '@class.inner',
  ['aA'] = '@parameter.outer',
  ['iA'] = '@parameter.inner',
  ['at'] = '@type',
}

for lhs, query in pairs(textobjects) do
  vim.keymap.set({ 'x', 'o' }, lhs, function() select.select_textobject(query, 'textobjects') end, { desc = query })
end

-- @local.scope lives in the `locals` query group, not `textobjects`
vim.keymap.set({ 'x', 'o' }, 'as', function() select.select_textobject('@local.scope', 'locals') end,
  { desc = '@local.scope' })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function(args)
    if vim.bo[args.buf].filetype == "" then return end
    if pcall(vim.treesitter.start) then
      -- set after the ftplugin has run, otherwise it overwrites us
      vim.bo[args.buf].indentexpr = "v:lua.vim.treesitter.indentexpr()"
    end
  end,
})

vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldmethod = "expr"
vim.o.foldlevel = 99
