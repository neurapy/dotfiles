local RENDER = {}

local UTILS = require("notebook_separators.utils")
local EXTMARKS = require("notebook_separators.extmarks")

local function render_all_windows_for_buf(bufnr)
        for _, win in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == bufnr then
                        RENDER.render(bufnr, win)
                end
        end
end

function RENDER.render(bufnr, win)
        bufnr = bufnr or vim.api.nvim_get_current_buf()
        if not vim.api.nvim_buf_is_valid(bufnr) then
                return
        end

        win = win or vim.api.nvim_get_current_win()
        if not vim.api.nvim_win_is_valid(win) then
                return
        end

        local ft = vim.bo[bufnr].filetype
        if ft ~= "markdown" and ft ~= "quarto" then
                return
        end

        EXTMARKS.clear(bufnr)

        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local line = UTILS.horizontal_line(win)

        local in_block = false
        local open_lnum = nil

        for i, s in ipairs(lines) do
                if UTILS.is_fence(s) then
                        local lnum = i - 1

                        if not in_block then
                                EXTMARKS.put_overlay(bufnr, lnum, line, "NotebookCellSeparator")

                                local lang = UTILS.fence_lang(s)
                                local icon, icon_hl = UTILS.lang_icon(lang)

                                EXTMARKS.put_right_chunks(bufnr, lnum, {
                                        { " ", "NotebookCellSeparator" },
                                        { icon, icon_hl },
                                        { " ", "NotebookCellSeparator" },
                                        { "┐", "NotebookCellBorder" },
                                })

                                in_block = true
                                open_lnum = lnum
                        else
                                -- Fill right border for interior lines
                                if open_lnum ~= nil then
                                        for j = open_lnum + 1, lnum - 1 do
                                                EXTMARKS.put_right(bufnr, j, "│", "NotebookCellBorder")
                                        end
                                end

                                -- Closing fence becomes BOTTOM separator
                                EXTMARKS.put_overlay(bufnr, lnum, line, "NotebookCellSeparator")
                                EXTMARKS.put_right(bufnr, lnum, "┘", "NotebookCellBorder")

                                in_block = false
                                open_lnum = nil
                        end
                end
        end
end

function RENDER.setup(_opts)
        vim.api.nvim_set_hl(0, "NotebookCellSeparator", { link = "DiagnosticInfo" })
        vim.api.nvim_set_hl(0, "NotebookCellBorder", { link = "DiagnosticInfo" })

        local aug = vim.api.nvim_create_augroup("NotebookSeparators", { clear = true })

        vim.api.nvim_create_autocmd({
                "BufEnter",
                "BufWinEnter",
                "TextChanged",
                "TextChangedI",
                "WinResized",
                "VimResized",
                "WinScrolled",
                "DiagnosticChanged",
                "OptionSet",
        }, {
                group = aug,
                pattern = { "*.md", "*.qmd", "*.ipynb" },
                callback = function(args)
                        -- Defer a tiny bit so window layout + textoff settle after resize/zoom.
                        vim.defer_fn(function()
                                if vim.api.nvim_buf_is_valid(args.buf) then
                                        render_all_windows_for_buf(args.buf)
                                end
                        end, 20)
                end,
        })
end

return RENDER
