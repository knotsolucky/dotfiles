local m = vim.keymap.set

m("n", ";", ":")
m("i", "jk", "<Esc>")
m("n", "<leader>w", "<cmd>w<cr>")
m("n", "<leader>q", "<cmd>q<cr>")
m("n", "<leader>e", "<cmd>NvimTreeToggle<cr>")
m("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
m("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
m("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
m("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
m("n", "<leader>fr", "<cmd>Telescope resume<cr>")
