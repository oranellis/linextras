require('telescope').setup {
	defaults = {
		prompt_prefix = '> ',
		selection_caret = '> ',
		entry_prefix = '  ',
	},
}

local builtin = require('telescope.builtin')
vim.keymap.set({'n', 't'}, '<leader>f', builtin.find_files, {})
vim.keymap.set({'n', 't'}, '<leader>b', builtin.buffers, {})
vim.keymap.set({'n', 't'}, '<leader>s', function()
	builtin.grep_string({ search = vim.fn.input('Search: ') });
end)
