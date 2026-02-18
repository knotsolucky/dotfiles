return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▎" },
        topdelete = { text = "▎" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local m = vim.keymap.set
        local o = { buffer = bufnr }

        -- Hunks
        m("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, vim.tbl_extend("force", o, { desc = "Next hunk" }))
        m("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, vim.tbl_extend("force", o, { desc = "Previous hunk" }))

        -- Git (leader-g) — which-key group "Git"
        m("n", "<leader>gs", gs.stage_hunk, vim.tbl_extend("force", o, { desc = "Stage hunk" }))
        m("n", "<leader>gr", gs.reset_hunk, vim.tbl_extend("force", o, { desc = "Reset hunk" }))
        m("n", "<leader>gp", gs.preview_hunk, vim.tbl_extend("force", o, { desc = "Preview hunk" }))
        m("n", "<leader>gb", function()
          gs.blame_line({ full = true })
        end, vim.tbl_extend("force", o, { desc = "Blame line" }))
        m("n", "<leader>gd", gs.diffthis, vim.tbl_extend("force", o, { desc = "Diff this" }))
        m("n", "<leader>gD", function()
          gs.diffthis("~")
        end, vim.tbl_extend("force", o, { desc = "Diff this (~)" }))
        m("n", "<leader>gS", gs.stage_buffer, vim.tbl_extend("force", o, { desc = "Stage buffer" }))
        m("n", "<leader>gR", gs.reset_buffer, vim.tbl_extend("force", o, { desc = "Reset buffer" }))
        m("n", "<leader>gB", gs.toggle_current_line_blame, vim.tbl_extend("force", o, { desc = "Toggle line blame" }))
        m("n", "<leader>gw", gs.toggle_word_diff, vim.tbl_extend("force", o, { desc = "Toggle word diff" }))
        m("n", "<leader>gn", function()
          gs.nav_hunk("next")
        end, vim.tbl_extend("force", o, { desc = "Next hunk" }))
        m("n", "<leader>gN", function()
          gs.nav_hunk("prev")
        end, vim.tbl_extend("force", o, { desc = "Previous hunk" }))

        -- Visual
        m("v", "<leader>gs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, vim.tbl_extend("force", o, { desc = "Stage hunk" }))
        m("v", "<leader>gr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, vim.tbl_extend("force", o, { desc = "Reset hunk" }))

        -- Text object
        m({ "o", "x" }, "ih", gs.select_hunk, vim.tbl_extend("force", o, { desc = "Select hunk" }))
      end,
    },
  },
}
