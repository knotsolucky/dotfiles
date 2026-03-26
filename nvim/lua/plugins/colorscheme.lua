return {
  "anAcc22/sakura.nvim",
  lazy = false,
  priority = 1000,
  dependencies = { "rktjmp/lush.nvim" },
  config = function()
    vim.opt.background = "dark"
    vim.cmd("colorscheme sakura")
  end,
}
