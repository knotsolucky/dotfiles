return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    lazy = false, -- load immediately
    config = function()
      require("nvim-treesitter.configs").setup({
        -- Languages you want to ensure are installed
        ensure_installed = {
          "c",
          "cpp",
          "c_sharp",
          "javascript",
          "typescript",
          "lua", -- include Lua for your Neovim config
        },

        sync_install = false,
        auto_install = true,

        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },

        indent = { enable = true },
      })
    end,
  },
}

