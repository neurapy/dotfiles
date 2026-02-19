return {
        {
                "neovim/nvim-lspconfig",
                opts = {
                        servers = {
                                clangd = {
                                        cmd = {
                                                "clangd",
                                                "--background-index",
                                                "--query-driver=/usr/bin/arm-none-eabi-gcc",
                                                "--log=error", -- reduziert clangd-eigene Logs stark
                                        },
                                },
                        },
                },
        },
}
