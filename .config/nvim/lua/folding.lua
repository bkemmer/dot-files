-- Folding
vim.opt.foldcolumn = "0" -- remove extra info on folds
vim.opt.foldtext = "" -- the first line of the fold will be syntax highlighted, rather than all be one colour
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 4 -- This limits how deeply code gets folded

vim.o.foldmethod = 'expr'
-- Default to treesitter folding
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- Prefer LSP folding if client supports it
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
         local client = vim.lsp.get_client_by_id(args.data.client_id)
         if client:supports_method('textDocument/foldingRange') then
             local win = vim.api.nvim_get_current_win()
             vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
        end
    end,
 })


