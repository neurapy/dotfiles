return {
        -- "goerz/jupytext.nvim",
        -- lazy = false,
        -- opts = {
        --         format = "md:markdown", -- edit ipynb as markdown
        --         update = false,
        --         autosync = false,
        --         async_write = false, -- IMPORTANT: avoid races with BufWritePost hooks
        -- },
        "GCBallesteros/jupytext.nvim",
        lazy = false,
        opts = {
                style = "markdown",
                output_extension = "md",
                force_ft = "markdown",
        },

        keys = {
                { "<leader>mn", ":NewNotebook ", desc = "Make New Notebook" },
        },
        init = function()
                local default_notebook = [[
  {
    "cells": [
     {
      "cell_type": "markdown",
      "metadata": {},
      "source": [
        ""
      ]
     }
    ],
    "metadata": {
     "kernelspec": {
      "display_name": "Python 3",
      "language": "python",
      "name": "python3"
     },
     "language_info": {
      "codemirror_mode": {
        "name": "ipython"
      },
      "file_extension": ".py",
      "mimetype": "text/x-python",
      "name": "python",
      "nbconvert_exporter": "python",
      "pygments_lexer": "ipython3"
     }
    },
    "nbformat": 4,
    "nbformat_minor": 5
  }
]]

                local function new_notebook(filename)
                        local path = filename .. ".ipynb"
                        local file = io.open(path, "w")
                        if file then
                                file:write(default_notebook)
                                file:close()
                                vim.cmd("edit " .. path)
                        else
                                print("Error: Could not open new notebook file for writing.")
                        end
                end

                vim.api.nvim_create_user_command("NewNotebook", function(opts)
                        new_notebook(opts.args)
                end, {
                        nargs = 1,
                        complete = "file",
                })
        end,
}
