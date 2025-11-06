return {
  {
    "kepano/flexoki-neovim",
    name = "flexoki",
    lazy = false,    -- load immediately
    priority = 1000, -- load before other plugins (so colorscheme is ready)
    config = function()
      vim.cmd.colorscheme("flexoki-dark") -- or "flexoki-light"
    end,
  },
}

