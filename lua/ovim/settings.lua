local M = {}

local edit = require("ovim.config_edit")


function M.open()

    vim.cmd("enew")


    local buf = vim.api.nvim_get_current_buf()


    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false

    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.cursorline = false



    local selected = 1


    local items = {
        "Change notes folder",
        "Change tree width",
        "Edit logo",
    }



    local function reload_config()

        require("ovim.config").reload()

        return require("ovim.config").options

    end




    local function redraw()


        local config = require("ovim.config").options


        local lines = {

            "",

        }



        for i, item in ipairs(items) do


            local prefix = "  "

            if i == selected then
                prefix = "> "
            end



            table.insert(
                lines,
                prefix .. item
            )



            if i == 1 then

                table.insert(
                    lines,
                    "    " .. config.notes_dir
                )


            elseif i == 2 then

                table.insert(
                    lines,
                    "    " .. config.tree.width
                )
	end


            table.insert(lines, "")

        end



        table.insert(lines, "q. Back")


        vim.bo[buf].modifiable = true


        vim.api.nvim_buf_set_lines(
            buf,
            0,
            -1,
            false,
            lines
        )


        vim.bo[buf].modifiable = false



        local cursor_line = 2


        for i = 1, selected - 1 do

            cursor_line = cursor_line + 2

            if i <= 3 then
                cursor_line = cursor_line + 1
            end

        end



        vim.api.nvim_win_set_cursor(
            0,
            {
                cursor_line,
                0
            }
        )


    end





    redraw()





    local function next_item()

        selected = selected + 1

        if selected > #items then
            selected = 1
        end

        redraw()

    end



    local function prev_item()

        selected = selected - 1

        if selected < 1 then
            selected = #items
        end

        redraw()

    end


    vim.keymap.set("n", "<Down>", next_item, {
        buffer = buf,
        silent = true,
    })


    vim.keymap.set("n", "<Up>", prev_item, {
        buffer = buf,
        silent = true,
    })


    vim.keymap.set("n", "j", next_item, {
        buffer = buf,
        silent = true,
    })


    vim.keymap.set("n", "k", prev_item, {
        buffer = buf,
        silent = true,
    })



    vim.keymap.set("n", "<CR>", function()


        local config = require("ovim.config").options



        if selected == 1 then


            vim.ui.input({
                prompt = "New dir: ",
                default = config.notes_dir,
            }, function(value)

		    if value then
                    edit.notes_dir(value)
                    reload_config()
                    redraw()
                end

            end)




        elseif selected == 2 then


            vim.ui.input({
                prompt = "Tree width: ",
                default = tostring(config.tree.width),
            }, function(value)


                if value then

                    edit.tree_width(value)

                    reload_config()

		    require("ovim.tree").update_width()

                    redraw()

                end


            end)




        elseif selected == 3 then


            vim.cmd(
                "edit " .. vim.fn.stdpath("config") .. "/config.lua"
            )


        end


    end, {
        buffer = buf,
        silent = true,
    })


    vim.keymap.set("n", "й", function()

        require("ovim.config").reload()

        require("ovim.menu").open()


    end, {
        buffer = buf,
        silent = true,
    })


    vim.keymap.set("n", "q", function()

        require("ovim.config").reload()

        require("ovim.menu").open()


    end, {
        buffer = buf,
        silent = true,
    })


end


return M
