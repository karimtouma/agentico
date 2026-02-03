--- code-transform.lua — Classify and render code blocks by content type
--- Filter order: 2 (runs after meta-strip.lua)
---
--- Categories:
---   code     — actual pseudo-code (FORTRAN, OOP, etc.) → pa-codeblock + line numbers
---   template — business templates, prompts, policies, slides, dialogues → pa-template-block
---   diagram  — ASCII art with box-drawing characters → pa-diagram-block
---   formula  — 1-3 line equations/slogans → \paformula{}

local code_counter = 0
local last_heading = ""  -- Track headings for slide detection

-- ============================================================================
-- Helpers
-- ============================================================================

local function count_pattern(text, pattern)
  local count = 0
  for _ in text:gmatch(pattern) do count = count + 1 end
  return count
end

local function count_lines(text)
  local n = 1
  for _ in text:gmatch("\n") do n = n + 1 end
  return n
end

-- Count box-drawing characters
local function count_box_drawing(text)
  local chars = {"┌","┐","└","┘","├","─","│","┼","┤","┬","┴","╔","╗","╚","╝","║","═","━"}
  local total = 0
  for _, ch in ipairs(chars) do
    total = total + count_pattern(text, ch)
  end
  return total
end

-- Score programming constructs
local function code_score(text)
  local patterns = {
    "function%s", "class%s", "struct%s", "void%s",
    "return%s", "import%s", "const%s", "var%s", "let%s",
    "public%s", "private%s", "throw%s", "new%s",
    "if%s*%(", "else%s*{", "for%s*%(", "while%s*%(",
    "^%s*//",       -- C-style comments
    "%{%s*$",       -- opening brace at end of line
    "^%s*%}",       -- closing brace at start of line
    "%;%s*$",       -- semicolons at end of line
    "=>",           -- arrow functions
    "DO%s+%d+",     -- FORTRAN DO loops
    "CONTINUE",     -- FORTRAN
  }
  local score = 0
  for _, p in ipairs(patterns) do
    if text:match(p) then score = score + 1 end
  end
  return score
end

-- Score template/form patterns
local function template_score(text)
  local score = 0
  if text:match("%[%.%.%.%]") then score = score + 1 end       -- [...]
  if text:match("____") then score = score + 2 end             -- ____
  if text:match("%[Nombre%]") or text:match("%[Fecha%]") then score = score + 1 end
  if text:match("%[SÍ/NO%]") then score = score + 1 end
  -- ALL-CAPS section headers with colons
  score = score + count_pattern(text, "\n[A-ZÁÉÍÓÚÑ][A-ZÁÉÍÓÚÑ ]+:")
  -- Unicode rulers
  if text:match("━━") then score = score + 2 end
  -- Score/rating patterns
  if text:match("Score") or text:match("Rating:") then score = score + 1 end
  return score
end

-- Score dialogue patterns
local function dialogue_score(text)
  local score = 0
  if text:match("Tú:") or text:match("Tu:") then score = score + 2 end
  if text:match("Copilot:") then score = score + 2 end
  if text:match("Agente:") then score = score + 2 end
  if text:match("Workspace responde:") then score = score + 2 end
  if text:match("%[Sugiere") or text:match("%[Presionas") then score = score + 2 end
  if text:match("%[Responde") or text:match("%[minutos") then score = score + 1 end
  return score
end

-- Score prompt patterns
local function prompt_score(text)
  local score = 0
  if text:match("^Genera ") or text:match("^Requerimientos") then score = score + 2 end
  if text:match("Requisitos:") then score = score + 1 end
  if text:match("Requerimientos") then score = score + 1 end
  return score
end

-- Check if text is a short formula/slogan (1-3 lines)
local function is_formula(text)
  local lines = count_lines(text)
  if lines > 3 then return false end
  local trimmed = text:match("^%s*(.-)%s*$")
  if not trimmed or #trimmed < 5 then return false end
  -- Pattern: Word = Word x Word
  if trimmed:match("^%u%l+%w*%s*=") then return true end
  -- Pattern with arrows spanning the whole line
  if trimmed:match("→") and lines <= 2 and not trimmed:match("\n.*\n.*\n") then return true end
  return false
end

-- ============================================================================
-- Classifier: returns "code", "template", "diagram", or "formula"
-- ============================================================================

local function classify(el)
  local text = el.text
  local classes = el.classes or {}
  local lang = classes[1] or ""

  -- 1. Explicit "markdown" language tag → template
  if lang == "markdown" then return "template" end

  -- 2. Known programming languages → code
  local prog_langs = {
    "python","javascript","js","typescript","ts","lua","java","c","cpp",
    "go","rust","ruby","php","swift","kotlin","scala","perl","bash","sh",
    "sql","html","css","json","yaml","xml","fortran","cobol","pascal"
  }
  for _, pl in ipairs(prog_langs) do
    if lang == pl then return "code" end
  end

  -- 3. Formula (very short, equation-like)
  if is_formula(text) then return "formula" end

  -- 4. ASCII diagram (high density of box-drawing chars)
  local box_count = count_box_drawing(text)
  if box_count >= 10 or (box_count >= 4 and text:match("─") and text:match("│")) then
    return "diagram"
  end

  -- 5. Slide context (heading tracker)
  if last_heading:match("[Ss]lide%s+%d+") then return "template" end

  -- 6. Dialogue
  if dialogue_score(text) >= 2 then return "template" end

  -- 7. Prompt template
  if prompt_score(text) >= 2 then return "template" end

  -- 8. Business template (strong signal)
  if template_score(text) >= 3 then return "template" end

  -- 9. Pseudo-code (programming constructs)
  if code_score(text) >= 2 then return "code" end

  -- 10. Weaker template signal
  if template_score(text) >= 2 then return "template" end

  -- 11. Default: template (safer than showing line numbers for non-code)
  return "template"
end

-- ============================================================================
-- Renderers
-- ============================================================================

local function render_code(text)
  code_counter = code_counter + 1
  local f = string.format("_code%03d.vrb", code_counter)
  return "\\begin{VerbatimOut}{" .. f .. "}\n" ..
    text ..
    "\n\\end{VerbatimOut}\n" ..
    "\\begin{pa-codeblock}\n" ..
    "\\VerbatimInput[fontsize=\\small,numbers=left,numbersep=5pt,numberblanklines=false]{" .. f .. "}\n" ..
    "\\end{pa-codeblock}"
end

local function render_template(text)
  code_counter = code_counter + 1
  local f = string.format("_code%03d.vrb", code_counter)
  return "\\begin{VerbatimOut}{" .. f .. "}\n" ..
    text ..
    "\n\\end{VerbatimOut}\n" ..
    "\\begin{pa-template-block}\n" ..
    "\\VerbatimInput[fontsize=\\small]{" .. f .. "}\n" ..
    "\\end{pa-template-block}"
end

local function render_diagram(text)
  code_counter = code_counter + 1
  local f = string.format("_code%03d.vrb", code_counter)
  return "\\begin{VerbatimOut}{" .. f .. "}\n" ..
    text ..
    "\n\\end{VerbatimOut}\n" ..
    "\\begin{pa-diagram-block}\n" ..
    "\\VerbatimInput[fontsize=\\footnotesize]{" .. f .. "}\n" ..
    "\\end{pa-diagram-block}"
end

local function render_formula(text)
  -- Escape LaTeX specials for use in \paformula{}
  local escaped = text:gsub("%%", "\\%%")
  escaped = escaped:gsub("&", "\\&")
  escaped = escaped:gsub("#", "\\#")
  escaped = escaped:gsub("_", "\\_")
  escaped = escaped:gsub("%$", "\\$")
  -- Trim whitespace
  escaped = escaped:match("^%s*(.-)%s*$")
  return "\\paformula{" .. escaped .. "}"
end

local renderers = {
  code     = render_code,
  template = render_template,
  diagram  = render_diagram,
  formula  = render_formula,
}

-- ============================================================================
-- Filter functions
-- ============================================================================

local function track_heading(el)
  if el.level >= 3 then
    last_heading = pandoc.utils.stringify(el)
  end
  return nil
end

local function process_codeblock(el)
  local category = classify(el)
  local renderer = renderers[category] or render_template
  local latex = renderer(el.text)
  last_heading = ""
  return pandoc.RawBlock("latex", latex)
end

return {
  {
    Header = track_heading,
    CodeBlock = process_codeblock,
  }
}
