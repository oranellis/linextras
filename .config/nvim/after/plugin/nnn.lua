require("nnn").setup({
	picker = {
		cmd = "NNN_TMPFILE=/home/$USER/.config/nnn/.lastd nnn -o",
		style = { border = "rounded" },
		session = "shared",
		fullscreen = false
	},
	auto_close = true,
	replace_netrw = "picker",
	quitcd = "lcd"
})

-- Keymaps
vim.keymap.set('n', '<leader>n', vim.cmd.NnnPicker)

-- Colours
vim.api.nvim_set_hl(0, "NnnNormal", { link = 'GruvboxFg1' } )
vim.api.nvim_set_hl(0, "NnnBorder", { link = 'GruvboxFg1' } )
