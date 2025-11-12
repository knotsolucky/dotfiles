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

      require("nvim-dap-virtual-text").setup({ commented = true })
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸" },
        controls = { enabled = true, element = "repl" },
      })

      require("mason-nvim-dap").setup({
        ensure_installed = { "python", "node2", "codelldb", "netcoredbg", "java-debug-adapter" },
        automatic_installation = true,
        handlers = {
          function(config)
            local ok, autoconfig = pcall(require, "mason-nvim-dap.automatic_setup")
            if ok then autoconfig(config) end
          end,
        },
      })

      local mason_root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
      local function mason_path(pkg)
        local ok, p = pcall(require("mason-registry").get_package, pkg)
        return ok and p:is_installed() and (mason_root .. "/packages/" .. pkg) or nil
      end

      local attach = require("dap.utils").pick_process
      local function setup_node2(path)
        dap.adapters.node2 = { type = "executable", command = "node", args = { path .. "/out/src/nodeDebug.js" } }
        for _, lang in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
          dap.configurations[lang] = {
            { type = "node2", request = "launch", name = "Launch file", program = "${file}", cwd = vim.fn.getcwd(), sourceMaps = true, protocol = "inspector", console = "integratedTerminal" },
            { type = "node2", request = "attach", name = "Attach to process", processId = attach, cwd = vim.fn.getcwd() },
          }
        end
      end

      local function setup_codelldb(path)
        local exe = path .. "/extension/adapter/codelldb" .. (vim.fn.has("win32") == 1 and ".exe" or "")
        dap.adapters.codelldb = { type = "server", port = "${port}", executable = { command = exe, args = { "--port", "${port}" } } }
        local config = { { name = "Launch executable", type = "codelldb", request = "launch", program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end, cwd = "${workspaceFolder}", stopOnEntry = false } }
        dap.configurations.c = config
        dap.configurations.cpp = config
      end

      local function setup_netcoredbg(path)
        local exe = path .. "/netcoredbg" .. (vim.fn.has("win32") == 1 and ".exe" or "")
        dap.adapters.netcoredbg = { type = "executable", command = exe, args = { "--interpreter=vscode" } }
        dap.configurations.cs = { { type = "netcoredbg", name = "Launch .NET", request = "launch", program = function() return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file") end } }
      end

      local function setup_python(path)
        local sep = vim.fn.has("win32") == 1 and "\\" or "/"
        local py = path .. (sep == "\\" and "\\venv\\Scripts\\python.exe" or "/venv/bin/python")
        dap.adapters.python = { type = "executable", command = py, args = { "-m", "debugpy.adapter" } }
        dap.configurations.python = { { type = "python", request = "launch", name = "Launch file", program = "${file}", pythonPath = function() return vim.fn.exepath("python") or "python" end } }
      end

      local setups = {
        ["node-debug2-adapter"] = setup_node2,
        ["codelldb"] = setup_codelldb,
        ["netcoredbg"] = setup_netcoredbg,
        ["debugpy"] = setup_python,
      }

      for pkg, setup in pairs(setups) do
        local path = mason_path(pkg)
        if path then setup(path) end
      end

      dap.listeners.after.event_initialized["dapui"] = dapui.open
      dap.listeners.before.event_terminated["dapui"] = dapui.close
      dap.listeners.before.event_exited["dapui"] = dapui.close

      local map = function(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { desc = desc }) end
      map("<F5>", dap.continue, "Debug Continue")
      map("<F10>", dap.step_over, "Debug Step Over")
      map("<F11>", dap.step_into, "Debug Step Into")
      map("<F12>", dap.step_out, "Debug Step Out")
      map("<leader>db", dap.toggle_breakpoint, "Debug Toggle Breakpoint")
      map("<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, "Debug Conditional Breakpoint")
      map("<leader>dr", dap.repl.toggle, "Debug Toggle REPL")
      map("<leader>dl", dap.run_last, "Debug Run Last")
      map("<leader>du", dapui.toggle, "Debug Toggle UI")
    end,
  },
}
