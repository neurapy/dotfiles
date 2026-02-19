return {
        "neurapy/asmview.nvim",
        cmd = { "AsmViewToggle", "AsmViewOpen", "AsmViewRebuild" },
        -- keymaps:
        keys = {
                { "<leader>od", "<cmd>AsmViewToggle<cr>", desc = "AsmView: toggle" },
                { "<leader>or", "<cmd>AsmViewRebuild<cr>", desc = "AsmView: rebuild" },
        },
        opts = function()
                return require("config.asmview") -- ../nvim/lua/config/asmview.lua
        end,
}
