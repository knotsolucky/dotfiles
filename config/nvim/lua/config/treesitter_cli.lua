-- nvim-treesitter calls `tree-sitter build`; CLI must be >= 0.26.1 (see :checkhealth nvim-treesitter).
local MIN = { 0, 26, 1 }

local function version(bin)
  if vim.fn.executable(bin) ~= 1 then
    return nil
  end
  local out = vim.trim(vim.fn.system({ bin, "--version" }))
  if out == "" then
    return nil
  end
  return vim.version.parse(out)
end

local function add_candidate(seen, list, path)
  local norm = vim.fs.normalize(path)
  if seen[norm] then
    return
  end
  seen[norm] = true
  if vim.fn.executable(norm) == 1 then
    list[#list + 1] = norm
  end
end

---@param data string stdpath("data")
local function candidate_bins(data)
  local seen = {}
  local bins = {}
  local home = vim.env.HOME or vim.fn.expand("~")

  for _, p in ipairs({
    "/usr/bin/tree-sitter",
    "/bin/tree-sitter",
    "/usr/local/bin/tree-sitter",
    "/opt/homebrew/bin/tree-sitter",
    home .. "/.cargo/bin/tree-sitter",
    vim.fs.normalize(data .. "/mason/bin/tree-sitter"),
  }) do
    add_candidate(seen, bins, p)
  end

  local hb = vim.env.HOMEBREW_PREFIX
  if hb and hb ~= "" then
    add_candidate(seen, bins, hb .. "/bin/tree-sitter")
  end

  for dir in string.gmatch(vim.env.PATH or "", "([^:]+)") do
    dir = vim.trim(dir)
    if dir ~= "" then
      add_candidate(seen, bins, dir:gsub("/+$", "") .. "/tree-sitter")
    end
  end

  return bins
end

---@param data string
local function best_bin(data)
  local chosen ---@type string?
  local chosen_ver ---@type vim.Version?
  for _, bin in ipairs(candidate_bins(data)) do
    local ver = version(bin)
    if ver and vim.version.ge(ver, MIN) then
      if not chosen_ver or vim.version.lt(chosen_ver, ver) then
        chosen_ver = ver
        chosen = bin
      end
    end
  end
  return chosen
end

local M = {}

---@param data string stdpath("data")
function M.prepend_to_path(data)
  local bin = best_bin(data)
  if bin then
    vim.env.PATH = vim.fn.fnamemodify(bin, ":h") .. ":" .. vim.env.PATH
    return
  end

  if vim.fn.executable("tree-sitter") == 1 then
    local p = vim.fn.exepath("tree-sitter")
    local v = version(p)
    if not v or not vim.version.ge(v, MIN) then
      vim.schedule(function()
        vim.notify(
          "nvim-treesitter needs tree-sitter CLI >= 0.26.1 with `build`. "
            .. "Yours: "
            .. p
            .. ". Install a current CLI (e.g. Arch: pacman -S tree-sitter; cargo: cargo install tree-sitter-cli --locked).",
          vim.log.levels.ERROR
        )
      end)
    end
  end
end

return M
