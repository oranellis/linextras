local ensure_packer = function()
    local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

ensure_packer()

require('packer').startup(function(use)
    use { 'wbthomason/packer.nvim' }

    -- Navigation
    use { 'nvim-telescope/telescope.nvim',
        requires = 'nvim-lua/plenary.nvim',
    }
    use { 'nvim-tree/nvim-tree.lua' }
    use { 'famiu/bufdelete.nvim' }

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
    use { 'danymat/neogen' }

    -- Language Servers
    use { 'neovim/nvim-lspconfig' }
    use { 'simrat39/rust-tools.nvim' }

    -- Debugging
    use { 'rcarriga/nvim-dap-ui',
        requires = {
            'mfussenegger/nvim-dap',
            'nvim-neotest/nvim-nio',
            'theHamsta/nvim-dap-virtual-text'
        }
    }

    -- Clipboard
    use { 'EtiamNullam/deferred-clipboard.nvim' }
end)
