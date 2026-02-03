--- part-dividers.lua — Insert part divider pages before chapter groups
--- This filter runs BEFORE other filters (prepended to filter chain)
---
--- Inserts \partdivider{N}{Title} LaTeX commands before the first
--- chapter of each Part, based on chapter numbering.
---
--- Part mapping:
---   Before Cap 0 (Prefacio)  → Part I: Contexto Estratégico
---   Before Cap 4             → Part II: Entendiendo la Tecnología
---   Before Cap 6             → Part III: Impacto en el Negocio
---   Before Cap 7             → Part IV: Casos de Estudio
---   Before Cap 12            → Part V: Liderazgo y Estrategia
---   Before Cap 14            → Part VI: Gobernanza y Futuro

-- Helper to extract text from header inlines
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
    end
  end
  return table.concat(result)
end

-- Part dividers configuration
local part_dividers = {
  { chapter_pattern = "Prefacio",                    part_num = "I",   part_title = "Contexto Estratégico" },
  { chapter_pattern = "Evolución Técnica",            part_num = "II",  part_title = "Entendiendo la Tecnología" },
  { chapter_pattern = "Impacto en el Negocio",       part_num = "III", part_title = "Impacto en el Negocio" },
  { chapter_pattern = "Fintech en América Latina",   part_num = "IV",  part_title = "Casos de Estudio" },
  { chapter_pattern = "Liderando Equipos",           part_num = "V",   part_title = "Liderazgo y Estrategia" },
  { chapter_pattern = "Desafíos, Riesgos",           part_num = "VI",  part_title = "Gobernanza y Futuro" },
}

-- Alternative: match by chapter number in the title
local part_by_chapnum = {
  ["0"]  = { part_num = "I",   part_title = "Contexto Estratégico" },
  ["4"]  = { part_num = "II",  part_title = "Entendiendo la Tecnología" },
  ["6"]  = { part_num = "III", part_title = "Impacto en el Negocio" },
  ["7"]  = { part_num = "IV",  part_title = "Casos de Estudio" },
  ["12"] = { part_num = "V",   part_title = "Liderazgo y Estrategia" },
  ["14"] = { part_num = "VI",  part_title = "Gobernanza y Futuro" },
}

local parts_inserted = {}
local chapter_counter = -1  -- Will become 0 for Prefacio
local appendix_letters = { "A", "B", "C", "D", "E", "F" }
local appendix_counter = 0
local in_appendices = false

function Pandoc(doc)
  local new_blocks = {}

  for _, block in ipairs(doc.blocks) do
    if block.t == "Header" and block.level == 1 then
      local text = stringify(block.content)

      -- Detect appendices by common patterns
      if text:match("^[Gg]losario") or text:match("^Apéndice") or
         text:match("^[Ff]rameworks") or text:match("^[Cc]hecklist") or
         text:match("^[Rr]ecursos") then
        in_appendices = true
      end

      -- Try to match chapter number from header text
      local chapnum = text:match("^Capítulo%s+(%d+)")
      if not chapnum then
        chapnum = text:match("^Cap%.?%s*(%d+)")
      end
      if text:match("^Prefacio") then
        chapnum = "0"
      end
      -- Executive Brief is unnumbered front matter, skip counter increment
      if text:match("^Resumen Ejecutivo") then
        chapnum = "-1"  -- Sentinel: won't match any part divider
      end

      -- If no explicit chapter number, use sequential counter
      if not chapnum and not in_appendices then
        chapter_counter = chapter_counter + 1
        chapnum = tostring(chapter_counter)
      elseif chapnum and tonumber(chapnum) >= 0 then
        chapter_counter = tonumber(chapnum)
      end

      -- Check by title pattern for part dividers
      local part_info = nil
      if chapnum and part_by_chapnum[chapnum] then
        part_info = part_by_chapnum[chapnum]
      else
        for _, divider in ipairs(part_dividers) do
          if text:find(divider.chapter_pattern, 1, true) and not parts_inserted[divider.part_num] then
            part_info = divider
            break
          end
        end
      end

      -- Insert part divider if needed
      if part_info and not parts_inserted[part_info.part_num] then
        parts_inserted[part_info.part_num] = true
        local latex = string.format(
          "\\partdivider{%s}{%s}",
          part_info.part_num,
          part_info.part_title
        )
        table.insert(new_blocks, pandoc.RawBlock("latex", latex))
      end

      -- Add the header block
      table.insert(new_blocks, block)

      -- Generate label for cross-references
      if in_appendices then
        appendix_counter = appendix_counter + 1
        local letter = appendix_letters[appendix_counter] or ("X" .. appendix_counter)
        local label_latex = string.format("\\label{app:%s}", letter)
        table.insert(new_blocks, pandoc.RawBlock("latex", label_latex))
      elseif chapnum then
        local label_latex = string.format("\\label{chap:%02d}", tonumber(chapnum))
        table.insert(new_blocks, pandoc.RawBlock("latex", label_latex))
      end
    else
      table.insert(new_blocks, block)
    end
  end

  return pandoc.Pandoc(new_blocks, doc.meta)
end

return {
  { Pandoc = Pandoc }
}
