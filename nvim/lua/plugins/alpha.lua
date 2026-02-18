return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.buttons.val = {
      dashboard.button("e", " File tree", "<cmd>NvimTreeToggle<cr>"),
      dashboard.button("f", " Find file", "<cmd>Telescope find_files<cr>"),
      dashboard.button("r", " Recent files", "<cmd>Telescope oldfiles<cr>"),
      dashboard.button("g", " Find word", "<cmd>Telescope live_grep<cr>"),
      dashboard.button("n", " New file", "<cmd>enew<cr>"),
      dashboard.button("c", " Config", "<cmd>e " .. vim.fn.stdpath("config") .. "/init.lua<cr>"),
      dashboard.button("q", " Quit", "<cmd>qa<cr>"),
    }

    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"

    require("alpha").setup(dashboard.config)

    -- Show dashboard when starting with no file
    local group = vim.api.nvim_create_augroup("alpha_dashboard", { clear = true })
    vim.api.nvim_create_autocmd("VimEnter", {
      group = group,
      callback = function()
        local should_skip = false
        if vim.fn.argc() > 0 then
          should_skip = true
        else
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_line_count(buf) > 1 then
              should_skip = true
              break
            end
          end
        end
        if not should_skip then
          vim.cmd("Alpha")
        end
      end,
    })
  end,
}
