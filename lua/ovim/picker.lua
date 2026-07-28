local M = {}

function M.open(items, callback)

    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, items)

    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false


    local width = 40
    local height = math.min(#items + 2, 15)

    local ui = vim.api.nvim_list_uis()[1]

    local row = math.floor((ui.height - height) / 2)
    local col = math.floor((ui.width - width) / 2)


    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        border = "rounded",
        title = " Open note ",
        title_pos = "center",
    })


    vim.cmd("setlocal cursorline")


    local opts = {
        buffer = buf,
        silent = true,
        nowait = true,
    }


    vim.keymap.set("n", "q", function()
        vim.api.nvim_win_close(win, true)
    end, opts)


    vim.keymap.set("n", "<CR>", function()

        local line = vim.api.nvim_get_current_line()

        vim.api.nvim_win_close(win, true)

        callback(line)

    end, opts)

end


return M
