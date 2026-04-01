return {
        "nvimtools/hydra.nvim",
        config = function()
                local hydra = require("hydra")

                -- Helper function to feed keys for the treesitter jumps
                local function keys(str)
                        return function()
                                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(str, true, false, true), "m", true)
                        end
                end

                -- Helper to insert a Python cell
                local function insert_cell(up)
                        return function()
                                -- vim.schedule ensures Hydra closes before we start moving around
                                vim.schedule(function()
                                        local current_line = vim.api.nvim_win_get_cursor(0)[1]
                                        if up then
                                                -- Search backward for the start of the current cell
                                                local start_line = vim.fn.search("^```[a-zA-Z]*", "bcnW")
                                                local insert_at = start_line > 0 and start_line - 1 or current_line - 1

                                                vim.api.nvim_buf_set_lines(
                                                        0,
                                                        insert_at,
                                                        insert_at,
                                                        false,
                                                        { "```python", "", "```", "" }
                                                )
                                                vim.api.nvim_win_set_cursor(0, { insert_at + 2, 0 })
                                        else
                                                -- Search forward for the end of the current cell
                                                local end_line = vim.fn.search("^```\\s*$", "cnW")
                                                local insert_at = end_line > 0 and end_line or current_line

                                                vim.api.nvim_buf_set_lines(
                                                        0,
                                                        insert_at,
                                                        insert_at,
                                                        false,
                                                        { "", "```python", "", "```" }
                                                )
                                                vim.api.nvim_win_set_cursor(0, { insert_at + 2, 0 })
                                        end
                                        vim.cmd("startinsert")
                                end)
                        end
                end

                -- Helper to delete a cell
                -- Helper to delete a cell (Pure text deletion)
                local function delete_cell()
                        return function()
                                -- Wait 50ms for Hydra to close, then aggressively delete the text block
                                vim.defer_fn(function()
                                        vim.api.nvim_feedkeys(
                                                vim.api.nvim_replace_termcodes("dax", true, false, true),
                                                "m",
                                                true
                                        )
                                end, 50)
                        end
                end

                hydra({
                        name = "QuartoNavigator",
                        hint = [[
      _j_/_k_: move down/up  _r_: run cell
      _l_: run line  _R_: run above
      _a_/_b_: add cell above/below
      _d_: delete cell
      ^^     _<esc>_/_q_: exit ]],
                        config = {
                                color = "pink",
                                invoke_on_body = true,

                                hint = {
                                        float_opts = {
                                                border = "rounded",
                                        },
                                },
                        },
                        mode = { "n" },
                        body = "<leader>h", -- Trigger key
                        heads = {
                                { "j", keys("]x") },
                                { "k", keys("[x") },
                                {
                                        "r",
                                        function()
                                                require("quarto.runner").run_cell()
                                        end,
                                        { desc = "run cell" },
                                },
                                {
                                        "l",
                                        function()
                                                require("quarto.runner").run_line()
                                        end,
                                        { desc = "run line" },
                                },
                                {
                                        "R",
                                        function()
                                                require("quarto.runner").run_above()
                                        end,
                                        { desc = "run above" },
                                },
                                { "a", insert_cell(true), { desc = "insert above", exit = true } },
                                { "b", insert_cell(false), { desc = "insert below", exit = true } },
                                { "d", delete_cell(), { desc = "delete cell", exit = true } },
                                { "<esc>", nil, { exit = true } },
                                { "q", nil, { exit = true } },
                        },
                })
        end,
}
