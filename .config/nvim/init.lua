-- =================== Plugins ===================

require('packer').startup(function()
	use 'wbthomason/packer.nvim' -- no keybinds
	use 'morhetz/gruvbox' -- no keybinds
	use 'sainnhe/everforest'
	use 'rust-lang/rust.vim' -- no keybinds
	use 'tpope/vim-surround' -- adds s nouns
	use 'terrortylor/nvim-comment' -- adds keybinds (gcc, gc(visual))
	use 'junegunn/fzf' -- no keybinds
	use 'junegunn/fzf.vim' -- no keybinds
	use 'luukvbaal/nnn.nvim'
	use 'tpope/vim-dispatch' -- no keybinds
	use 'neovim/nvim-lspconfig' -- no keybinds
	use 'ray-x/lsp_signature.nvim' -- no keybinds
	use 'hrsh7th/cmp-nvim-lsp' -- no keybinds
	use 'hrsh7th/cmp-buffer' -- no keybinds
	use 'hrsh7th/cmp-path' -- no keybinds
	use 'hrsh7th/cmp-cmdline' -- no keybinds
	use 'hrsh7th/nvim-cmp' -- no keybinds
	use 'hrsh7th/vim-vsnip'
	use 'nvim-treesitter/nvim-treesitter'
	use 'sbdchd/neoformat' -- no keybinds
	use {
	  'nvim-lualine/lualine.nvim',
	  requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}
	use 'ntpeters/vim-better-whitespace'
	use 'windwp/nvim-autopairs'
	use 'preservim/vimux' -- no keybinds
	use 'easymotion/vim-easymotion'
	use 'tpope/vim-fugitive' -- no keybinds
	use 'simrat39/symbols-outline.nvim'
	use {
	  'nvim-tree/nvim-tree.lua',
	  requires = { 'nvim-tree/nvim-web-devicons' },
	}
end)

-- =================== Unset Keys ===================

vim.api.nvim_set_keymap('n', 'gD', '<Nop>', {})
vim.api.nvim_set_keymap('n', 'gd', '<Nop>', {})
vim.api.nvim_set_keymap('n', '<F2>', '<Nop>', {})
vim.api.nvim_set_keymap('n', 'gh', '<Nop>', {})
vim.api.nvim_set_keymap('n', 'gi', '<Nop>', {})
vim.api.nvim_set_keymap('n', 'gt', '<Nop>', {})
vim.api.nvim_set_keymap('n', 'gr', '<Nop>', {})


-- =================== Configuration ===================

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- semicolon as leader
vim.g.mapleader = ";"
vim.opt.termguicolors = true

-- load legacy config
vim.cmd([[ so ~/.config/nvim/legacy.vim ]])

vim.api.nvim_set_option("updatetime", 100)
vim.api.nvim_set_option("so", 100)
vim.api.nvim_set_option("syntax", "on")
vim.api.nvim_set_option("hidden", true)
vim.api.nvim_set_option("autoread", true)
vim.api.nvim_win_set_option(0, "number", true)
vim.api.nvim_set_option("ruler", true)
vim.api.nvim_set_option("visualbell", true)
vim.api.nvim_win_set_option(0, "wrap", true)
vim.api.nvim_set_option("encoding", "utf-8")
vim.api.nvim_set_option("foldlevelstart", 99)

-- =================== Language Server Setup ===================

local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', ',e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
-- vim.api.nvim_set_keymap('n', 'ge', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
-- vim.api.nvim_set_keymap('n', 'gE', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
-- vim.api.nvim_set_keymap('n', ',q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	vim.api.nvim_set_keymap('n', '<leader>h', ':ClangdSwitchSourceHeader<cr>', {})
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', ',f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and map buffer local keybindings when the language server attaches
local servers = { 'clangd', 'zls', 'pyright' }
for _, lsp in pairs(servers) do
    require('lspconfig')[lsp].setup {
	    on_attach = on_attach,
        flags = {
            -- This will be the default in neovim 0.7+
            debounce_text_changes = 150,
        }
    }
end

require('lspconfig').clangd.setup{
    on_attach = on_attach,
    cmd = {
        "clangd",
        "--background-index",
        "--pch-storage=memory",
        "--clang-tidy",
        "--suggest-missing-includes",
        "--all-scopes-completion",
        "--pretty",
        "--header-insertion=never",
        "-j=4",
        "--inlay-hints",
        "--header-insertion-decorators",
    },
    filetypes = {"c", "cpp", "objc", "objcpp"},
    init_option = { fallbackFlags = {  "-std=c++2a"  } }
}

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
require('lspconfig').zls.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

require('lspconfig').pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities
}


-- =================== Cmp Setup ===================

local cmp = require'cmp'

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
	  ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
	  ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
	  ['<C-e>'] = cmp.mapping({
		  i = cmp.mapping.abort(),
		  c = cmp.mapping.close(),
		}),
	  ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently elected item. Set `select` to `false` to only confirm explicitly selected items.
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' }, -- For vsnip users.
		-- { name = 'luasnip' }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
	  }, {
		{ name = 'buffer' },
	  })
  })

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
	  }, {
		{ name = 'buffer' },
	  })
  })

cmp.setup.cmdline('/', {
	sources = {
	  { name = 'buffer' }
	}
  })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	sources = cmp.config.sources({
		{ name = 'path' }
	  }, {
		{ name = 'cmdline' }
	  })
  })

-- Setup lspconfig.
-- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- require('lspconfig')['clangd'].setup {
--   capabilities = capabilities
-- }

-- =================== Nvim Tree Setup ===================

local function on_attach(bufnr)
	local api = require('nvim-tree.api')

	local function opts(desc)
	return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true, hijack_cursor = true }
	end

	vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,		  opts('CD'))
	vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,	 opts('Open: In Place'))
	vim.keymap.set('n', '<C-k>', api.node.show_info_popup,			  opts('Info'))
	vim.keymap.set('n', '<C-r>', api.fs.rename_sub,					 opts('Rename: Omit Filename'))
	vim.keymap.set('n', '<C-t>', api.node.open.tab,					 opts('Open: New Tab'))
	vim.keymap.set('n', '<C-v>', api.node.open.vertical,				opts('Open: Vertical Split'))
	vim.keymap.set('n', '<C-x>', api.node.open.horizontal,			  opts('Open: Horizontal Split'))
	vim.keymap.set('n', '<BS>',  api.node.navigate.parent_close,		opts('Close Directory'))
	vim.keymap.set('n', '<CR>',  api.node.open.edit,					opts('Open'))
	vim.keymap.set('n', '<Tab>', api.node.open.preview,				 opts('Open Preview'))
	vim.keymap.set('n', '>',	 api.node.navigate.sibling.next,		opts('Next Sibling'))
	vim.keymap.set('n', '<',	 api.node.navigate.sibling.prev,		opts('Previous Sibling'))
	vim.keymap.set('n', '.',	 api.node.run.cmd,					  opts('Run Command'))
	vim.keymap.set('n', '-',	 api.tree.change_root_to_parent,		opts('Up'))
	vim.keymap.set('n', 'a',	 api.fs.create,						 opts('Create'))
	vim.keymap.set('n', 'bmv',   api.marks.bulk.move,				   opts('Move Bookmarked'))
	vim.keymap.set('n', 'B',	 api.tree.toggle_no_buffer_filter,	  opts('Toggle No Buffer'))
	vim.keymap.set('n', 'c',	 api.fs.copy.node,					  opts('Copy'))
	vim.keymap.set('n', 'C',	 api.tree.toggle_git_clean_filter,	  opts('Toggle Git Clean'))
	vim.keymap.set('n', '[c',	api.node.navigate.git.prev,			opts('Prev Git'))
	vim.keymap.set('n', ']c',	api.node.navigate.git.next,			opts('Next Git'))
	vim.keymap.set('n', 'd',	 api.fs.remove,						 opts('Delete'))
	vim.keymap.set('n', 'D',	 api.fs.trash,						  opts('Trash'))
	vim.keymap.set('n', 'E',	 api.tree.expand_all,				   opts('Expand All'))
	vim.keymap.set('n', 'e',	 api.fs.rename_basename,				opts('Rename: Basename'))
	vim.keymap.set('n', ']e',	api.node.navigate.diagnostics.next,	opts('Next Diagnostic'))
	vim.keymap.set('n', '[e',	api.node.navigate.diagnostics.prev,	opts('Prev Diagnostic'))
	vim.keymap.set('n', 'F',	 api.live_filter.clear,				 opts('Clean Filter'))
	vim.keymap.set('n', 'f',	 api.live_filter.start,				 opts('Filter'))
	vim.keymap.set('n', 'g?',	api.tree.toggle_help,				  opts('Help'))
	vim.keymap.set('n', 'gy',	api.fs.copy.absolute_path,			 opts('Copy Absolute Path'))
	vim.keymap.set('n', 'h',  api.node.navigate.parent_close,		opts('Close Directory'))
	vim.keymap.set('n', 'H',	 api.tree.toggle_hidden_filter,		 opts('Toggle Dotfiles'))
	vim.keymap.set('n', 'I',	 api.tree.toggle_gitignore_filter,	  opts('Toggle Git Ignore'))
	vim.keymap.set('n', 'J',	 api.node.navigate.sibling.last,		opts('Last Sibling'))
	vim.keymap.set('n', 'K',	 api.node.navigate.sibling.first,	   opts('First Sibling'))
	vim.keymap.set('n', 'l',	 api.node.open.edit,					opts('Open'))
	vim.keymap.set('n', 'm',	 api.marks.toggle,					  opts('Toggle Bookmark'))
	vim.keymap.set('n', 'o',	 api.node.open.edit,					opts('Open'))
	vim.keymap.set('n', 'O',	 api.node.open.no_window_picker,		opts('Open: No Window Picker'))
	vim.keymap.set('n', 'p',	 api.fs.paste,						  opts('Paste'))
	vim.keymap.set('n', 'P',	 api.node.navigate.parent,			  opts('Parent Directory'))
	vim.keymap.set('n', 'q',	 api.tree.close,						opts('Close'))
	vim.keymap.set('n', 'r',	 api.fs.rename,						 opts('Rename'))
	vim.keymap.set('n', 'R',	 api.tree.reload,					   opts('Refresh'))
	vim.keymap.set('n', 's',	 api.node.run.system,				   opts('Run System'))
	vim.keymap.set('n', 'S',	 api.tree.search_node,				  opts('Search'))
	vim.keymap.set('n', 'U',	 api.tree.toggle_custom_filter,		 opts('Toggle Hidden'))
	vim.keymap.set('n', 'W',	 api.tree.collapse_all,				 opts('Collapse'))
	vim.keymap.set('n', 'x',	 api.fs.cut,							opts('Cut'))
	vim.keymap.set('n', 'y',	 api.fs.copy.filename,				  opts('Copy Name'))
	vim.keymap.set('n', 'Y',	 api.fs.copy.relative_path,			 opts('Copy Relative Path'))
	vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,		   opts('Open'))
	vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
	vim.keymap.set('n', 'o', '', { buffer = bufnr })
	vim.keymap.del('n', 'o', { buffer = bufnr })
	vim.keymap.set('n', '<BS>', '', { buffer = bufnr })
	vim.keymap.del('n', '<BS>', { buffer = bufnr })
	vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
	vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))

end

-- =================== Plugin Setup ===================

-- lsp_signature.nvim
require "lsp_signature".setup {
	hint_prefix = "",
	floating_window = false
}

-- lualine
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

-- nvim-treesitter
require('nvim-treesitter.configs').setup {
	highlight = {
		enable = true,
	},
}

require('nvim-autopairs').setup {}

-- NNN
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

require('nvim_comment').setup {
	comment_empty = false,
}

require("nvim-tree").setup({ })

vim.api.nvim_command('autocmd BufEnter *.cpp,*.hpp,*.c,*.h :lua vim.api.nvim_buf_set_option(0, "commentstring", "// %s")')

-- =================== Keybinds ===================

-- custom quit commands
function check_empty()
	if vim.fn.expand('%:t') == "" then
		if vim.api.nvim_buf_line_count(0) and vim.fn.getline(1) == "" then
			return true
		end
	end
	return false
end

function custom_quit()
	if vim.fn.expand('%:t') == "" then
		if vim.api.nvim_buf_line_count(0) and vim.fn.getline(1) == "" then
			-- vim.api.nvim_command('q') -- quit on last invocation of 'q'
		else
			print("Enter a name for this buffer or leave blank to delete")
			local fname = vim.fn.input("File: ")
			if fname == "" then
				vim.api.nvim_command('bd!')
				if check_empty() then
					-- vim.api.nvim_command('q') -- quit on last invocation of 'q'
				end
			else
				vim.api.nvim_command('w ' .. fname)
				vim.api.nvim_command('bd')
				if check_empty() then
					-- vim.api.nvim_command('q') -- quit on last invocation of 'q'
				end
			end
		end
	else
		if vim.api.nvim_buf_get_option(0, 'readonly') == true then
			vim.api.nvim_command('bd!')
			if check_empty() then
				-- vim.api.nvim_command('q') -- quit on last invocation of 'q'
			end
		else
			vim.api.nvim_command('w')
			vim.api.nvim_command('bd')
			if check_empty() then
				-- vim.api.nvim_command('q') -- quit on last invocation of 'q'
			end
		end
	end
end
vim.api.nvim_set_keymap('n', '<leader>q', "<cmd>lua custom_quit()<cr>", {  })
-- vim.api.nvim_set_keymap('n', '<leader>q', ':wa<cr>:qa!<cr>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>w', ':wa<cr>', { silent = true })

-- file and buffer navigation
vim.api.nvim_set_keymap('n', '<leader>f', ':Files<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>b', ':Buffers<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>n', ':NnnPicker<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>t', ':NvimTreeOpen<cr>', {})

-- git shortcuts
vim.api.nvim_set_keymap('n', '<leader>gp', ':Git pull<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>gs', ':Git status<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>gc', ':Git commit -a<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>gu', ':Git push<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>ga', ':Git add -A<cr>', {})

-- window shortcuts (disabled in favour of learning C-W defaults)
-- vim.api.nvim_set_keymap('n', '<space>v', ':split<cr>', {})
-- vim.api.nvim_set_keymap('n', '<space>g', ':vsplit<cr>', {})
-- vim.api.nvim_set_keymap('n', '<space>h', '<c-w>h', {})
-- vim.api.nvim_set_keymap('n', '<space>j', '<c-w>j', {})
-- vim.api.nvim_set_keymap('n', '<space>k', '<c-w>k', {})
-- vim.api.nvim_set_keymap('n', '<space>l', '<c-w>l', {})
-- vim.api.nvim_set_keymap('n', '<space>w', '<c-w>q', {})

-- symbols-outline
vim.api.nvim_set_keymap('n', '<leader>s', ':SymbolsOutline<cr>', {})

-- terminals
vim.api.nvim_set_keymap('n', '<leader>c', ':! ', {})
vim.api.nvim_set_keymap('n', '<leader>m', ':wa<cr>:! autobuild<cr>', {})

-- =================== Colour Changes ===================

vim.cmd([[highlight Normal guibg=NONE ctermbg=NONE]])
