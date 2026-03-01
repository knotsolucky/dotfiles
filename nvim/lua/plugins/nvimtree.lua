return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    view = { side = "right" },
  },
  config = function(_, opts)
    require("nvim-tree").setup(opts)
  end,
}
