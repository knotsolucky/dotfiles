return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
      notify_on_error = true,
      format_on_save = {
        timeout_ms = 2000,
        lsp_fallback = true,
        async = false,
      },
      log_level = vim.log.levels.WARN,
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        jsonc = { "prettierd", "prettier" },
        html = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
        scss = { "prettierd", "prettier" },
        less = { "prettierd", "prettier" },
        markdown = { "prettierd", "prettier" },
        ["markdown.mdx"] = { "prettierd", "prettier" },
        python = { "black", "isort" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        yaml = { "yamlfmt" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        cs = { "csharpier" },
        java = { "google-java-format" },
        rust = { "rustfmt" },
      },
      formatters = {
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },
        prettierd = {
          condition = function(ctx)
            -- Only use prettierd if config file exists, otherwise skip
            local config_file = vim.fs.find({ "prettier.config.js", "prettier.config.cjs", ".prettierrc", ".prettierrc.json", ".prettierrc.js", ".prettierrc.cjs", ".prettierrc.yaml", ".prettierrc.yml", "package.json" }, { path = ctx.filename, upward = true })[1]
            return config_file ~= nil
          end,
        },
        prettier = {
          condition = function(ctx)
            -- Only use prettier if config file exists, otherwise skip
            local config_file = vim.fs.find({ "prettier.config.js", "prettier.config.cjs", ".prettierrc", ".prettierrc.json", ".prettierrc.js", ".prettierrc.cjs", ".prettierrc.yaml", ".prettierrc.yml", "package.json" }, { path = ctx.filename, upward = true })[1]
            return config_file ~= nil
          end,
        },
        black = {
          condition = function()
            return vim.fn.executable("black") == 1
          end,
          prepend_args = { "--line-length", "88" },
        },
        isort = {
          condition = function()
            return vim.fn.executable("isort") == 1
          end,
          prepend_args = { "--profile", "black" },
        },
        shfmt = {
          condition = function()
            return vim.fn.executable("shfmt") == 1
          end,
          prepend_args = { "-i", "2", "-ci", "-sr" },
        },
        clang_format = {
          prepend_args = { "--style", "{BasedOnStyle: Google, IndentWidth: 2, ColumnLimit: 100}" },
        },
        csharpier = {
          command = (vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")) .. "/bin/csharpier",
          args = { "--write-stdout" },
          stdin = true,
        },
        rustfmt = {
          condition = function()
            -- Use system rustfmt (installed via Homebrew)
            return vim.fn.executable("rustfmt") == 1
          end,
          command = "rustfmt",
          prepend_args = { "--edition", "2021" },
        },
        yamlfmt = {
          prepend_args = { "-formatter", "retain_line_breaks=true" },
        },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)

      -- Add keybindings for manual formatting
      vim.keymap.set({ "n", "v" }, "<leader>f", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format buffer" })
    end,
  },
}
