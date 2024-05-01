local function on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	-- custom mappings
	vim.keymap.set("n", "h", api.tree.close, opts("Close"))
	vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
end

require("nvim-tree").setup({
	on_attach = on_attach,
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 40,
	},
	actions = {
		change_dir = {
			global = true,
		},
		open_file = {
			quit_on_open = true,
		},
	},
})

vim.keymap.set('n', '<leader>n', function ()
	require("nvim-tree.api").tree.open()
end)
