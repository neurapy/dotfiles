return {
        -- 1) Build step (command that produces the ELF)
        make_cmd = { "make", "-s", "kernel" },

        -- 2) objdump step
        elf_path = "build/kernel.elf", -- relative to project root
        objdump_cmd = { "arm-none-eabi-objdump" },
        objdump_args = { -- if you remove these it will break.
                "-d", -- disassemble
                "-l", -- include file:line info (required for mapping)
                "--demangle", -- nicer symbols (useful for C++)
                "--no-show-raw-insn", -- hide raw bytes
        },

        -- UI
        split = "vert rightbelow vsplit",
        title = "AsmView",
        filetype = "asm", -- the type the AMSVIEW BUFFER is treated at
        hl_group = "Visual",
        max_line_delta = 80,

        -- behavior
        auto_sync = true,
}
