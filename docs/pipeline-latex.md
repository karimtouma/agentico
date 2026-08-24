# Pipeline LaTeX - referencia interna

Cómo se convierte el manuscrito en `ingenieria_agentica/` en el PDF de 577 páginas de
`latex-pipeline/output/agentico-por-diseno.pdf`.

Todo lo que sigue está verificado contra el repo. Las cifras corresponden al último build
commiteado (0 errores de TeX, 0 caracteres perdidos, 0 referencias sin resolver, 0 etiquetas
duplicadas, 20 overfull hboxes, 577 páginas, 1,902,965 bytes).

---

## 0. Cadena completa, de un vistazo

```
capitulos/*.md + apendices/*.md
        │
        │  pandoc --from markdown+autolink_bare_uris-tex_math_dollars
        │  --metadata-file=config.yml
        ▼
  12 filtros Lua (orden fijo, ver §1)
        │
        ▼
  templates/book.tex  (plantilla de pandoc)
        │
        ▼
  output/agentico-por-diseno.tex
        │
        │  lualatex --shell-escape (pase 1)
        │  makeindex agentico-por-diseno.idx
        │  lualatex --shell-escape (pases 2 y 3)
        ▼
  output/agentico-por-diseno.pdf   →   make logcheck
```

El build corre dentro de Docker, con el repo montado en `/book`. Siempre desde
`latex-pipeline/`:

```bash
cd latex-pipeline && docker compose run --rm book make pdf
```

`docker-compose.yml` monta `../ingenieria_agentica` en `/book/content` (solo lectura), y
`cls/`, `sty/`, `filters/`, `templates/`, `scripts/`, `fonts/`, `config.yml` en `/book/...`
(también solo lectura). Solo `output/` e `illustrations/` son escribibles. Por eso el Makefile
usa rutas absolutas `/book/...` y no rutas relativas al repo.

Detalle del reader que vale más de lo que parece: `MD_FORMAT` desactiva `tex_math_dollars`.
El libro no tiene matemáticas y sí tiene 991 apariciones de `US$`. Con `tex_math_dollars`
activo, cada `$` abre un span de matemáticas que se traga los separadores de fila de las
tablas siguientes. Si alguien reactiva esa extensión, vuelven los 31 errores.

---

## 1. Los 12 filtros Lua

### 1.1 Orden real vs. orden declarado en los comentarios

El orden real es el de `FILTER_CHAIN` en el `Makefile`. Varias cabeceras `--- Filter order: N`
dentro de los `.lua` quedaron desactualizadas y mienten. **La fuente de verdad es el Makefile.**

| # real | Filtro | Cabecera del `.lua` | ¿Miente? |
|---|---|---|---|
| 1 | `meta-strip.lua` | `Filter order: 1 (runs first)` | No |
| 2 | `figure-transform.lua` | (no declara orden) | - |
| 3 | `code-transform.lua` | `Filter order: 2` | **Sí** |
| 4 | `part-dividers.lua` | "runs BEFORE other filters (prepended to filter chain)" | **Sí** (corre 4.º, hay tres antes) |
| 5 | `emoji-transform.lua` | `Filter order: 5` | No |
| 6 | `checkbox-transform.lua` | `Filter order: 4` | **Sí** |
| 7 | `callout-transform.lua` | `Filter order: 2` | **Sí** |
| 8 | `table-transform.lua` | `Filter order: 7 (runs after callout-transform.lua)` | **Sí** en el número; la frase "después de callout" es correcta |
| 9 | `crossref-transform.lua` | `Filter order: 6` | **Sí** |
| 10 | `index-transform.lua` | (no declara orden) | - |
| 11 | `drop-caps.lua` | "Runs AFTER callout-transform.lua" | No (es correcto, no da número) |
| 12 | `hr-transform.lua` | `Filter order: 7 (runs last)` | **Sí** en el número; "runs last" es correcto |

Comprobar en cualquier momento:

```bash
cd latex-pipeline
grep -n 'lua-filter' Makefile
grep -n 'Filter order' filters/*.lua
```

### 1.2 Por qué el orden importa

Regla mental única: **casi todos estos filtros destruyen el AST**. Convierten bloques de
Pandoc en `RawBlock("latex", ...)`. Un `RawBlock` es una cadena opaca: ningún filtro posterior
puede volver a mirar dentro. Así que el orden determina qué transformaciones alcanzan a qué
contenido.

**Dependencia que funciona a propósito (1 antes de 7).** `meta-strip.lua` tiene un handler
`BlockQuote` que elimina blockquotes de metadatos (`**Extensión objetivo:** ...`).
`callout-transform.lua` convierte *todos* los blockquotes en entornos tcolorbox raw. Si se
invirtieran, esos bloques de metadatos ya serían LaTeX crudo cuando `meta-strip` los buscara,
y aparecerían impresos en el libro como recuadros.

**Dependencia que rompe cosas (8 y 7 antes de 9 y 10).** `table-transform` y `callout-transform`
congelan tablas y callouts en LaTeX antes de que `crossref-transform` e `index-transform`
tengan turno. Consecuencia medible:

- Markdown: 290 spans `[término]{.idx}`. `.tex` generado: 279 `\index{}`. Faltan 11.
  Caso concreto: `09_impacto_negocio.md:88` contiene
  `| [Curva de aprendizaje]{.idx data-sub="costos ocultos"}: 11 semanas ... |`. En el `.tex`
  el texto aparece, pero `\index{costos ocultos!Curva de aprendizaje}` no existe (0 ocurrencias).
- Markdown: 112 menciones `Capítulo N`, 38 menciones `Apéndice X`. `.tex`: 52 `\hyperref[chap:` y
  4 `\hyperref[app:`. En `00a_executive_brief.md:202` la celda `| ... | Capítulo 3 |` sale en el
  `.tex` como texto plano `Entender qué es IA agéntica & Capítulo 3 \\`, sin enlace.

No es un bug que haya que arreglar a la ligera: mover `crossref` e `index` antes de
`callout`/`table` los expone a otros problemas (los `\index{}` dentro de celdas `longtblr` y
dentro de `tcolorbox` tienen su propia casuística). Está documentado aquí para que nadie pierda
una tarde buscando por qué su `{.idx}` en una tabla no sale en el índice analítico. **Si
necesitas que un término entre al índice, ponlo en prosa, no en una celda ni en un callout.**

**Dependencia que borra contenido (5 antes de 6).** `emoji-transform` elimina el rango
`0x2600-0x26FF`, que incluye `☐` (U+2610) y `☑` (U+2611). `checkbox-transform` tiene un handler
`Str` que convierte esos dos caracteres en `\checkbox{}` / `\checkedbox{}`, pero nunca llega a
verlos: el emoji ya fue borrado un filtro antes.

Consecuencia medible, y es una pérdida de contenido, no solo código muerto: los **51 `☐`** del
manuscrito no se convierten en nada, se **borran**. `09_impacto_negocio.md:700` dice
`**Aprobaciones:** ☐ CTO | ☐ VP Engineering | ☐ CFO | ☐ CISO`; en el `.tex` sale
`Aprobaciones:} CTO \textbar{} VP Engineering \textbar{} CFO ...`, sin una sola casilla. Las
tablas de `04_por_que_diseñar.md:453` y siguientes pierden las suyas igual. Arreglo: mover
`checkbox-transform` antes de `emoji-transform`, o sacar `0x2610`-`0x2611` de los rangos de
`emoji-transform`.

Las casillas que sí llegan al PDF vienen del patrón `[ ]` / `[x]` a nivel de `Para`/`Plain`:
el `.tex` tiene **175 `\checkbox{}` y 134 `\checkedbox{}`** (309 en total). El handler `Str`
solo está muerto para `☐` y `☑`; para `✓` (U+2713) y `✅` (U+2705) sí funciona, porque esos dos
codepoints están en `latex_fallback` y `emoji-transform` los deja pasar - de ahí sale buena
parte de los `\checkedbox{}`.

---

### 1.3 Filtro por filtro

#### 1 - `meta-strip.lua`

Entrada: párrafos de navegación del manuscrito. Salida: nada (los borra).

Elimina `Para`/`Plain` que empiecen por `[Continúa`, `[Volver`, `**Fin del`, `**Palabras:`,
`**Páginas estimadas`, `**Extensión:`, `**Siguiente:`, `Navegación:`. Borra H1 que empiecen por
`Navegación` o `Índice`. Borra blockquotes de `Extensión objetivo`.

Devuelve **dos** tablas de filtros, es decir dos pasadas: la segunda (`Pandoc =
remove_empty_referencias`) elimina las secciones `## Referencias` que quedan vacías después de
que pandoc consume las definiciones de notas al pie.

Va primero porque trabaja sobre AST limpio de Pandoc y porque cualquier filtro posterior
convertiría estos bloques en raw.

#### 2 - `figure-transform.lua`

Entrada: `![fig:id]` (un `Para` que contiene una sola `Image` con prefijo `fig:`).
Salida: `\begin{figure}...\end{figure}` o un tcolorbox de placeholder.

Parsea `manifest.yml` con un parser YAML propio (no usa librería). Busca el manifiesto en tres
rutas, en orden: `/book/content/figuras/manifest.yml`, `/book/figuras/manifest.yml`,
`../ingenieria_agentica/figuras/manifest.yml`.

Tres renderizadores según `status`:

| status | salida |
|---|---|
| `final` | `figure` con `\includegraphics{/book/illustrations/fig-<id>.pdf}` |
| `draft` | igual, con `{\color{pa-warning}\textsc{[borrador]}}` en el caption |
| `placeholder` | tcolorbox con título `Figura pendiente` y las 4 primeras líneas del campo `todo` |

Lee `figure-mode` de la metadata (`all` | `final-only` | `no-placeholders`). Esta es la única
clave de `config.yml` fuera del bloque `book:` que sí se consume.

**Estado real: infraestructura lista, funcionalidad inactiva.** `manifest.yml` registra 46
figuras y las 46 están en `placeholder`; `figuras/tikz/` y `figuras/svg/` están vacíos; el
manuscrito tiene 0 referencias `![fig:`. El filtro corre en cada build y no transforma nada.

Los 10 diagramas que sí tiene el libro no pasan por aquí: son bloques ```` ```{=latex} ````
escritos a mano en el markdown (ver `code-transform`, §1.3). Es decir, hay dos caminos para las
ilustraciones y hoy solo se usa el que no está documentado en el manifiesto.

Va en posición 2 porque emite `RawBlock` y necesita ver `Image` intactas.

#### 3 - `code-transform.lua`

Entrada: `CodeBlock`. Salida: uno de cuatro entornos LaTeX.

Clasifica por heurística de puntuación (`code_score`, `template_score`, `dialogue_score`,
`prompt_score`, `is_formula`, conteo de caracteres de dibujo de cajas). Además rastrea los
encabezados de nivel 3 o superior en `last_heading` para detectar "slides".

| categoría | salida |
|---|---|
| `code` | `pa-codeblock` + `VerbatimInput` con números de línea |
| `template` | `pa-template-block` (default si nada matchea) |
| `diagram` | `pa-diagram-block`, `\footnotesize` |
| `formula` | `\paformula{...}` con `% & # _ $` escapados |

Los tres primeros escriben el contenido a un fichero auxiliar `_codeNNN.vrb` vía `VerbatimOut` y
lo releen con `VerbatimInput`. Por eso quedan `_code001.vrb` y `_code002.vrb` en `output/`: son
subproductos normales, y `make clean` sí los borra (`$(OUTPUT)/*.vrb` está en la lista). Que solo
haya dos significa que el manuscrito entero contiene 2 bloques de código.

Nota editorial: el libro prohíbe código, así que en la práctica nada cae en `code`. Los dos
bloques del manuscrito (```` ```markdown ```` en `11` y en `13`) acaban ambos en `template`: el
`.tex` tiene 2 `\begin{pa-template-block}` y 0 `\begin{pa-codeblock}`, 0 `pa-diagram-block` y
0 `\paformula{}`.

**Lo que este filtro NO toca.** El manuscrito contiene 12 vallas de código de nivel superior,
pero 10 de ellas son ```` ```{=latex} ````. Pandoc las parsea como `RawBlock`, no como
`CodeBlock`, así que `code-transform` ni las ve y llegan literales al `.tex`. Son los 10
`\begin{tikzpicture}` del libro: diagramas TikZ escritos a mano dentro del markdown, en
`03`, `08`, `12`, `13`, `B_frameworks_decision` (uno cada uno) y `14_futuro_2030` (cinco). Usan
los estilos de `pa-diagrams.sty`, a veces redefiniendo variantes locales. Es el mecanismo por el
que el libro tiene ilustraciones a pesar de que el sistema de figuras esté inactivo.

#### 4 - `part-dividers.lua`

Entrada: `Header` de nivel 1. Salida: hasta cuatro `RawBlock` alrededor de cada capítulo.

Por cada H1 inserta, en este orden:

1. `\partdivider{N}{Título}` si ese capítulo abre una Parte.
2. `\notespage{Parte N: Título}` inmediatamente después, **salvo en la Parte I** (para ahorrar
   páginas).
3. El propio header.
4. `\label{chap:NN}` o `\label{app:X}`.
5. `\chapterminitoc{...}` si el capítulo tiene 3 o más secciones H2 elegibles.

El mapa de Partes vive en `part_by_chapnum` (por número) con un fallback `part_dividers` (por
patrón en el título):

| Parte | Dispara en | Título |
|---|---|---|
| I | cap 0 | Contexto Estratégico |
| II | cap 5 | Sesgos y Evidencia |
| III | cap 7 | La Tecnología |
| IV | cap 9 | Impacto en el Negocio |
| V | cap 11 | Liderazgo y Estrategia |
| VI | cap 13 | Gobernanza y Futuro |

Detalles que muerden:

- **Centinela `-1`.** `Resumen Ejecutivo` (00a) recibe `chapnum = "-1"`. Eso hace dos cosas:
  no matchea ninguna Parte y no genera `\label`. Sin el centinela, dos capítulos de front matter
  generarían la misma etiqueta y `logcheck` fallaría por "multiply defined".
- **Detección de apéndices.** `in_appendices` se activa con el primer H1 que empiece por
  `Glosario`, `Apéndice`, `Frameworks`, `Checklist` o `Recursos`. A partir de ahí las etiquetas
  son `app:A`..`app:E` por contador secuencial, no por el título.
- **El mini TOC excluye** las secciones `Conclusiones*`, `Preguntas de Reflexión` y `Referencias`,
  y se salta por completo `Prefacio` y `Resumen Ejecutivo`.
- **Escapado del mini TOC.** Los títulos de sección se escapan a mano para `% $ & # _`. Si un
  título futuro trae otro carácter especial de TeX, el build revienta ahí.

Resultado medido en el `.tex`: 6 `\partdivider`, 5 `\notespage`, 15 `\chapterminitoc`,
15 `\label{chap:`, 5 `\label{app:`.

#### 5 - `emoji-transform.lua`

Entrada: `Str`. Salida: `Str` sin emojis.

Recorre codepoints y borra los que caen en los rangos de emoji (`0x1F300-0x1F9FF`,
`0x2600-0x26FF`, `0x2700-0x27BF`, variation selectors, ZWJ, banderas, etc.). **Excepción:** una
tabla `latex_fallback` preserva 9 codepoints que el `.cls` sabe dibujar vía `\newunicodechar`:
`✓ ✗ ✅ ❌ ⚠ ⭐ 📊 🔬 🤖`.

Si añades un `\newunicodechar{X}` al `.cls`, tienes que añadir su codepoint a `latex_fallback`
en este filtro, o nunca llegará a LaTeX.

Va antes de callout/table por la misma razón de siempre: después ya sería raw.

#### 6 - `checkbox-transform.lua`

Entrada: `[ ]`, `[x]`, `[X]` en `Para`/`Plain`. Salida: `\checkbox{}` / `\checkedbox{}`.

Reconoce el patrón partido en tres inlines (`Str "["`, `Space`, `Str "]"`) que produce pandoc, y
el token único `[x]`/`[X]`. El handler `Str` para `☐ ☑ ✓ ✅` es parcialmente código muerto:
ver §1.2.

Tiene que correr antes de `callout-transform` porque muchas checklists viven dentro de
blockquotes, y `callout-transform` usa `has_checkboxes()` sobre el texto plano (`[ ]`, `[x]`)
para clasificar el bloque como `checklist-box`. Ojo con esto: `checkbox-transform` sustituye
esos tokens por `RawInline`, y la función `stringify` de `callout-transform` no extrae texto de
`RawInline`. En un bloque cuyo único indicio de checklist fuesen los `[ ]`, la clasificación
`checklist-box` puede no dispararse.

#### 7 - `callout-transform.lua`

Entrada: `BlockQuote` y `Div` con clase `callout`. Salida: entorno tcolorbox de `pa-callouts.sty`.

Clasifica por el **primer texto en negrita** del primer bloque, con una cascada de patrones donde
gana el primero que matchea. Extracto del orden real:

`Resumen Ejecutivo` → `Para tu pr...` / `próxima reunión` → `Errores comunes` → `Argumento para`
→ `Nota para` / `Nota:` → `Tendencia` → `Punto crítico` / `crítico` → `Ejemplo` / `Ejercicio` →
`Lectura ejecutiva` → `Implicaci...` → `Datos:` / `Métrica` → `Framework` / `Estrategia` →
`Checklist` → `Pregunta` / `Decisi` / `Reflexi` → `Propósito` → `Fuente:` → `^Cómo` / `^Cuándo`
→ detección de checkboxes → `Caso Real` / `Caso Ficticio` → `Extensi` / `Tipo:` / `Empresa:` /
`Período:` → `Antes:` / `Ahora:` → cita entre comillas → `^Usar ` → **fallback
`callout-generico`**.

Consecuencia práctica: si añades un callout nuevo con un título en negrita que contiene, por
ejemplo, la palabra "crítico", caerá en `punto-critico` aunque no sea eso. Antes de añadir una
regla, comprueba que ninguna regla anterior la intercepta.

Para los fenced divs (`::: {.callout .tipo}`) hay un mapa explícito `div_class_map` de 8 clases
hacia 6 entornos distintos: `alerta-critica` es alias de `punto-critico` y `para-reunion` lo es
de `reunion-liderazgo`.

El cuerpo interno se convierte con `pandoc.write(doc, "latex")` y se emite como `RawBlock`. Ese
`pandoc.write` es exactamente lo que aplana los spans `.idx` y las referencias cruzadas
descritas en §1.2.

#### 8 - `table-transform.lua`

Entrada: `Table` de Pandoc. Salida: `longtblr` de tabularray.

- **Siempre** `longtblr` (soporta tema como clave externa y cortes de página).
- **Siempre** columnas `X[1,align]` con `width=\textwidth`: fuerza el ajuste de línea y evita
  desbordes horizontales.
- Tema por número de columnas: `<= 4` → `pa-narrow`, `<= 7` → `pa-wide`, `> 7` → `pa-verywide`.
  Los tres temas están en `pa-tables.sty` y solo cambian el escalado de fuente.
- Zebra: `row{even}={bg=pa-tablealt}`; cabecera `row{1}={bg=pa-tablehead,font=\bfseries}`.
- Reglas: `hline{1,Z}={0.10em}` y, si hay cabecera, `hline{2}={0.04em}`. `rowsep=2pt`.
- `<br>` en HTML crudo dentro de una celda se convierte en `\\` (celdas multilínea).

El `.tex` actual tiene 364 `longtblr`.

#### 9 - `crossref-transform.lua`

Entrada: `Para` y `Plain`. Salida: `\hyperref[...]{...}`.

Dos mecanismos: un handler `Str` con patrones (`Capítulo N`, `Cap. N`, `Apéndice A-D`,
`Parte I-VI`) y un `process_inlines` que reconstruye la secuencia partida `Str("Capítulo") +
Space + Str("7")`.

Limitaciones reales, todas verificadas:

- **No procesa `Header`.** Solo devuelve `{ Para = Para, Plain = Plain }`. Una mención en un
  título nunca se enlaza.
- **`Apéndice E` no se enlaza.** Ambos patrones aceptan `[A-D]`. `part-dividers` sí emite
  `\label{app:E}` (existe 1 en el `.tex`), pero no hay ningún `\hyperref[app:E]`. Hay 1 mención
  de "Apéndice E" en el manuscrito que queda muerta. Arreglo: cambiar `[A-D]` por `[A-E]` en las
  dos ocurrencias del fichero.
- **`Parte I-VI` genera `\hyperref[part:I]` pero nadie define `\label{part:...}`.** En el `.tex`
  actual hay 0 `label{part:` y 0 `hyperref[part:`, así que hoy no explota; en cuanto un texto
  diga "Parte III" en un párrafo, aparecerá una referencia sin resolver y `logcheck` fallará.
- No alcanza tablas ni callouts (§1.2).

#### 10 - `index-transform.lua`

Entrada: `Span` con clase `idx`. Salida: `RawInline("\index{...}")` seguido del contenido visible.

- `[término]{.idx}` → `\index{término}término`
- `[término]{.idx data-sub="padre"}` → `\index{padre!término}término`

Solo escapa `&`. Si un término lleva `%`, `#`, `_` o `!`, hay que escaparlo a mano en el
markdown o ampliar `escape_index`.

El paquete es `imakeidx`, cargado en el `.cls`, y por eso el Makefile pasa
`--pdf-engine-opt=--shell-escape`. El `make pdf` corre `makeindex` explícitamente entre los
pases 1 y 2 de lualatex, así que shell-escape no es estrictamente necesario para el índice, pero
sí lo es si alguien vuelve a activar la generación automática de `imakeidx`.

#### 11 - `drop-caps.lua`

**No hace nada.** El fichero completo es un `function Pandoc(doc) return doc end` con un comentario:
"Drop caps DESACTIVADAS - causaban problemas de layout". El `.cls` sí carga `lettrine` y configura
`\LettrineFontHook`; el `.tex` tiene 0 `\lettrine`. Sigue en la cadena por si se reactiva.

#### 12 - `hr-transform.lua`

Entrada: `HorizontalRule` (los `---` del markdown). Salida: `\separator{}`, una regla centrada al
30% del ancho de texto. 13 líneas de fichero. Va último porque no depende de nada. El `.tex`
tiene 299 `\separator{}`.

---

## 2. La clase y los paquetes

### 2.1 `cls/paradigma-agentico.cls`

Basada en `memoir`, cargada como `\LoadClass[10pt,openright,final]{memoir}`.

**Opciones de clase.** Declara `digital` y `print` (flag interno `\ifpa@digital`), y pasa
cualquier otra opción a memoir. Ver §3.2: hoy nadie pasa `digital`.

**Geometría** (líneas 141-160, valores literales del fichero):

| Parámetro | Valor |
|---|---|
| Stock | `\setstocksize{11in}{8.5in}` (US Letter) |
| Trim | `\settrimmedsize{9.68in}{7.44in}{*}` (Crown Quarto) |
| Centrado en el stock | `\settrims{0.66in}{0.53in}` |
| Caja de texto | `\settypeblocksize{21.0cm}{13.5cm}{*}` |
| Margen interior | `\setlrmargins{2.2cm}{*}{*}` |
| Margen superior | `\setulmargins{1.8cm}{*}{*}` |
| Head/foot | `\setheadfoot{13pt}{24pt}`, `\setheaderspaces{*}{11pt}{*}` |
| Cierre | `\checkandfixthelayout[nearest]` |

El margen exterior no se fija: memoir lo calcula. Trim de 7.44in = 18.90cm, menos 2.2cm de
gutter menos 13.5cm de caja = **3.20cm**. El comentario del `.cls` en la línea 153 dice
"~3.0cm": está mal por 2mm. (La cifra de "5cm" que circuló un tiempo era falsa; el `README.md`
ya está corregido y declara ~3.2cm.)

**Fuentes.** `\setmainfont` Libertinus Serif (con `Numbers = OldStyle`), `\setsansfont`
Libertinus Sans (`Numbers = Lining`), `\setmonofont` Fira Mono (`Scale = 0.88`). Todas por ruta
absoluta `/book/fonts/<Familia>/`, que existe gracias al volumen de docker-compose. Microtype con
`protrusion` y `expansion`, y `tracking = false` (LuaLaTeX no soporta tracking en OpenType).
Interlineado: `\setSingleSpace{1.15}` + `\SingleSpacing`.

**Paquetes que carga** (30 `\RequirePackage`): fontspec, babel(spanish, es-tabla), microtype,
calc, xcolor(table), graphicx, float, wrapfig, booktabs, tabularx, longtable, array, multirow,
colortbl, tabularray, tikz, tcolorbox(most), fontawesome5, enumitem, fancyvrb, truncate,
amssymb, imakeidx, hyperref, bookmark, footmisc, newunicodechar, lettrine, epigraph, marginnote.

**Colores base.** 13 `\definecolor`: los 12 de la paleta en las líneas 166-177 (`pa-primary`
`#1A5276`, `pa-secondary`, `pa-accent`, `pa-light`, `pa-tablehead`, `pa-tablealt`, `pa-darktext`,
`pa-midgray`, `pa-lightgray`, `pa-success`, `pa-warning`, `pa-danger`) más `pa-codebg` en la 540.
El comentario de la línea 164 dice "Overridden by pa-colors.sty if loaded": **no es cierto**, ver
§2.2. Estos 12 valores son la paleta que se imprime.

**Fallbacks unicode.** 17 `\newunicodechar` para `≈ ≠ ≤ ≥ ↔ ↗ ✓ ✗ □ ▼ ✅ ❌ ⚠ ⭐ 📊 🔬 🤖`.
Recordatorio de §1.3: los 9 que son emoji necesitan además estar en `latex_fallback` de
`emoji-transform.lua`.

**Comandos que consumen los filtros Lua** (todo lo que los filtros emiten tiene que existir aquí):

| Comando | Qué hace | Lo emite |
|---|---|---|
| `\checkbox` / `\checkedbox` | `$\square$` gris / `$\boxtimes$` verde | `checkbox-transform` |
| `\separator` | regla centrada 0.3\textwidth | `hr-transform` |
| `\partdivider{N}{Título}` | página completa sin numerar: "PARTE N", regla, título a 24pt | `part-dividers` |
| `\notespage{Título}` | página con 28 líneas rayadas de 0.55cm de paso | `part-dividers` |
| `\chapterminitoc{items}` | bloque "En este capítulo:" con `itemize` compacto y regla inferior | `part-dividers` |
| `\pullquote{...}` | cita destacada con comillas FontAwesome | nadie (disponible, sin uso) |
| `\paformula{...}` | (en `pa-codeblocks.sty`) | `code-transform` |
| `\tightlist` | `\providecommand` para pandoc | pandoc |

También define el chapter style `paradigma`, la maquetación del TOC (`\cft*font`), los estilos de
página, y el entorno `pa-codeblock` (línea 542) con el alias `Shaded` que pandoc espera.

### 2.2 Los 6 `.sty`

Se cargan con `\input` desde `templates/book.tex`, no con `\usepackage`, y se encuentran vía
`TEXINPUTS := $(CLS):$(STY):` exportado en el Makefile.

| Fichero | Qué define |
|---|---|
| `pa-colors.sty` | Solo 6 `\definecolor` activos: `pa-callout-{accent,neutral,alert}-{bg,border}`. Los otros 24 están dentro de dos macros de tema, `\setthemecorporategray` y `\setthemewarmterracotta`, **que nadie invoca en ningún fichero del repo** (`grep -rn 'setthemecorporategray' latex-pipeline/` solo casa con su propia definición). El mecanismo de temas existe y está desconectado: para cambiar la paleta hay que editar los `\definecolor` del `.cls`, o llamar a una de esas macros desde el preámbulo de `templates/book.tex`. |
| `pa-callouts.sty` | **16** entornos `tcolorbox` (la cabecera del fichero dice 14 y 1 especial: está desactualizada). Son los destinos de `callout-transform`: `argumento-board`, `callout-generico`, `caso-ficticio`, `caso-real`, `checklist-box`, `cita-directa`, `dato-clave`, `ejemplo-practico`, `errores-comunes`, `implicacion-talento`, `lectura-ejecutiva`, `nota-lideres`, `punto-critico`, `resumen-ejecutivo`, `reunion-liderazgo`, `tendencia-clave`. Agrupados en 3 familias visuales (accent/neutral/alert) más `cita-directa`. |
| `pa-tables.sty` | 3 temas de tabularray: `NewTblrTheme{pa-narrow}`, `{pa-wide}`, `{pa-verywide}`, más los anchos de regla booktabs (`\heavyrulewidth` 0.08em, `\lightrulewidth` 0.03em, `\cmidrulewidth` 0.025em). |
| `pa-codeblocks.sty` | 2 `tcolorbox` (`pa-template-block`, `pa-diagram-block`) y `\paformula{}`. El tercer entorno, `pa-codeblock`, está en el `.cls`. |
| `pa-diagrams.sty` | 10 `\tikzstyle`: `agentbox`, `orchbox`, `humanbox`, `processbox`, `decisionbox`, `quadaxis`, `quadcell`, `layerbox`, `layertitle`, `diagramarrow`. Los usan los 10 bloques TikZ escritos a mano en el manuscrito. `decisionbox`, `quadcell`, `layerbox` y `layertitle` están definidos pero no se referencian en el contenido (0 apariciones en `capitulos/` y `apendices/`). |
| `pa-typography.sty` | Cabe entera en una pantalla y es donde se toca la calidad de composición: `\parindent 1em`, `\hyphenpenalty=800`, `\tolerance=800`, `\emergencystretch=2em`, `\hfuzz=0.5pt`, `\frenchspacing`, fracciones de flotantes, `xurl` para cortar URLs, estilo de captions, ancho de `epigraph`. La cabecera lo declara "canonical location - overrides .cls values": si peleas contra overfull hboxes, es aquí. |

---

## 3. `config.yml`: la trampa más cara del repo

### 3.1 Solo dos claves están vivas

`config.yml` **parece** el panel de control del libro. No lo es. Se pasa a pandoc con
`--metadata-file=$(CONFIG)`, así que sus claves solo tienen efecto si alguien las lee: o la
plantilla las interpola como variable de pandoc, o un filtro Lua las lee de `meta`.

Lo que realmente se consume:

| Clave | Quién la lee | Efecto |
|---|---|---|
| `book.date` | `templates/book.tex`, 4 veces | Año en portada, portadilla, créditos y "Primera edición" |
| `figure-mode` | `filters/figure-transform.lua`, `function Meta` | `all` / `final-only` / `no-placeholders` |

**Todo lo demás es letra muerta**, incluidas cinco de las seis claves del bloque `book:`
(`title`, `tomo`, `subtitle`, `author` y `lang`; solo `date` sobrevive).

La prueba, desde `latex-pipeline/`:

```bash
# Qué variables de pandoc consume realmente la plantilla:
grep -o '\$[a-zA-Z][a-zA-Z0-9._-]*\$' templates/book.tex | sort -u
#   $body$  $book.date$  $classoption$  $endfor$  $endif$  $sep$

# Las claves "de configuración" no se leen en ninguna parte:
grep -rn '\$theme\$\|\$page_size\$\|\$mode\$\|\$fonts\.\|\$layout\.\|\$features\.' \
     templates/ cls/ sty/ filters/ Makefile
#   (sin salida)

# Ni siquiera título y autor salen del YAML:
grep -c '\$title\$\|\$author\$\|\$lang\$' templates/book.tex
#   0
```

Detalles concretos de lo que **no** pasa si editas `config.yml`:

- `theme: modern_blue` - el valor no se lee. El mecanismo de temas sí existe
  (`\setthemecorporategray` y `\setthemewarmterracotta` en `sty/pa-colors.sty`) pero ninguna de
  las dos macros se invoca en ninguna parte, y `modern_blue` ni siquiera es una de ellas: es la
  paleta base del `.cls`.
- `page_size: letter` - no se lee. El tamaño está hardcodeado en `\setstocksize` /
  `\settrimmedsize`.
- `mode: print` - no se lee. Ver §3.2.
- `fonts.size: 11pt` - **el libro es 10pt**. El tamaño real está en
  `\LoadClass[10pt,...]{memoir}`.
- `layout.margin_inner: 3cm` - **el gutter real es 2.2cm**, en `\setlrmargins{2.2cm}`.
  Los otros tres márgenes del bloque tampoco corresponden a nada.
- `features.drop_caps: true` - `drop-caps.lua` es un no-op y el `.tex` tiene 0 `\lettrine`.
- `features.illustrations: true` - las figuras se controlan con `figure-mode` y con `manifest.yml`.
- `book.title`, `book.tomo`, `book.subtitle`, `book.author` - la plantilla los escribe a mano
  en `\title{}`, en la portada y en los créditos. Cambiarlos en el YAML no cambia el PDF.
- `book.lang: es` - está anidado bajo `book:`, así que pandoc **no** ve una variable `lang` de
  nivel superior. La localización del español la da `babel` en el `.cls`, no el YAML.

### 3.2 Dónde se cambia cada cosa de verdad

| Quieres cambiar | Toca |
|---|---|
| Año de portada y créditos | `config.yml` → `book.date` |
| Título, subtítulo, autor, correo, URL | `templates/book.tex` (portadilla, portada, créditos) |
| Paleta de color | `cls/paradigma-agentico.cls` líneas 166-177 (paleta viva); `sty/pa-colors.sty` para los 6 colores de callout |
| Tamaño de página, trim, márgenes | `cls/paradigma-agentico.cls`, líneas 141-160 |
| Tamaño de cuerpo | `\LoadClass[10pt,...]` en el `.cls`, línea 22 |
| Interlineado | `\setSingleSpace{1.15}` en el `.cls`, línea 222 |
| Fuentes | `\setmainfont` / `\setsansfont` / `\setmonofont` en el `.cls`, líneas 184-207 |
| Ajuste de línea, guionado, overfull | `sty/pa-typography.sty` |
| Estilo de tablas | `sty/pa-tables.sty` + umbrales `NARROW_THRESHOLD` / `WIDE_THRESHOLD` en `filters/table-transform.lua` |
| Estilo de callouts | `sty/pa-callouts.sty` + la cascada de `filters/callout-transform.lua` |
| Modo de figuras | `config.yml` → `figure-mode` |
| Mapa de Partes | `filters/part-dividers.lua`, tabla `part_by_chapnum` |

### 3.3 `make digital` no produce un PDF digital

La clase tiene la lógica: `\ifpa@digital` (línea 400) elige entre `colorlinks=true` con enlaces
de color y la variante de imprenta. Pero se activa con la **opción de clase** `digital`, y el
target `digital` del Makefile pasa `-V mode=digital`, que es una **variable de pandoc** que la
plantilla nunca usa (`grep '\$mode\$' templates/book.tex` no devuelve nada).

Resultado: `make digital` genera `agentico-por-diseno-digital.pdf` con exactamente los mismos
ajustes de hyperref que el de imprenta. Para arreglarlo habría que pasar
`-V classoption=digital` junto a `twoside`.

Lo mismo aplica al comando `/theme` de la skill `book-build`: promete cambiar el tema editando
`config.yml`, y `config.yml` no controla ningún tema.

---

## 4. `templates/book.tex`

Es la plantilla de pandoc y es **autocontenida**: genera todo el libro salvo el cuerpo. Hubo tres
ficheros más en `templates/` (`frontmatter.tex`, `backmatter.tex`, `partpage.tex`) que ningún
`\input` incluía; fueron eliminados. Hoy quedan dos: `book.tex` y `figure-wrapper.tex` (este
último lo usa `build-figures.sh`, no pandoc).

**Variables de pandoc que consume: tres.**

| Variable | Uso |
|---|---|
| `$classoption$` | `\documentclass[...]{paradigma-agentico}` con `$for(classoption)$...$sep$,$endfor$` |
| `$book.date$` | 4 veces: portada, portadilla, créditos, "Primera edición" |
| `$body$` | El manuscrito entero, entre `\mainmatter` y `\backmatter` |

`$toc$` **no aparece en la plantilla**: el TOC se emite a mano con `\tableofcontents*`. Por eso
`grep -o '\$[a-zA-Z][a-zA-Z0-9._-]*\$' templates/book.tex` solo devuelve estas tres más los
`$for$`/`$if$`/`$sep$` de control.

**Estructura que genera:**

```
\input{pa-colors|pa-callouts|pa-tables|pa-codeblocks|pa-diagrams|pa-typography}
\begin{document}
\frontmatter  \pagestyle{empty}
  ├─ Portadilla ("Agéntico por Diseño" / "Tomo I")
  ├─ Portada (título, TOMO I, subtítulo, autor, correo, URL, año)
  ├─ Página de créditos  →  declara explícitamente Unlicense / dominio público,
  │                          y enlaza github.com/karimtouma/agentico
  ├─ "Cómo Usar Este Libro" (leyenda de iconos, tabla de situaciones, rutas por rol,
  │                          nota sobre los márgenes para anotar)
  └─ TOC: { \hypersetup{linkcolor=pa-darktext} \setcounter{tocdepth}{1} \tableofcontents* }
\mainmatter  \pagestyle{paradigma-page}  \markboth{}{}
  └─ $body$        (los \partdivider los inyecta part-dividers.lua, no la plantilla)
\backmatter
  ├─ \printindex   (índice analítico, pagestyle paradigma-plain)
  └─ "Sobre el Autor"
```

Nota sobre el TOC: la plantilla fija `tocdepth=1` (solo capítulos y partes) aunque el Makefile
pasa `--toc --toc-depth=3`. Gana la plantilla. La profundidad 3 sí alimenta el `.toc` y los
bookmarks del PDF.

---

## 5. `scripts/`

### 5.1 `build-figures.sh` - útil, hoy sin trabajo que hacer

Corre **dentro** del contenedor (rutas `/book/...` hardcodeadas). Compila
`figuras/tikz/*.tex` con `lualatex --shell-escape` usando `templates/figure-wrapper.tex`, y
convierte `figuras/svg/*.svg` con `rsvg-convert` (viene de `librsvg`, instalado en el
Dockerfile). Cachea por MD5 en `illustrations/.cache/<basename>.md5`.

**Contrato de nombres, no documentado en el manifiesto y hoy sin probar.** El script escribe
`/book/illustrations/<basename>.pdf`, donde `<basename>` es el nombre del fichero fuente sin
extensión. `figure-transform.lua` (`render_final`/`render_draft`) busca
`/book/illustrations/fig-<id>.pdf`. Es decir: los fuentes **tienen** que llamarse
`fig-<id>.tex` / `fig-<id>.svg`, con el mismo `<id>` que la clave en `manifest.yml`. Como los 46
`source:` del manifiesto son `null`, ese acoplamiento nunca se ha ejercitado.

El target `figures` del Makefile solo lo invoca si existe al menos un `.tex` en `tikz/` o un
`.svg` en `svg/`. Como ambos directorios están vacíos, en cada build imprime un aviso
`[figures] No figure sources found` y no hace nada.

### 5.2 `build.sh` - sí sigue teniendo sentido

Es el envoltorio de Docker que el Makefile no puede ser: el Makefile corre *dentro* del
contenedor, `build.sh` corre en el host. Verifica que Docker esté arriba, construye la imagen si
falta, y traduce subcomandos a `docker compose run --rm book make <target>`. Usa rutas absolutas
derivadas de `BASH_SOURCE`, así que funciona desde cualquier directorio:

```bash
/Users/karim/Desktop/book/latex-pipeline/scripts/build.sh status
/Users/karim/Desktop/book/latex-pipeline/scripts/build.sh chapter 07
```

Subcomandos: `pdf` (default), `digital`, `epub`, `latex`, `chapter N`, `validate`, `optimize`,
`clean`, `rebuild`, `status`, `help`.

Aporta dos cosas sobre el Makefile: `status` (estado de Docker, PDFs con tamaño y fecha) y
`analyze_log` después de `pdf` (páginas, overfull, underfull, warnings).

Único defecto: `show_status` imprime `theme:`, `page_size:` y `mode:` de `config.yml` como si
fueran configuración efectiva. No lo son (§3). Es la fuente más probable de que alguien crea que
esas claves hacen algo.

### 5.3 `validate.sh` - roto, no lo uses

**Aborta en la primera comprobación: muere en la línea 39 de sus 208 líneas.** Verificado
ejecutándolo:

```bash
$ bash /Users/karim/Desktop/book/latex-pipeline/scripts/validate.sh
  ✓ Chapter 00: 00_prefacio.md
  ... (hasta Chapter 14)
$ echo $?
1
```

Se detiene después del capítulo 14, sin imprimir error, sin estadísticas, sin validar el build y
sin validar la efectividad de los filtros.

Causas, en orden de gravedad:

1. **`set -euo pipefail` + `ls` que falla.** El bucle hace
   `file=$(ls "$CONTENT_DIR/capitulos/${i}_"*.md 2>/dev/null | head -1)`. Cuando no hay match,
   `ls` sale con 1; con `pipefail`, la tubería devuelve 1; la sustitución de comandos propaga ese
   estado; `set -e` mata el script. La rama `else` con `log_error` es inalcanzable.
2. **`for i in $(seq -w 0 15)`.** Itera hasta el capítulo `15`, que no existe. Ese es el
   iterador que dispara el fallo del punto 1. El último capítulo es el 14.
3. **Omite `00a_executive_brief.md`.** El glob es `${i}_*.md`, y `00_` solo casa con
   `00_prefacio.md`. El resumen ejecutivo nunca se valida.
4. **`for letter in A B C D`.** Falta el apéndice `E_modelos_mentales.md`. Aunque el script
   llegara hasta ahí, reportaría 4 de 5 apéndices.
5. **`((WARNINGS++))` / `((ERRORS++))` bajo `set -e`.** Con el contador en 0, el post-incremento
   devuelve 0, la expresión aritmética se evalúa como falsa y el estado de salida es 1: otro
   punto de muerte súbita en cuanto se registre el primer warning.

Nadie lo llama: el target `validate` del Makefile hace sus propios `grep` y no ejecuta este
script. Lo que sí funciona hoy para verificar la salud del build es `make logcheck` (encadenado
automáticamente a `make pdf`).

Arreglo mínimo si alguien lo retoma: cambiar el rango a `00 00a 01..14` explícito, añadir `E` al
bucle de apéndices, sustituir `((X++))` por `X=$((X+1))`, y envolver el `ls` en
`|| true`.

---

## 6. Añadir un capítulo nuevo

Orden importa: los tres primeros pasos hacen que compile; el resto evita incoherencias.

1. **Crear el fichero** `ingenieria_agentica/capitulos/NN_slug.md`. El H1 debe empezar por
   `Capítulo NN:` para que `part-dividers.lua` extraiga el número con
   `text:match("^Capítulo%s+(%d+)")` y genere `\label{chap:NN}`. Si el H1 no matchea, el filtro
   cae al contador secuencial y la etiqueta puede salir con el número equivocado.
2. **`latex-pipeline/Makefile`** → añadir la línea a `CHAPTER_FILES`, en la posición correcta.
   El orden de esa lista **es** el orden del libro; pandoc concatena en ese orden.
3. **`latex-pipeline/filters/part-dividers.lua`** → solo si el capítulo abre una Parte nueva o
   si desplaza el capítulo que la abría: actualizar `part_by_chapnum` (y, si aplica,
   `part_dividers`). Un desajuste aquí se detecta rápido:
   `grep -c 'partdivider' output/agentico-por-diseno.tex` debe dar 6.
4. **Los 8 bloques editoriales obligatorios** dentro del `.md`: `> **Resumen Ejecutivo**`,
   `> **Dato verificado:**`, `## Conclusiones y Takeaways`, `## Preguntas de Reflexión`,
   `> **Para Tu Próxima Reunión de Liderazgo**`, `> **Tarjeta de Referencia Rápida**`,
   `**Referencias:**`, `*Fin del Capítulo N*`. Los blockquotes tienen que clasificar bien en
   `callout-transform.lua`: revisa la cascada de §1.3 antes de inventar un título en negrita.
5. **`ingenieria_agentica/BOOK_MASTER.md`** → fila en la tabla y recuento de palabras.
6. **`CLAUDE.md`** → árbol de ficheros.
7. **`capitulos/00_prefacio.md`** → rutas de lectura.
8. **`capitulos/00a_executive_brief.md`** → tabla de navegación.
9. **Pie del capítulo anterior** → "Continúa en...". (Lo borra `meta-strip.lua` en el PDF, pero
   sirve para leer el manuscrito en markdown y en el MCP server.)
10. **Renumerar, si hace falta**: siempre de mayor a menor, para no reemplazar dos veces.
11. **Compilar y comprobar**:

```bash
cd latex-pipeline && docker compose run --rm book make pdf
```

`make pdf` encadena `logcheck`, que falla si aparecen errores de TeX, caracteres perdidos,
referencias sin resolver o etiquetas duplicadas. Escape: `make pdf STRICT=0`. No lo uses para
"pasar": los tres pases de lualatex corren con `> /dev/null 2>&1 || true`, así que sin
`logcheck` un documento roto produce PDF y salida cero.

Comprobaciones rápidas después del build, desde `latex-pipeline/`:

```bash
grep -c 'partdivider'   output/agentico-por-diseno.tex   # 6
grep -c 'label{chap:'   output/agentico-por-diseno.tex   # nº de capítulos numerados + prefacio
grep -c 'label{app:'    output/agentico-por-diseno.tex   # 5
grep -c 'multiply defined' output/agentico-por-diseno.log # 0
```

---

## 7. Referencia rápida de targets

Todos desde `latex-pipeline/`, prefijados con `docker compose run --rm book`.

| Target | Qué hace | Nota |
|---|---|---|
| `make figures` | TikZ/SVG → PDF vía `build-figures.sh` | No-op hoy: `tikz/` y `svg/` vacíos |
| `make pdf` | Build completo + `logcheck` | Depende de `figures`. Default |
| `make latex` | Solo el `.tex`, para inspeccionar | Rápido; la mejor herramienta para depurar filtros |
| `make chapter CHAP=07` | PDF de un solo capítulo | Sin part dividers coherentes |
| `make digital` | PDF "digital" | **No difiere del de imprenta**, ver §3.3 |
| `make epub` | EPUB | Aplica los mismos filtros, que emiten LaTeX crudo: la salida está degradada |
| `make validate` | greps sobre `.tex` y `.log` | No ejecuta `scripts/validate.sh` |
| `make logcheck` | Falla si el último build tuvo errores | `STRICT=0` lo degrada a warning |
| `make optimize` | Overfull/underfull + páginas | Depende de `pdf` |
| `make preview` | `pdf` + `open` | Solo macOS, y desde el host, no desde Docker |
| `make clean` | Borra artefactos de `output/` | Incluye `.vrb`, `.idx`, `.ind`, `.ilg` |
| `make docker-build` | `docker compose build --no-cache` | Obligatorio tras tocar el `Dockerfile` |
| `make help` | Lista de targets | |

---

## 8. Trampas, resumidas

1. `config.yml` es decorativo salvo `book.date` y `figure-mode` (§3).
2. `make digital` == `make pdf` en resultado; falta pasar `classoption=digital` (§3.3).
3. Las cabeceras `Filter order: N` de 6 de los 12 filtros mienten (§1.1).
4. Los `{.idx}` y las referencias `Capítulo N` dentro de tablas y callouts se pierden (§1.2).
5. `emoji-transform` corre antes que `checkbox-transform` y **borra los 51 `☐` del manuscrito**
   sin sustituirlos: las casillas escritas con el carácter unicode no llegan al PDF (§1.2).
6. `crossref-transform` no cubre `Apéndice E`, ni encabezados, y emite `\hyperref[part:...]`
   contra etiquetas que nadie define (§1.3).
7. `drop-caps.lua` es un no-op declarado (§1.3).
8. El sistema de figuras (`manifest.yml` + `figure-transform`) está inactivo: los 10 diagramas
   reales del libro son bloques ```` ```{=latex} ```` con TikZ escrito a mano dentro del
   markdown (§1.3). Además, el nombre de fichero que produce `build-figures.sh` y el que espera
   `figure-transform.lua` solo coinciden si los fuentes se llaman `fig-<id>.tex` / `fig-<id>.svg`
   (§5.1).
9. Las macros de tema de `pa-colors.sty` no las invoca nadie; la paleta viva está en el `.cls`
   (§2.2).
10. `scripts/validate.sh` muere en la primera iteración fallida; no lo uses (§5.3).
11. Reactivar `tex_math_dollars` rompe las tablas por culpa de los 991 `US$` (§0).
12. Tocar el `Dockerfile` obliga a `make docker-build`: `--rm` significa contenedor nuevo cada
    vez, no imagen nueva.
13. Un `\newunicodechar` nuevo en el `.cls` no sirve de nada si su codepoint no está también en
    `latex_fallback` de `emoji-transform.lua` (§1.3).
