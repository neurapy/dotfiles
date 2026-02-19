-- Manuelle Taste zum ersten Öffnen in 'keys' hinzufügen (siehe unten)
return {
        "mfussenegger/nvim-dap",
        opts = function()
                local dap = require("dap")
                local asm_buf = nil
                local asm_win = nil
                -- Wir erstellen einen Namespace für unsere Highlights
                local asm_ns = vim.api.nvim_create_namespace("dap_asm_view")

                local function update_asm_view()
                        local session = dap.session()
                        if not session then
                                return
                        end

                        -- Wir fragen den realen Speicher ab
                        session:request(
                                "evaluate",
                                { expression = "disassemble /mr $pc-20, $pc+40" },
                                function(err, response)
                                        if err or not response then
                                                return
                                        end

                                        -- Buffer-Logik
                                        if not asm_buf or not vim.api.nvim_buf_is_valid(asm_buf) then
                                                asm_buf = vim.api.nvim_create_buf(false, true)
                                                vim.api.nvim_set_option_value("filetype", "asm", { buf = asm_buf })
                                                vim.api.nvim_buf_set_name(asm_buf, "Realtime-Disassembly")
                                        end

                                        local lines = vim.split(response.result, "\n")
                                        vim.api.nvim_buf_set_lines(asm_buf, 0, -1, false, lines)

                                        -- Fenster-Logik (Split rechts)
                                        if not asm_win or not vim.api.nvim_win_is_valid(asm_win) then
                                                vim.cmd("vsplit")
                                                asm_win = vim.api.nvim_get_current_win()
                                                vim.api.nvim_win_set_buf(asm_win, asm_buf)
                                                vim.api.nvim_win_set_width(asm_win, 65)
                                        end

                                        -- ALTE HIGHLIGHTS LÖSCHEN (via Namespace)
                                        vim.api.nvim_buf_clear_namespace(asm_buf, asm_ns, 0, -1)

                                        -- NEUE POSITION MARKIEREN
                                        for i, line in ipairs(lines) do
                                                if line:match("=>") then
                                                        -- Setzt den Cursor im ASM Fenster auf die Zeile
                                                        vim.api.nvim_win_set_cursor(asm_win, { i, 0 })

                                                        -- MODERNER ERSATZ für nvim_buf_add_highlight:
                                                        vim.api.nvim_buf_set_extmark(asm_buf, asm_ns, i - 1, 0, {
                                                                end_row = i - 1,
                                                                line_hl_group = "Visual", -- Markiert die ganze Zeile
                                                                priority = 100,
                                                        })
                                                end
                                        end
                                end
                        )
                end

                -- AUTOMATISIERUNG
                dap.listeners.after.event_stopped["update_asm_view"] = function()
                        update_asm_view()
                end

                dap.adapters.gdb = {
                        type = "executable",
                        command = "arm-none-eabi-gdb",
                        args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
                }

                dap.configurations.c = {
                        {
                                name = "Come on motherfucker!",
                                type = "gdb",
                                request = "attach",
                                target = "localhost:1234",
                                program = function()
                                        return vim.fn.getcwd() .. "/build/kernel.elf"
                                end,
                                cwd = "${workspaceFolder}",
                                stopAtBeginningOfMainSubprogram = false,
                        },
                }
                dap.configurations.asm = dap.configurations.c
        end,

        keys = {
                {
                        "<leader>ds",
                        function()
                                -- Ruft die oben definierte Logik manuell auf
                                -- (Du musst die Funktion 'update_asm_view' globaler definieren oder in den Scope packen)
                                -- Einfacher: Wir schicken nur den Befehl ans REPL, falls du kein extra Fenster willst:
                                require("dap").repl.execute("disassemble /mr $pc-20, $pc+40")
                        end,
                        desc = "GDB: Show Memory Disassembly",
                },

                {
                        "<leader>dd", -- CPSR VIEW
                        function()
                                local dap = require("dap")
                                local session = dap.session()
                                if session then
                                        -- Fragt GDB nach dem CPSR und gibt es formatiert aus
                                        session:request("evaluate", { expression = "$cpsr" }, function(err, response)
                                                if response then
                                                        local val = tonumber(response.result)
                                                        local hex = string.format("0x%X", val)
                                                        local mode_bits = bit.band(val, 0x1f)
                                                        local modes = {
                                                                [0x10] = "User",
                                                                [0x11] = "FIQ",
                                                                [0x12] = "IRQ",
                                                                [0x13] = "SVC",
                                                                [0x17] = "Abort",
                                                                [0x1B] = "Undef",
                                                                [0x1F] = "System",
                                                        }
                                                        local mode_name = modes[mode_bits] or "Unknown"

                                                        vim.notify(
                                                                string.format(
                                                                        "CPSR: %s\nMode: %s\nIRQ: %s",
                                                                        hex,
                                                                        mode_name,
                                                                        bit.band(val, 0x80) == 0 and "Enabled"
                                                                                or "Disabled"
                                                                ),
                                                                vim.log.levels.INFO
                                                        )
                                                end
                                        end)
                                end
                        end,
                        desc = "Interpret CPSR",
                },
                {
                        "<leader>da",
                        function()
                                local session = require("dap").session()
                                if session then
                                        -- Holt Disassembly mit C-Code-Referenz (/m)
                                        session:request(
                                                "evaluate",
                                                { expression = "-exec disassemble /m" },
                                                function(err, response)
                                                        if response then
                                                                -- Erstellt ein temporäres Buffer-Fenster für die Assembly
                                                                local buf = vim.api.nvim_create_buf(false, true)
                                                                vim.api.nvim_buf_set_lines(
                                                                        buf,
                                                                        0,
                                                                        -1,
                                                                        false,
                                                                        vim.split(response.result, "\n")
                                                                )
                                                                vim.api.nvim_set_option_value(
                                                                        "filetype",
                                                                        "asm",
                                                                        { buf = buf }
                                                                )
                                                                vim.api.nvim_open_win(
                                                                        buf,
                                                                        true,
                                                                        { vertical = true, split = "right", width = 80 }
                                                                )
                                                        end
                                                end
                                        )
                                end
                        end,
                        desc = "Show Mixed Disassembly",
                }, -- Ersetze deine F1 (oder welche Taste du nutzt) durch das hier:
                {
                        "<F1>",
                        function()
                                -- Kein -exec mehr nötig! Einfach den GDB-Befehl direkt schicken.
                                require("dap").repl.execute("disassemble /m $pc-20, $pc+20")
                        end,
                        desc = "Show Mixed Assembly",
                },
                -- In den dap.lua Keys:
                {
                        "<F2>",
                        function()
                                require("dap").terminate()
                        end,
                        desc = "Stop",
                },
                {
                        "<F3>",
                        function()
                                require("dap").repl.open()
                        end,
                        desc = "GDB Konsole öffnen",
                },
                {
                        "<F4>",
                        function()
                                require("dapui").toggle()
                        end,
                        desc = "UI an/aus",
                },
                {
                        "<F5>",
                        function()
                                require("dap").continue()
                        end,
                        desc = "Start/Weiter",
                },
                {
                        "<F9>",
                        function()
                                require("dap").toggle_breakpoint()
                        end,
                        desc = "Breakpoint setzen/löschen",
                },
                {
                        "<F10>",
                        function()
                                require("dap").step_over({ granularity = "instruction" })
                        end,
                        desc = "Nächste Instruktion (Überspringen)",
                },
                {
                        "<F11>",
                        function()
                                require("dap").step_into({ granularity = "instruction" })
                        end,
                        desc = "Einzelschritt (Hineingehen)",
                },
                {
                        "<F12>",
                        function()
                                require("dap").step_out()
                        end,
                        desc = "Aus Funktion springen",
                },
        },
}
