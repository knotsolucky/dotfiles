return {
  "xiyaowong/nvim-transparent",
  config = function()
    require("transparent").setup({
      extra_groups = { -- additional groups to clear (optional)
        "NvimTreeNormal",
        "BufferLineTabClose",
      },
      exclude = {}, -- groups to *not* make transparent
    })
  end
}
