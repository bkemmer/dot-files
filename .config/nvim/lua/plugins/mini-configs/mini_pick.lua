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
km.set("n", "<leader>cs", "<cmd>Pick lsp scope='document_symbol'<cr>", { desc = "document symbols" })
km.set("n", "<leader>cS", "<cmd>Pick lsp scope='workspace_symbol'<cr>", { desc = "workspace symbols" })
km.set("n", "<leader>ff", "<cmd>Pick files<cr>", { desc = "files" })
km.set("n", "<leader>fg", "<cmd>Pick git_files<cr>", { desc = "git files" })
km.set("n", "<leader>sh", "<cmd>Pick help<cr>", { desc = "[Seek] help" })
km.set("n", "<leader>sk", "<cmd>Pick keymaps<cr>", { desc = "[Seek]keymaps" })
km.set("n", "<leader>sb", "<cmd>Pick buf_lines<cr>", { desc = "[Seek] buffer lines" })
km.set("n", "<Leader>pr", "<cmd>Pick resume<cr>", { desc = "Resume last Pick" })
km.set("n", "<Leader>fh", "<cmd>Pick visted paths<cr>", { desc = "Open Mini Pick for visited paths ordered by robust frecency" })

