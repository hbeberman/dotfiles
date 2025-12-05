-- ~/.config/nvim/init.lua
--

-- Spacebar leader
vim.g.mapleader = " "

-- Scrolloff
vim.o.scrolloff = 3

-- Set foldmethod
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = false
vim.opt.foldnestmax = 2

-- Disable auto comment continuation on newlines
vim.opt.formatoptions:remove({ "c", "r", "o" })

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

-- Automatically center on last line when reopening
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
      vim.cmd("normal! zz") -- center the cursor line
    end
  end,
})

-- Always open files with all folds expanded
vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, {
  callback = function()
    -- Set a very high fold level so everything is unfolded
    vim.cmd("normal! zR")
  end,
})


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
  "ntpeters/vim-better-whitespace",
  "ziglang/zig.vim",
}

-- Mason Setup
local mason_ok, mason = pcall(require, "mason")
if mason_ok then
  mason.setup({
    ui = {
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
        },
    }
  })
end

-- Configure mason-lspconfig but DON'T auto-setup servers
-- We'll handle rust-analyzer manually via rustaceanvim
local mason_lsp_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if mason_lsp_ok then
  mason_lspconfig.setup({
    automatic_installation = false,
  })
end

-- Make trailing whitespace very apparent
vim.g.better_whitespace_enabled = 1
vim.g.better_whitespace_ctermcolor = 'red'
vim.g.better_whitespace_guicolor = '#ff0000'
vim.g.strip_whitespace_on_save = 0
vim.g.strip_whitespace_confirm = 1
vim.g.better_whitespace_skip_empty_lines = 1

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


-- 🦎 Zig Language Server (zls) configuration
-- Disable zig.vim conflicting settings
vim.g.zig_fmt_parse_errors = 0
vim.g.zig_fmt_autosave = 0

-- Setup zls using vim.lsp.config (nvim 0.11+)
if vim.lsp.config then
  -- Define zls configuration
  vim.lsp.config.zls = {
    cmd = { 'zls' },  -- will use zls from PATH
    filetypes = { 'zig', 'zon' },
    root_markers = { 'zls.json', '.git', 'build.zig' },
    -- settings = {
    --   zls = {
    --     zig_exe_path = '/path/to/zig'  -- omit if zig is in PATH
    --   }
    -- }
  }

  -- Enable zls globally
  vim.lsp.enable('zls')

  -- Format on save for Zig files
  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = {"*.zig", "*.zon"},
    callback = function()
      vim.lsp.buf.format()
    end
  })
else
  -- Fallback to old lspconfig API for older nvim versions
  local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
  if lspconfig_ok then
    lspconfig.zls.setup({
      -- cmd will be omitted if zls is in PATH, otherwise specify: { '/path/to/zls' }
      -- settings = {
      --   zls = {
      --     zig_exe_path = '/path/to/zig'  -- omit if zig is in PATH
      --   }
      -- }
    })

    -- Format on save for Zig files
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = {"*.zig", "*.zon"},
      callback = function()
        vim.lsp.buf.format()
      end
    })
  end
end


-- 🌲 Tree-sitter configuration
local treesitter_ok, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if treesitter_ok then
  treesitter_configs.setup {
    -- Parsers to install automatically
    ensure_installed = {
      "rust",
      "zig",
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
end


-- Use virtual_lines instead of virtual_text for diagnostics
vim.diagnostic.config({
  virtual_text = false,  -- Disable inline diagnostics
  virtual_lines = true,  -- Enable virtual_lines
})

-- Toggle diagnostic display (virtual_lines)
vim.keymap.set('n', '<leader>e', function()
  local current = vim.diagnostic.config()
  vim.diagnostic.config({
    virtual_text = false,  -- Always keep virtual_text off
    virtual_lines = not current.virtual_lines,
  })
end, { desc = 'Toggle diagnostic virtual_lines' })


-- Zig Customizations
vim.api.nvim_create_autocmd('BufWritePre',{
  pattern = {"*.zig", "*.zon"},
  callback = function(ev)
    vim.lsp.buf.code_action({
      context = { only = { "source.organizeImports" } },
      apply = true,
    })
  end
})

-- GameZoea test creation command
vim.api.nvim_create_user_command("GBtest", function(opts)
  local name = opts.args
  if name == "" then
    print("Usage: :GBtest <name>")
    return
  end

  -- Template for the test block
  local lines = {
    '#[test]',
    '#[ignore = "TODO"]',
    string.format("fn %s() {", name),
    '    const ROM: &[u8] = gbasm! {r#"',
    '    "#};',
    '    let mut gb = Gameboy::headless_dmg(ROM);',
    '    gb.step(20000);',
    '    assert_hex_eq!(gb.cpu.a(), 0x00);',
    "}",
    "", -- ← add a blank line after the block
  }

  -- Insert after the current line
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_lines(0, row, row, false, lines)

  -- Move cursor to just after the inserted block
  vim.api.nvim_win_set_cursor(0, { row + #lines, 0 })
end, { nargs = 1 })


-- GameZoea opcode creation command
vim.api.nvim_create_user_command("GBopcode", function(opts)
  local name = opts.args
  if name == "" then
    print("Usage: :GBopcode <name>")
    return
  end

  -- Template for the opcode function block (with TODO line)
  local lines = {
    string.format("// {{{ opcode %s", name),
    string.format("pub fn %s(&mut self) {", name),
    "    match self.mc {",
    "        M1 => {",
    "            self.fetch_next();",
    '            todo!("Opcode {} unimplemented", function!());',
    "        }",
    "        M0 => self.set_mc(M2),",
    '        _ => panic!("Invalid mc in {}: {:?}", function!(), self.mc),',
    "    }",
    "}",
    "// }}}",
    "", -- blank line after
  }

  -- Insert after current line
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_lines(0, row, row, false, lines)

  -- Move cursor to after the inserted block
  vim.api.nvim_win_set_cursor(0, { row + #lines, 0 })
end, { nargs = 1 })

