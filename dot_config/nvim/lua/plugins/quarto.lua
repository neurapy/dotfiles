return {
        {
                "quarto-dev/quarto-nvim",
                ft = { "quarto", "markdown" },
                dependencies = {
                        "jmbuhr/otter.nvim",
                        "nvim-treesitter/nvim-treesitter",
                },
                opts = {
                        lspFeatures = {
                                languages = { "r", "python", "rust" },
                                chunks = "all",
                                diagnostics = {
                                        enabled = true,
                                        triggers = { "BufWritePost" },
                                },
                                completion = { enabled = true },
                        },
                        keymap = {
                                hover = "K",
                                definition = "gd",
                                rename = "<leader>qr",
                                references = "gr",
                                format = "<leader>qf",
                        },
                        codeRunner = {
                                enabled = true,
                                default_method = "molten",
                        },
                },

                config = function(_, opts)
                        require("quarto").setup(opts)

                        local runner = require("quarto.runner")

                        vim.keymap.set("n", "<leader>rc", runner.run_cell, { desc = "run cell", silent = true })
                        vim.keymap.set("n", "<leader>ra", runner.run_above, { desc = "run cell", silent = true })
                        vim.keymap.set("n", "<leader>rA", runner.run_all, { desc = "run all cells", silent = true })
                        vim.keymap.set("n", "<leader>rl", runner.run_line, { desc = "run line", silent = true })
                        vim.keymap.set("v", "<leader>r", runner.run_range, { desc = "run visual range", silent = true })
                        vim.keymap.set("n", "<leader>RA", function()
                                runner.run_all(true)
                        end, { desc = "run all cells of all languages", silent = true })
                end,
        },
}
