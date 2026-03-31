local km = vim.keymap
-- Mini.Bufremove
km.set("n", "<leader>bd", function() require("mini.bufremove").delete(0, false) end, { desc = "delete buffer" })
km.set("n", "<leader>bD", function() require("mini.bufremove").delete(0, true) end, { desc = "delete buffer (force)" })
-- Mini.Files
km.set("n", "<leader>fe", function() require("mini.files").open(vim.api.nvim_buf_get_name(0)) end, { desc = "explore" })

-- Mini.Trailspace
km.set("n", "<leader>ts", function() require("mini.trailspace").trim() end, { desc = "trim trailspace" })

-- Mini.Sessions
km.set("n", "<leader>ss", function() require("mini.sessions").write() end, { desc = "Session: save" })
km.set("n", "<leader>sl", function() require("mini.sessions").select() end, { desc = "Session: load" })
km.set("n", "<leader>sr", function() require("mini.sessions").read() end, { desc = "Session: Read last session" })

local function write_session()
  local cwd_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  vim.ui.input({ prompt = "Name: ", default = cwd_name }, function(name)
    MiniSessions.write(name)
  end)
end

km.set("n", "<leader>sw", function() write_session() end, { desc = "Session: Write" })


