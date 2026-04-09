return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = { "hrsh7th/cmp-nvim-lsp", "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    build = ":MasonUpdate",
    config = function() require("mason").setup() end,
  },
  {
    "frostplexx/mason-bridge.nvim",
    lazy = false,
    dependencies = "williamboman/mason.nvim",
    config = function() require("mason-bridge").setup({}) end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    config = function()
      local cap = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), require("cmp_nvim_lsp").default_capabilities())
      local function on_attach(_, bufnr)
        local m, o = vim.keymap.set, { buffer = bufnr }
        m("n", "gd", vim.lsp.buf.definition, o)
        m("n", "gD", vim.lsp.buf.declaration, o)
        m("n", "gr", vim.lsp.buf.references, o)
        m("n", "K", vim.lsp.buf.hover, o)
        m("n", "<leader>ca", function()
          require("telescope.builtin").lsp_code_actions({ bufnr = bufnr })
        end, vim.tbl_extend("force", o, { desc = "Code action (Telescope)" }))
        m("n", "<leader>cf", vim.lsp.buf.format, vim.tbl_extend("force", o, { desc = "Format" }))
      end
      local mlsp = require("mason-lspconfig")
      local mappings = require("mason-lspconfig.mappings").get_mason_map()
      for _, name in ipairs(mlsp.get_installed_servers()) do
        vim.lsp.config(name, { capabilities = cap, on_attach = on_attach })
      end
      require("mason-registry"):on("package:install:success", vim.schedule_wrap(function(pkg)
        local name = mappings.package_to_lspconfig[pkg.name]
        if name then vim.lsp.config(name, { capabilities = cap, on_attach = on_attach }) end
      end))
      mlsp.setup({ automatic_installation = true, ensure_installed = {} })
    end,
  },
}
