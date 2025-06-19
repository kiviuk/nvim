-- This is the main module for our plugin.
local M = {}

---
-- Creates a formatted banner from a single line of text. (Internal function)
-- @param line_content (string) The full content of the line to be transformed.
-- @return (string, nil) or (nil, string)
---
local function create_banner_from_text(line_content, opts)
  opts = opts or {} -- Ensure opts is a table to avoid errors

  -- 1. Get Configuration
  local total_width = opts.width or vim.opt.textwidth:get()
  if total_width == 0 then
    total_width = 96
  end

  -- 2. Intelligent Prefix Detection and Text Parsing
  local comment_prefix
  local text = line_content

  if vim.startswith(text, "//") then
    comment_prefix = "//"
    text = text:gsub("^//+", "")
  elseif vim.startswith(text, "#") then
    comment_prefix = "#"
    text = text:gsub("^#+", "")
  else
    local cs = vim.bo.commentstring or "# %s"
    comment_prefix = cs:match("^%s*(.-)%%s") or "#"
  end

  -- 3. Clean and Transform Text
  text = vim.trim(text:gsub("=", ""))
  text = text:upper()

  -- Gracefully handle empty/non-text lines by returning the original line
  if not text or text == "" then
    return line_content
  end

  -- 4. Calculate Padding and Build Banner
  local spaced_text = " " .. text .. " "
  local prefix_len = #comment_prefix + 1
  local min_width = prefix_len + #spaced_text + 2
  if total_width < min_width then
    return nil, "Text is too long for width " .. total_width .. " (needs " .. min_width .. ")."
  end

  local remaining_width = total_width - prefix_len - #spaced_text
  local left_equals_len = math.floor(remaining_width / 2)
  local right_equals_len = remaining_width - left_equals_len
  local left_equals = string.rep("=", left_equals_len)
  local right_equals = string.rep("=", right_equals_len)
  local new_line = comment_prefix .. " " .. left_equals .. spaced_text .. right_equals

  return new_line
end

---
-- Public API: Bannarizes a range of lines.
-- Accepts command options including line range and arguments.
-- @param cmd_opts A table from a command, containing `line1`, `line2`, and `args`.
---
function M.bannarize_range(cmd_opts)
  local banner_opts = {
    -- Parse the width from the command arguments.
    -- tonumber("80") -> 80, tonumber("") -> nil
    width = tonumber(cmd_opts.args),
  }

  local first = cmd_opts.line1
  local last = cmd_opts.line2
  local original_lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
  local lines_to_set = {}

  for _, line in ipairs(original_lines) do
    -- Pass the banner_opts table down to the core function
    local new_line, err = create_banner_from_text(line, banner_opts)
    if err then
      vim.notify("Bannarizer Error: " .. err, vim.log.levels.ERROR)
      return
    end
    table.insert(lines_to_set, new_line)
  end

  vim.api.nvim_buf_set_lines(0, first - 1, last, false, lines_to_set)
end

return M
