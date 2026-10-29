return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter").setup()

      require("nvim-treesitter").install {
        "bash", "c", "cpp", "lua", "vim", "vimdoc", "query",
        "python", "javascript", "typescript", "html", "css", "json",
        "markdown", "markdown_inline", "fennel",
      }

      -- Enable treesitter highlighting per filetype (new main branch API)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "bash", "sh", "c", "cpp", "lua", "vim", "help", "query",
          "python", "javascript", "typescript", "html", "css", "json",
          "markdown", "fennel",
        },
        -- pcall: a parser that has not been installed yet should not stop the file from opening
        callback = function() pcall(vim.treesitter.start) end,
      })
    end,
  },

  -- ── Textobjects ──────────────────────────────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = function()
      vim.g.no_plugin_maps = true
    end,
    config = function()
      local select = require("nvim-treesitter-textobjects.select")
      local swap   = require("nvim-treesitter-textobjects.swap")
      local move   = require("nvim-treesitter-textobjects.move")

      require("nvim-treesitter-textobjects").setup {
        select = {
          lookahead = true,
          selection_modes = {
            ["@parameter.outer"] = "v",
            ["@function.outer"]  = "V",
            ["@class.outer"]     = "<c-v>",
          },
          include_surrounding_whitespace = true,
        },
        move = { set_jumps = true },
      }

      -- Select
      vim.keymap.set({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "ac", function() select.select_textobject("@class.outer",    "textobjects") end)
      vim.keymap.set({ "x", "o" }, "ic", function() select.select_textobject("@class.inner",    "textobjects") end, { desc = "Select inner part of a class region" })
      vim.keymap.set({ "x", "o" }, "as", function() select.select_textobject("@local.scope",    "locals")      end, { desc = "Select language scope" })

      -- Swap
      vim.keymap.set("n", "<leader>a", function() swap.swap_next("@parameter.inner")     end)
      vim.keymap.set("n", "<leader>A", function() swap.swap_previous("@parameter.inner") end)

      -- Move
      vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer",  "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "]s", function() move.goto_next_start("@local.scope",     "locals")      end, { desc = "Next scope" })
      vim.keymap.set({ "n", "x", "o" }, "]z", function() move.goto_next_start("@fold",            "folds")       end, { desc = "Next fold" })
      vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer",    "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer",   "textobjects") end)
    end,
  },
  -- ── End Textobjects ──────────────────────────────────────────────────────
}
