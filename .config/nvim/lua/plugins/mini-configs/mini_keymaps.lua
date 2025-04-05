local km = vim.keymap
-- Mini.Bufremove
km.set("n", "<leader>bd", function() require("mini.bufremove").delete(0, false) end, { desc = "delete buffer" })
km.set("n", "<leader>bD", function() require("mini.bufremove").delete(0, true) end, { desc = "delete buffer (force)" })


-- km.set("n", "<leader>e", function() require("mini.files").open(vim.api.nvim_buf_get_name(0)) end, { desc = "explore" })
km.set("n", "<leader>fe", function() require("mini.files").open(vim.api.nvim_buf_get_name(0)) end, { desc = "explore" })


