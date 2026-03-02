return {
  "akinsho/bufferline.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {
    options = {
      offsets = { { filetype = "nvimtree", text = "File tree", text_align = "center" } },
    },
  },
}
