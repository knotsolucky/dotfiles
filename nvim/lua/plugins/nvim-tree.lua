return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
      { "<leader>E", "<cmd>NvimTreeFocus<cr>", desc = "Focus file explorer" },
    },
    opts = {
      hijack_netrw = true,
      view = { width = 35, relativenumber = true },
      renderer = {
        highlight_git = true,
        icons = {
          glyphs = {
            git = {
              unstaged = "",
              staged = "S",
              unmerged = "",
              renamed = "➜",
              untracked = "U",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
      filters = { dotfiles = false },
      actions = { open_file = { resize_window = true } },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },
}

