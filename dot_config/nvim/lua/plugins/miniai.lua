return {
        {
                "nvim-mini/mini.ai",
                opts = function(_, opts)
                        local ai = require("mini.ai")
                        opts.custom_textobjects = opts.custom_textobjects or {}

                        -- Bind 'x' to your markdown code block treesitter queries
                        opts.custom_textobjects.x = ai.gen_spec.treesitter({
                                a = "@class.outer",
                                i = "@class.inner",
                        })
                end,
        },
}
