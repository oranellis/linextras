local fb_actions = require('telescope._extensions.file_browser.actions')

require('telescope').setup {
	defaults = {
		prompt_prefix = '> ',
		selection_caret = '> ',
		entry_prefix = '  ',
	},
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>n', require("telescope").extensions.file_browser.file_browser, {})
vim.keymap.set('n', '<leader>s', function()
	builtin.grep_string({ search = vim.fn.input('Search: ') });
end)
