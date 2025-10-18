local bufnr = vim.api.nvim_get_current_buf()
vim.o.signcolumn = "yes"  -- always reserve space
vim.keymap.set(
  "n", 
  "<leader>a", 
  function()
    vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
    -- or vim.lsp.buf.codeAction() if you don't want grouping.
  end,
  { silent = true, buffer = bufnr }
)
vim.keymap.set(
  "n", 
  "K",  -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
  function()
    vim.cmd.RustLsp({'hover', 'actions'})
  end,
  { silent = true, buffer = bufnr }
)
-- Toggle diagnostic display (virtual_lines)
vim.keymap.set('n', '<leader>e', function()
  local current = vim.diagnostic.config()
  vim.diagnostic.config({
    virtual_text = false,  -- Always keep virtual_text off
    virtual_lines = not current.virtual_lines,
  })
end, { desc = 'Toggle diagnostic virtual_lines' })

