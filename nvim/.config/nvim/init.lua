-- ~/.config/nvim/init.lua
--

-- Spacebar leader
vim.g.mapleader = " "

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


-- Setup the pckr nvim package manager  
local function bootstrap_pckr()
  local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

  if not (vim.uv or vim.loop).fs_stat(pckr_path) then
    vim.fn.system({
      'git',
      'clone',
      "--filter=blob:none",
      'https://github.com/lewis6991/pckr.nvim',
      pckr_path
    })
  end

  vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()

-- List of required plugins
require('pckr').add{
  "mason-org/mason.nvim",
  "mason-org/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  "mrcjkb/rustaceanvim",
  "mfussenegger/nvim-dap",
  "nvim-treesitter/nvim-treesitter",
}

-- Mason Setup
require("mason").setup({
    ui = {
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
        },
    }
})
-- Configure mason-lspconfig but DON'T auto-setup servers
-- We'll handle rust-analyzer manually via rustaceanvim
require("mason-lspconfig").setup({
  automatic_installation = false,
})

-- Rust tool setup
vim.g.rustaceanvim = {
  -- 🔧 Extra tooling configuration (optional)
  tools = {},

  -- 🧠 LSP configuration
  server = {
    on_attach = function(client, bufnr)
      -- ✅ Enable semantic tokens immediately on attach
      if client.server_capabilities.semanticTokensProvider then
        vim.defer_fn(function()
          -- Start semantic tokens for this buffer
          pcall(vim.lsp.semantic_tokens.start, bufnr)
          -- Refresh them immediately (no args in 0.11+)
          pcall(vim.lsp.semantic_tokens.refresh)
        end, 100)
      end

      -- ✅ Auto-format before saving
      local grp = vim.api.nvim_create_augroup("RustaceanFormat", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = grp,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })

      -- 🪄 Optional: keymaps
      -- local opts = { buffer = bufnr, silent = true }
      -- vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    end,

    default_settings = {
      ["rust-analyzer"] = {
        semanticHighlighting = true,   -- enable semantic tokens
        cargo = {
          allFeatures = true,
        },
        check = {
          command = "clippy",          -- run clippy on save
        },
      },
    },
  },

  -- 🪶 Debug Adapter Protocol config
  dap = {},
}

-- 🎨 Optional: define or fix missing highlight groups
vim.cmd [[
  hi! link @lsp.type.struct Type
  hi! link @lsp.type.enum Type
  hi! link @lsp.type.function Function
  hi! link @lsp.type.variable Identifier
  hi! link @lsp.type.parameter Identifier
  hi! link @lsp.typemod.function.defaultLibrary Function
]]


-- 🌲 Tree-sitter configuration
require('nvim-treesitter.configs').setup {
  -- Parsers to install automatically
  ensure_installed = {
    "rust",
    "lua",
    "vim",
    "bash",
    "toml",
    "json",
    "yaml",
    "markdown",
  },

  sync_install = false,  -- install parsers asynchronously

  highlight = {
    enable = true,                       -- enable highlighting
    additional_vim_regex_highlighting = false,  -- avoid duplicate highlights
  },

  indent = { enable = true },            -- optional, for autoindent
}


-- Use virtual_lines instead of virtual_text for diagnostics
vim.diagnostic.config({
  virtual_text = false,  -- Disable inline diagnostics
  virtual_lines = true,  -- Enable virtual_lines
})
