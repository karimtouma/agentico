--- crossref-transform.lua — Convert chapter/appendix references to hyperlinks
--- Filter order: 6
---
--- Transforms textual cross-references into LaTeX \hyperref commands:
---   "Capítulo 7"   → \hyperref[chap:07]{Capítulo 7}
---   "Apéndice B"   → \hyperref[app:B]{Apéndice B}
---   "capítulo 12"  → \hyperref[chap:12]{capítulo 12}

-- Patterns to match and their label generators
local patterns = {
  -- "Capítulo X" or "capítulo X" (1-2 digit number)
  {
    pattern = "([Cc]apítulo)%s+(%d+)",
    label = function(_, num)
      return string.format("chap:%02d", tonumber(num))
    end,
    replace = function(word, num)
      return word .. " " .. num
    end
  },
  -- "Cap. X" or "cap. X"
  {
    pattern = "([Cc]ap%.)%s*(%d+)",
    label = function(_, num)
      return string.format("chap:%02d", tonumber(num))
    end,
    replace = function(word, num)
      return word .. " " .. num
    end
  },
  -- "Apéndice X" where X is A-D
  {
    pattern = "([Aa]péndice)%s+([A-D])",
    label = function(_, letter)
      return "app:" .. letter
    end,
    replace = function(word, letter)
      return word .. " " .. letter
    end
  },
  -- "Parte I-VI"
  {
    pattern = "([Pp]arte)%s+([IVX]+)",
    label = function(_, roman)
      return "part:" .. roman
    end,
    replace = function(word, roman)
      return word .. " " .. roman
    end
  },
}

function Str(el)
  local text = el.text

  for _, rule in ipairs(patterns) do
    local word, ref = text:match(rule.pattern)
    if word and ref then
      local label = rule.label(word, ref)
      local display = rule.replace(word, ref)
      local latex = string.format("\\hyperref[%s]{%s}", label, display)
      return pandoc.RawInline("latex", latex)
    end
  end

  return nil
end

-- Process inlines within a single element, converting cross-references
local function process_inlines(inlines)
  local new_inlines = {}
  local modified = false
  local i = 1

  while i <= #inlines do
    local matched = false

    if inlines[i].t == "Str" then
      local text = inlines[i].text

      if text:match("^[Cc]apítulo$") or text:match("^[Cc]ap%.$") then
        if i + 2 <= #inlines and
           inlines[i+1].t == "Space" and
           inlines[i+2].t == "Str" and
           inlines[i+2].text:match("^%d+") then
          local num = inlines[i+2].text:match("^(%d+)")
          local label = string.format("chap:%02d", tonumber(num))
          local display = text .. " " .. num
          local rest = inlines[i+2].text:sub(#num + 1)

          local latex = string.format("\\hyperref[%s]{%s}", label, display)
          table.insert(new_inlines, pandoc.RawInline("latex", latex))

          if rest ~= "" then
            table.insert(new_inlines, pandoc.Str(rest))
          end

          i = i + 3
          modified = true
          matched = true
        end

      elseif text:match("^[Aa]péndice$") then
        if i + 2 <= #inlines and
           inlines[i+1].t == "Space" and
           inlines[i+2].t == "Str" and
           inlines[i+2].text:match("^[A-D]") then
          local letter = inlines[i+2].text:sub(1, 1)
          local label = "app:" .. letter
          local display = text .. " " .. letter
          local rest = inlines[i+2].text:sub(2)

          local latex = string.format("\\hyperref[%s]{%s}", label, display)
          table.insert(new_inlines, pandoc.RawInline("latex", latex))

          if rest ~= "" then
            table.insert(new_inlines, pandoc.Str(rest))
          end

          i = i + 3
          modified = true
          matched = true
        end
      end
    end

    if not matched then
      table.insert(new_inlines, inlines[i])
      i = i + 1
    end
  end

  if modified then
    return pandoc.Inlines(new_inlines)
  end
  return nil
end

-- Only process cross-references in body text (Para, Plain), NOT in Headers
-- Headers with \hyperref cause warnings on every page via running headers
function Para(el)
  local result = process_inlines(el.content)
  if result then
    el.content = result
    return el
  end
  return nil
end

function Plain(el)
  local result = process_inlines(el.content)
  if result then
    el.content = result
    return el
  end
  return nil
end

return {
  { Para = Para, Plain = Plain }
}
