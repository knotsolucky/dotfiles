local highlights = {
  RainbowDelimiterRed = { fg = "#ff6b6b", bg = "#3d2020", bold = true },
  RainbowDelimiterYellow = { fg = "#ffd93d", bg = "#3d3520", bold = true },
  RainbowDelimiterBlue = { fg = "#6bcbff", bg = "#202d3d", bold = true },
  RainbowDelimiterOrange = { fg = "#ff9f43", bg = "#3d2a20", bold = true },
  RainbowDelimiterGreen = { fg = "#6bcf7f", bg = "#203d28", bold = true },
  RainbowDelimiterViolet = { fg = "#c678ff", bg = "#2a203d", bold = true },
  RainbowDelimiterCyan = { fg = "#56d4dd", bg = "#203d3d", bold = true },
}

return {
  "HiPhish/rainbow-delimiters.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    for name, attrs in pairs(highlights) do
      vim.api.nvim_set_hl(0, name, {
        fg = attrs.fg,
        bg = attrs.bg,
        bold = attrs.bold,
      })
    end
    require("rainbow-delimiters.setup").setup({
      highlight = vim.tbl_keys(highlights),
    })
  end,
}
