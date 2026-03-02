local m = vim.keymap.set

-- Create leader keymaps immediately so they exist (which-key will find them)
m("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Telescope: Find files" })
m("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, { desc = "Telescope: Live grep" })
m("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "Telescope: Buffers" })
m("n", "<leader>fo", function() require("telescope.builtin").oldfiles() end, { desc = "Telescope: Recent files" })
m("n", "<leader>fd", function() require("telescope.builtin").diagnostics() end, { desc = "Telescope: Diagnostics" })
m("n", "<leader>l", function() require("telescope.builtin").diagnostics() end, { desc = "Show all linter messages" })
-- Tabs
m("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "Tabs: New tab" })
m("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Tabs: Close tab" })
m("n", "<leader>tj", "<cmd>tabnext<cr>", { desc = "Tabs: Next tab" })
m("n", "<leader>tk", "<cmd>tabprev<cr>", { desc = "Tabs: Previous tab" })
m("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Tabs: Close other tabs" })

vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostic (linter/LSP)" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
