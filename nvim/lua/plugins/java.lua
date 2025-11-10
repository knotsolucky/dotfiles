return {
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvim-lua/plenary.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local jdtls_ok, jdtls = pcall(require, "jdtls")
      if not jdtls_ok then
        return
      end
      local mason_registry = require("mason-registry")
      if not mason_registry.has_package("jdtls") then
        vim.notify("jdtls is not installed. Run :MasonInstall jdtls", vim.log.levels.WARN)
        return
      end

      local jdtls_pkg = mason_registry.get_package("jdtls")
      local jdtls_path = jdtls_pkg:get_install_path()
      local launcher = jdtls_path .. "/plugins/org.eclipse.equinox.launcher.jar"
      local config_dir = jdtls_path .. "/config_linux"
      if vim.fn.has("mac") == 1 then
        config_dir = jdtls_path .. "/config_mac"
      elseif vim.fn.has("win32") == 1 then
        config_dir = jdtls_path .. "/config_win"
      end

      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      local workspace_dir = vim.fn.stdpath("data") .. "/jdtls_workspaces/" .. project_name

      local root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })
      if not root_dir then
        vim.notify("Could not find project root for JDTLS", vim.log.levels.WARN)
        return
      end

      local bundles = {}
      local java_debug_ok, java_debug_pkg = pcall(mason_registry.get_package, "java-debug-adapter")
      if java_debug_ok then
        local java_debug_path = java_debug_pkg:get_install_path()
        local jar_pattern = java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"
        for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), "\n")) do
          if bundle ~= "" then
            table.insert(bundles, bundle)
          end
        end
      end

      local config = {
        cmd = {
          "java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-Xms1g",
          "--add-modules=ALL-SYSTEM",
          "--add-opens", "java.base/java.util=ALL-UNNAMED",
          "--add-opens", "java.base/java.lang=ALL-UNNAMED",
          "-jar",
          launcher,
          "-configuration",
          config_dir,
          "-data",
          workspace_dir,
        },
        root_dir = root_dir,
        settings = {
          java = {
            eclipse = { downloadSources = true },
            configuration = {
              updateBuildConfiguration = "interactive",
            },
            maven = { downloadSources = true },
            references = { includeDecompiledSources = true },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens = { enabled = true },
            signatureHelp = { enabled = true },
            inlayHints = {
              parameterNames = { enabled = "all" },
            },
            format = { enabled = false },
          },
        },
        init_options = {
          bundles = bundles,
        },
      }

      jdtls.start_or_attach(config)
    end,
  },
}

