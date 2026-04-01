return {
        {
                "neovim/nvim-lspconfig",
                lazy = false,
                opts = {
                        servers = {
                                clangd = {
                                        cmd = {
                                                "clangd",
                                                "--background-index",
                                                "--query-driver=/usr/bin/arm-none-eabi-gcc",
                                                "--log=error",
                                        },
                                },

                                lua_ls = {
                                        settings = {
                                                Lua = {
                                                        runtime = {
                                                                version = "LuaJIT",
                                                        },
                                                        diagnostics = {
                                                                globals = { "vim" },
                                                        },
                                                        workspace = {
                                                                library = vim.api.nvim_get_runtime_file("", true),
                                                                checkThirdParty = false,
                                                        },
                                                        telemetry = {
                                                                enable = false,
                                                        },
                                                },
                                        },
                                },
                        },
                },
        },
}
