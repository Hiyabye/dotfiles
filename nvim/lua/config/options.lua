-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Display
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.showmode = false

-- Indentation
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.smartindent = true

-- Editing
vim.o.wrap = false
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.mouse = "a"

-- Arrow keys wrap at line edges (VSCode-style)
vim.o.whichwrap = "h,l,<,>,[,]"

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Windows
vim.o.splitright = true
vim.o.splitbelow = true

vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)
