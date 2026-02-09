return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "jay-babu/mason-nvim-dap.nvim",
      "rcarriga/nvim-dap-ui",
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Continue" },
      { "<F9>", function() require("dap").step_over() end, desc = "Step over" },
      { "<F10>", function() require("dap").step_into() end, desc = "Step into" },
      { "<F11>", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Breakpoint" },
      { "<leader>dB", function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, desc = "Conditional breakpoint" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "REPL" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle UI" },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "codelldb", "node", "cppdbg", "debugpy", "java" },
      automatic_setup = true,
    },
    config = function(_, opts)
      require("mason-nvim-dap").setup(opts)
    end,
  },
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }, opts = {} },
}
