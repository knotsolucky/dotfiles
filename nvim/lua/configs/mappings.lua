local wk = require("which-key")

-- v3 spec: use wk.add() with { lhs, rhs?, desc, group, ... }; prefix = "<leader>"
wk.add({
  -- Telescope (leader-f)
  { "f", group = "Telescope" },
  { "ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
  { "fg", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
  { "fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
  { "fo", function() require("telescope.builtin").oldfiles() end, desc = "Recent files" },
  { "fh", function() require("telescope.builtin").help_tags() end, desc = "Help tags" },
  { "fk", function() require("telescope.builtin").keymaps() end, desc = "Keymaps" },
  { "fz", function() require("telescope.builtin").git_files() end, desc = "Git files" },
  -- File tree
  { "e", function() require("nvim-tree.api").tree.toggle() end, desc = "File tree" },
  -- Which-key
  { "?", function() require("which-key").show() end, desc = "Show keymaps" },
}, { prefix = "<leader>", mode = "n" })
