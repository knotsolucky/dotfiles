local telescope = require("telescope")
telescope.setup({
  defaults = {
    border = true,
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    layout_config = { prompt_position = "top" },
    sorting_strategy = "ascending",
  },
  pickers = {
    find_files = { theme = "dropdown" },
    live_grep = { theme = "dropdown" },
    buffers = { theme = "dropdown" },
    oldfiles = { theme = "dropdown" },
  },
})

-- Commands
vim.api.nvim_create_user_command("TelescopeFindFiles", function()
  require("telescope.builtin").find_files()
end, { desc = "Telescope: find files" })

vim.api.nvim_create_user_command("TelescopeLiveGrep", function()
  require("telescope.builtin").live_grep()
end, { desc = "Telescope: live grep" })

vim.api.nvim_create_user_command("TelescopeBuffers", function()
  require("telescope.builtin").buffers()
end, { desc = "Telescope: open buffers" })

vim.api.nvim_create_user_command("TelescopeOldfiles", function()
  require("telescope.builtin").oldfiles()
end, { desc = "Telescope: recent files" })

vim.api.nvim_create_user_command("TelescopeHelpTags", function()
  require("telescope.builtin").help_tags()
end, { desc = "Telescope: help tags" })

vim.api.nvim_create_user_command("TelescopeKeymaps", function()
  require("telescope.builtin").keymaps()
end, { desc = "Telescope: keymaps" })

vim.api.nvim_create_user_command("TelescopeGitFiles", function()
  require("telescope.builtin").git_files()
end, { desc = "Telescope: git files" })
