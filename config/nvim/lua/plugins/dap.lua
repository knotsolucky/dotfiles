return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "DAP continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "DAP step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "DAP step into" },
      { "<F12>", function() require("dap").step_out() end, desc = "DAP step out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP breakpoint" },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup({
        floating = { border = "rounded" },
      })
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
