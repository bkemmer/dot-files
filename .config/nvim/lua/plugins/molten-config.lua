vim.keymap.set("n", "<localleader>ip", function()
  local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
  if venv ~= nil then
    -- in the form of /home/benlubas/.virtualenvs/VENV_NAME
    venv = string.match(venv, "/.+/(.+)")
    vim.cmd((":MoltenInit %s"):format(venv))
  else
    vim.cmd(":MoltenInit python3")
  end
end, { desc = "Initialize Molten for python3", silent = true })
