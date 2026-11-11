return {
    "stevearc/conform.nvim",
    enabled = vim.fn.has("win32") == 0, -- the formatters aren't installed on windows
    version = "*",
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "ruff_format" },
                cpp = { "clang-format" },
                markdown = { "prettier" },
                json = { "jmatte" },
            },
            formatters = {
                jmatte = {
                    command = "jmatte",
                    stdin = true,
                },
            },
        })

        vim.keymap.set('n', '<leader>cf', conform.format, { desc = "conform format" })
    end
}
