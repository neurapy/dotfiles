local MODULE = {}

local RENDER = require("notebook_separators.render")

function MODULE.render(bufnr, win)
        RENDER.render(bufnr, win)
end

function MODULE.setup(opts)
        opts = opts or {}
        RENDER.setup(opts)
end

return MODULE
