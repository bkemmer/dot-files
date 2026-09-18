-- mini snippets
local gen_loader = require('mini.snippets').gen_loader
require('mini.snippets').setup({
  snippets = {
    -- Load snippets based on current language by reading files from
    -- "snippets/" subdirectories from 'runtimepath' directories.
    -- This is what picks up friendly-snippets.
    gen_loader.from_lang(),
  },
})
