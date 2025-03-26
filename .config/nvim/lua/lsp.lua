local capabilities = require('blink.cmp').get_lsp_capabilities()
local lspconfig = require('lspconfig')

lspconfig['lua_ls'].setup({ capabilities = capabilities })
lspconfig['jedi_language_server'].setup({ capabilities = capabilities })
lspconfig['pyright'].setup({ capabilities = capabilities })

