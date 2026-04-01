return {
    {
        "bjarneo/aether.nvim",
        name = "aether",
        priority = 1000,
        opts = {
            disable_italics = false,
            colors = {
                -- Monotone shades (base00-base07)
                base00 = "#1e1e2e", -- Default background
                base01 = "#0e0e15", -- Lighter background (status bars)
                base02 = "#1e1e2e", -- Selection background
                base03 = "#0e0e15", -- Comments, invisibles
                base04 = "#101019", -- Dark foreground
                base05 = "#000000", -- Default foreground
                base06 = "#000000", -- Light foreground
                base07 = "#101019", -- Light background

                -- Accent colors (base08-base0F)
                base08 = "#1c1c2b", -- Variables, errors, red
                base09 = "#0c0c12", -- Integers, constants, orange
                base0A = "#181825", -- Classes, types, yellow
                base0B = "#1a1a28", -- Strings, green
                base0C = "#12121c", -- Support, regex, cyan
                base0D = "#161622", -- Functions, keywords, blue
                base0E = "#14141f", -- Keywords, storage, magenta
                base0F = "#08080c", -- Deprecated, brown/yellow
            },
        },
        config = function(_, opts)
            require("aether").setup(opts)
            vim.cmd.colorscheme("aether")

            -- Enable hot reload
            require("aether.hotreload").setup()
        end,
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "aether",
        },
    },
}
