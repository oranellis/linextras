require('telescope').setup {
    defaults = {
        file_ignore_patterns = { '.git' },
        scroll_strategy = 'limit',
        sorting_strategy = "ascending", -- Descending is bugged and some items are cut off while scrolling
        prompt_prefix=' 🔍 ',
        mappings = {
            i = {
                ["<Esc>"] = require('telescope.actions').close, -- Bind Escape key to close action
            },
        },
    },
    pickers = {
        lsp_dynamic_workspace_symbols = {
            -- Include all kinds of symbols, including functions
            symbol_kinds = {
                "File",
                "Module",
                "Namespace",
                "Package",
                "Class",
                "Method",
                "Property",
                "Field",
                "Constructor",
                "Enum",
                "Interface",
                "Function",  -- Add this to include functions
                "Variable",
                "Constant",
                "String",
                "Number",
                "Boolean",
                "Array",
                "Object",
                "Key",
                "Null",
                "EnumMember",
                "Struct",
                "Event",
                "Operator",
                "TypeParameter",
            },
        },
    }
}

local builtin = require('telescope.builtin')

vim.keymap.set({'n', 't'}, '<leader>b', builtin.buffers)
vim.keymap.set({'n', 't'}, '<leader>s', function()
    builtin.grep_string({ search = vim.fn.input('Search: ') });
end)
vim.keymap.set({'n', 't'}, '<leader>f', function()
    builtin.find_files({hidden=true})
end)

