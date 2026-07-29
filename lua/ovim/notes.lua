local M = {}

local state = require("ovim.state")


local function get_notes_dir()

    local path = vim.fn.stdpath("config") .. "/config.lua"

    local config = dofile(path)

    return vim.fn.expand(config.notes_dir)

end


function M.create()

    local notes_dir = get_notes_dir()

    vim.fn.mkdir(notes_dir, "p")

    vim.ui.input({
        prompt = "Note name: ",
    }, function(name)

        if not name or name == "" then
            return
        end

        local file = notes_dir .. "/" .. name .. ".md"

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

        vim.cmd.edit(vim.fn.fnameescape(file))

        require("ovim.tree").open()

    end)

end


function M.open()

    local notes_dir = get_notes_dir()

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


    if #files == 0 then
        print("No notes found")
        return
    end


    require("ovim.picker").open(files, function(file)

        state.in_menu = false

        local path = notes_dir .. "/" .. file

        vim.cmd.edit(vim.fn.fnameescape(path))

        require("ovim.tree").open()

    end)

end


return M
