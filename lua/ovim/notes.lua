local M = {}

local config = require("ovim.config").options
local state = require("ovim.state")


M.notes_dir = vim.fn.expand(config.notes_dir)



function M.create()

    vim.fn.mkdir(M.notes_dir, "p")


    vim.ui.input({
        prompt = "Note name: ",
    }, function(name)


        if not name or name == "" then
            return
        end


        local file = M.notes_dir .. "/" .. name .. ".md"


        local f = io.open(file, "w")


        if f then

            f:write(
                "---\n" ..
                "created: " .. os.date("%Y-%m-%d") .. "\n" ..
                "tags:\n" ..
                "---\n\n" ..
                "# " .. name .. "\n\n"
            )


            f:close()

        end



        state.in_menu = false


        vim.cmd("edit " .. file)


        require("ovim.tree").open()


    end)

end




function M.open()

    local files = {}


    local handle = vim.loop.fs_scandir(M.notes_dir)


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



    if #files == 0 then

        print("No notes found")
        return

    end



    require("ovim.picker").open(files, function(file)


        state.in_menu = false


        vim.cmd(
            "edit " .. M.notes_dir .. "/" .. file
        )


        require("ovim.tree").open()


    end)

end


return M
