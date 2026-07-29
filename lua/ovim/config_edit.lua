local M = {}

local path = vim.fn.stdpath("config") .. "/config.lua"



local function replace(pattern, value)

    local file = io.open(path, "r")

    if not file then
        return
    end


    local content = file:read("*all")

    file:close()



    content = content:gsub(
        pattern,
        value
    )



    file = io.open(path, "w")

    if file then
        file:write(content)
        file:close()
    end

end


function M.notes_dir(value)

    replace(
        'notes_dir = ".-"',
        'notes_dir = "' .. value .. '"'
    )

end


function M.tree_width(value)

    replace(
        'width = %d+',
        'width = ' .. value
    )

end


return M
