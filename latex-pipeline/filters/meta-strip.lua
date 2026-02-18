--- meta-strip.lua — Remove navigation lines, word counts, and trailing separators
--- Filter order: 1 (runs first)

-- Patterns to strip from the document
local strip_patterns = {
  "^%[Continúa",           -- [Continúa en Capítulo X]
  "^%[Volver",             -- [Volver al índice]
  "^%*%*Fin del",          -- **Fin del Capítulo X**
  "^%*%*Palabras:",        -- **Palabras:** ~X,XXX
  "^%*%*Páginas estimadas", -- **Páginas estimadas:** ~X
  "^%*%*Extensión:",       -- **Extensión:**
  "^%*%*Siguiente:",       -- **Siguiente:** [Capítulo X...]
  "^Navegación:",          -- Navegación:
  "^%-%-%-$",              -- Standalone --- at end (will handle separately)
}

-- Check if a string matches any strip pattern
local function should_strip(text)
  for _, pattern in ipairs(strip_patterns) do
    if text:match(pattern) then
      return true
    end
  end
  return false
end

-- Extract plain text from inline elements
local function stringify(inlines)
  local result = {}
  for _, inline in ipairs(inlines) do
    if inline.t == "Str" then
      table.insert(result, inline.text)
    elseif inline.t == "Space" then
      table.insert(result, " ")
    elseif inline.t == "SoftBreak" then
      table.insert(result, " ")
    elseif inline.t == "Strong" or inline.t == "Emph" then
      table.insert(result, stringify(inline.content))
    elseif inline.t == "Link" then
      table.insert(result, stringify(inline.content))
    end
  end
  return table.concat(result)
end

-- Filter paragraphs
function Para(el)
  local text = stringify(el.content)
  if should_strip(text) then
    return {} -- Remove the paragraph
  end
  return nil -- Keep it
end

-- Filter plain blocks (sometimes used instead of Para)
function Plain(el)
  local text = stringify(el.content)
  if should_strip(text) then
    return {}
  end
  return nil
end

-- Remove trailing HorizontalRules at end of document sections
-- We handle this by tracking consecutive HRs
local hr_count = 0

function HorizontalRule(el)
  -- We'll let the hr-transform.lua handle remaining HRs
  -- Here we just track if there's a trailing one
  return nil
end

-- Strip top-level H1 headers (chapter files already have # Chapter X as H1,
-- but Pandoc --top-level-division=chapter handles this, so we leave H1s alone)
-- Only strip H1 if it looks like a duplicate/navigation header
function Header(el)
  if el.level == 1 then
    local text = stringify(el.content)
    -- Remove "Capítulo X:" prefix navigation-style headers
    if text:match("^Navegación") or text:match("^Índice") then
      return {}
    end
  end
  return nil
end

-- Filter blockquotes that contain metadata (Extensión objetivo, etc.)
function BlockQuote(el)
  if #el.content > 0 then
    local first = el.content[1]
    if first.t == "Para" or first.t == "Plain" then
      local text = stringify(first.content)
      if text:match("^%*%*Extensión objetivo") or
         text:match("^Extensión objetivo") then
        return {} -- Remove the entire blockquote
      end
    end
  end
  return nil
end

-- Second pass: remove empty "Referencias" sections at document level.
-- Pandoc auto-generates a "Referencias" header for footnote definitions
-- (localized from "Footnotes" when lang=es). Since footnotes are already
-- rendered as \footnote{} in LaTeX, the section ends up empty.
-- Also handles explicit ## Referencias headings followed only by footnote
-- definitions (which pandoc consumes), leaving the section empty.
local function is_navigation_para(block)
  if block.t ~= "Para" and block.t ~= "Plain" then return false end
  local text = stringify(block.content)
  return text:match("^Fin del ") or text:match("^Continúa en ")
end

local function remove_empty_referencias(doc)
  local blocks = doc.blocks
  local new_blocks = {}
  local i = 1
  while i <= #blocks do
    local block = blocks[i]
    if block.t == "Header" and block.level == 2 then
      local text = stringify(block.content)
      if text == "Referencias" then
        -- Look ahead: skip HorizontalRules and navigation footers,
        -- check if next real content block is a Header or end of document
        local j = i + 1
        local has_content = false
        while j <= #blocks do
          local nb = blocks[j]
          if nb.t == "HorizontalRule" or is_navigation_para(nb) then
            j = j + 1
          elseif nb.t == "Header" then
            break  -- next section starts, no content found
          else
            has_content = true
            break
          end
        end
        if not has_content then
          i = i + 1  -- skip the empty Referencias header
        else
          table.insert(new_blocks, block)
          i = i + 1
        end
      else
        table.insert(new_blocks, block)
        i = i + 1
      end
    else
      table.insert(new_blocks, block)
      i = i + 1
    end
  end
  doc.blocks = new_blocks
  return doc
end

return {
  {
    Para = Para,
    Plain = Plain,
    Header = Header,
    BlockQuote = BlockQuote,
  },
  {
    Pandoc = remove_empty_referencias,
  }
}
