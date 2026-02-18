-- drop-caps.lua — Apply \lettrine drop caps at the start of each chapter
-- Runs AFTER callout-transform.lua (blockquotes already converted to RawBlock)
-- Finds the first body paragraph after each H1 and wraps the first letter
-- in \lettrine{X}{rest-of-word} for a professional book opening.

-- Drop caps DESACTIVADAS - causaban problemas de layout
-- Para reactivar, descomentar el código abajo

function Pandoc(doc)
  -- No-op: retorna el documento sin modificar
  return doc
end
