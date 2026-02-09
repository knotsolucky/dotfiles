return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    build = ":MasonUpdate",
    opts = {},
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      local lsp = require "configs.lspconfig"
      local registry = require("mason-registry")

      local function setup_lspconfig()
        local util = require("lspconfig.util")
        require("mason-lspconfig").setup({
          ensure_installed = lsp.servers,
          automatic_installation = true,
          handlers = {
            function(server)
              require("lspconfig")[server].setup({ capabilities = lsp.capabilities, on_attach = lsp.on_attach })
            end,
            ["rust_analyzer"] = function()
              require("lspconfig").rust_analyzer.setup({
                capabilities = lsp.capabilities,
                on_attach = lsp.on_attach,
                settings = { ["rust-analyzer"] = { check = { command = "clippy" } } },
              })
            end,
            ["jdtls"] = function()
              require("lspconfig").jdtls.setup({
                capabilities = lsp.capabilities,
                on_attach = lsp.on_attach,
                root_dir = util.root_pattern(".git", "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle"),
              })
            end,
          },
        })
      end

      registry.update(function(success)
        if not success then
          vim.notify("Mason: run :MasonUpdate once, then restart Neovim for auto-install.", vim.log.levels.INFO)
        end
        setup_lspconfig()
        vim.schedule(function() pcall(vim.cmd, "MasonToolsInstall") end)
      end)
    end,
  },
}
