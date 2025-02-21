require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  filters = {
    custom = { "^\\.git$", "\\.pyc$", "__pycache__", "^\\.github$", "^\\.vscode$", "^\\.venv" },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
