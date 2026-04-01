return {
        {
                "benlubas/molten-nvim",
                dependencies = { "3rd/image.nvim" },
                build = ":UpdateRemotePlugins",
                init = function()
                        vim.g.molten_image_provider = "image.nvim"
                        vim.g.molten_auto_open_output = false
                        vim.g.molten_enter_output_behavior = "open_and_enter"
                        vim.g.molten_wrap_output = true
                        vim.g.molten_virt_text_output = true
                        vim.g.molten_virt_lines_off_by_1 = true
                        vim.g.molten_virt_text_truncate = "top"
                        vim.g.molten_floating_window_focus = "bottom"

                        -- vim.g.molten_output_crop_border = false
                        -- vim.g.molten_image_location = "both"
                        vim.g.molten_output_win_max_height = 32
                        vim.g.molten_output_win_max_width = 100
                        -- vim.g.molten_use_border_highlights = true
                        -- vim.g.molten_cover_empty_lines = true
                end,

                keys = {
                        { "<leader>m", group = "Molten", desc = "Molten" },

                        { "<leader>mi", "<cmd>MoltenInit<cr>", desc = "Molten: Init kernel" },
                        { "<leader>mI", "<cmd>MoltenInit shared<cr>", desc = "Molten: Init (shared)" },
                        { "<leader>m?", "<cmd>MoltenInfo<cr>", desc = "Molten: Info" },
                        { "<leader>mD", "<cmd>MoltenDeinit<cr>", desc = "Molten: Deinit" },

                        -- cell control
                        { "<leader>md", ":MoltenDelete<CR>", desc = "delete cell", silent = true },

                        -- run code
                        { "<leader>ml", "<cmd>MoltenEvaluateLine<cr>", desc = " Eval line" },
                        { "<leader>mo", "<cmd>MoltenEvaluateOperator<cr>", desc = "Eval operator" },
                        { "<leader>mv", ":<C-u>MoltenEvaluateVisual<CR>gv", mode = "v", desc = "Eval visual" },

                        -- output UI
                        { "<leader>ms", "<cmd>MoltenShowOutput<cr>", desc = " Show output" },
                        { "<leader>mh", "<cmd>MoltenHideOutput<cr>", desc = " Hide output" },
                        { "<leader>me", "<cmd>noautocmd MoltenEnterOutput<cr>", desc = "Enter output" },

                        -- interrupt / restart
                        { "<leader>m<BS>", "<cmd>MoltenInterrupt<cr>", desc = "Molten: Interrupt kernel" },
                        { "<leader>mR", "<cmd>MoltenRestart<cr>", desc = "Molten: Restart kernel" },
                        { "<leader>mX", "<cmd>MoltenRestart!<cr>", desc = "Molten: Restart + clear outputs" },

                        -- save/load outputs (paths optional; uses g:molten_save_path if omitted)
                        { "<leader>mS", "<cmd>MoltenSave<cr>", desc = "Molten: Save outputs" },
                        { "<leader>mL", "<cmd>MoltenLoad<cr>", desc = "Molten: Load outputs" },
                },
        },
}
-- %%
