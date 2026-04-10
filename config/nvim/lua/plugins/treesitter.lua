return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_ts", { clear = true }),
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })

      local langs = { "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" }
      if vim.fn.executable("tree-sitter") == 1 then
        vim.schedule(function()
          require("nvim-treesitter").install(langs)
        end)
      end
    end,
  },
}
