function QuitIfNoNamedBuffer()
  if vim.fn.bufname('%') == '' and not vim.bo.modified then
    vim.cmd('quit')
  else
    print("Named buffer or unsaved changes exist")
  end
end

-- Map it to a key, for example <leader>q
vim.keymap.set('n', '<leader>q', QuitIfNoNamedBuffer, { noremap = true, desc = "QuitIfNoNamedBuffer" })

