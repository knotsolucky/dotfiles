local dir = vim.fn.stdpath("config") .. "/lua/plugins"
local imports = {}

for name, ty in vim.fs.dir(dir) do
  if ty == "file" and name:sub(-4) == ".lua" and name ~= "init.lua" then
    local stem = name:sub(1, -5)
    -- Rename to `_foo.lua` to keep file but skip loading
    if stem:sub(1, 1) ~= "_" then
      imports[#imports + 1] = { import = "plugins." .. stem }
    end
  end
end

table.sort(imports, function(a, b)
  return a.import < b.import
end)

return imports
