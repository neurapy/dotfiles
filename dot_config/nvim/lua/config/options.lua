-- Options are automatically loaded before lazy.nvim startup
-- Add any additional options here

vim.opt.shiftwidth = 8
vim.opt.tabstop = 8
vim.opt.softtabstop = -1 -- folgt shiftwidth
vim.opt.expandtab = true
vim.opt.autoindent = true

vim.opt.spelllang = { "en", "de" }

vim.g.python3_host_prog = vim.fn.expand("~/.local/share/micromamba/envs/neovim/bin/python")

-- vim.opt.conceallevel = 0 -- Right now this has to be set for the notebook_seperators to work.
-- vim.opt.concealcursor = ""
