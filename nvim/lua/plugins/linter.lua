return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      local mason_root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
      if lint.linters.trivy then
        lint.linters.trivy.cmd = mason_root .. "/bin/trivy"
      end

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        yaml = { "yamllint", "trivy" },
        json = { "jsonlint", "trivy" },
        dockerfile = { "trivy" },
      }

      local augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = augroup,
        callback = function() lint.try_lint() end,
      })
    end,
  },
}
