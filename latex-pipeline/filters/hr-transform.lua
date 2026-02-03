--- hr-transform.lua — Convert horizontal rules to decorative separators
--- Filter order: 7 (runs last)
---
--- Converts Pandoc HorizontalRule (from markdown ---) to a subtle
--- centered short line, rather than a full-width rule.

function HorizontalRule()
  return pandoc.RawBlock("latex", "\\separator{}")
end

return {
  { HorizontalRule = HorizontalRule }
}
