local M = {}

M.tree_win = nil
M.editor_win = nil


function M.close()

    if M.tree_win and vim.api.nvim_win_is_valid(M.tree_win) then

        -- закрываем только если есть другое окно
        if #vim.api.nvim_list_wins() > 1 then
            vim.api.nvim_win_close(M.tree_win, true)
        end

    end


    M.tree_win = nil
    M.editor_win = nil

end



function M.toggle()

    if M.tree_win and vim.api.nvim_win_is_valid(M.tree_win) then

        M.close()

    else

        M.open()

    end

end



function M.open()

    -- если дерево уже есть
    if M.tree_win and vim.api.nvim_win_is_valid(M.tree_win) then
        return
    end


    local notes_dir = vim.fn.expand("~/Notes")

    local files = {}


    local handle = vim.loop.fs_scandir(notes_dir)

    if handle then

        while true do

            local name, type = vim.loop.fs_scandir_next(handle)

            if not name then
                break
            end


            if type == "file" and name:match("%.md$") then
                table.insert(files, name)
            end

        end

    end



    local buf = vim.api.nvim_create_buf(false, true)


    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
        " Notes",
        "",
        unpack(files)
    })


    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false



    -- сохраняем окно заметки
    M.editor_win = vim.api.nvim_get_current_win()



    vim.cmd("leftabove vsplit")



    M.tree_win = vim.api.nvim_get_current_win()



    vim.api.nvim_win_set_buf(M.tree_win, buf)

    vim.api.nvim_win_set_width(M.tree_win, 25)



    -- обратно в заметку
    vim.api.nvim_set_current_win(M.editor_win)



    local opts = {
        buffer = buf,
        silent = true,
        nowait = true,
    }



    -- открыть файл из дерева
    vim.keymap.set("n", "<CR>", function()

        local file = vim.api.nvim_get_current_line()


        if file:match("%.md$") then

            if M.editor_win and vim.api.nvim_win_is_valid(M.editor_win) then

                vim.api.nvim_set_current_win(M.editor_win)

            end


            vim.cmd("edit " .. notes_dir .. "/" .. file)


            -- обновляем окно редактора
            M.editor_win = vim.api.nvim_get_current_win()

        end


    end, opts)



    -- закрыть дерево
    vim.keymap.set("n", "q", function()

        M.close()

    end, opts)

end




function M.setup_keys()

    -- Tab дерево ↔ заметка
    vim.keymap.set("n", "<Tab>", function()


        if M.tree_win and vim.api.nvim_win_is_valid(M.tree_win) then


            local current = vim.api.nvim_get_current_win()


            if current == M.tree_win then

                if M.editor_win and vim.api.nvim_win_is_valid(M.editor_win) then
                    vim.api.nvim_set_current_win(M.editor_win)
                end


            else

                vim.api.nvim_set_current_win(M.tree_win)

            end


        end


    end, {
        silent = true
    })



    -- t открыть/закрыть дерево
    vim.keymap.set("n", "t", function()

        M.toggle()

    end, {
        silent = true
    })

end


return M
