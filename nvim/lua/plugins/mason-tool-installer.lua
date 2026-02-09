return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    lazy = false,
    opts = {
      ensure_installed = {
        "prettier", "rustfmt", "clang-format", "ruff", "black", "google-java-format",
        "eslint", "clang-tidy",
      },
      run_on_start = true,
      start_delay = 6000,
      debounce_hours = 2,
      auto_update = false,
      integrations = { ["mason-lspconfig"] = true, ["mason-nvim-dap"] = true },
    },
    config = function(_, o) require("mason-tool-installer").setup(o) end,
  },
}
