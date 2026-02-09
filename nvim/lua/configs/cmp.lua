require("cmp_nvim_lsp").setup()

local cmp = require "cmp"
local luasnip = require "luasnip"

require("tailwindcss-colorizer-cmp").setup({ color_square_width = 2 })

local lspkind = require("lspkind")
cmp.setup({
  completion = { completeopt = "menu,menuone,noselect", keyword_length = 1 },
  formatting = {
    format = function(entry, vim_item)
      vim_item = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
      return require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
    end,
  },
  window = {
    completion = cmp.config.window.bordered({ border = "rounded" }),
    documentation = cmp.config.window.bordered({ border = "rounded" }),
  },
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fallback() end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then luasnip.jump(-1)
      else fallback() end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources(
    { { name = "nvim_lsp" }, { name = "luasnip" }, { name = "buffer" }, { name = "path" } }
  ),
})
