-- Install treesitter in a local setting without git clone
-- it requires that treesitter-cli is installed

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
-- parser_config.python = {
--   install_info = {
--     url = "~/projects/neovim/tree-sitter-python", -- local path to your tree-sitter-python clone
--     files = { "src/parser.c", "src/scanner.cc" }, -- note that these files are relative to the root of the repository
--     requires_generate_from_grammar = true, -- if true, it will run tree-sitter generate before installing
--   },
-- }


-- parser_config.dap_repl = {
--   install_info = {
--     url = "~/projects/neovim/nvim-dap-repl-highlights", -- local path to your treesitter clone
--     files = { "src/tree_sitter/parser.h", "src/tree_sitter/parser.h.gch" }, -- note that these files are relative to the root of the repository
--     requires_generate_from_grammar = true, -- if true, it will run tree-sitter generate before installing
--   },
-- }


require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "python", "dap_repl"},
}
