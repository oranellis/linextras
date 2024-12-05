-- Remap leader
vim.g.mapleader = ';'

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Enable colours
vim.opt.termguicolors = true

-- Keep builtin highlighting on
vim.cmd.syntax 'enable'

-- No Text Wrap
vim.wo.wrap = false

-- Search highlight
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

-- Indent and indent function
local function TabStopGlobal(spaces)
  vim.opt.tabstop = spaces
  vim.opt.softtabstop = spaces
  vim.opt.shiftwidth = spaces
  vim.opt.expandtab = true
end
TabStopGlobal(2)

-- Scrolloff
vim.opt.scrolloff = 8

-- Buffers
vim.opt.hidden = true
vim.opt.autoread = true

-- Visual bell
vim.opt.visualbell = true

-- For whitespace highlighting
vim.g.better_whitespace_operator=''
vim.g.strip_whitespace_on_save=0
vim.g.strip_whitespace_confirm=0
