--- callout-transform.lua — Transform blockquotes into tcolorbox environments
--- Filter order: 2 (runs after meta-strip.lua)
---
--- Classifies each BlockQuote based on its first bold text or content pattern,
--- then wraps it in the appropriate LaTeX environment from pa-callouts.sty.

-- Helper: extract plain text from a list of Inlines
local function stringify(inlines)
  local result = {}
  if not inlines then return "" end
  for _, inline in ipairs(inlines) do
    if inline.t == "Str" then
      table.insert(result, inline.text)
    elseif inline.t == "Space" then
      table.insert(result, " ")
    elseif inline.t == "SoftBreak" or inline.t == "LineBreak" then
      table.insert(result, " ")
    elseif inline.t == "Strong" or inline.t == "Emph" then
      table.insert(result, stringify(inline.content))
    elseif inline.t == "Link" then
      table.insert(result, stringify(inline.content))
    elseif inline.t == "Quoted" then
      table.insert(result, stringify(inline.content))
    elseif inline.t == "Code" then
      table.insert(result, inline.text)
    end
  end
  return table.concat(result)
end

-- Helper: get the first Strong element's text from a block
local function get_first_bold(block)
  if not block then return nil end

  local inlines = nil
  if block.t == "Para" or block.t == "Plain" then
    inlines = block.content
  elseif block.t == "BulletList" or block.t == "OrderedList" then
    -- Check first item's first block
    if block.content and #block.content > 0 then
      local first_item = block.content[1]
      if first_item and #first_item > 0 then
        return get_first_bold(first_item[1])
      end
    end
    return nil
  end

  if not inlines then return nil end

  for _, inline in ipairs(inlines) do
    if inline.t == "Strong" then
      return stringify(inline.content)
    end
  end
  return nil
end

-- Helper: get the full text of the first paragraph in a blockquote
local function get_first_para_text(blocks)
  if not blocks or #blocks == 0 then return "" end
  local first = blocks[1]
  if first.t == "Para" or first.t == "Plain" then
    return stringify(first.content)
  end
  return ""
end

-- Helper: check if text starts with a quote character
local function starts_with_quote(text)
  if not text then return false end
  local trimmed = text:match("^%s*(.-)%s*$")
  return trimmed:sub(1, 1) == '"' or trimmed:sub(1, 1) == "\u{201C}" -- smart quote
end

-- Helper: check if blockquote contains checkboxes
local function has_checkboxes(blocks)
  for _, block in ipairs(blocks) do
    if block.t == "Para" or block.t == "Plain" then
      local text = stringify(block.content)
      if text:match("%[%s*%]") or text:match("%[x%]") or text:match("%[X%]") then
        return true
      end
    elseif block.t == "BulletList" then
      for _, item in ipairs(block.content) do
        for _, sub_block in ipairs(item) do
          local text = stringify(sub_block.content or {})
          if text:match("%[%s*%]") or text:match("%[x%]") or text:match("%[X%]") then
            return true
          end
        end
      end
    end
  end
  return false
end

-- Classification rules (order matters — first match wins)
local function classify_blockquote(blocks)
  local bold_text = get_first_bold(blocks[1])
  local first_text = get_first_para_text(blocks)

  -- 1. Resumen Ejecutivo
  if bold_text and bold_text:match("[Rr]esumen [Ee]jecutivo") then
    return "resumen-ejecutivo"
  end

  -- 2. Para tu próxima reunión de liderazgo
  if bold_text and bold_text:match("[Pp]ara tu pr") then
    return "reunion-liderazgo"
  end
  if bold_text and bold_text:match("próxima reunión") then
    return "reunion-liderazgo"
  end

  -- 3. Errores comunes
  if bold_text and bold_text:match("[Ee]rrores? comunes?") then
    return "errores-comunes"
  end

  -- 4. Argumento para el Board
  if bold_text and bold_text:match("[Aa]rgumento para") then
    return "argumento-board"
  end

  -- 5. Nota para líderes
  if bold_text and bold_text:match("[Nn]ota para") then
    return "nota-lideres"
  end
  if bold_text and bold_text:match("[Nn]ota:") then
    return "nota-lideres"
  end

  -- 6. Tendencia clave
  if bold_text and bold_text:match("[Tt]endencia") then
    return "tendencia-clave"
  end

  -- 7. Punto crítico
  if bold_text and bold_text:match("[Pp]unto cr") then
    return "punto-critico"
  end
  if bold_text and bold_text:match("crítico") then
    return "punto-critico"
  end

  -- 8. Ejemplo práctico
  if bold_text and bold_text:match("[Ee]jemplo") then
    return "ejemplo-practico"
  end
  if bold_text and bold_text:match("[Ee]jercicio") then
    return "ejemplo-practico"
  end

  -- 9. Lectura ejecutiva
  if bold_text and bold_text:match("[Ll]ectura ejecutiva") then
    return "lectura-ejecutiva"
  end

  -- 10. Implicación para líderes
  if bold_text and bold_text:match("[Ii]mplicaci") then
    return "implicacion-talento"
  end

  -- 13. Dato clave
  if bold_text and bold_text:match("[Dd]atos?:") then
    return "dato-clave"
  end
  if bold_text and bold_text:match("[Mm]étrica") then
    return "dato-clave"
  end

  -- Framework / Strategy blocks → ejemplo-practico
  if bold_text and bold_text:match("[Ff]ramework") then
    return "ejemplo-practico"
  end
  if bold_text and bold_text:match("[Ee]strategia") then
    return "ejemplo-practico"
  end
  if bold_text and bold_text:match("[Cc]hecklist") then
    return "checklist-box"
  end

  -- Pregunta / Decisión / Reflexión → reunion-liderazgo
  if bold_text and bold_text:match("[Pp]regunta") then
    return "reunion-liderazgo"
  end
  if bold_text and bold_text:match("[Dd]ecisi") then
    return "reunion-liderazgo"
  end
  if bold_text and bold_text:match("[Rr]eflexi") then
    return "reunion-liderazgo"
  end

  -- Propósito blocks → nota-lideres
  if bold_text and bold_text:match("[Pp]ropósito") then
    return "nota-lideres"
  end

  -- Fuente / Source → dato-clave
  if bold_text and bold_text:match("[Ff]uente:") then
    return "dato-clave"
  end

  -- Cómo / How-to blocks → ejemplo-practico
  if bold_text and bold_text:match("^Cómo") then
    return "ejemplo-practico"
  end
  if bold_text and bold_text:match("^Cuándo") then
    return "ejemplo-practico"
  end

  -- 12. Checklist (checkbox detection)
  if has_checkboxes(blocks) then
    return "checklist-box"
  end

  -- Case study badges (must come before generic metadata patterns)
  if bold_text and bold_text:match("[Cc]aso [Rr]eal") then
    return "caso-real"
  end
  if bold_text and bold_text:match("[Cc]aso [Ff]icticio") then
    return "caso-ficticio"
  end

  -- Metadata blocks (Extensión objetivo, Tipo, Empresa, Período) → nota-lideres
  if bold_text and bold_text:match("[Ee]xtensi") then
    return "nota-lideres"
  end
  if bold_text and (bold_text:match("^Tipo:") or bold_text:match("^Empresa:") or bold_text:match("^Período:")) then
    return "nota-lideres"
  end

  -- Before/After patterns → cita-directa
  if bold_text and (bold_text:match("^Antes:") or bold_text:match("^Ahora:")) then
    return "cita-directa"
  end

  -- 11. Direct quotes (text starting with quotation mark)
  if starts_with_quote(first_text) then
    return "cita-directa"
  end

  -- Attributed quotes: **Name:** "quote"
  if bold_text and first_text:match('"') then
    -- Pattern like **Senior 1:** "text..."
    local after_bold = first_text:match(':%s*"')
    if after_bold then
      return "cita-directa"
    end
  end

  -- Usar trimestralmente → nota-lideres
  if first_text:match("^Usar ") then
    return "nota-lideres"
  end

  -- 14. Generic fallback
  return "callout-generico"
end

-- Convert blockquote content to LaTeX string
local function blocks_to_latex(blocks)
  -- Use pandoc.write to convert blocks to LaTeX
  local doc = pandoc.Pandoc(blocks)
  local latex = pandoc.write(doc, "latex")
  return latex
end

-- Helper: check if the first block is a title-only paragraph (just bold text)
-- and strip it to avoid duplication with tcolorbox title
local function strip_title_paragraph(blocks)
  if not blocks or #blocks == 0 then return blocks end
  local first = blocks[1]
  if first.t ~= "Para" and first.t ~= "Plain" then return blocks end

  local inlines = first.content
  if not inlines or #inlines == 0 then return blocks end

  -- Check if the paragraph is ONLY a Strong element (possibly with trailing whitespace)
  local has_strong = false
  local only_strong = true
  for _, inline in ipairs(inlines) do
    if inline.t == "Strong" then
      has_strong = true
    elseif inline.t == "Space" or inline.t == "SoftBreak" or inline.t == "LineBreak" then
      -- whitespace is fine
    else
      only_strong = false
      break
    end
  end

  if has_strong and only_strong then
    -- First paragraph is title-only — remove it
    local new_blocks = {}
    for i = 2, #blocks do
      table.insert(new_blocks, blocks[i])
    end
    return new_blocks
  end

  -- If the paragraph starts with Strong followed by real content, strip just the Strong
  -- (e.g., "> **Resumen Ejecutivo** \n > - bullet" rendered as single Para)
  -- This case is less common; usually title is its own paragraph. Keep as-is.
  return blocks
end

-- Environments that have a hardcoded tcolorbox title (should strip duplicate)
local titled_envs = {
  ["resumen-ejecutivo"] = true,
  ["reunion-liderazgo"] = true,
  ["argumento-board"] = true,
  ["dato-clave"] = true,
  ["caso-real"] = true,
  ["nota-lideres"] = true,
  ["tendencia-clave"] = true,
  ["ejemplo-practico"] = true,
  ["lectura-ejecutiva"] = true,
  ["implicacion-talento"] = true,
  ["checklist-box"] = true,
  ["caso-ficticio"] = true,
  ["errores-comunes"] = true,
  ["punto-critico"] = true,
}

-- Main filter function
function BlockQuote(el)
  if not el.content or #el.content == 0 then
    return nil
  end

  local env_name = classify_blockquote(el.content)

  -- For titled environments, strip the bold title paragraph from body
  -- to avoid duplication with the tcolorbox title
  local content_blocks = el.content
  if titled_envs[env_name] then
    content_blocks = strip_title_paragraph(content_blocks)
  end

  -- Convert the blockquote content to LaTeX
  local inner_latex = blocks_to_latex(content_blocks)

  -- Wrap in the appropriate tcolorbox environment
  local latex = string.format(
    "\\begin{%s}\n%s\\end{%s}",
    env_name,
    inner_latex,
    env_name
  )

  return pandoc.RawBlock("latex", latex)
end

return {
  { BlockQuote = BlockQuote }
}
