require('telescope').setup {
    defaults = { file_ignore_patterns = { '.git' },
        scroll_strategy = 'limit',
        sorting_strategy = "ascending", -- Descending is bugged and some items are cut off while scrolling
    },
}

local builtin = require('telescope.builtin')

vim.keymap.set({'n', 't'}, '<leader>b', builtin.buffers)
vim.keymap.set({'n', 't'}, '<leader>i', function()
    builtin.lsp_dynamic_workspace_symbols()
end, { silent = true, noremap = true })
vim.keymap.set({'n', 't'}, '<leader>s', function()
    builtin.grep_string({ search = vim.fn.input('Search: ') });
end)
vim.keymap.set({'n', 't'}, '<leader>f', function()
    builtin.find_files({hidden=true})
end)
