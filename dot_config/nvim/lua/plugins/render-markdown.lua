return {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
                render_modes = { "n", "c", "i" },
                heading = {
                        enabled = true,
                        render_modes = false,
                        atx = true,
                        setext = true,
                        sign = false,
                        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
                        position = "inline",
                        signs = { "󰫎 " },
                        width = "block",
                        left_margin = 0,
                        left_pad = 1,
                        right_pad = 1,
                        min_width = 0,
                        border = false,
                        border_virtual = false,
                        border_prefix = false,
                        above = "▄",
                        below = "▀",
                        backgrounds = {
                                "RenderMarkdownH1Bg",
                                "RenderMarkdownH2Bg",
                                "RenderMarkdownH3Bg",
                                "RenderMarkdownH4Bg",
                                "RenderMarkdownH5Bg",
                                "RenderMarkdownH6Bg",
                        },
                        foregrounds = {
                                "RenderMarkdownH1",
                                "RenderMarkdownH2",
                                "RenderMarkdownH3",
                                "RenderMarkdownH4",
                                "RenderMarkdownH5",
                                "RenderMarkdownH6",
                        },
                        custom = {},
                },
                code = {
                        style = "full",
                        sign = false,
                        render_modes = { "n", "c", "i", "v" },
                        border = "thin", -- Important for Visible Molten Output.

                        -- Box Position
                        width = "full",

                        -- Popout Language Border
                        language_border = " ",
                        language_left = "",
                        language_right = "",
                },
                dash = {
                        enabled = true,
                        render_modes = { "n", "c", "i", "v" },
                        icon = "─",
                        width = "full",
                        left_margin = 0,
                        priority = nil,
                        highlight = "RenderMarkdownDash",
                },
                checkbox = {
                        enabled = true,
                },

                pipe_table = { preset = "heavy" },
        },
        ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
        config = function(_, opts)
                require("render-markdown").setup(opts)
                Snacks.toggle({
                        name = "Render Markdown",
                        get = require("render-markdown").get,
                        set = require("render-markdown").set,
                }):map("<leader>um")
        end,
}
