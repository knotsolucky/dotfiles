return {
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Explorer toggle" },
    },
    opts = {
      hijack_cursor = true,
      update_focused_file = { enable = true },
      view = { width = 34 },
      renderer = { group_empty = true },
    },
  },
}
