return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = { "lua", "vim", "vimdoc", "query", "javascript", "typescript", "tsx", "html", "css", "json", "python", "rust", "bash", "c", "java" },
    highlight = { enable = true },
    indent = { enable = true },
  },
  config = function(_, opts)
    vim.schedule(function()
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if ok and configs then
        configs.setup(opts)
      else
        vim.notify("nvim-treesitter: run :Lazy install and restart Neovim", vim.log.levels.WARN)
      end
    end)
  end,
}
