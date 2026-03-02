return {
  {
    "folke/which-key.nvim",
    lazy = false,
    config = function()
      require("which-key").setup({ preset = "helix" })
    end,
  },
}
