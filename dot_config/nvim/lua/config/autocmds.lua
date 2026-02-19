-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
--
-- Disable Tree-sitter highlighting for .S (preprocessed asm) files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.S",
  callback = function()
    -- Stop Tree-sitter for this buffer only
    pcall(vim.treesitter.stop)

    -- Ensure classic syntax highlighting is enabled
    vim.bo.syntax = "asm"
  end,
})
