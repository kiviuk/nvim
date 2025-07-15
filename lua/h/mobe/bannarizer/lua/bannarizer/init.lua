local M = {}

-- Configuration constants
local C = {
  DEFAULT_WIDTH = 96,
}

-- Buffer-local storage for the last used width
local function get_last_width()
  return vim.b.bannarizer_last_width
end

local function set_last_width(width)
  vim.b.bannarizer_last_width = width
end

--- Create a banner line from input text.
--- @param line_content string
--- @param opts table (expects `width`)
--- @return string|nil, string|nil
local function create_banner_from_text(line_content, opts)
  local total_width = opts.width
  local cs = vim.bo.commentstring or "# %s"
  local comment_prefix = cs:match("^%s*(.-)%%s") or "#"
  local comment_pattern = "^" .. vim.pesc(comment_prefix) .. "+%s*"

  local text = line_content:gsub(comment_pattern, "")
  text = vim.trim(text:gsub("=", "")):upper()

  if text == "" then
    return line_content
  end

  local spaced_text = " " .. text .. " "
  local min_width = #comment_prefix + 1 + #spaced_text + 2
  if total_width < min_width then
    return nil, ("Text too long for width %d (needs at least %d)"):format(total_width, min_width)
  end

  local remaining = total_width - #comment_prefix - #spaced_text
  local left = math.floor(remaining / 2)
  local right = remaining - left

  local new_line = ("%s%s%s%s"):format(comment_prefix, string.rep("=", left), spaced_text, string.rep("=", right))

  return new_line
end

--- Bannarize a range of lines.
--- @param cmd_opts table (from user command)
--- @param skip_repeat boolean? If true, disables repeat#set to avoid recursion
function M.bannarize_range(cmd_opts, skip_repeat)
  local width = tonumber(cmd_opts.args)
    or get_last_width()
    or (vim.opt.textwidth:get() > 0 and vim.opt.textwidth:get())
    or C.DEFAULT_WIDTH

  set_last_width(width)

  local first = cmd_opts.line1
  local last = cmd_opts.line2
  local original_lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
  local new_lines = {}

  for _, line in ipairs(original_lines) do
    local new_line, err = create_banner_from_text(line, { width = width })
    if err then
      vim.notify("Bannarizer Error: " .. err, vim.log.levels.ERROR)
      return
    end
    table.insert(new_lines, new_line)
  end

  vim.api.nvim_buf_set_lines(0, first - 1, last, false, new_lines)

  if not skip_repeat then
    vim.fn["repeat#set"](":BannarizerRepeat\n", -1)
  end
end
--  =========================================== WCDN ===========================================
--- Repeat the last bannarize action on the current line
function M.repeat_last()
  local line = vim.fn.line(".")
  M.bannarize_range({ line1 = line, line2 = line }, true)
  vim.fn["repeat#set"](":BannarizerRepeat\n", -1)
end

--- Prompt the user for a new width and bannarize selected or current line
function M.prompt_and_bannarize()
  local default = get_last_width() or (vim.opt.textwidth:get() > 0 and vim.opt.textwidth:get()) or C.DEFAULT_WIDTH

  vim.ui.input({
    prompt = "Enter banner width: ",
    default = tostring(default),
  }, function(input)
    if not input or input == "" then
      return
    end
    local width = tonumber(input)
    if not width or width <= 0 then
      vim.notify("Invalid width: " .. tostring(input), vim.log.levels.ERROR)
      return
    end

    local mode = vim.api.nvim_get_mode().mode
    local line1, line2
    if mode:find("^[vV]") then
      line1 = vim.fn.line("v")
      line2 = vim.fn.line(".")
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
    else
      line1 = vim.fn.line(".")
      line2 = line1
    end

    M.bannarize_range({
      line1 = math.min(line1, line2),
      line2 = math.max(line1, line2),
      args = tostring(width),
    })
  end)
end

return M
