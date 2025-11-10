return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
      },
      window = {
        border = "single",
      },
      layout = {
        spacing = 6,
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register({
        ["<leader>f"] = { name = "Find" },
        ["<leader>d"] = { name = "Debug" },
        ["<leader>c"] = { name = "Code" },
        ["<leader>g"] = { name = "Git" },
        ["<leader>l"] = {
          name = "LSP",
          d = {
            name = "Diagnostics",
            d = "Diagnostics (cursor)",
            D = "Diagnostics list",
            n = "Next diagnostic",
            p = "Previous diagnostic",
          },
          a = {
            name = "Actions",
            a = "Code actions",
            r = "Rename symbol",
            f = "Format buffer",
          },
          g = {
            name = "Navigation",
            d = "Definition",
            D = "Declaration",
            r = "References",
            i = "Implementation",
            t = "Type definition",
            h = "Hover",
            k = "Signature help",
          },
          s = {
            name = "Symbols",
            s = "Document symbols",
            S = "Workspace symbols",
            I = "Incoming calls",
            O = "Outgoing calls",
          },
          w = {
            name = "Workspace",
            l = "List folders",
            a = "Add folder",
            r = "Remove folder",
          },
        },
      })
    end,
  },
}

