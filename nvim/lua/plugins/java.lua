return {
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = { "williamboman/mason.nvim", "nvim-lua/plenary.nvim", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local jdtls = require("jdtls")
      local mason_registry = require("mason-registry")
      if not mason_registry.is_installed("jdtls") then
        vim.notify("jdtls is not installed. Run :MasonInstall jdtls", vim.log.levels.WARN)
        return
      end

      local mason_root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
      local jdtls_path = mason_root .. "/packages/jdtls"
      local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", 1, 1, true)[1] or jdtls_path .. "/plugins/org.eclipse.equinox.launcher.jar"
      if vim.fn.empty(launcher) == 1 or vim.fn.filereadable(launcher) == 0 then
        vim.notify("Could not locate jdtls launcher. Please reinstall jdtls.", vim.log.levels.ERROR)
        return
      end

      local uname = vim.loop.os_uname()
      local arch, sysname = uname.machine:lower(), uname.sysname
      local config_dir = jdtls_path .. "/config_linux"
      if sysname == "Darwin" then
        config_dir = jdtls_path .. (arch:find("arm") and "/config_mac_arm" or "/config_mac")
      elseif sysname == "Windows_NT" then
        config_dir = jdtls_path .. "/config_win"
      elseif sysname == "Linux" and arch:find("arm") then
        config_dir = jdtls_path .. "/config_linux_arm"
      end

      local root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })
      if not root_dir then
        vim.notify("Could not find project root for JDTLS", vim.log.levels.WARN)
        return
      end

      local bundles = {}
      if mason_registry.is_installed("java-debug-adapter") then
        local jar_pattern = mason_root .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
        for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), "\n")) do
          if bundle ~= "" then table.insert(bundles, bundle) end
        end
      end

      local java_cmd = "java"
      for _, path in ipairs({ "/opt/homebrew/opt/openjdk@21/bin/java", "/opt/homebrew/opt/openjdk@17/bin/java", vim.fn.exepath("java") }) do
        if path and path ~= "" and vim.fn.executable(path) == 1 then
          java_cmd = path
          break
        end
      end

      jdtls.start_or_attach({
        cmd = {
          java_cmd, "-Declipse.application=org.eclipse.jdt.ls.core.id1", "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product", "-Dlog.protocol=true", "-Dlog.level=ALL", "-Xms1g",
          "--add-modules=ALL-SYSTEM", "--add-opens", "java.base/java.util=ALL-UNNAMED", "--add-opens", "java.base/java.lang=ALL-UNNAMED",
          "-jar", launcher, "-configuration", config_dir, "-data", vim.fn.stdpath("data") .. "/jdtls_workspaces/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
        },
        root_dir = root_dir,
        settings = {
          java = {
            eclipse = { downloadSources = true },
            configuration = { updateBuildConfiguration = "interactive" },
            maven = { downloadSources = true },
            references = { includeDecompiledSources = true },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens = { enabled = true },
            signatureHelp = { enabled = true },
            inlayHints = { parameterNames = { enabled = "all" } },
            format = { enabled = false },
          },
        },
        init_options = { bundles = bundles },
      })
    end,
  },
}
