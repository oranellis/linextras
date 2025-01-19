local opts = { noremap=true, silent=true }

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ge', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gn', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gE', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gh', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua require("telescope.builtin").lsp_definitions()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua require("telescope.builtin").lsp_implementations()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gt', '<cmd>lua require("telescope.builtin").lsp_type_definitions()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gs', '<cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<cr>', opts)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

require('lspconfig').clangd.setup{
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>h', ':ClangdSwitchSourceHeader<cr>', opts)
    end,
    cmd = {
        "clangd",
        "--background-index",
        "--pch-storage=memory",
        "--all-scopes-completion",
        "--pretty",
        "--header-insertion=never",
        "-j=4",
        "--inlay-hints",
        "--header-insertion-decorators",
        "--function-arg-placeholders",
        "--completion-style=detailed",
    },
    filetypes = {"c", "cpp", "objc", "objcpp"},
    root_dir = require('lspconfig').util.root_pattern("src"),
    init_options = {
        fallbackFlags = {
            "-std=c++20",
        }
    },
    capabilities = capabilities
}

local lsp_formatting_cpp = function(bufnr)
    vim.lsp.buf.format({
        filter = function(client)
            return client.name == "clangd"
        end,
        bufnr = bufnr,
    })
end

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.cpp","*.cc","*.cxx","*.c","*.hpp","*.h"},
    callback = function(args)
        lsp_formatting_cpp(args.buf)
    end,
})

require('lspconfig').zls.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

require('lspconfig').pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

require('lspconfig').lua_ls.setup {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
    on_attach = on_attach,
    capabilities = capabilities
}

require('lspconfig').ts_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        completions = {
            completeFunctionCalls = true
        }
    }
}

require('lspconfig').yamlls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

require('lspconfig').cssls.setup {
    cmd = { 'css-languageserver', '--stdio' },
    on_attach = on_attach,
    capabilities = capabilities,
}

require('lspconfig').dockerls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

require('lspconfig').rust_analyzer.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        ['rust-analyzer'] = {
            workspace = {
                symbol = {
                    search = {
                        kind = "all_symbols"
                    },
                },
            },
        }
    }
}

local lsp_formatting_rust = function(bufnr)
    vim.lsp.buf.format({
        filter = function(client)
            return client.name == "rust_analyzer"
        end,
        bufnr = bufnr,
    })
end

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.rs"},
    callback = function(args)
        lsp_formatting_rust(args.buf)
    end,
})

require('lspconfig').bashls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}
