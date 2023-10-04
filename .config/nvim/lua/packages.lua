local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
		vim.cmd [[packadd packer.nvim]]
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
	use { 'wbthomason/packer.nvim' }

	-- Navigation
	use { 'nvim-telescope/telescope.nvim',
		requires = 'nvim-lua/plenary.nvim'
	}
	use { 'luukvbaal/nnn.nvim' }
	use { 'tpope/vim-fugitive' }

	-- Text Manipulation
	use { 'windwp/nvim-autopairs' }
	use { 'terrortylor/nvim-comment' }
	use { 'ntpeters/vim-better-whitespace' }

	-- Cosmetic
	use { 'ellisonleao/gruvbox.nvim' }
	use { 'lewis6991/gitsigns.nvim' }
	use { 'nvim-lualine/lualine.nvim',
		requires = 'kyazdani42/nvim-web-devicons'
	}
	-- use { 'ntpeters/vim-better-whitespace' }

	-- Completion Engine
	use { 'nvim-treesitter/nvim-treesitter' }
	use { 'hrsh7th/nvim-cmp' }
	use { 'hrsh7th/cmp-nvim-lsp' }
	use { 'hrsh7th/cmp-buffer' }
	use { 'hrsh7th/cmp-path' }
	use { 'hrsh7th/cmp-cmdline' }
	use { 'hrsh7th/cmp-vsnip' }
	use { 'hrsh7th/vim-vsnip' }
	use { 'windwp/nvim-ts-autotag' }

	-- Language Servers
	use { 'neovim/nvim-lspconfig' }
	use { 'simrat39/rust-tools.nvim' }

	if packer_bootstrap then
		require('packer').sync()
	end
end)
