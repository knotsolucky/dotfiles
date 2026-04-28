return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
      views = {
        popupmenu = { border = { style = "rounded", padding = { 0, 1 } } },
        hover = { border = { style = "rounded", padding = { 0, 2 } } },
        confirm = { border = { style = "rounded", padding = { 0, 1 } } },
      },
    },
  },
}
