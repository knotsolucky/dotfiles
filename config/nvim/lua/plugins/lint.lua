return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "InsertLeave" },
    keys = {
      { "<leader>ll", function() require("lint").try_lint() end, desc = "Lint buffer" },
    },
    config = function()
      local lint = require("lint")
      local function sync()
        local by_ft = {}
        if vim.fn.executable("eslint_d") == 1 then
          for _, ft in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
            by_ft[ft] = { "eslint_d" }
          end
        end
        if vim.fn.executable("ruff") == 1 then
          by_ft.python = { "ruff" }
        end
        if vim.fn.executable("luacheck") == 1 then
          by_ft.lua = { "luacheck" }
        end
        lint.linters_by_ft = by_ft
      end
      sync()
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("user_lint", { clear = true }),
        callback = function()
          sync()
          lint.try_lint()
        end,
      })
    end,
  },
}
