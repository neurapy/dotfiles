return {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
        opts = {
                -- Keep markdown pretty, but don’t break notebook output virtual text
                code = {
                        sign = false,

                        -- IMPORTANT for your issue:
                        conceal_delimiters = false, -- keep ``` lines visible so virt-text anchored there stays visible
                        border = "thin", -- avoid "hide" which can conceal boundary lines

                        -- Pretty code blocks
                        width = "block",
                        left_pad = 1,
                        right_pad = 1,
                        min_width = 60, -- optional: helps “cell-like” look when width="block"

                        -- Nice language header
                        language = true,
                        language_icon = true,
                        language_name = true,
                        language_info = true,
                        position = "left",
                        language_pad = 1,
                },

                heading = {
                        sign = false,
                        -- If you want clean headings without big icons:
                        icons = {},
                        -- Optional: add subtle full-width heading backgrounds
                        width = "full",
                },

                -- Notebook-y markdown usually doesn’t need task UI
                checkbox = { enabled = false },

                -- (Optional) tables/quotes look great in notebook markdown
                pipe_table = { enabled = true, preset = "round" },
                quote = { enabled = true },
                dash = { enabled = true },
                link = { enabled = true },
        },
        config = function(_, opts)
                require("render-markdown").setup(opts)
                Snacks.toggle({
                        name = "Render Markdown",
                        get = require("render-markdown").get,
                        set = require("render-markdown").set,
                }):map("<leader>um")
        end,
}
