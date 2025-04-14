-- Install treesitter in a local setting without git clone
-- it requires that treesitter-cli is installed

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.python = {
  install_info = {
    url = "~/projects/tree-sitter-python", -- local path to your tree-sitter-python clone
    files = { "src/parser.c", "src/scanner.cc" }, -- note that these files are relative to the root of the repository
    requires_generate_from_grammar = true, -- if true, it will run tree-sitter generate before installing
  },
}

