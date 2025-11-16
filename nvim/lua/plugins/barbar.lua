return {
  {
    "romgrk/barbar.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "lewis6991/gitsigns.nvim",
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      animation = true,
      insert_at_end = true,
      maximum_padding = 1,
      sidebar_filetypes = {
        NvimTree = true,
        alpha = true,
      },
    },
    config = function(_, opts)
      require("barbar").setup(opts)

      local map = vim.keymap.set
      map("n", "<Tab>", "<Cmd>BufferNext<CR>", { desc = "Next buffer" })
      map("n", "<S-Tab>", "<Cmd>BufferPrevious<CR>", { desc = "Previous buffer" })
      map("n", "<leader>bc", "<Cmd>BufferClose<CR>", { desc = "Close buffer" })
      map("n", "<leader>bb", "<Cmd>BufferPick<CR>", { desc = "Pick buffer" })
    end,
  },
}

