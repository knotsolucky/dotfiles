return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("nvim-dap-virtual-text").setup({
        commented = true,
      })

      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸" },
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "↻",
            terminate = "□",
          },
        },
      })

      local mason_registry = require("mason-registry")
      local mason_dap = require("mason-nvim-dap")
      mason_dap.setup({
        ensure_installed = { "python", "node2", "codelldb", "netcoredbg", "java-debug-adapter" },
        automatic_installation = true,
        handlers = {
          function(config)
            local ok, autoconfig = pcall(require, "mason-nvim-dap.automatic_setup")
            if ok then
              autoconfig(config)
            end
          end,
        },
      })

      local dap_package_map = {
        node2 = "node-debug2-adapter",
        python = "debugpy",
        codelldb = "codelldb",
        netcoredbg = "netcoredbg",
        ["java-debug-adapter"] = "java-debug-adapter",
      }

      local function mason_path(alias)
        local package = dap_package_map[alias] or alias
        local ok, pkg = pcall(mason_registry.get_package, package)
        if not ok or not pkg then
          mason_registry.refresh()
          return nil
        end
        if not pkg:is_installed() then
          return nil
        end
        if type(pkg.get_install_path) ~= "function" then
          return nil
        end
        return pkg:get_install_path()
      end

      local function register_adapters()
        local setups = {
          node2 = function(path)
            dap.adapters.node2 = {
              type = "executable",
              command = "node",
              args = { path .. "/out/src/nodeDebug.js" },
            }
            local languages = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
            local attach = require("dap.utils").pick_process
            for _, language in ipairs(languages) do
              dap.configurations[language] = {
                {
                  type = "node2",
                  request = "launch",
                  name = "Launch file",
                  program = "${file}",
                  cwd = vim.fn.getcwd(),
                  sourceMaps = true,
                  protocol = "inspector",
                  console = "integratedTerminal",
                },
                {
                  type = "node2",
                  request = "attach",
                  name = "Attach to process",
                  processId = attach,
                  cwd = vim.fn.getcwd(),
                },
              }
            end
          end,
          codelldb = function(path)
            local executable = path .. "/extension/adapter/codelldb"
            if vim.fn.has("win32") == 1 then
              executable = executable .. ".exe"
            end
            dap.adapters.codelldb = {
              type = "server",
              port = "${port}",
              executable = {
                command = executable,
                args = { "--port", "${port}" },
              },
            }
            local config = {
              {
                name = "Launch executable",
                type = "codelldb",
                request = "launch",
                program = function()
                  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
              },
            }
            dap.configurations.c = config
            dap.configurations.cpp = config
          end,
          netcoredbg = function(path)
            local executable = path .. "/netcoredbg"
            if vim.fn.has("win32") == 1 then
              executable = executable .. ".exe"
            end
            dap.adapters.netcoredbg = {
              type = "executable",
              command = executable,
              args = { "--interpreter=vscode" },
            }
            dap.configurations.cs = {
              {
                type = "netcoredbg",
                name = "Launch .NET",
                request = "launch",
                program = function()
                  return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
                end,
              },
            }
          end,
          python = function(path)
            local separator = vim.fn.has("win32") == 1 and "\\" or "/"
            local python_bin = separator == "\\" and "\\venv\\Scripts\\python.exe" or "/venv/bin/python"
            local python_path = path .. python_bin
            dap.adapters.python = {
              type = "executable",
              command = python_path,
              args = { "-m", "debugpy.adapter" },
            }
            dap.configurations.python = {
              {
                type = "python",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                pythonPath = function()
                  return vim.fn.exepath("python") or "python"
                end,
              },
            }
          end,
        }

        for alias, setup in pairs(setups) do
          local path = mason_path(alias)
          if path then
            setup(path)
          end
        end
      end

      register_adapters()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { desc = desc })
      end

      map("<F5>", dap.continue, "Debug Continue")
      map("<F10>", dap.step_over, "Debug Step Over")
      map("<F11>", dap.step_into, "Debug Step Into")
      map("<F12>", dap.step_out, "Debug Step Out")
      map("<leader>db", dap.toggle_breakpoint, "Debug Toggle Breakpoint")
      map("<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, "Debug Conditional Breakpoint")
      map("<leader>dr", dap.repl.toggle, "Debug Toggle REPL")
      map("<leader>dl", dap.run_last, "Debug Run Last")
      map("<leader>du", dapui.toggle, "Debug Toggle UI")
    end,
  },
}

