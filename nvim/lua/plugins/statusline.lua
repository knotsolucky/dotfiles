local icons = require("icons")

local function gitsigns_branch()
  local head = vim.b.gitsigns_head
  if head and head ~= "" then
    return icons.branch .. " " .. head
  end
  return ""
end

local function gitsigns_diff()
  local dict = vim.b.gitsigns_status_dict
  if not dict then return "" end
  local added = dict.added or 0
  local removed = dict.removed or 0
  local changed = dict.changed or 0
  if added == 0 and removed == 0 and changed == 0 then return "" end
  local parts = {}
  if added > 0 then table.insert(parts, "+" .. added) end
  if removed > 0 then table.insert(parts, "-" .. removed) end
  if changed > 0 then table.insert(parts, "~" .. changed) end
  return table.concat(parts, " ")
end

return {
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "EdenEast/nightfox.nvim",
      "lewis6991/gitsigns.nvim",
    },
    opts = {
      options = {
        theme = "auto",
        section_separators = { left = "█", right = "█" },
        component_separators = { left = "│", right = "│" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          { gitsigns_branch, icon = { align = "right" } },
          { gitsigns_diff, color = { fg = "#81a1c1" } },
          "diagnostics",
        },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "nvim-tree" },
    },
  },
}
