return {
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require "alpha"
      local dashboard = require "alpha.themes.dashboard"
      dashboard.section.header.val = {
        " ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
        " ████╗  ██║██║   ██║██║████╗ ████║",
        " ██╔██╗ ██║██║   ██║██║██╔████╔██║",
        " ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        " ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
        " ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
      }
      dashboard.section.buttons.val = {
        dashboard.button("f", "Find file", ":Telescope find_files<CR>"),
        dashboard.button("g", "Live grep", ":Telescope live_grep<CR>"),
        dashboard.button("n", "New file", ":ene <BAR> startinsert<CR>"),
        dashboard.button("e", "Explorer", ":NvimTreeToggle<CR>"),
        dashboard.button("u", "Update plugins", ":Lazy sync<CR>"),
        dashboard.button("q", "Quit", ":qa<CR>"),
      }
      dashboard.section.footer.val = "NvChad"
      alpha.setup(dashboard.opts)
    end,
  },

  -- Better cmdline, search, notifications
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {},
  },

  -- Better input() / vim.ui.select
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- TODO / FIXME / HACK highlights and search
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPost",
    opts = {},
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require "lint"
      local function js_ts_linter()
        if vim.fn.executable "eslint_d" == 1 then
          return { "eslint_d" }
        end
        if vim.fn.executable "eslint" == 1 then
          return { "eslint" }
        end
        return {}
      end
      lint.linters_by_ft = {
        javascript = js_ts_linter(),
        typescript = js_ts_linter(),
        javascriptreact = js_ts_linter(),
        typescriptreact = js_ts_linter(),
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      }
      local augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = augroup,
        callback = function()
          if vim.g.disable_lsp_lint_formatter then
            return
          end
          lint.try_lint()
        end,
      })
    end,
  },

  -- DAP (debugging)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸" },
        controls = { enabled = true, element = "repl" },
      })

      require("mason-nvim-dap").setup({
        ensure_installed = { "python" },
        automatic_installation = true,
        handlers = {
          function(config)
            require("mason-nvim-dap").default_setup(config)
          end,
        },
      })

      dap.listeners.after.event_initialized["dapui"] = dapui.open
      dap.listeners.before.event_terminated["dapui"] = dapui.close
      dap.listeners.before.event_exited["dapui"] = dapui.close

      -- DAP keymaps
      local map = vim.keymap.set
      map("n", "<F5>", dap.continue, { desc = "DAP Continue" })
      map("n", "<F10>", dap.step_over, { desc = "DAP Step Over" })
      map("n", "<F11>", dap.step_into, { desc = "DAP Step Into" })
      map("n", "<F12>", dap.step_out, { desc = "DAP Step Out" })
      map("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP Toggle Breakpoint" })
      map("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
      end, { desc = "DAP Conditional Breakpoint" })
      map("n", "<leader>dr", dap.repl.toggle, { desc = "DAP Toggle REPL" })
      map("n", "<leader>dl", dap.run_last, { desc = "DAP Run Last" })
      map("n", "<leader>du", dapui.toggle, { desc = "DAP Toggle UI" })
    end,
  },
}
