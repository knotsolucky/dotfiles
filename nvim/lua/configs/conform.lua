local mason_root = vim.env.MASON or (vim.fn.stdpath "data" .. "/mason")

local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    markdown = { "prettier" },
    python = { "black", "isort" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    yaml = { "yamlfmt" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    cs = { "csharpier" },
    rust = { "rustfmt" },
    java = { "google-java-format" },
  },
  formatters = {
    clang_format = {
      prepend_args = { "--style", "{BasedOnStyle: Google, IndentWidth: 2, ColumnLimit: 100}" },
    },
    csharpier = {
      command = mason_root .. "/bin/csharpier",
      args = { "--write-stdout" },
      stdin = true,
    },
  },
  format_on_save = function(bufnr)
    if vim.g.disable_lsp_lint_formatter then
      return nil
    end
    return { timeout_ms = 500 }
  end,
}

return options
