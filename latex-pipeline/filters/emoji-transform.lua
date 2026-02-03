--- emoji-transform.lua — Remove emojis from text for clean LaTeX output
--- Filter order: 5
---
--- For a print book, most emojis are stripped to prevent LuaLaTeX errors.
--- However, symbols that have \newunicodechar fallbacks in the .cls file
--- are PRESERVED so LaTeX can render them (checkmarks, crosses, etc.).

-- Codepoints with LaTeX fallbacks in paradigma-agentico.cls (lines 91-105)
-- These MUST NOT be stripped — LaTeX renders them via newunicodechar
local latex_fallback = {
  [0x2713] = true,  -- ✓ → \checkmark
  [0x2717] = true,  -- ✗ → $\times$
  [0x2705] = true,  -- ✅ → colored checkmark
  [0x274C] = true,  -- ❌ → colored times
  [0x26A0] = true,  -- ⚠ → colored triangle
  [0x2B50] = true,  -- ⭐ → $\star$
  [0x1F4CA] = true, -- 📊 → \faChartBar
  [0x1F52C] = true, -- 🔬 → \faMicroscope
  [0x1F916] = true, -- 🤖 → \faRobot
}

-- Check if a character is an emoji that should be stripped
local function is_emoji_codepoint(cp)
  if not cp then return false end
  if latex_fallback[cp] then return false end  -- preserve chars with LaTeX fallback
  return (cp >= 0x1F300 and cp <= 0x1F9FF)   -- Misc Symbols, Emoticons, etc.
      or (cp >= 0x1F600 and cp <= 0x1F64F)    -- Emoticons
      or (cp >= 0x2600 and cp <= 0x26FF)      -- Misc Symbols
      or (cp >= 0x2700 and cp <= 0x27BF)      -- Dingbats
      or (cp >= 0x2B50 and cp <= 0x2B55)      -- Stars, circles
      or (cp >= 0x1F000 and cp <= 0x1F02F)    -- Mahjong, Dominos
      or (cp >= 0x1FA00 and cp <= 0x1FA6F)    -- Chess Symbols
      or (cp >= 0x1FA70 and cp <= 0x1FAFF)    -- Symbols Extended-A
      or (cp >= 0xFE00 and cp <= 0xFE0F)      -- Variation Selectors
      or (cp >= 0x200D and cp <= 0x200D)       -- ZWJ
      or (cp >= 0x20E3 and cp <= 0x20E3)       -- Combining enclosing keycap
      or (cp >= 0xE0020 and cp <= 0xE007F)     -- Tags
      or (cp >= 0x1F1E0 and cp <= 0x1F1FF)    -- Regional indicators (flags)
end

-- Remove emoji characters from a string
local function strip_emojis(text)
  if not text then return text end

  local result = {}
  for _, cp in utf8.codes(text) do
    if not is_emoji_codepoint(cp) then
      table.insert(result, utf8.char(cp))
    end
  end

  return table.concat(result)
end

function Str(el)
  local cleaned = strip_emojis(el.text)
  if cleaned ~= el.text then
    if cleaned == "" then
      return pandoc.Str("") -- Empty string (emoji was the whole token)
    end
    return pandoc.Str(cleaned)
  end
  return nil
end

return {
  { Str = Str }
}
