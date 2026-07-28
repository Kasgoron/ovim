local M = {}

local notes = require("ovim.notes")
local state = require("ovim.state")


function M.open()
    local config = require("ovim.config").options
    state.in_menu = true

    vim.cmd("enew")


    local buf = vim.api.nvim_get_current_buf()


    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
 
local lines = {}


for _, line in ipairs(config.ui.logo) do
    table.insert(lines, line)
end


table.insert(lines, "")
table.insert(lines, "        1. New note")
table.insert(lines, "        2. Open note")
table.insert(lines, "        3. Settings")
table.insert(lines, "")
table.insert(lines, "        q. Quit")
table.insert(lines, "")

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
        silent = true,
    })



    vim.keymap.set("n", "2", function()

        notes.open()

    end, {
        buffer = buf,
        silent = true,
    })



    vim.keymap.set("n", "3", function()

        require("ovim.settings").open()

    end, {
        buffer = buf,
        silent = true,
    })



    vim.keymap.set("n", "q", "<cmd>qa<CR>", {
        buffer = buf,
        silent = true,
    })


end


return M
