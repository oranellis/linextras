local cmp = require('cmp')

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = {
		['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
		['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
		['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
		['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
		['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false }),
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' },
	}, {
		{ name = 'buffer' },
	})
})

cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'cmp_git' },
	}, {
		{ name = 'buffer' },
	})
})

cmp.setup.cmdline('/', {
	sources = {
		{ name = 'buffer' }
	}
})

cmp.setup.cmdline(':', {
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

vim.api.nvim_command('autocmd BufEnter *.cpp,*.hpp,*.c,*.h,*.cc :lua vim.api.nvim_buf_set_option(0, "commentstring", "// %s")')

vim.api.nvim_command("imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'")
vim.api.nvim_command("smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'")
vim.api.nvim_command("imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'")
vim.api.nvim_command("smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'")
