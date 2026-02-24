local M = {}

local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

-------------------------------------------------------------
-- parse something like name{a,b,c}
-------------------------------------------------------------
local function parse_list_def(str)
  local name, body = str:match("^(%w+)%s*{%s*(.-)%s*}$")
  if not name then return nil end
  local parts = {}
  for item in body:gmatch("([^,]+)") do
    table.insert(parts, trim(item))
  end
  return {type="list", name=name, values=parts}
end

-------------------------------------------------------------
-- parse lines{..3}, lines{2..5}, lines{1..3,4..6}
-------------------------------------------------------------
local function parse_lines_def(str)
  local name, body = str:match("^(lines)%s*{%s*(.-)%s*}$")
  if not name then return nil end

  local ranges = {}

  for segment in body:gmatch("([^,]+)") do
    segment = trim(segment)

    -- ..N = relative count
    local rel = segment:match("^%.%.(%d+)$")
    if rel then
      table.insert(ranges, {type="rel", count=tonumber(rel)})
    else
      -- A..B
      local a,b = segment:match("^(%d+)%s*%.%.%s*(%d+)$")
      if a and b then
        table.insert(ranges, {type="abs", start=tonumber(a), finish=tonumber(b)})
      else
        -- single number
        local n = segment:match("^(%d+)$")
        if n then
          table.insert(ranges, {type="rel", count=tonumber(n)})
        end
      end
    end
  end

  return {type="lines", ranges=ranges}
end

-------------------------------------------------------------
-- parse template: anything that isn't list or lines
-------------------------------------------------------------
local function parse_template(str)
  return {type="template", text=str}
end

-------------------------------------------------------------
-- Parse DSL string into components
-------------------------------------------------------------
local function parse_dsl(input)
  local parts = {}

  for part in input:gmatch("([^,]+)") do
    part = trim(part)

    -- try list
    local list = parse_list_def(part)
    if list then
      table.insert(parts, list)
    else
      -- try lines
      local lines = parse_lines_def(part)
      if lines then
        table.insert(parts, lines)
      else
        -- it's a template
        table.insert(parts, parse_template(part))
      end
    end
  end

  return parts
end

-------------------------------------------------------------
-- Build context: lists, template, ranges
-------------------------------------------------------------
local function build_context(parts)
  local lists = {}
  local template = nil
  local ranges = {}
  for _, p in ipairs(parts) do
    if p.type == "list" then
      lists[p.name] = p.values
    elseif p.type == "lines" then
      vim.list_extend(ranges, p.ranges)
    elseif p.type == "template" then
      template = p.text
    end
  end

  if not template then
    error("No template found in DSL input")
  end
  return {lists = lists, ranges = ranges, template = template}
end

-------------------------------------------------------------
-- Produce zipped rows
-------------------------------------------------------------
local function zip_lists(lists)
  local keys = {}
  for name,_ in pairs(lists) do table.insert(keys,name) end
  table.sort(keys)

  local min_len = math.huge
  for _, k in ipairs(keys) do
    min_len = math.min(min_len, #lists[k])
  end

  local rows = {}
  for i = 1, min_len do
    local row = {}
    for _,k in ipairs(keys) do
      row[k] = lists[k][i]
    end
    table.insert(rows, row)
  end
  return rows
end

-------------------------------------------------------------
-- Convert template text using row variables
-------------------------------------------------------------
local function apply_template(text, row)
  return (text:gsub("%$(%w+)", function(name)
    return row[name] or ("$"..name)
  end))
end

-------------------------------------------------------------
-- Convert line ranges into explicit target buffer lines
-------------------------------------------------------------
local function compute_target_lines(ranges, cursor_row)
  local out = {}
  for _, r in ipairs(ranges) do
    if r.type == "rel" then
      for i=0, r.count-1 do
        table.insert(out, cursor_row + i)
      end
    elseif r.type == "abs" then
      for i=r.start, r.finish do
        table.insert(out, cursor_row + (i - 1))
      end
    end
  end
  return out
end

-------------------------------------------------------------
-- Perform insertion
-------------------------------------------------------------
local function perform_insertion(lines, start_col)
  local buf = 0
  vim.api.nvim_buf_call(buf, function()
    for _, item in ipairs(lines) do
      local row = item.row
      local new = item.text
      vim.cmd("undojoin")
      local old = vim.api.nvim_buf_get_lines(buf, row, row+1, false)[1] or ""
      local prefix = old:sub(1, start_col)
      local suffix = old:sub(start_col+1)
      vim.api.nvim_buf_set_lines(buf, row, row+1, false, { prefix .. new .. suffix })
    end
  end)
end

-------------------------------------------------------------
-- Entry function: reads DSL from user input
-------------------------------------------------------------
function M.run()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local dsl = vim.fn.input("DSL: ")

  local parts = parse_dsl(dsl)
  local ctx = build_context(parts)
  local zipped = zip_lists(ctx.lists)
  local targets = compute_target_lines(ctx.ranges, row - 1)

  if #targets < #zipped then
    print("Warning: Not enough target lines; truncating.")
  end

  local lines_to_insert = {}
  for i=1, math.min(#targets, #zipped) do
    local row_data = zipped[i]
    local text = apply_template(ctx.template, row_data)
    table.insert(lines_to_insert, {row = targets[i], text = text})
  end

  perform_insertion(lines_to_insert, col)
  print("Done.")
end

function M.setup()
  vim.keymap.set("n", "<leader>zd", function()
    M.run()  -- interactive (input prompt)
  end, {desc="Run DSL zipper"})

  -- NEW: command-line DSL execution
  vim.api.nvim_create_user_command("zipdsl", function(opts)
    M.run(opts.args)  -- pass DSL text directly
  end, {
    nargs = 1,           -- require exactly one argument
    complete = "file",   -- or none
    desc = "Run DSL zipper via command line"
  })
end

return M
