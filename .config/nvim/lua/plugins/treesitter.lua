vim.pack.add({{ src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' }})

-- require("nvim-treesitter").setup({})
require("nvim-treesitter").install({
	"bash",
	"c",
	"diff",
	"dockerfile",
	"gitcommit",
	"gitignore",
	"ini",
	"jsdoc",
	"json",
        "kitty",
        "latex",
	"lua",
	"luadoc",
	"luap",
	"make",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"regex",
	"sql",
	"terraform",
	"toml",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
})

-- Enable Highlighting by filetype
vim.api.nvim_create_autocmd('FileType', {
  pattern = { '<filetype>' },
  callback = function() vim.treesitter.start() end,
})

-- Enable Treesitter-based folding
vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo[0][0].foldmethod = 'expr'

-- Experimental Identation
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

