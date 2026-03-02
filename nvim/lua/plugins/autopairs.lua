return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = { "hrsh7th/nvim-cmp" },
  opts = {},
  config = function(_, opts)
    require("nvim-autopairs").setup(opts)
    local cmp = require("cmp")
    cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
  end,
}
