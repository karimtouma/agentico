--- index-transform.lua — Convert markdown index markers to LaTeX \index{} commands
---
--- Convention: [term]{.idx} in markdown → \index{term}term in LaTeX
--- Subentries: [term]{.idx data-sub="parent"} → \index{parent!term}term
---
--- This filter processes Span elements with class "idx" and converts them
--- to raw LaTeX \index{} commands for the back-of-book analytical index.

-- Escape special LaTeX characters for \index{} entries
local function escape_index(s)
  s = s:gsub("&", "\\&")
  return s
end

function Span(el)
  if el.classes:includes("idx") then
    local text = pandoc.utils.stringify(el.content)
    local sub = el.attributes["data-sub"]

    local index_entry
    if sub then
      -- Subentry: \index{parent!term}
      index_entry = string.format("\\index{%s!%s}", escape_index(sub), escape_index(text))
    else
      -- Main entry: \index{term}
      index_entry = string.format("\\index{%s}", escape_index(text))
    end

    -- Return the index command followed by the visible text
    return {
      pandoc.RawInline("latex", index_entry),
      table.unpack(el.content)
    }
  end
end

return {
  { Span = Span }
}
