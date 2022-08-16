-- =================== Plugins ===================

require('packer').startup(function()
    use 'wbthomason/packer.nvim' -- no keybinds
    use 'morhetz/gruvbox' -- no keybinds
    use 'rust-lang/rust.vim' -- no keybinds
    use 'tpope/vim-surround' -- adds s nouns
    use 'tpope/vim-commentary' -- adds keybinds (gcc, gc(visual))
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
end)

-- =================== Unset Keys ===================

vim.api.nvim_set_keymap('n', 'gD', '<Nop>', {})
vim.api.nvim_set_keymap('n', 'gd', '<Nop>', {})
vim.api.nvim_set_keymap('n', '<F2>', '<Nop>', {})
vim.api.nvim_set_keymap('n', 'gh', '<Nop>', {})
vim.api.nvim_set_keymap('n', 'gi', '<Nop>', {})
vim.api.nvim_set_keymap('n', 'gt', '<Nop>', {})
vim.api.nvim_set_keymap('n', 'gr', '<Nop>', {})
vim.api.nvim_set_keymap('n', 'Q', 'q', { silent = true })


-- =================== Configuration ===================

-- semicolon as leader
vim.g.mapleader = ";"

-- load legacy config
vim.cmd([[ so ~/.config/nvim/legacy.vim ]])


-- =================== Language Server Setup ===================

local opts = { noremap=true, silent=true }
-- vim.api.nvim_set_keymap('n', ',e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
-- vim.api.nvim_set_keymap('n', 'ge', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
-- vim.api.nvim_set_keymap('n', 'gE', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
-- vim.api.nvim_set_keymap('n', ',q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
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

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
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


-- =================== Keybinds ===================

-- custom quit commands
vim.api.nvim_set_keymap('n', 'q', ':w<cr>:bd!<cr>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', ':wa<cr>:qa!<cr>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>z', ':bd!<cr>', { silent = true })

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

-- window shortcuts
vim.api.nvim_set_keymap('n', '<space>v', ':split<cr>', {})
vim.api.nvim_set_keymap('n', '<space>g', ':vsplit<cr>', {})
vim.api.nvim_set_keymap('n', '<space>h', '<c-w>h', {})
vim.api.nvim_set_keymap('n', '<space>j', '<c-w>j', {})
vim.api.nvim_set_keymap('n', '<space>k', '<c-w>k', {})
vim.api.nvim_set_keymap('n', '<space>l', '<c-w>l', {})
vim.api.nvim_set_keymap('n', '<space>w', '<c-w>q', {})

-- symbols-outline
vim.api.nvim_set_keymap('n', '<leader>s', ':SymbolsOutline<cr>', {})

-- terminals
vim.api.nvim_set_keymap('n', '<leader>c', ':! ', {})
vim.api.nvim_set_keymap('n', '<leader>m', ':! autobuild<cr>', {})
