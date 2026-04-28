return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope", "MasonSearch" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
      { "<leader>ms", "<cmd>MasonSearch<CR>", desc = "Mason search/install" },
    },
    config = function()
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local telescope = require("telescope")

      -- Do not map <CR> → select_tab globally: it breaks non-file pickers (e.g. MasonSearch
      -- table entries get opened as paths). Use <C-t> in pickers for tab drop (Telescope default).
      telescope.setup({
        defaults = {
          border = true,
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        },
      })

      vim.api.nvim_create_user_command("MasonSearch", function()
        local ok, registry = pcall(require, "mason-registry")
        if not ok then
          vim.notify("mason-registry not available", vim.log.levels.ERROR)
          return
        end

        if registry.refresh then
          pcall(registry.refresh)
        end

        local names = registry.get_all_package_names()
        table.sort(names)

        local function entry_name(entry)
          if not entry or type(entry) ~= "table" then
            return nil
          end
          -- telescope table finder uses .value (not [1]); missing .value caused no MasonInstall
          -- and the default action treated display text as a path → buffer "Python", etc.
          return entry.value or entry[1]
        end

        pickers.new({}, {
          prompt_title = "Mason packages",
          finder = finders.new_table({
            results = names,
            entry_maker = function(line)
              return { value = line, display = line, ordinal = line }
            end,
          }),
          sorter = conf.generic_sorter({}),
          attach_mappings = function(prompt_bufnr, map)
            local function install()
              local name = entry_name(action_state.get_selected_entry())
              actions.close(prompt_bufnr)
              if name and name ~= "" then
                vim.cmd({ cmd = "MasonInstall", args = { name } })
              end
            end
            actions.select_default:replace(install)
            actions.select_tab:replace(install)
            map("i", "<CR>", install)
            map("n", "<CR>", install)
            return true
          end,
        }):find()
      end, { desc = "Search Mason packages and install" })
    end,
  },
}
