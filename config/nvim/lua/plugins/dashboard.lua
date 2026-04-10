return {
  {
    "goolord/alpha-nvim",
    lazy = false,
    priority = 900,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("alpha").setup(require("alpha.themes.dashboard").config)
    end,
  },
}
