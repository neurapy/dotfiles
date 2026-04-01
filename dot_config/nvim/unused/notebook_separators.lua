local Module = {}

local ns = vim.api.nvim_create_namespace("notebook_separators")

local function is_fence(line)
        return line:match("^%s*```+")
end

local function text_width(win)
        local w = vim.api.nvim_win_get_width(win)
        local info = vim.fn.getwininfo(win)[1]
        local off = info and info.textoff or 0
        return math.max(1, w - off)
end

local function horiz(win)
        local tw = text_width(win)
        -- leave 1 column for the right border glyph (┐/┘/│)
        return string.rep("─", math.max(1, tw - 1))
end

local function put_overlay(bufnr, lnum, text, hl)
        vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, 0, {
                virt_text = { { text, hl } },
                virt_text_pos = "overlay",
                hl_mode = "combine",
        })
end

local function put_right(bufnr, lnum, glyph, hl)
        vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, 0, {
                virt_text = { { glyph, hl } },
                virt_text_pos = "right_align",
                hl_mode = "combine",
        })
end

local function render_all_windows_for_buf(bufnr)
        for _, win in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == bufnr then
                        Module.render(bufnr, win)
                end
        end
end

function Module.render(bufnr, win)
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

        vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local line = horiz(win)

        local in_block = false
        local open_lnum = nil

        for i, s in ipairs(lines) do
                if is_fence(s) then
                        local lnum = i - 1

                        if not in_block then
                                -- Opening fence becomes TOP separator
                                put_overlay(bufnr, lnum, line, "NotebookCellSeparator")
                                put_right(bufnr, lnum, "┐", "NotebookCellBorder")
                                in_block = true
                                open_lnum = lnum
                        else
                                -- Fill right border for interior lines
                                if open_lnum ~= nil then
                                        for j = open_lnum + 1, lnum - 1 do
                                                put_right(bufnr, j, "│", "NotebookCellBorder")
                                        end
                                end

                                -- Closing fence becomes BOTTOM separator
                                put_overlay(bufnr, lnum, line, "NotebookCellSeparator")
                                put_right(bufnr, lnum, "┘", "NotebookCellBorder")

                                in_block = false
                                open_lnum = nil
                        end
                end
        end
end

function Module.setup()
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

return Module
