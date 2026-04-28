vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search" })

vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

vim.keymap.set("n", "<leader>e", "<cmd>Ex<CR>", { desc = "NetRW" })

vim.keymap.set("n", "<leader>sd", function()
  vim.diagnostic.open_float({ scope = "line", border = "rounded" })
end, { desc = "Diagnostic full message (float)" })
