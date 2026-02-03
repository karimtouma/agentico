--- checkbox-transform.lua — Convert markdown checkboxes to LaTeX symbols
--- Filter order: 4
---
--- Transforms:
---   - [ ] → \checkbox{}  (☐ empty square)
---   - [x] → \checkedbox{} (☑ checked square)
---   - [X] → \checkedbox{} (☑ checked square)

function Str(el)
  -- Match checkbox patterns within text strings
  -- These appear as literal text after Pandoc parsing

  if el.text == "☐" then
    return pandoc.RawInline("latex", "\\checkbox{}")
  end

  if el.text == "☑" or el.text == "✓" or el.text == "✅" then
    return pandoc.RawInline("latex", "\\checkedbox{}")
  end

  return nil
end

-- Handle the [ ] and [x] patterns that Pandoc may parse as raw text
function Para(el)
  local new_content = {}
  local modified = false
  local i = 1

  while i <= #el.content do
    local inline = el.content[i]

    if inline.t == "Str" then
      -- Check for [ ] pattern (empty checkbox)
      if inline.text == "[" and
         i + 2 <= #el.content and
         el.content[i+1].t == "Space" and
         el.content[i+2].t == "Str" and
         el.content[i+2].text == "]" then
        table.insert(new_content, pandoc.RawInline("latex", "\\checkbox{}"))
        i = i + 3
        modified = true
      -- Check for [x] or [X] pattern (checked checkbox)
      elseif inline.text == "[x]" or inline.text == "[X]" then
        table.insert(new_content, pandoc.RawInline("latex", "\\checkedbox{}"))
        i = i + 1
        modified = true
      else
        table.insert(new_content, inline)
        i = i + 1
      end
    else
      table.insert(new_content, inline)
      i = i + 1
    end
  end

  if modified then
    return pandoc.Para(new_content)
  end
  return nil
end

-- Same logic for Plain blocks
function Plain(el)
  local new_content = {}
  local modified = false
  local i = 1

  while i <= #el.content do
    local inline = el.content[i]

    if inline.t == "Str" then
      if inline.text == "[" and
         i + 2 <= #el.content and
         el.content[i+1].t == "Space" and
         el.content[i+2].t == "Str" and
         el.content[i+2].text == "]" then
        table.insert(new_content, pandoc.RawInline("latex", "\\checkbox{}"))
        i = i + 3
        modified = true
      elseif inline.text == "[x]" or inline.text == "[X]" then
        table.insert(new_content, pandoc.RawInline("latex", "\\checkedbox{}"))
        i = i + 1
        modified = true
      else
        table.insert(new_content, inline)
        i = i + 1
      end
    else
      table.insert(new_content, inline)
      i = i + 1
    end
  end

  if modified then
    return pandoc.Plain(new_content)
  end
  return nil
end

return {
  {
    Str = Str,
    Para = Para,
    Plain = Plain,
  }
}
