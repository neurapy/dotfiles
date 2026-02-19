return {
        {
                "nvim-treesitter/nvim-treesitter",
                opts = function(_, opts)
                        local function add_linkerscript()
                                require("nvim-treesitter.parsers").linkerscript = {
                                        tier = 1,
                                        install_info = {
                                                url = "https://github.com/tree-sitter-grammars/tree-sitter-linkerscript",
                                                revision = "f99011a3554213b654985a4b0a65b3b032ec4621",
                                                branch = "master", -- repo default branch is master
                                                files = { "src/parser.c" },
                                                queries = "queries", -- install highlight/indent/etc queries from the repo
                                        },
                                }
                        end

                        -- register now (so auto-install can see it)
                        add_linkerscript()

                        -- re-register after :TSUpdate (so updates don’t wipe it)
                        vim.api.nvim_create_autocmd("User", {
                                pattern = "TSUpdate",
                                callback = add_linkerscript,
                        })

                        -- make .lds/.ld become filetype=linkerscript
                        vim.filetype.add({
                                extension = {
                                        lds = "linkerscript",
                                        ld = "linkerscript",
                                },
                        })

                        -- make sure ft->lang mapping exists (safe even if redundant)
                        vim.treesitter.language.register("linkerscript", "linkerscript")

                        -- ensure it gets installed
                        opts.ensure_installed = opts.ensure_installed or {}
                        if not vim.tbl_contains(opts.ensure_installed, "linkerscript") then
                                table.insert(opts.ensure_installed, "linkerscript")
                        end
                end,
        },
}
