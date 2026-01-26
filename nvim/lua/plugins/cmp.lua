return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Color preview function for Tailwind and other color values
      local function is_color_value(label)
        if not label or label == "" then
          return false
        end
        
        -- Check for Tailwind color classes (e.g., bg-blue-500, text-red-600, border-gray-200)
        -- Pattern: prefix-color-shade (e.g., bg-blue-500, text-red-600)
        local tailwind_prefixes = {
          "bg", "text", "border", "ring", "outline", "divide", "ring-offset",
          "placeholder", "caret", "accent", "indicator", "decoration",
          "underline", "overline", "line-through", "shadow", "outline",
          "from", "via", "to", "fill", "stroke"
        }
        
        for _, prefix in ipairs(tailwind_prefixes) do
          -- Match pattern like bg-blue-500 or text-red-600
          if label:match("^" .. prefix .. "-[%w-]+%-%d+$") or label:match("^" .. prefix .. "-[%w-]+%-%d+%-") then
            return true
          end
        end
        
        -- Check for hex colors (#rrggbb, #rgb)
        if label:match("^#[0-9a-fA-F]{3,6}$") then
          return true
        end
        
        -- Check for rgb/rgba/hsl/hsla colors
        if label:match("rgba?%(") or label:match("hsla?%(") then
          return true
        end
        
        -- Check for named colors (red, blue, etc.) in common CSS contexts
        if label:match("^color%-") or label:match("^background%-color%-") then
          return true
        end
        
        return false
      end

      -- Enhanced formatting function
      local function format(entry, vim_item)
        -- Get the label for color detection
        local label = vim_item.abbr or entry.completion_item.label or ""
        
        -- Check if this is a color value (Tailwind or CSS colors)
        if is_color_value(label) then
          -- Use Color kind for color values with icon
          vim_item.kind = lspkind.symbolic("Color", { mode = "symbol_text" })
        else
          -- Add icons using lspkind for other items
          vim_item.kind = lspkind.symbolic(vim_item.kind, { mode = "symbol_text" })
        end
        
        -- Add source name with better formatting
        local source_names = {
          nvim_lsp = "LSP",
          luasnip = "Snip",
          buffer = "Buf",
          path = "Path",
        }
        vim_item.menu = source_names[entry.source.name] or ""
        
        -- Truncate long items but preserve important info
        if label and #label > 50 then
          vim_item.abbr = string.sub(label, 1, 47) .. "..."
        end
        
        return vim_item
      end

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,noselect",
          keyword_length = 1,
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:CmpDoc",
          }),
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = format,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
        }, {
          { name = "buffer", priority = 500, keyword_length = 3 },
          { name = "path", priority = 250 },
        }),
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
      })

      -- Setup lspkind
      lspkind.init({
        mode = "symbol_text",
        preset = "default",
        symbol_map = {
          Text = "󰉿",
          Method = "󰆧",
          Function = "󰊕",
          Constructor = "󰆧",
          Field = "󰜢",
          Variable = "󰀫",
          Class = "󰠱",
          Interface = "󰠱",
          Module = "󰏓",
          Property = "󰜢",
          Unit = "󰑭",
          Value = "󰎠",
          Enum = "󰒻",
          Keyword = "󰌋",
          Snippet = "󰆐",
          Color = "󰏘",
          File = "󰈙",
          Reference = "󰈇",
          Folder = "󰉋",
          EnumMember = "󰒻",
          Constant = "󰏿",
          Struct = "󰙅",
          Event = "󰆍",
          Operator = "󰆕",
          TypeParameter = "󰊄",
        },
      })

      local ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
      if ok then
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end

      -- Setup custom highlight groups for better visual appearance
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          -- Completion menu highlights
          vim.api.nvim_set_hl(0, "CmpPmenu", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "CmpPmenuBorder", { fg = "#6c7086" })
          vim.api.nvim_set_hl(0, "CmpSel", { bg = "#45475a", bold = true })
          vim.api.nvim_set_hl(0, "CmpDoc", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "CmpDocBorder", { fg = "#6c7086" })
          vim.api.nvim_set_hl(0, "CmpGhostText", { fg = "#6c7086", italic = true })
          -- Color-specific highlights
          vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = "#f38ba8", bold = true })
        end,
      })
      -- Trigger the autocmd to set initial highlights
      vim.cmd("doautocmd ColorScheme")
    end,
  },
}
