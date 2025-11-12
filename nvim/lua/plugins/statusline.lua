return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "linrongbin16/lsp-progress.nvim",
      { "stevearc/dressing.nvim", opts = {} },
    },
    config = function()
      require("lsp-progress").setup()
      require("lualine").setup({
        options = {
          theme = "auto",
          section_separators = "",
          component_separators = "",
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = {
            { "diagnostics" },
            {
              function()
                local ok, progress = pcall(require, "lsp-progress")
                return ok and progress.progress() or ""
              end,
              separator = "",
              padding = { left = 1, right = 0 },
            },
          },
          lualine_x = {
            { "filetype", icon_only = true, colored = true },
            "encoding",
            "fileformat",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        extensions = { "quickfix", "nvim-tree", "toggleterm", "trouble" },
      })
    end,
  },
}
