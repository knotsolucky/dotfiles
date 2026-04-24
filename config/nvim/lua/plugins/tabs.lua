return {
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',     
      'nvim-tree/nvim-web-devicons', 
    },
    init = function() 
      vim.g.barbar_auto_setup = false 
    end,
    opts = {
      -- Add any custom options here
      animation = true,
      icons = {filetype = {enabled = true}},
    },
    config = function(_, opts)
      require('barbar').setup(opts)

      -- Keybindings
      local map = vim.keymap.set
      local map_opts = { noremap = true, silent = true }

      -- Tab to go forward
      map('n', '<Tab>', '<Cmd>BufferNext<CR>', map_opts)

      -- Shift-Tab to go backward
      map('n', '<S-Tab>', '<Cmd>BufferPrevious<CR>', map_opts)
    end,
  },
}
