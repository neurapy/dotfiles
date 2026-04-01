local EXTMARKS = {}

EXTMARKS.ns = vim.api.nvim_create_namespace("notebook_separators")

function EXTMARKS.clear(bufnr)
        vim.api.nvim_buf_clear_namespace(bufnr, EXTMARKS.ns, 0, -1)
end

-- NEW: allow overlay with multiple virt_text chunks
-- chunks = { {text, hl}, {text2, hl2}, ... }
function EXTMARKS.put_overlay_chunks(bufnr, lnum, chunks)
        vim.api.nvim_buf_set_extmark(bufnr, EXTMARKS.ns, lnum, 0, {
                virt_text = chunks,
                virt_text_pos = "overlay",
                hl_mode = "combine",
        })
end

function EXTMARKS.put_overlay(bufnr, lnum, text, hl, priority)
        vim.api.nvim_buf_set_extmark(bufnr, EXTMARKS.ns, lnum, 0, {
                virt_text = { { text, hl } },
                virt_text_pos = "overlay",
                hl_mode = "combine",
                priority = priority or 100,
        })
end

function EXTMARKS.put_right_chunks(bufnr, lnum, chunks)
        vim.api.nvim_buf_set_extmark(bufnr, EXTMARKS.ns, lnum, 0, {
                virt_text = chunks,
                virt_text_pos = "right_align",
                hl_mode = "combine",
                priority = 200,
        })
end

function EXTMARKS.put_right(bufnr, lnum, glyph, hl)
        vim.api.nvim_buf_set_extmark(bufnr, EXTMARKS.ns, lnum, 0, {
                virt_text = { { glyph, hl } },
                virt_text_pos = "right_align",
                hl_mode = "combine",
                priority = 200, -- border wins
        })
end

function EXTMARKS.put_right_icon(bufnr, lnum, glyph, hl)
        vim.api.nvim_buf_set_extmark(bufnr, EXTMARKS.ns, lnum, 0, {
                virt_text = { { glyph, hl } },
                virt_text_pos = "right_align",
                hl_mode = "combine",
                priority = 150, -- below border (we'll set border higher)
        })
end

return EXTMARKS
