local neogen = require('neogen')

neogen.setup {
    enabled = true,
}

vim.api.nvim_set_keymap("n", "<Leader>dd", ":Neogen<CR>", { noremap = true, silent = true })
