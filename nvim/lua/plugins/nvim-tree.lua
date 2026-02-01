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
      update_focused_file = { enable = true, update_root = { enable = true } },
      sync_root_with_cwd = true,
      sort = { sorter = "case_sensitive" },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = { hint = "", info = "", warning = "", error = "" },
      },
      trash = { cmd = "trash-put" },
      notify = { threshold = vim.log.levels.WARN },
      view = {
        width = 35,
        relativenumber = true,
        side = "left",
        preserve_window_proportions = true,
        cursorline = true,
      },
      renderer = {
        highlight_git = true,
        group_empty = true,
        indent_markers = { enable = true },
        add_trailing = false,
        highlight_modified = "name",
        icons = {
          show = { file = true, folder = true, folder_arrow = true },
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
      filters = { dotfiles = false, custom = { ".git", "node_modules", ".cache" } },
      actions = {
        open_file = {
          resize_window = true,
          window_picker = { enable = true },
          quit_on_open = false,
        },
        remove_file = { close_window = true },
      },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },
}

