return {
        {
                "yetone/avante.nvim",
                build = "make",
                event = "VeryLazy",
                version = false,
                opts = {
                        provider = "codex",
                        acp_providers = {
                                codex = {
                                        command = "npx",
                                        args = { "@zed-industries/codex-acp" },
                                        env = {
                                                NODE_NO_WARNINGS = "1",
                                                CODEX_HOME = vim.fn.expand("~/.codex"),
                                        },
                                },
                        },
                },
                dependencies = {
                        "nvim-lua/plenary.nvim",
                        "MunifTanjim/nui.nvim",
                },
        },
}
