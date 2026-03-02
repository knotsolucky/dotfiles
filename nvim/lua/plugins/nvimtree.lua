return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>e", function() require("nvim-tree.api").tree.toggle() end, desc = "File tree" },
  },
  opts = {
    view = { side = "right" },
  },
  config = function(_, opts)
    require("nvim-tree").setup(opts)
  end,
}
