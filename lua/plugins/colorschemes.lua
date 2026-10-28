return {
    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        lazy = false,    -- load at startup
        priority = 1000, -- make sure it loads before other start plugins
        config = function()
            -- vim.cmd.colorscheme("kanagawa")
        end,
    },
    {
        "EdenEast/nightfox.nvim",
        name = "nightfox",
        lazy = false,    -- load at startup
        priority = 1000, -- make sure it loads before other start plugins
        config = function()
            -- vim.cmd.colorscheme("terafox")
            vim.cmd.colorscheme("nightfox")
            -- vim.cmd.colorscheme("dayfox")
            -- vim.cmd.colorscheme("nordfox")
        end,
    },
    {
        "shaunsingh/nord.nvim",
        name = "nord",
        lazy = false,
        priority = 1000,
        config = function()
            -- vim.cmd.colorscheme("nord")
        end,
    },
    {
        "aktersnurra/no-clown-fiesta.nvim",
        priority = 1000,
        -- config = function()
        --     local plugin = require "no-clown-fiesta"
        --     plugin.setup({
        --         -- transparent = true,
        --         -- theme = "dark",
        --         theme = "dim",
        --         -- theme = "light",
        --         styles = {
        --             type = { bold = true },
        --             lsp = { underline = false },
        --             match_paren = { underline = true },
        --         },
        --     })
        --     local ret =  plugin.load()
        --
        --     -- -- native: 262626
        --     -- -- ghostty: 272B33
        --     local light = "#292929"
        --     local dark = "#262626"
        --     local darker = "#202020"
        --     -- local tabunderline = false
        --     --
        --     vim.api.nvim_set_hl(0, "CursorLine", { bg = darker })
        --     vim.api.nvim_set_hl(0, "ColorColumn", { bg = light })
        --     -- vim.api.nvim_set_hl(0, "Search", { bg = dark, underline = true })
        --     vim.api.nvim_set_hl(0, "StatusLine", { bg = dark })
        --     -- vim.api.nvim_set_hl(0, "Visual", { bg = dark })
        --     -- vim.api.nvim_set_hl(0, "TabLine", { bg = dark, underline = tabunderline })
        --     -- vim.api.nvim_set_hl(0, "TabLineSel", { bg = light, underline = tabunderline })
        --     -- vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE", underline = tabunderline })
        --
        --     return ret
        -- end,
        lazy = false,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            -- vim.cmd("colorscheme catppuccin-frappe")
        end
    },
}
