return {
  {
    "famiu/feline.nvim",
    event = "VeryLazy",
    dependencies = { "lewis6991/gitsigns.nvim" },
    config = function()
      require("feline").setup()
    end,
  },
}
