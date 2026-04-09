local specs = {}
local dir = vim.fn.stdpath("config") .. "/lua/plugins"
for _, path in ipairs(vim.split(vim.fn.globpath(dir, "*.lua"), "\n")) do
  local name = vim.fn.fnamemodify(path, ":t:r")
  if name ~= "init" then
    local ok, mod = pcall(require, "plugins." .. name)
    if ok and mod then
      for _, spec in ipairs(mod) do
        specs[#specs + 1] = spec
      end
    end
  end
end
return specs
