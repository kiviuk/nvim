-- This is the main module for our plugin.
local M = {}

---
-- Creates a formatted banner from a single line of text. (Internal function)
-- @param line_content (string) The full content of the line to be transformed.
-- @return (string, nil) or (nil, string)
---
local function create_banner_from_text(line_content)
  -- 1. Get Configuration
  local total_width = vim.opt.textwidth:get()
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

  if not text or text == "" then
    return line_content -- Gracefully return original line
  end

  -- 4. Calculate Padding and Build Banner
  local spaced_text = " " .. text .. " "
  local prefix_len = #comment_prefix + 1
  local min_width = prefix_len + #spaced_text + 2
  if total_width < min_width then
    return nil, "Text is too long for current width (" .. total_width .. ")."
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
-- Bannarizes a range of lines. This is the main public function of our module.
-- @param opts A table from a command, containing `line1` and `line2`.
---
function M.bannarize_range(opts)
  local first = opts.line1
  local last = opts.line2
  local original_lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
  local lines_to_set = {}

  for _, line in ipairs(original_lines) do
    local new_line, err = create_banner_from_text(line)
    if err then
      vim.notify("Bannarizer Error: " .. err, vim.log.levels.ERROR)
      return
    end
    table.insert(lines_to_set, new_line)
  end

  vim.api.nvim_buf_set_lines(0, first - 1, last, false, lines_to_set)
end

return M
