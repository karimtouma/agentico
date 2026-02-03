--- table-transform.lua — Transform Pandoc tables to tabularray environments
--- Filter order: 7 (runs after callout-transform.lua)
---
--- Emits tabularray longtblr/tblr environments with:
---   - Auto-width distribution for wide tables (X columns)
---   - Zebra striping via tabularray row coloring
---   - Booktabs rules
---   - <br> conversion to \\ for multi-line cells
---   - Font scaling based on column count (3 themes)

-- ============================================================================
-- Configuration
-- ============================================================================
local NARROW_THRESHOLD = 4   -- columns <= 4 use pa-narrow theme
local WIDE_THRESHOLD   = 7   -- columns <= 7 use pa-wide; > 7 use pa-verywide

-- ============================================================================
-- Helper: Convert Pandoc Inlines to LaTeX string
-- ============================================================================
local function inlines_to_latex(inlines)
  if not inlines or #inlines == 0 then return "" end
  local doc = pandoc.Pandoc({pandoc.Plain(inlines)})
  local result = pandoc.write(doc, "latex")
  return (result:gsub("\n$", ""))
end

-- ============================================================================
-- Helper: Process <br> tags in inlines → tabularray line breaks
-- ============================================================================
local function process_br(inlines)
  local result = pandoc.List()
  for _, inline in ipairs(inlines) do
    if inline.t == "RawInline" and inline.format == "html" then
      local text = inline.text:lower()
      if text:match("<br%s*/?>") then
        result:insert(pandoc.RawInline("latex", "\\\\"))
      else
        result:insert(inline)
      end
    else
      result:insert(inline)
    end
  end
  return result
end

-- ============================================================================
-- Helper: Convert cell content (list of Blocks) to LaTeX string
-- ============================================================================
local function cell_to_latex(blocks)
  if not blocks or #blocks == 0 then return "" end
  local parts = {}
  for _, block in ipairs(blocks) do
    if block.t == "Para" or block.t == "Plain" then
      local processed = process_br(block.content)
      table.insert(parts, inlines_to_latex(processed))
    else
      local doc = pandoc.Pandoc({block})
      local text = pandoc.write(doc, "latex"):gsub("\n$", "")
      table.insert(parts, text)
    end
  end
  return table.concat(parts, " ")
end

-- ============================================================================
-- Helper: Estimate content width of a cell in characters
-- ============================================================================
local function estimate_width(blocks)
  if not blocks or #blocks == 0 then return 0 end
  local max_w = 0
  for _, block in ipairs(blocks) do
    if block.t == "Para" or block.t == "Plain" then
      local text = pandoc.utils.stringify(block)
      max_w = math.max(max_w, #text)
    end
  end
  return max_w
end

-- ============================================================================
-- Helper: Alignment character for tabularray
-- ============================================================================
local function align_char(align)
  if align == "AlignRight" then return "r"
  elseif align == "AlignCenter" then return "c"
  else return "l"
  end
end

-- ============================================================================
-- Helper: Count body rows
-- ============================================================================
local function count_rows(tbl)
  local n = 0
  for _, body in ipairs(tbl.bodies) do
    n = n + #body.body
  end
  return n
end

-- ============================================================================
-- Helper: Escape & in cell text (tabularray uses & as column separator)
-- Cell content from pandoc.write already escapes LaTeX specials,
-- but we need to be careful not to double-escape.
-- ============================================================================

-- ============================================================================
-- Main Table transformation
-- ============================================================================
function Table(tbl)
  local ncols = #tbl.colspecs
  local nrows = count_rows(tbl)
  local has_head = tbl.head and #tbl.head.rows > 0

  -- Select theme by column count (font scaling)
  -- Always use X columns for text wrapping — prevents overflow
  local theme
  if ncols <= NARROW_THRESHOLD then
    theme = "pa-narrow"
  elseif ncols <= WIDE_THRESHOLD then
    theme = "pa-wide"
  else
    theme = "pa-verywide"
  end
  local use_x = true  -- always use X columns for auto-width

  -- Build column specification
  local colspec_parts = {}
  for _, spec in ipairs(tbl.colspecs) do
    local a = align_char(spec[1])
    if use_x then
      colspec_parts[#colspec_parts + 1] = "X[1," .. a .. "]"
    else
      colspec_parts[#colspec_parts + 1] = a
    end
  end
  local colspec = table.concat(colspec_parts, " ")

  -- Always use longtblr (supports theme as outer key + page breaks)
  local env = "longtblr"

  -- Build outer options (theme)
  local outer_str = "theme=" .. theme

  -- Build inner options (colspec, width, row, hline, rowsep)
  local inner = {}
  inner[#inner + 1] = "colspec={" .. colspec .. "}"
  if use_x then
    inner[#inner + 1] = "width=\\textwidth"
  end
  inner[#inner + 1] = "row{even}={bg=pa-tablealt}"
  if has_head then
    inner[#inner + 1] = "row{1}={bg=pa-tablehead,font=\\bfseries}"
    inner[#inner + 1] = "hline{1,Z}={0.10em}"
    inner[#inner + 1] = "hline{2}={0.04em}"
  else
    inner[#inner + 1] = "hline{1,Z}={0.10em}"
  end
  inner[#inner + 1] = "rowsep=2pt"

  local inner_str = table.concat(inner, ",\n  ")

  -- Build rows
  local rows = {}

  -- Header rows
  if has_head then
    for _, row in ipairs(tbl.head.rows) do
      local cells = {}
      for _, cell in ipairs(row.cells) do
        cells[#cells + 1] = cell_to_latex(cell.contents)
      end
      rows[#rows + 1] = table.concat(cells, " & ") .. " \\\\"
    end
  end

  -- Body rows
  for _, body in ipairs(tbl.bodies) do
    for _, row in ipairs(body.body) do
      local cells = {}
      for _, cell in ipairs(row.cells) do
        cells[#cells + 1] = cell_to_latex(cell.contents)
      end
      rows[#rows + 1] = table.concat(cells, " & ") .. " \\\\"
    end
  end

  local body_str = table.concat(rows, "\n")

  -- Assemble: longtblr uses [outer]{inner}
  local latex = string.format(
    "\\begin{%s}[\n  %s\n]{\n  %s\n}\n%s\n\\end{%s}",
    env, outer_str, inner_str, body_str, env
  )

  return pandoc.RawBlock("latex", latex)
end

return {
  { Table = Table }
}
