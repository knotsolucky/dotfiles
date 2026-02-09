return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = { add = { text = "▎" }, change = { text = "▎" }, delete = { text = "▎" }, topdelete = { text = "▎" }, changedelete = { text = "▎" }, untracked = { text = "▎" } },
      on_attach = function(bufnr)
        local gs, m, o = require("gitsigns"), vim.keymap.set, { buffer = bufnr }
        local e = function(desc) return vim.tbl_extend("force", o, { desc = desc }) end
        m("n", "]c", function()
          if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end
        end, e("Next hunk"))
        m("n", "[c", function()
          if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end
        end, e("Prev hunk"))
        m("n", "<leader>gs", gs.stage_hunk, e("Stage hunk"))
        m("n", "<leader>gr", gs.reset_hunk, e("Reset hunk"))
        m("n", "<leader>gp", gs.preview_hunk, e("Preview hunk"))
        m("n", "<leader>gb", function() gs.blame_line({ full = true }) end, e("Blame line"))
        m("n", "<leader>gd", gs.diffthis, e("Diff this"))
        m("n", "<leader>gD", function() gs.diffthis("~") end, e("Diff this (~)"))
        m("n", "<leader>gS", gs.stage_buffer, e("Stage buffer"))
        m("n", "<leader>gR", gs.reset_buffer, e("Reset buffer"))
        m("n", "<leader>gB", gs.toggle_current_line_blame, e("Toggle blame"))
        m("n", "<leader>gw", gs.toggle_word_diff, e("Word diff"))
        m("n", "<leader>gn", function() gs.nav_hunk("next") end, e("Next hunk"))
        m("n", "<leader>gN", function() gs.nav_hunk("prev") end, e("Prev hunk"))
        m("v", "<leader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, e("Stage hunk"))
        m("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, e("Reset hunk"))
        m({ "o", "x" }, "ih", gs.select_hunk, e("Select hunk"))
      end,
    },
  },
}
