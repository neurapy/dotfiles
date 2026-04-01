-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- ~/.config/nvim/lua/config/keymaps.lua

-- Smart Resizing Logic
local function smart_resize_width(direction)
        -- Check if there is a window to the right
        local has_right = vim.fn.winnr("l") ~= vim.fn.winnr()

        if direction == "left" then
                -- If there is a window to the right, shrink current to pull border left
                -- If we are the rightmost window, grow current to push border left
                if has_right then
                        vim.cmd("vertical resize -2")
                else
                        vim.cmd("vertical resize +2")
                end
        else -- direction == 'right'
                if has_right then
                        vim.cmd("vertical resize +2")
                else
                        vim.cmd("vertical resize -2")
                end
        end
end

local function smart_resize_height(direction)
        -- Check if there is a window below
        local has_below = vim.fn.winnr("j") ~= vim.fn.winnr()

        if direction == "up" then
                if has_below then
                        vim.cmd("resize -2")
                else
                        vim.cmd("resize +2")
                end
        else -- direction == 'down'
                if has_below then
                        vim.cmd("resize +2")
                else
                        vim.cmd("resize -2")
                end
        end
end

-- Keymaps
vim.keymap.set("n", "<C-S-h>", function()
        smart_resize_width("left")
end, { desc = "Move Border Left" })
vim.keymap.set("n", "<C-S-l>", function()
        smart_resize_width("right")
end, { desc = "Move Border Right" })
vim.keymap.set("n", "<C-S-k>", function()
        smart_resize_height("up")
end, { desc = "Move Border Up" })
vim.keymap.set("n", "<C-S-j>", function()
        smart_resize_height("down")
end, { desc = "Move Border Down" })
