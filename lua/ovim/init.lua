local M = {}

function M.setup()

    require("ovim.keymaps").setup()

    require("ovim.tree").setup_keys()


    vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()

            vim.keymap.set("n", "q", function()

                require("ovim.keymaps").quit()

            end, {
                buffer = true,
                silent = true
            })


            vim.keymap.set("n", "Й", function()

                require("ovim.keymaps").quit()

            end, {
                buffer = true,
                silent = true
            })

        end
    })


    require("ovim.menu").open()

end


M.setup()

return M
