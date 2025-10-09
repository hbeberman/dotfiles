-- ~/.config/nvim/init.lua

-- Line numbers
vim.o.number = true

-- Line wrapping
vim.opt.whichwrap = vim.opt.whichwrap._value .. ",<,>,h,l"

-- Indentation
vim.o.expandtab = true   -- use spaces instead of tabs
vim.o.shiftwidth = 2     -- indentation size
vim.o.tabstop = 2        -- number of spaces per tab
vim.o.smartindent = true -- auto indent new lines

-- Search
vim.o.ignorecase = true  -- case insensitive search...
vim.o.smartcase = true   -- ...unless uppercase used
vim.o.incsearch = true   -- show matches as you type
vim.o.hlsearch = false   -- don’t highlight all matches

-- UI
vim.o.termguicolors = true
vim.o.cursorline = true

-- Clipboard
vim.o.clipboard = "unnamedplus"

-- Make Normal and Float windows transparent
vim.cmd [[
  hi Normal guibg=NONE ctermbg=NONE
  hi NormalFloat guibg=NONE ctermbg=NONE
]]

