local M = {}


function M.save()

    vim.cmd("write")

end



function M.quit()

    local state = require("ovim.state")

    local ok, tree = pcall(require, "ovim.tree")

    if ok then
        tree.close()
    end


    -- если мы в меню
    if state.in_menu then
        vim.cmd("qa")
        return
    end


    -- если мы в заметке
    vim.cmd("bd!")


    state.in_menu = true


    vim.schedule(function()
        state.open_menu()
    end)


vim.cmd("bd!")


    state.in_settings = true


    vim.schedule(function()
        state.open_menu()
    end)

end

function M.setup()


    local save_keys = {
        "w",
        "W",
        "ц",
        "Ц",
    }

    local quit_keys = {
        "q",
        "Q",
        "й",
        "Й",
    }



    for _, key in ipairs(save_keys) do

        vim.keymap.set("n", key, M.save, {
            silent = true,
        })

    end



    for _, key in ipairs(quit_keys) do

        vim.keymap.set("n", key, M.quit, {
            silent = true,
        })

    end


end


return M
