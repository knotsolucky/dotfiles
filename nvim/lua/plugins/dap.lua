return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "REPL" },
      { "<leader>du", function() require("dap").up() end, desc = "Up" },
      { "<leader>dd", function() require("dap").down() end, desc = "Down" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run last" },
    },
    dependencies = {
      "jay-babu/mason-nvim-dap.nvim",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      require("configs.dap")
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    lazy = true,
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = { "codelldb", "python", "javadbg" },
        automatic_installation = true,
        handlers = {},
      })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = "mfussenegger/nvim-dap",
    opts = {},
    config = function(_, opts)
      local dapui = require("dapui")
      dapui.setup(opts)
      local dap = require("dap")
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },
}
