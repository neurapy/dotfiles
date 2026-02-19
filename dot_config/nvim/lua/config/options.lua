-- Options are automatically loaded before lazy.nvim startup
-- Add any additional options here

-- Der deutsche Satz ist deutsch.
-- The German sentence is a problem

vim.opt.shiftwidth = 8
vim.opt.tabstop = 8
vim.opt.softtabstop = -1 -- folgt shiftwidth
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Spellchecks
vim.opt.spelllang = { "en", "de" }
