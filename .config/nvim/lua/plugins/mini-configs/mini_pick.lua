local km = vim.keymap
local minipick = require("mini.pick")
local choose_all = function()
  local mappings = minipick.get_picker_opts().mappings
  vim.api.nvim_input(mappings.mark_all .. mappings.choose_marked)
end
minipick.setup({
  mappings = {
    choose_all = { char = "<c-q>", func = choose_all },
    -- sys_paste = { char = "<c-v>", func = function() minipick.set_picker_query({ vim.fn.getreg("+") }) end },
  },
})
vim.ui.select = minipick.ui_select
km.set("n", "<c-p>", "<cmd>Pick files<cr>", { desc = "Pick files" })
km.set("n", "<leader><leader>", "<cmd>Pick git_files<cr>", { desc = "Pick git files" })
km.set("n", "<leader>/", "<cmd>Pick grep_live<cr>", { desc = "Pick grep" })
km.set("n", "<leader>pb", "<cmd>Pick buffers<cr>", { desc = "Pick buffers" })
km.set("n", "<leader>ps", "<cmd>Pick lsp scope='document_symbol'<cr>", { desc = "Pick document symbols" })
km.set("n", "<leader>pS", "<cmd>Pick lsp scope='workspace_symbol'<cr>", { desc = "Pick workspace symbols" })
km.set("n", "<leader>pf", "<cmd>Pick files<cr>", { desc = "Pick files" })
km.set("n", "<leader>pg", "<cmd>Pick git_files<cr>", { desc = "Pick git files" })
km.set("n", "<leader>ph", "<cmd>Pick help<cr>", { desc = "Pick help" })
km.set("n", "<leader>pk", "<cmd>Pick keymaps<cr>", { desc = "Pick keymaps" })
km.set("n", "<leader>plb", "<cmd>Pick buf_lines<cr>", { desc = "Pick buffer lines" })
km.set("n", "<Leader>pr", "<cmd>Pick resume<cr>", { desc = "Resume last Pick" })
km.set("n", "<Leader>pv", "<cmd>Pick visted paths<cr>", { desc = "Pick visited paths by robust frecency" })

