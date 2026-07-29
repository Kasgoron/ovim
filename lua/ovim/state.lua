local M = {}

M.in_menu = true

function M.open_menu()
    require("ovim.menu").open()
end

return M

