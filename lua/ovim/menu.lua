local M = {}

local notes = require("ovim.notes")
local state = require("ovim.state")


function M.open()

    state.in_menu = true


    vim.cmd("enew")


    local buf = vim.api.nvim_get_current_buf()


    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false


    local lines = {
        "",
        "              OVIM",
        "",
        "        1. New note",
        "        2. Open note",
        "        3. Settings",
        "",
        "        q. Quit",
        ""
    }


    vim.api.nvim_buf_set_lines(
        buf,
        0,
        -1,
        false,
        lines
    )


    vim.bo[buf].modifiable = false



    vim.keymap.set("n", "1", function()

        notes.create()

    end, {
        buffer = buf,
        silent = true
    })


    vim.keymap.set("n", "2", function()

        notes.open()

    end, {
        buffer = buf,
        silent = true
    })


    vim.keymap.set("n", "3", function()

        print("Settings")

    end, {
        buffer = buf,
        silent = true
    })


end


return M
