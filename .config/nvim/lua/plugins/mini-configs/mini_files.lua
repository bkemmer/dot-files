-- MINI.FILES

local show_dotfiles = true

local filter_show = function(fs_entry) return true end

local filter_hide = function(fs_entry)
    return not vim.startswith(fs_entry.name, '.')
end

local toggle_dotfiles = function()
    show_dotfiles = not show_dotfiles
    local new_filter = show_dotfiles and filter_show or filter_hide
    MiniFiles.refresh({ content = { filter = new_filter } })
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesBufferCreate',
  callback = function(args)
    local buf_id = args.data.buf_id
    -- Tweak left-hand side of mapping to your liking
    vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf_id })
  end,
})


local set_mark = function(id, path, desc)
  MiniFiles.set_bookmark(id, path, { desc = desc })
end
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesExplorerOpen',
  callback = function()
    set_mark('c', vim.fn.stdpath('config'), 'Config') -- path
    set_mark('w', vim.fn.getcwd, 'Working directory') -- callable
    set_mark('~', '~', 'Home directory')
  end,
})

-- replacing oil.nvim
require('mini.files').setup({
  -- Customization of shown content
  content = {
    -- Predicate for which file system entries to show
    filter = filter_show,
    -- What prefix to show to the left of file system entry
    -- prefix = function() end, -- uncomment this to remove icons
    -- In which order to show file system entries
    -- sort = "case_sensitive"
  },

  -- Module mappings created only inside explorer.
  -- Use `''` (empty string) to not create one.
  mappings = {
    close       = 'q',
    go_in       = 'l',
    go_in_plus  = '<CR>', -- Enter directory or open file, currently the only difference between the defaults
    go_out      = 'h',
    go_out_plus = 'H',
    mark_goto   = "'",
    markset    = 'm',
    reset       = '<BS>',
    reveal_cwd  = '@',
    show_help   = 'g?',
    synchronize = '=',
    trim_left   = '<',
    trim_right  = '>',
  },

  -- General options
  options = {
    -- Whether to delete permanently or move into module-specific trash
    permanent_delete = false,
    -- Whether to use for editing directories
    use_as_default_explorer = true,
  },

  -- Customization of explorer windows
  windows = {
    -- Maximum number of windows to show side by side
    max_number = math.huge,
    -- Whether to show preview of file/directory under cursor
    preview = true,
    -- Width of focused window
    width_focus = 50,
    -- Width of non-focused window
    width_nofocus = 15,
    -- Width of preview window
    width_preview = 50,
  },
})

-- Mini.Files Open()
vim.keymap.set("n", "<Leader>e", function()
      local buf_name = vim.api.nvim_buf_get_name(0)
      local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
      MiniFiles.open(path)
      MiniFiles.reveal_cwd()
    end, { desc = "Open Mini Files" })



