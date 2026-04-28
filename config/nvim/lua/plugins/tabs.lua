return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        -- Avoid single-letter / icon-only tab hints when fonts omit glyphs; counts still show issues exist
        diagnostics_indicator = function(count)
          if count == 0 then
            return ""
          end
          return string.format(" (%d)", count)
        end,
        separator_style = "thin",
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      local map_opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", vim.tbl_extend("force", map_opts, { desc = "Next buffer tab" }))
      vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", vim.tbl_extend("force", map_opts, { desc = "Prev buffer tab" }))
      vim.keymap.set("n", "]b", "<Cmd>BufferLineCycleNext<CR>", vim.tbl_extend("force", map_opts, { desc = "Next buffer tab (fallback)" }))
      vim.keymap.set("n", "[b", "<Cmd>BufferLineCyclePrev<CR>", vim.tbl_extend("force", map_opts, { desc = "Prev buffer tab (fallback)" }))
    end,
  },
}
