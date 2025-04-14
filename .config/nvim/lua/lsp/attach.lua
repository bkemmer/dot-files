local M = {}

M.on_attach = function(client, bufnr)
    local keymapOptions = function(desc)
        return {
            nowait = true,
            noremap = true,
            silent = true,
            buffer = bufnr,
            desc = "LSP " .. desc,
        }
    end

    local toggle_diagnostic = function()
        local buffnr_opts = { bufnr = bufnr }
        vim.diagnostic.enable(not vim.diagnostic.is_enabled(buffnr_opts), buffnr_opts)
    end

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, keymapOptions("Go to declaration"))
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymapOptions("Go to definition"))
    vim.keymap.set("n", "gr", vim.lsp.buf.references, keymapOptions("Go to references"))
    vim.keymap.set("n", "K", vim.lsp.buf.hover, keymapOptions("Hover for info"))
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, keymapOptions("Go to implementation"))
    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, keymapOptions("Go to type definition"))
    vim.keymap.set("n", "<leader>e", vim.lsp.buf.rename, keymapOptions("Rename symbol"))
    vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, keymapOptions("Show code actions"))
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist, keymapOptions("Set quickfix list"))
    vim.keymap.set("n", "<leader>Q", toggle_diagnostic, keymapOptions("Toggle diagnostics"))

    -- if client.server_capabilities.inlayHintProvider then
    --     vim.lsp.inlay_hint.enable(true)
    -- end
end
M.capabilities = require("blink.cmp").get_lsp_capabilities()

return M

