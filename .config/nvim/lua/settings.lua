-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Enable colours
vim.opt.termguicolors = true

-- Search highlighting
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- No backups
vim.opt.backup = false
vim.opt.writebackup = false

-- Persistent undo history
vim.opt.undodir = os.getenv("HOME") .. "/.cache/nvim/undo"
vim.opt.undofile = true

-- Persistent signcolumn
vim.opt.signcolumn = 'yes:1'

-- Mouse support
vim.opt.mouse = 'a'

-- Short messages
vim.opt.shortmess = 'cfilnxtToOF'

-- Use x11 clipboard
vim.opt.clipboard:prepend {"unnamed","unnamedplus"}

-- Fast updates
vim.opt.updatetime = 100

-- Gutter
vim.opt.number = true

-- Indent
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
-- vim.opt.autoindent = true
-- vim.opt.smartindent = true

-- Scrolloff
vim.opt.scrolloff = 8

-- Buffers
vim.opt.hidden = true
vim.opt.autoread = true

-- Visual bell
vim.opt.visualbell = true

-- Remap leader
vim.g.mapleader = ';'
