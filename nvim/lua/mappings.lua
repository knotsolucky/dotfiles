local m = vim.keymap.set

-- Show which-key popup manually (Space then ?)
m("n", "<leader>?", function() require("which-key").show() end, { desc = "Which-key: show" })

m("n", "<leader>e", function() require("nvim-tree.api").tree.toggle() end, { desc = "Toggle file tree" })

-- Telescope (call builtin so it works even before commands are registered)
m("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Find files" })
m("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, { desc = "Live grep" })
m("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "Buffers" })
m("n", "<leader>fo", function() require("telescope.builtin").oldfiles() end, { desc = "Recent files" })
m("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { desc = "Help tags" })
m("n", "<leader>fk", function() require("telescope.builtin").keymaps() end, { desc = "Keymaps" })
m("n", "<leader>fz", function() require("telescope.builtin").git_files() end, { desc = "Git files" })
