local cmp = require('cmp')
local cmp_lsp = require("cmp_nvim_lsp")
local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp_lsp.default_capabilities()
)

-- Set up Mason and Mason LSP config
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "rust_analyzer", -- Ensure rust-analyzer is installed
        "lua_ls",
    }
})

-- Set up handlers for LSP servers, this will be triggered after servers are installed
require("mason-lspconfig").setup_handlers({
    -- Default handler for all servers
    function(server_name)
        require("lspconfig")[server_name].setup({
            capabilities = capabilities
        })
    end,

    -- Special configuration for lua_ls
    ["lua_ls"] = function()
        local lspconfig = require("lspconfig")
        lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = { version = "Lua 5.1" },
                    diagnostics = {
                        globals = { "vim", "it", "describe", "before_each", "after_each" },
                    },
                }
            }
        })
    end,
})

-- Set up CMP for autocompletion
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For luasnip users
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<c-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<c-y>'] = cmp.mapping.confirm({ select = true }),
        ["<c-space>"] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- for luasnip users
    }, {
        { name = 'buffer' },
    }),
})

-- configure diagnostics display
vim.diagnostic.config({
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})
