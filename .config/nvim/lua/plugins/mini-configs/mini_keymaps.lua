local km = vim.keymap
-- Mini.Bufremove
km.set("n", "<leader>bd", function() require("mini.bufremove").delete(0, false) end, { desc = "delete buffer" })
km.set("n", "<leader>bD", function() require("mini.bufremove").delete(0, true) end, { desc = "delete buffer (force)" })
-- Mini.Files
km.set("n", "<leader>fe", function() require("mini.files").open(vim.api.nvim_buf_get_name(0)) end, { desc = "explore" })

-- Mini.Trailspace
km.set("n", "<leader>ts", function() require("mini.trailspace").trim() end, { desc = "trim trailspace" })
