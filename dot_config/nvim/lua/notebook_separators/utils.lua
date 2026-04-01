local UTILS = {}

function UTILS.is_fence(line)
        return line:match("^%s*```+")
end

function UTILS.text_width(win)
        local w = vim.api.nvim_win_get_width(win)
        local info = vim.fn.getwininfo(win)[1]
        local off = info and info.textoff or 0
        return math.max(1, w - off)
end

function UTILS.horizontal_line(win)
        local text_width = UTILS.text_width(win)
        return string.rep("─", math.max(1, text_width - 1))
end

function UTILS.fence_lang(line)
        local lang = line:match("^%s*```+%s*{?([%w%._-]+)")
        if not lang then
                return nil
        end
        lang = lang:gsub("^%.", "") -- { .python } -> python
        lang = lang:gsub("[^%w_-].*$", "") -- trim weird tails if any
        if lang == "" then
                return nil
        end
        return lang
end

function UTILS.lang_icon(lang)
        if not lang then
                return "󰊤", "NotebookCellIcon"
        end

        local ok, devicons = pcall(require, "nvim-web-devicons")
        if ok and devicons and devicons.get_icon_by_filetype then
                local icon, hl = devicons.get_icon_by_filetype(lang, { default = true })
                if icon then
                        return icon, hl or "NotebookCellIcon"
                end
        end

        return "󰊤", "NotebookCellIcon"
end

return UTILS
