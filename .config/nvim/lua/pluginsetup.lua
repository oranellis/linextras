require('lualine').setup {
	options = {
		icons_enabled = false,
		theme = 'gruvbox',
		globalstatus = true,
	},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'branch', 'diff', 'diagnostics'},
		lualine_c = {'filename'},
		lualine_x = {'encoding', 'fileformat', 'filetype'},
		lualine_y = {'progress'},
		lualine_z = {'location'}
	}
}

require('nvim-treesitter.configs').setup {
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	}
}

require("nnn").setup({
	picker = {
		cmd = "NNN_TMPFILE=/home/$USER/.config/nnn/.lastd nnn -o",
		style = { border = "rounded" },
		session = "shared",
	},
	replace_netrw = "picker",
	quitcd = "lcd"
})

require("symbols-outline").setup {
	width = 25,
}

require("nvim-autopairs").setup {}

require('nvim_comment').setup {
	comment_empty = false,
}

vim.api.nvim_command('autocmd BufEnter *.cpp,*.hpp,*.c,*.h :lua vim.api.nvim_buf_set_option(0, "commentstring", "// %s")')

vim.api.nvim_command("imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'")
vim.api.nvim_command("smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'")
vim.api.nvim_command("imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'")
vim.api.nvim_command("smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'")

vim.g.fzf_history_dir = '~/.local/share/fzf-history'
vim.api.nvim_command("let $FZF_DEFAULT_COMMAND='find . ( -name node_modules -o -name .git -o -name build -o -name .cache ) -prune -o ! -type d -a -print'")
-- let $FZF_DEFAULT_COMMAND='find . \( -name node_modules -o -name .git -o -name build -o -name .cache \) -prune -o ! -type d -a -print'
