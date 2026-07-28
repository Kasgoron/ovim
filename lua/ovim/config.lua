local M = {}

local config_path = vim.fn.stdpath("config") .. "/config.lua"



local function create_config()

    local file = io.open(config_path, "w")

    if not file then
        return
    end


    file:write([[
return {

    notes_dir = "~/Notes",

    ui = {

        title = "OVIM",

        logo = {
            "        ██████╗ ██╗   ██╗██╗███╗   ███╗",
            "       ██╔═══██╗██║   ██║██║████╗ ████║",
            "       ██║   ██║██║   ██║██║██╔████╔██║",
            "       ╚██████╔╝╚██████╔╝██║██║╚██╔╝██║",
            "        ╚═════╝  ╚═════╝ ╚═╝╚═╝ ╚═╝ ╚═╝",
            "",
            "             Markdown Workspace",
        },

    },

    tree = {

        width = 25,

    },

}
]])

    file:close()

end



if vim.fn.filereadable(config_path) == 0 then
    create_config()
end



local function load()

    local defaults = require("ovim.defaults")

    local ok, user_config = pcall(dofile, config_path)


    if ok and type(user_config) == "table" then

        M.options = vim.tbl_deep_extend(
            "force",
            defaults,
            user_config
        )

    else

        M.options = defaults

    end

end



load()



function M.reload()

    local defaults = require("ovim.defaults")

    local ok, user_config = pcall(dofile, config_path)


    if ok and type(user_config) == "table" then

        M.options = vim.tbl_deep_extend(
            "force",
            defaults,
            user_config
        )

    else

        M.options = defaults

    end

end



return M
