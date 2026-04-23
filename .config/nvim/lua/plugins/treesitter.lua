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

require('nvim-treesitter').setup({
  highlight = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      -- init_selection = 'gnn',
      -- scope_incremental = 'grc',
      node_incremental = '+',
      node_decremental = '-',
    },
  },
  indent = { enable = true },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['a='] = { query = '@assignment.outer', desc = '@assignment.outer' },
        ['i='] = { query = '@assignment.inner', desc = '@assignment.inner' },
        ['[='] = { query = '@assignment.lhs', desc = '@assignment.lhs' },
        [']='] = { query = '@assignment.rhs', desc = '@assignment.rhs' },
        -- vim use m for methods e.g. [m
        ['am'] = { query = '@function.outer', desc = '@function.outer' },
        ['im'] = { query = '@function.inner', desc = '@function.inner' },
        ['ac'] = { query = '@call.outer', desc = '@call.outer' },
        ['ic'] = { query = '@call.inner', desc = '@call.inner' },
        -- not selecting multiple lines of comment - FIXME
        -- ic = { query = '@comment.inner', desc = '@comment.inner' },
        -- ac = { query = '@comment.outer', desc = '@comment.outer' },
        ['aC'] = { query = '@class.outer', desc = '@class.outer' },
        ['iC'] = { query = '@class.inner', desc = '@class.inner' },
        -- a taken by 
        ['aA'] = { query = '@parameter.outer', desc = '@parameter.outer' },
        ['iA'] = { query = '@parameter.inner', desc = '@parameter.inner' },
        ['as'] = {
          query = '@local.scope',
          query_group = 'locals',
          desc = '@local.scope',
        },
        ['at'] = { query = '@type' },
      },
    },
  },
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		local filetype = vim.bo.filetype
		if filetype and filetype ~= "" then
			pcall(vim.treesitter.start)
		end
	end,
})

vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.bo.indentexpr = "v:lua.vim.treesitter.indentexpr()"
vim.wo.foldlevel = 99
