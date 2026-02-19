local dap = require("dap")

-- 1. Variables to hold our buffer and window
local asm_buf = nil
local asm_win = nil

-- 2. Function to create/get the window
local function open_asm_window()
        -- If window exists and is valid, do nothing
        if asm_win and vim.api.nvim_win_is_valid(asm_win) then
                return
        end

        -- Create a new split on the right (adjust 'vsplit' or 'split' as you like)
        vim.cmd("vsplit")
        asm_win = vim.api.nvim_get_current_win()

        -- Create a scratch buffer if needed
        if not asm_buf or not vim.api.nvim_buf_is_valid(asm_buf) then
                asm_buf = vim.api.nvim_create_buf(false, true) -- No file, Scratch buffer
                vim.api.nvim_buf_set_name(asm_buf, "ASM-Live")
                -- Set filetype to asm for syntax highlighting
                vim.api.nvim_buf_set_option(asm_buf, "filetype", "asm")
        end

        -- Attach buffer to window
        vim.api.nvim_win_set_buf(asm_win, asm_buf)
end

-- 3. Function to update the assembly view
local function update_asm_view(session)
        if not asm_buf or not vim.api.nvim_buf_is_valid(asm_buf) then
                return
        end

        -- We request GDB to disassemble around the Program Counter ($pc)
        -- 20 bytes back and 20 bytes forward covers roughly 5-10 instructions
        local cmd = "disassemble $pc-20, $pc+20"

        session:request("evaluate", { expression = cmd, context = "repl" }, function(err, response)
                if err then
                        vim.api.nvim_buf_set_lines(asm_buf, 0, -1, false, { "Error getting asm: " .. err.message })
                        return
                end

                -- GDB usually returns the result as a string in response.result
                local result = response.result

                -- Clean up the output (GDB DAP sometimes wraps output in quotes or adds newlines)
                -- We split by newline to get a table of lines
                local lines = {}
                for s in result:gmatch("[^\r\n]+") do
                        -- Remove GDB's "Standard Output:" prefixes if they exist
                        table.insert(lines, s)
                end

                -- Update the buffer
                vim.api.nvim_buf_set_option(asm_buf, "modifiable", true)
                vim.api.nvim_buf_set_lines(asm_buf, 0, -1, false, lines)
                vim.api.nvim_buf_set_option(asm_buf, "modifiable", false)
        end)
end

-- 4. Hook into DAP Events
dap.listeners.after.event_stopped["refresh_asm_window"] = function(session, body)
        -- Only update if the window is actually open
        if asm_win and vim.api.nvim_win_is_valid(asm_win) then
                update_asm_view(session)
        end
end

-- 5. Create a user command to toggle it
vim.api.nvim_create_user_command("DapAsm", function()
        open_asm_window()
        -- Force an update immediately if we are already debugging
        local session = dap.session()
        if session then
                update_asm_view(session)
        end
end, {})
