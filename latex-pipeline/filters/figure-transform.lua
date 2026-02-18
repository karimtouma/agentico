-- =============================================================================
-- figure-transform.lua — Resolve figure references from manifest.yml
-- =============================================================================
-- Syntax in markdown:  ![fig:loop-agentico]
-- Manifest at:         /book/content/figuras/manifest.yml
-- Output:              LaTeX \begin{figure}...\end{figure} or placeholder box
-- =============================================================================

local manifest = {}
local fig_stats = { final = 0, draft = 0, placeholder = 0, missing = 0 }

-- Figure mode from metadata (all | final-only | no-placeholders)
local figure_mode = "all"

-- =============================================================================
-- Simple YAML parser for our manifest structure
-- =============================================================================
local function parse_manifest(filepath)
  local f = io.open(filepath, "r")
  if not f then
    io.stderr:write("[figure-transform] WARNING: Cannot open manifest: " .. filepath .. "\n")
    return {}
  end

  local figures = {}
  local current_id = nil
  local current_fig = nil
  local in_todo = false
  local todo_lines = {}

  for line in f:lines() do
    -- Skip comments and empty lines
    if line:match("^%s*#") or line:match("^%s*$") then
      -- skip
    elseif line:match("^figures:") then
      -- top level key, skip
    elseif in_todo then
      -- Collecting multi-line todo block
      if line:match("^%s%s%s%s%S") or line:match("^%s%s%s%s%s%s") then
        -- Continuation of todo (indented content)
        local content = line:match("^%s+(.*)")
        if content then
          table.insert(todo_lines, content)
        end
      else
        -- End of todo block, save it
        if current_fig then
          current_fig.todo = table.concat(todo_lines, "\n")
        end
        in_todo = false
        todo_lines = {}
        -- Re-process this line
        goto reprocess
      end
    end

    ::reprocess::
    if not in_todo then
      -- New figure ID (top-level key under figures:, 2-space indent)
      local id = line:match("^  ([%w%-]+):%s*$")
      if id then
        -- Save previous figure
        if current_id and current_fig then
          if #todo_lines > 0 then
            current_fig.todo = table.concat(todo_lines, "\n")
            todo_lines = {}
          end
          figures[current_id] = current_fig
        end
        current_id = id
        current_fig = {
          source = nil,
          status = "placeholder",
          caption = "",
          label = "fig:" .. id,
          chapter = "",
          width = "\\textwidth",
          tier = 3,
          complexity = "medium",
          todo = ""
        }
        in_todo = false
      elseif current_fig then
        -- Key-value pairs (4-space indent)
        local key, val = line:match("^    ([%w_]+):%s*(.+)%s*$")
        if key and val then
          -- Remove quotes
          val = val:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")
          if key == "source" then
            if val == "null" or val == "~" then
              current_fig.source = nil
            else
              current_fig.source = val
            end
          elseif key == "status" then
            current_fig.status = val
          elseif key == "caption" then
            current_fig.caption = val
          elseif key == "label" then
            current_fig.label = val
          elseif key == "chapter" then
            current_fig.chapter = val
          elseif key == "width" then
            current_fig.width = val
          elseif key == "tier" then
            current_fig.tier = tonumber(val) or 3
          elseif key == "complexity" then
            current_fig.complexity = val
          end
        end

        -- Multi-line todo starts with "todo: |"
        local todo_start = line:match("^    todo:%s*|%s*$")
        if todo_start then
          in_todo = true
          todo_lines = {}
        end
      end
    end
  end

  -- Save last figure
  if current_id and current_fig then
    if #todo_lines > 0 then
      current_fig.todo = table.concat(todo_lines, "\n")
    end
    figures[current_id] = current_fig
  end

  f:close()
  return figures
end

-- =============================================================================
-- Escape special LaTeX characters in text
-- =============================================================================
local function latex_escape(s)
  if not s then return "" end
  s = s:gsub("\\", "\\textbackslash{}")
  s = s:gsub("%%", "\\%%")
  s = s:gsub("%$", "\\$")
  s = s:gsub("%&", "\\&")
  s = s:gsub("#", "\\#")
  s = s:gsub("_", "\\_")
  s = s:gsub("{", "\\{")
  s = s:gsub("}", "\\}")
  s = s:gsub("~", "\\textasciitilde{}")
  s = s:gsub("%^", "\\textasciicircum{}")
  return s
end

-- Light escape: only escape characters that break captions (not braces/backslash)
local function caption_escape(s)
  if not s then return "" end
  s = s:gsub("%%", "\\%%")
  s = s:gsub("%$", "\\$")
  s = s:gsub("%&", "\\&")
  s = s:gsub("#", "\\#")
  s = s:gsub("_", "\\_")
  s = s:gsub("~", "\\textasciitilde{}")
  return s
end

-- =============================================================================
-- Generate LaTeX for each figure status
-- =============================================================================

local function render_final(fig)
  local pdf_name = "fig-" .. fig.id .. ".pdf"
  return string.format([[
\begin{figure}[htbp]
  \centering
  \includegraphics[width=%s]{/book/illustrations/%s}
  \caption{%s}
  \label{%s}
\end{figure}
]], fig.width, pdf_name, caption_escape(fig.caption), fig.label)
end

local function render_draft(fig)
  local pdf_name = "fig-" .. fig.id .. ".pdf"
  return string.format([[
\begin{figure}[htbp]
  \centering
  \includegraphics[width=%s]{/book/illustrations/%s}
  \caption{{\color{pa-warning}\textsc{[borrador]}} %s}
  \label{%s}
\end{figure}
]], fig.width, pdf_name, caption_escape(fig.caption), fig.label)
end

local function render_placeholder(fig)
  local todo_text = fig.todo or ""
  -- Truncate todo for display (first 3 lines)
  local lines = {}
  for line in todo_text:gmatch("[^\n]+") do
    table.insert(lines, line)
    if #lines >= 4 then break end
  end
  local display_todo = latex_escape(table.concat(lines, "\n"))

  local complexity_label = ({
    low = "baja",
    medium = "media",
    high = "alta"
  })[fig.complexity] or "media"

  return string.format([[
\begin{figure}[htbp]
  \centering
  \begin{tcolorbox}[
    colback=pa-callout-neutral-bg,
    colframe=pa-callout-neutral-border,
    width=%s,
    arc=2mm,
    boxrule=0.5pt,
    left=8pt, right=8pt, top=6pt, bottom=6pt,
    title={\faImage\quad Figura pendiente: %s}
  ]
  \small\itshape\color{pa-midgray}
  %s
  \par\medskip
  \normalfont\footnotesize\color{pa-secondary}
  Complejidad: \textbf{%s} \quad Tier: \textbf{%d} \quad Cap: \textbf{%s}
  \end{tcolorbox}
  \caption{%s}
  \label{%s}
\end{figure}
]], fig.width, caption_escape(fig.caption), display_todo,
   complexity_label, fig.tier, fig.chapter,
   caption_escape(fig.caption), fig.label)
end

-- =============================================================================
-- Pandoc filter functions
-- =============================================================================

function Meta(meta)
  -- Read figure-mode from metadata if set
  if meta["figure-mode"] then
    figure_mode = pandoc.utils.stringify(meta["figure-mode"])
  end

  -- Load manifest
  local manifest_paths = {
    "/book/content/figuras/manifest.yml",
    "/book/figuras/manifest.yml",
    "../ingenieria_agentica/figuras/manifest.yml"
  }

  for _, path in ipairs(manifest_paths) do
    manifest = parse_manifest(path)
    if next(manifest) then
      local count = 0
      for _ in pairs(manifest) do count = count + 1 end
      io.stderr:write(string.format(
        "[figure-transform] Loaded manifest: %d figures from %s\n", count, path
      ))
      break
    end
  end

  if not next(manifest) then
    io.stderr:write("[figure-transform] WARNING: No manifest loaded. Figure references will fail.\n")
  end

  return meta
end

function Para(el)
  -- Look for paragraphs containing only a single Image with fig: prefix
  if #el.content == 1 and el.content[1].t == "Image" then
    local img = el.content[1]
    local src = img.src or ""

    -- Match ![fig:some-id] or ![fig:some-id "optional caption"]
    local fig_id = src:match("^fig:(.+)$")
    if not fig_id then return nil end

    local fig_data = manifest[fig_id]
    if not fig_data then
      io.stderr:write(string.format(
        "[figure-transform] WARNING: Figure '%s' not found in manifest\n", fig_id
      ))
      fig_stats.missing = fig_stats.missing + 1
      -- Return a visible warning in the document
      return pandoc.RawBlock("latex", string.format(
        "\\par{\\color{pa-danger}\\textbf{[FIGURE MISSING: fig:%s — not in manifest]}}\\par",
        fig_id
      ))
    end

    -- Build render data
    local render = {
      id = fig_id,
      caption = fig_data.caption,
      label = fig_data.label or ("fig:" .. fig_id),
      width = fig_data.width or "\\textwidth",
      status = fig_data.status or "placeholder",
      tier = fig_data.tier or 3,
      complexity = fig_data.complexity or "medium",
      chapter = fig_data.chapter or "?",
      todo = fig_data.todo or ""
    }

    -- Override caption if provided in markdown
    local alt_text = pandoc.utils.stringify(img.caption)
    if alt_text and alt_text ~= "" and alt_text ~= ("fig:" .. fig_id) then
      render.caption = alt_text
    end

    -- Apply figure-mode filter
    if figure_mode == "final-only" and render.status ~= "final" then
      return pandoc.RawBlock("latex", "") -- skip
    end
    if figure_mode == "no-placeholders" and render.status == "placeholder" then
      return pandoc.RawBlock("latex", "") -- skip
    end

    -- Render based on status
    local latex_output
    if render.status == "final" then
      latex_output = render_final(render)
      fig_stats.final = fig_stats.final + 1
    elseif render.status == "draft" then
      latex_output = render_draft(render)
      fig_stats.draft = fig_stats.draft + 1
    else
      latex_output = render_placeholder(render)
      fig_stats.placeholder = fig_stats.placeholder + 1
    end

    return pandoc.RawBlock("latex", latex_output)
  end

  return nil
end

function Pandoc(doc)
  -- Print summary at end
  local total = fig_stats.final + fig_stats.draft + fig_stats.placeholder + fig_stats.missing
  if total > 0 then
    io.stderr:write(string.format(
      "[figure-transform] Summary: %d final, %d draft, %d placeholder, %d missing (mode: %s)\n",
      fig_stats.final, fig_stats.draft, fig_stats.placeholder, fig_stats.missing, figure_mode
    ))
  end
  return doc
end

return {
  { Meta = Meta },
  { Para = Para },
  { Pandoc = Pandoc }
}
