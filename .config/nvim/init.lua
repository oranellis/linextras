-- =================== Plugins ===================

local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

require("packer").init({
	autoremove = true,
})

require("packer").startup(function(use)
	use "wbthomason/packer.nvim"
	use "neovim/nvim-lspconfig"
	use "hrsh7th/nvim-cmp"
	use {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-vsnip",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-cmdline",
		after = { "hrsh7th/nvim-cmp" },
		requires = { "hrsh7th/nvim-cmp" },
	}
	use('hrsh7th/vim-vsnip')
	use 'morhetz/gruvbox'
	use 'windwp/nvim-autopairs'
	use 'terrortylor/nvim-comment'
	use 'junegunn/fzf'
	use 'junegunn/fzf.vim'
	use 'luukvbaal/nnn.nvim'
	use 'tpope/vim-dispatch'
	use 'nvim-treesitter/nvim-treesitter'
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}
	use 'ntpeters/vim-better-whitespace'
	use 'tpope/vim-fugitive'
	use 'simrat39/symbols-outline.nvim'
	use 'simrat39/rust-tools.nvim'
end)

if packer_bootstrap then
	require("packer").sync()
	return
end

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

-- search highlighting
vim.o.hlsearch = true
vim.o.incsearch = false

-- no backups
vim.o.backup = false
vim.o.writebackup = false

-- persistent signcolumn
vim.wo.signcolumn = 'number'

-- mouse support
vim.o.mouse = 'a'

-- short message
vim.o.shortmess = 'cfilnxtToOF'

-- use x11 clipboard
vim.opt.clipboard:prepend {"unnamed","unnamedplus"}

-- dark background
vim.o.background='dark'

-- set colourscheme
local colorschemeok, _ = pcall(vim.cmd, 'colorscheme gruvbox')
if not colorschemeok then
	vim.cmd('colorscheme default')
end

vim.o.updatetime = 100
vim.o.so = 10
vim.o.syntax = "on"
vim.o.hidden = true
vim.o.autoread = true
vim.o.ruler = true
vim.o.visualbell = true
vim.o.encoding = "utf-8"
vim.o.foldlevelstart = 99
vim.api.nvim_win_set_option(0, "wrap", true)
vim.api.nvim_win_set_option(0, "number", true)

-- tabstop options
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = false
vim.o.autoindent = true
vim.o.smartindent = true

vim.api.nvim_command('autocmd BufRead,BufNewFile *.c setlocal colorcolumn=80')
vim.api.nvim_command('autocmd BufRead,BufNewFile *.h setlocal colorcolumn=80')
vim.api.nvim_command('autocmd BufRead,BufNewFile *.cpp setlocal colorcolumn=80')
vim.api.nvim_command('autocmd BufRead,BufNewFile *.hpp setlocal colorcolumn=80')

require('cmpsetup')
require('lspsetup')
require('pluginsetup')

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
			vim.api.nvim_command('q') -- quit on last invocation of 'q'
		else
			print("Enter a name for this buffer or leave blank to delete")
			local fname = vim.fn.input("File: ")
			if fname == "" then
				vim.api.nvim_command('bd!')
				if check_empty() then
					vim.api.nvim_command('q') -- quit on last invocation of 'q'
				end
			else
				vim.api.nvim_command('w ' .. fname)
				vim.api.nvim_command('bd')
				if check_empty() then
					vim.api.nvim_command('q') -- quit on last invocation of 'q'
				end
			end
		end
	else
		if vim.api.nvim_buf_get_option(0, 'readonly') == true then
			vim.api.nvim_command('bd!')
			if check_empty() then
				vim.api.nvim_command('q') -- quit on last invocation of 'q'
			end
		else
			vim.api.nvim_command('w')
			vim.api.nvim_command('bd')
			if check_empty() then
				vim.api.nvim_command('q') -- quit on last invocation of 'q'
			end
		end
	end
end

vim.api.nvim_set_keymap('n', '<leader>q', "<cmd>lua custom_quit()<cr>", {	})
vim.api.nvim_set_keymap('n', '<leader>w', ':wa<cr>', { silent = true })

-- file and buffer navigation
vim.api.nvim_set_keymap('n', '<leader>f', ':Files<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>b', ':Buffers<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>n', ':NnnPicker<cr>', {})

-- git shortcuts
vim.api.nvim_set_keymap('n', '<leader>gp', ':Git pull<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>gs', ':Git status<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>gc', ':Git commit -a<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>gu', ':Git push<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>ga', ':Git add -A<cr>', {})

-- symbols-outline
vim.api.nvim_set_keymap('n', '<leader>s', ':SymbolsOutline<cr>', {})

-- terminals
vim.api.nvim_set_keymap('n', '<leader>c', ':! ', {})
vim.api.nvim_set_keymap('n', '<leader>m', ':wa<cr>:! autobuild<cr>', {})

-- =================== Colour Changes ===================

vim.cmd([[highlight Normal guibg=NONE ctermbg=NONE]])

-- =================== Plugin Settings ===================

-- Markdown Viewer
vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 1
vim.g.mkdp_theme = 'light'
