return {
        {
                "nvim-treesitter/nvim-treesitter",
                build = ":TSUpdate",
                event = { "BufReadPre", "BufNewFile" }, -- ensures plugin is on rtp before we require it
                dependencies = {
                        "nvim-treesitter/nvim-treesitter-textobjects",
                },
                config = function()
                        -- At this point, lazy has added the plugin to runtimepath.
                        local configs = require("nvim-treesitter.configs")

                        configs.setup({
                                highlight = { enable = true },

                                textobjects = {
                                        move = {
                                                enable = true,
                                                set_jumps = false,
                                                goto_next_start = {
                                                        ["]b"] = { query = "@block.inner", desc = "next code block" },
                                                },
                                                goto_previous_start = {
                                                        ["[b"] = {
                                                                query = "@block.inner",
                                                                desc = "previous code block",
                                                        },
                                                },
                                        },
                                },
                        })
                end,
        },
}
