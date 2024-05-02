local function on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	local function edit_or_enter()
		local node = api.tree.get_node_under_cursor()
		if node.type == "directory" and not node.open then
			api.node.open.edit()
			vim.cmd.normal('j')
		else
			api.node.open.edit()
		end
	end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	-- custom mappings
	vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Parent Directory'))
	vim.keymap.set('n', 'l', edit_or_enter, opts('Open'))
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
