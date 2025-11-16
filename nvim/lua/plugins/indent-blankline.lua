return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local palette = {
        "#f5a97f",
        "#c6a0f6",
        "#8bd5ca",
        "#ed8796",
        "#a6da95",
        "#91d7e3",
      }

      local highlight_groups = {}
      for i, color in ipairs(palette) do
        local name = ("IblIndent%d"):format(i)
        vim.api.nvim_set_hl(0, name, { fg = color, nocombine = true })
        table.insert(highlight_groups, name)
      end

      require("ibl").setup({
        indent = {
          char = "│",
          highlight = highlight_groups,
        },
        scope = { enabled = true, show_start = false, show_end = false },
        whitespace = { remove_blankline_trail = true },
      })
    end,
  },
}

