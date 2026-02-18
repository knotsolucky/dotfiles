-- Nerd Font (Font Awesome) icons used consistently across the config.
-- Requires a Nerd Font (e.g. JetBrainsMono Nerd Font, Hack Nerd Font) in your terminal and guifont.
local M = {}

-- Font Awesome codepoints (Nerd Font PUA), UTF-8 encoded
M.folder = "\239\129\187"       --  folder (Explorer)
M.search = "\239\128\130"       --  search (Telescope)
M.columns = "\239\131\155"      --  columns (Buffers)
M.code = "\239\132\161"         --  code (Code)
M.github = "\239\132\166"       --  github (Git)
M.save = "\239\131\135"         --  save / file (File)
M.times = "\239\128\141"        --  times (Quit)
M.adjust = "\239\129\130"       --  adjust (Transparency)
M.dashboard = "\239\131\164"    --  tachometer (Dashboard)
M.branch = "\238\130\160"       --  git branch (statusline)

-- Diagnostics (optional, use if you want same icon set)
M.diagnostic_error = "\239\129\151"   --  times_circle
M.diagnostic_warn = "\239\129\177"    --  exclamation_triangle
M.diagnostic_info = "\239\129\154"     --  info_circle
M.diagnostic_hint = "\239\188\171"     --  lightbulb
M.session = "\239\131\134"              --  book (Sessions)
M.theme = "\239\140\140"                --  palette (Theme)

return M
