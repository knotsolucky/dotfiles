return {
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "EdenEast/nightfox.nvim",
    },
    opts = {
      options = {
        theme = "auto",
        section_separators = { left = "█", right = "█" },
        component_separators = { left = "│", right = "│" },
      },
    },
  },
}
