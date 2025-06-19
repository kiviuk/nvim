local M = {}

-- Store last used width for repeat
local last_opts = {}

local function create_banner_from_text(line_content, opts)
  opts = opts or {}

  local total_width = opts.width or vim.opt.textwidth:get()
  if total_width == 0 then
    total_width = 96
  end

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

  text = vim.trim(text:gsub("=", ""))
  text = text:upper()

  if text == "" then
    return line_content
  end

  local spaced_text = " " .. text .. " "
  local prefix_len = #comment_prefix + 1
  local min_width = prefix_len + #spaced_text + 2
  if total_width < min_width then
    return nil, "Text too long for width " .. total_width .. " (needs " .. min_width .. ")"
  end

  local remaining = total_width - prefix_len - #spaced_text
  local left = string.rep("=", math.floor(remaining / 2))
  local right = string.rep("=", remaining - #left)
  local new_line = comment_prefix .. " " .. left .. spaced_text .. right

  return new_line
end

function M.bannarize_range(cmd_opts, skip_repeat)
  local width = tonumber(cmd_opts.args)

  if not width and last_opts.width then
    width = last_opts.width
  end
  if not width or width == 0 then
    width = vim.opt.textwidth:get()
    if width == 0 then
      width = 96
    end
  end

  last_opts.width = width
  local banner_opts = { width = width }

  local first = cmd_opts.line1
  local last = cmd_opts.line2
  local original_lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
  local lines_to_set = {}

  for _, line in ipairs(original_lines) do
    local new_line, err = create_banner_from_text(line, banner_opts)
    if err then
      vim.notify("Bannarizer Error: " .. err, vim.log.levels.ERROR)
      return
    end
    table.insert(lines_to_set, new_line)
  end

  vim.api.nvim_buf_set_lines(0, first - 1, last, false, lines_to_set)

  if not skip_repeat then
    vim.fn["repeat#set"](":BannarizerRepeat\n", -1)
  end
end

function M.repeat_last()
  local line = vim.fn.line(".")
  M.bannarize_range({
    line1 = line,
    line2 = line,
    args = tostring(last_opts.width),
  }, true)
  vim.fn["repeat#set"](":BannarizerRepeat\n", -1)
end
--
-- Setter for last width (used by prompt)
function M.set_last_width(width)
  last_opts.width = width
end

-- Expose function to prompt user for width and bannarize selection or line
function M.prompt_and_bannarize()
  vim.ui.input({
    prompt = "Enter banner width: ",
    default = tostring(last_opts.width or (vim.opt.textwidth:get() ~= 0 and vim.opt.textwidth:get() or 96)),
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
    if mode == "v" or mode == "V" then
      line1 = vim.fn.line("v")
      line2 = vim.fn.line(".")
      if line1 > line2 then
        line1, line2 = line2, line1
      end
      -- Exit visual mode
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
    else
      line1 = vim.fn.line(".")
      line2 = line1
    end

    M.bannarize_range({
      line1 = line1,
      line2 = line2,
      args = tostring(width),
    })

    -- Update remembered width for future repeats
    M.set_last_width(width)
  end)
end
return M
