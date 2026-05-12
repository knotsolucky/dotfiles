return {
  'vyfor/cord.nvim',
  build = './build',
  event = 'VeryLazy',
  ---@type CordConfig
  opts = {
    user_stub = false,
    display = {
      show_time = true,
      show_repository = true,
    },
  },
}
