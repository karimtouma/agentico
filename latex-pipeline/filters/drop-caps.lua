-- drop-caps.lua — Apply \lettrine drop caps at the start of each chapter
-- Runs AFTER callout-transform.lua (blockquotes already converted to RawBlock)
-- Finds the first body paragraph after each H1 and wraps the first letter
-- in \lettrine{X}{rest-of-word} for a professional book opening.

function Pandoc(doc)
  local blocks = doc.blocks
  local looking = false
  local skip_count = 0

  for i, block in ipairs(blocks) do
    if block.t == "Header" and block.level == 1 then
      looking = true
      skip_count = 0
    elseif looking then
      skip_count = skip_count + 1
      -- Safety: don't search forever (some chapters have many blocks before first para)
      if skip_count > 20 then
        looking = false
      elseif block.t == "Para" then
        -- Found the first paragraph after a chapter heading
        local inlines = block.content
        if #inlines > 0 and inlines[1].t == "Str" then
          local text = inlines[1].text
          local pos2 = utf8.offset(text, 2)
          if pos2 then
            local first_char = text:sub(1, pos2 - 1)
            local rest = text:sub(pos2)

            -- Replace first Str inline with \lettrine{char}{rest-of-word}
            inlines[1] = pandoc.RawInline("latex",
              "\\noindent\\lettrine{" .. first_char .. "}{" .. rest .. "}")
            block.content = inlines
          end
        end
        -- Skip paragraphs starting with bold (2 chapters: **IA Agéntica**, **Banco Continental**)
        -- Those get no drop cap — the bold name is more important visually
        looking = false
      end
    end
  end

  return doc
end
