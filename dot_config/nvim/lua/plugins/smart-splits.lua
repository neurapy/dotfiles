return {
        "antoinemadec/window-movement.nvim",
        lazy = true,

        -- sorgt dafür, dass lazy.nvim das Plugin beim Drücken dieser Keys lädt
        keys = {
                { "<A-Left>" },
                { "<A-Down>" },
                { "<A-Up>" },
                { "<A-Right>" },
                { "<A-S-Left>" },
                { "<A-S-Down>" },
                { "<A-S-Up>" },
                { "<A-S-Right>" },
                { "<A-q>" },
                { "<C-A-Left>" },
                { "<C-A-Right>" },
                { "<C-A-S-Left>" },
                { "<C-A-S-Right>" },
        },

        config = function()
                local default_opts = { noremap = true, silent = true }

                local function remap_arrow_hjkl(mode, lhs, rhs, opt)
                        local arrow_hjkl_table = {
                                ["<Left>"] = "h",
                                ["<Down>"] = "j",
                                ["<Up>"] = "k",
                                ["<Right>"] = "l",
                                Left = "h",
                                Down = "j",
                                Up = "k",
                                Right = "l",
                        }
                        vim.keymap.set(mode, lhs, rhs, opt)
                        for arrow, hjkl in pairs(arrow_hjkl_table) do
                                if string.find(lhs, arrow) then
                                        vim.keymap.set(mode, string.gsub(lhs, arrow, hjkl), rhs, opt)
                                        return
                                end
                        end
                end

                for _, mode in pairs({ "n", "i", "t" }) do
                        local esc_chars = (mode == "i" or mode == "t") and "<C-\\><C-n>" or ""

                        remap_arrow_hjkl(mode, "<A-Left>", esc_chars .. "<C-w>h", default_opts)
                        remap_arrow_hjkl(mode, "<A-Down>", esc_chars .. "<C-w>j", default_opts)
                        remap_arrow_hjkl(mode, "<A-Up>", esc_chars .. "<C-w>k", default_opts)
                        remap_arrow_hjkl(mode, "<A-Right>", esc_chars .. "<C-w>l", default_opts)

                        remap_arrow_hjkl(mode, "<A-S-Left>", function()
                                require("window-movement").move_win_to_direction("left")
                        end, default_opts)
                        remap_arrow_hjkl(mode, "<A-S-Down>", function()
                                require("window-movement").move_win_to_direction("down")
                        end, default_opts)
                        remap_arrow_hjkl(mode, "<A-S-Up>", function()
                                require("window-movement").move_win_to_direction("up")
                        end, default_opts)
                        remap_arrow_hjkl(mode, "<A-S-Right>", function()
                                require("window-movement").move_win_to_direction("right")
                        end, default_opts)

                        remap_arrow_hjkl(mode, "<A-q>", function()
                                require("window-movement").quad_win_cycle()
                        end, default_opts)

                        remap_arrow_hjkl(mode, "<C-A-Left>", esc_chars .. "gT", default_opts)
                        remap_arrow_hjkl(mode, "<C-A-Right>", esc_chars .. "gt", default_opts)

                        remap_arrow_hjkl(mode, "<C-A-S-Left>", function()
                                require("window-movement").move_win_to_tab("prev")
                        end, default_opts)
                        remap_arrow_hjkl(mode, "<C-A-S-Right>", function()
                                require("window-movement").move_win_to_tab("next")
                        end, default_opts)
                end
        end,
}
