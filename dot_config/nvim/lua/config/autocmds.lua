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
-- -- Disable Tree-sitter highlighting for .S (preprocessed asm) files
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--         pattern = "*.S",
--         callback = function()
--                 -- Stop Tree-sitter for this buffer only
--                 pcall(vim.treesitter.stop)
--
--                 -- Ensure classic syntax highlighting is enabled
--                 vim.bo.syntax = "asm"
--         end,
-- })
--
-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
--         pattern = { "*.ipynb", "*.md", "*.qmd" },
--         callback = function()
--                 if vim.b.quarto_activated then
--                         return
--                 end
--                 vim.b.quarto_activated = true
--                 pcall(function()
--                         require("quarto").activate()
--                 end)
--         end,
-- })
--
-- vim.api.nvim_create_autocmd("FileType", {
--         pattern = { "markdown", "quarto" },
--         callback = function()
--                 -- only activate once per buffer
--                 if vim.b.quarto_activated then
--                         return
--                 end
--                 vim.b.quarto_activated = true
--                 pcall(function()
--                         require("quarto").activate()
--                 end)
--         end,
-- })
--
--
-- Intercept any attempt to write an otter buffer to disk
vim.api.nvim_create_autocmd("BufWriteCmd", {
        pattern = "*.otter.*",
        callback = function(opts)
                -- Tell Neovim the buffer is "saved" so it stops trying to write it
                vim.bo[opts.buf].modified = false
                return true
        end,
})
