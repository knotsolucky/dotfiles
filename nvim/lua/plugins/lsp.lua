local servers = {
  lua_ls = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  tsserver = {},
  pyright = {},
  bashls = {},
  jsonls = {},
  yamlls = {},
  tailwindcss = {},
  clangd = {
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=never",
      "--completion-style=bundled",
    },
  },
  omnisharp = {
    cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
    settings = {
      omnisharp = {
        enableEditorConfigSupport = true,
        enableRoslynAnalyzers = true,
        organizeImportsOnFormat = true,
        enableImportCompletion = true,
      },
    },
  },
}

local tool_installs = {
  "stylua",
  "prettierd",
  "prettier",
  "eslint_d",
  "tailwindcss-language-server",
  "black",
  "isort",
  "typescript-language-server",
  "shellcheck",
  "shfmt",
  "yamlfmt",
  "clang-format",
  "csharpier",
  "google-java-format",
  "jdtls",
}

local function compute_ensure_servers()
  local ensure = {}
  local has_mapping, server_mapping = pcall(require, "mason-lspconfig.mappings.server")
  if has_mapping then
    local available = server_mapping.lspconfig_to_package or {}
    for server in pairs(servers) do
      if available[server] then
        table.insert(ensure, server)
      end
    end
  else
    local skip = { tsserver = true }
    for server in pairs(servers) do
      if not skip[server] then
        table.insert(ensure, server)
      end
    end
  end
  return ensure
end

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
      },
      {
        "williamboman/mason-lspconfig.nvim",
      },
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local mason_tool_installer = require("mason-tool-installer")
      local lspconfig = require("lspconfig")

      mason.setup()
      mason_tool_installer.setup({
        ensure_installed = tool_installs,
        auto_update = true,
        run_on_start = true,
        start_delay = 3000,
      })

      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()

      local on_attach = function(client, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        local lmap = function(keys, rhs, desc)
          map("n", "<leader>l" .. keys, rhs, desc)
        end

        if client.name == "tsserver" or client.name == "lua_ls" then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end

        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        map("n", "gr", vim.lsp.buf.references, "Go to references")
        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
        map("n", "K", vim.lsp.buf.hover, "Hover documentation")
        map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
        map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")

        lmap("dd", vim.diagnostic.open_float, "Diagnostics (cursor)")
        lmap("dD", vim.diagnostic.setloclist, "Diagnostics list")
        lmap("dn", vim.diagnostic.goto_next, "Diagnostic next")
        lmap("dp", vim.diagnostic.goto_prev, "Diagnostic previous")

        lmap("ar", vim.lsp.buf.rename, "Rename symbol")
        lmap("aa", vim.lsp.buf.code_action, "Code actions")
        lmap("af", function()
          vim.lsp.buf.format({ async = true })
        end, "Format buffer")

        lmap("gs", vim.lsp.buf.document_symbol, "Document symbols")
        lmap("gS", vim.lsp.buf.workspace_symbol, "Workspace symbols")
        lmap("gI", vim.lsp.buf.incoming_calls, "Incoming calls")
        lmap("gO", vim.lsp.buf.outgoing_calls, "Outgoing calls")

        lmap("gd", vim.lsp.buf.definition, "Go to definition")
        lmap("gD", vim.lsp.buf.declaration, "Go to declaration")
        lmap("gr", vim.lsp.buf.references, "Go to references")
        lmap("gi", vim.lsp.buf.implementation, "Go to implementation")
        lmap("gt", vim.lsp.buf.type_definition, "Type definition")
        lmap("gh", vim.lsp.buf.hover, "Hover documentation")
        lmap("gk", vim.lsp.buf.signature_help, "Signature help")

        lmap("wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "List workspace folders")
        lmap("wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
        lmap("wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")

        local ok, which_key = pcall(require, "which-key")
        if ok then
          which_key.add({
            { "<leader>la", group = "Actions" },
            { "<leader>laa", desc = "Code actions" },
            { "<leader>laf", desc = "Format buffer" },
            { "<leader>lar", desc = "Rename symbol" },
            { "<leader>ld", group = "Diagnostics" },
            { "<leader>ldd", desc = "Diagnostics (cursor)" },
            { "<leader>ldD", desc = "Diagnostics list" },
            { "<leader>ldn", desc = "Next diagnostic" },
            { "<leader>ldp", desc = "Previous diagnostic" },
            { "<leader>lg", group = "Navigation" },
            { "<leader>lgd", desc = "Definition" },
            { "<leader>lgD", desc = "Declaration" },
            { "<leader>lgr", desc = "References" },
            { "<leader>lgi", desc = "Implementation" },
            { "<leader>lgt", desc = "Type definition" },
            { "<leader>lgh", desc = "Hover" },
            { "<leader>lgk", desc = "Signature help" },
            { "<leader>ls", group = "Symbols" },
            { "<leader>lss", desc = "Document symbols" },
            { "<leader>lsS", desc = "Workspace symbols" },
            { "<leader>lsI", desc = "Incoming calls" },
            { "<leader>lsO", desc = "Outgoing calls" },
            { "<leader>lw", group = "Workspace" },
            { "<leader>lwa", desc = "Add folder" },
            { "<leader>lwl", desc = "List folders" },
            { "<leader>lwr", desc = "Remove folder" },
          }, { buffer = bufnr, mode = "n" })
        end
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then
            vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
          end
        end,
      })

      mason_lspconfig.setup({
        ensure_installed = compute_ensure_servers(),
        automatic_installation = true,
        handlers = {
          function(server_name)
            local server_opts = vim.tbl_deep_extend("force", {}, servers[server_name] or {})
            server_opts.capabilities = capabilities
            server_opts.on_attach = on_attach
            if server_name == "clangd" then
              server_opts.capabilities = vim.deepcopy(capabilities)
              server_opts.capabilities.offsetEncoding = { "utf-16" }
            end
            if server_name == "omnisharp" then
              local ok, omnisharp_ext = pcall(require, "omnisharp_extended")
              if ok then
                server_opts.handlers = server_opts.handlers or {}
                server_opts.handlers["textDocument/definition"] = omnisharp_ext.handler
              end
            end
            lspconfig[server_name].setup(server_opts)
          end,
        },
      })

      vim.diagnostic.config({
        float = { border = "rounded" },
        severity_sort = true,
        virtual_text = {
          prefix = "●",
        },
      })
    end,
  },
}
