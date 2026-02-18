--- part-dividers.lua — Insert part divider pages, notes pages, and mini TOCs
--- This filter runs BEFORE other filters (prepended to filter chain)
---
--- Features:
---   1. Inserts \partdivider{N}{Title} LaTeX commands before the first
---      chapter of each Part, based on chapter numbering.
---   2. Inserts \notespage{Part Title} after each part divider.
---   3. Inserts \chapterminitoc{...} after each chapter header with
---      a list of section titles for quick reference.
---
--- Part mapping:
---   Before Cap 0 (Prefacio)       → Part I: Contexto Estratégico
---   Before Cap 5 (Sesgos)         → Part II: Sesgos y Evidencia
---   Before Cap 7 (Evolución Téc.) → Part III: La Tecnología
---   Before Cap 9 (Impacto)        → Part IV: Impacto en el Negocio
---   Before Cap 11 (Liderando)     → Part V: Liderazgo y Estrategia
---   Before Cap 13 (Gobernanza)    → Part VI: Gobernanza y Futuro

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
  { chapter_pattern = "Sesgos Cognitivos",           part_num = "II",  part_title = "Sesgos y Evidencia" },
  { chapter_pattern = "Evolución Técnica",           part_num = "III", part_title = "La Tecnología" },
  { chapter_pattern = "Impacto en el Negocio",       part_num = "IV",  part_title = "Impacto en el Negocio" },
  { chapter_pattern = "Liderando Equipos",           part_num = "V",   part_title = "Liderazgo y Estrategia" },
  { chapter_pattern = "Desafíos, Riesgos",           part_num = "VI",  part_title = "Gobernanza y Futuro" },
}

-- Alternative: match by chapter number in the title
local part_by_chapnum = {
  ["0"]  = { part_num = "I",   part_title = "Contexto Estratégico" },
  ["5"]  = { part_num = "II",  part_title = "Sesgos y Evidencia" },
  ["7"]  = { part_num = "III", part_title = "La Tecnología" },
  ["9"]  = { part_num = "IV",  part_title = "Impacto en el Negocio" },
  ["11"] = { part_num = "V",   part_title = "Liderazgo y Estrategia" },
  ["13"] = { part_num = "VI",  part_title = "Gobernanza y Futuro" },
}

local parts_inserted = {}
local chapter_counter = -1  -- Will become 0 for Prefacio
local appendix_letters = { "A", "B", "C", "D", "E", "F" }
local appendix_counter = 0
local in_appendices = false

-- Chapters that should NOT get a mini TOC (too short or structural)
local skip_minitoc = {
  ["Prefacio"] = true,
  ["Resumen Ejecutivo"] = true,
}

-- Build a map of chapter index → list of section titles
local function build_section_map(blocks)
  local section_map = {}  -- maps block index of H1 → list of section titles
  local current_h1_idx = nil

  for i, block in ipairs(blocks) do
    if block.t == "Header" then
      if block.level == 1 then
        current_h1_idx = i
        section_map[i] = {}
      elseif block.level == 2 and current_h1_idx then
        local text = stringify(block.content)
        -- Skip standard ending sections from mini TOC
        if not text:match("^Conclusiones") and
           not text:match("^Preguntas de Reflexión") and
           not text:match("^Referencias") then
          table.insert(section_map[current_h1_idx], text)
        end
      end
    end
  end

  return section_map
end

function Pandoc(doc)
  -- First pass: build section map for mini TOCs
  local section_map = build_section_map(doc.blocks)

  local new_blocks = {}

  for i, block in ipairs(doc.blocks) do
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
      -- (Sentinels for 03b/08b removed: now regular numbered chapters 04/10)

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

      -- Insert part divider + notes page if needed
      if part_info and not parts_inserted[part_info.part_num] then
        parts_inserted[part_info.part_num] = true
        local latex = string.format(
          "\\partdivider{%s}{%s}",
          part_info.part_num,
          part_info.part_title
        )
        table.insert(new_blocks, pandoc.RawBlock("latex", latex))

        -- Insert notes page after part divider (skip for Part I to save space)
        if part_info.part_num ~= "I" then
          local notes_latex = string.format(
            "\\notespage{Parte %s: %s}",
            part_info.part_num,
            part_info.part_title
          )
          table.insert(new_blocks, pandoc.RawBlock("latex", notes_latex))
        end
      end

      -- Add the header block
      table.insert(new_blocks, block)

      -- Generate label for cross-references
      if in_appendices then
        appendix_counter = appendix_counter + 1
        local letter = appendix_letters[appendix_counter] or ("X" .. appendix_counter)
        local label_latex = string.format("\\label{app:%s}", letter)
        table.insert(new_blocks, pandoc.RawBlock("latex", label_latex))
      elseif chapnum and tonumber(chapnum) >= 0 then
        local label_latex = string.format("\\label{chap:%02d}", tonumber(chapnum))
        table.insert(new_blocks, pandoc.RawBlock("latex", label_latex))
      end

      -- Insert mini TOC for chapters with sections (skip structural/short chapters)
      local short_title = text:match("^[^:]+")  -- Get text before first colon
      if not skip_minitoc[short_title] and not in_appendices then
        local sections = section_map[i]
        if sections and #sections >= 3 then
          -- Build mini TOC items
          local items = {}
          for _, sec_title in ipairs(sections) do
            -- Escape LaTeX special characters commonly found in section titles
            local escaped = sec_title:gsub("%%", "\\%%")
            escaped = escaped:gsub("%$", "\\$")
            escaped = escaped:gsub("&", "\\&")
            escaped = escaped:gsub("#", "\\#")
            escaped = escaped:gsub("_", "\\_")
            table.insert(items, string.format("\\item %s", escaped))
          end
          local minitoc_latex = string.format(
            "\\chapterminitoc{%s}",
            table.concat(items, "\n")
          )
          table.insert(new_blocks, pandoc.RawBlock("latex", minitoc_latex))
        end
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
