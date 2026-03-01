local m = vim.keymap.set

m("n", "<leader>e", function() require("nvim-tree.api").tree.toggle() end, { desc = "Toggle file tree" })
