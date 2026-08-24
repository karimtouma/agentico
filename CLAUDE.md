# Proyecto: Libro "Agéntico por Diseño, Tomo I: Tecnologías de la Información"

## Contexto
Libro sobre ingeniería de software para la era de los agentes.
El libro es fundacional: cómo diseñar organizaciones y equipos de desarrollo que operan con agentes autónomos.
Este es el **Tomo I** de la serie, enfocado en **Tecnologías de la Información**.
- **Autor**: Karim Touma
- **Audiencia**: Gerentes y líderes técnicos (VP Eng, CTO, Tech Leads)
- **Tono**: Profesional, accesible, sin código, enfocado en estrategia y ROI
- **Estructura**: 14 capítulos numerados + front matter (prefacio, resumen ejecutivo) + 5 apéndices
- **Idioma**: Español neutro latinoamericano
- **Licencia**: Unlicense (dominio público). Aplica al código **y** al contenido del libro.
  Es una decisión deliberada del autor y ya está declarada en la página de créditos del PDF.
  No propongas dual-licensing ni Creative Commons.

### Extensión real (medida, no estimada)

| Métrica | Valor | Cómo se mide |
|---------|-------|--------------|
| Palabras | **142,097** | `cat ingenieria_agentica/capitulos/*.md ingenieria_agentica/apendices/*.md \| wc -w` |
| Páginas del PDF | **577** | `latex-pipeline/output/agentico-por-diseno.pdf` |
| Tamaño del PDF | ~1.9 MB (1,902,906 bytes) | commiteado a propósito, para descargar sin compilar |
| Ficheros de capítulo | 16 | `00_prefacio`, `00a_executive_brief`, `01`..`14` |
| Apéndices | 5 | `A_glosario` .. `E_modelos_mentales` |

> **La cifra "134,000 palabras" es obsoleta y ya fue purgada del repo.** `README.md`,
> `ingenieria_agentica/BOOK_MASTER.md` y `mcp-server/README.md` dicen hoy **142,097**; no queda
> ninguna ocurrencia de "134,000". Al citar la extensión usa **142,097** o "~142K", y re-mídela
> con el comando de la tabla antes de escribirla en cualquier sitio nuevo. Si vuelve a aparecer
> otra cifra, es una regresión.

> **Los "Objetivos de Extensión por Sección" son historia, no plan vigente.** La tabla de
> objetivos que vivía en este archivo sumaba ~325 páginas y quedó superada por el manuscrito real
> (577). `BOOK_MASTER.md` ya no conserva ese plan: hoy documenta rangos de páginas **medidos**
> sobre el PDF compilado. No reintroduzcas objetivos de páginas ni recortes contenido para
> acercarte a ellos.

## Reglas de Escritura

### Lo que SÍ incluir:
1. Resumen ejecutivo al inicio de cada capítulo (3-5 bullets)
2. Recuadros "Para tu próxima reunión de liderazgo"
3. Métricas y datos citados con fuente (Gartner, McKinsey, etc.)
4. Frameworks de decisión y matrices
5. Takeaways al final de cada capítulo
6. Preguntas de reflexión para el lector

### Lo que NO incluir:
1. Código de programación (ni siquiera snippets)
2. Jerga técnica sin explicar el "so what" para el negocio
3. Tutoriales paso a paso de herramientas
4. Detalles de implementación técnica
5. **Em dashes** (el carácter U+2014, "raya"). Usar siempre guion con espacios ( - ) en su lugar: `palabra - otra palabra`. Detéctalos con `grep -n "$(printf '\u2014')" fichero.md`; el conteo debe ser 0.
6. Contenido ficticio: empresas, sitios web, casos de estudio, cifras o citas inventadas. El proyecto eliminó deliberadamente todo caso ficticio. Todo dato lleva fuente.

### Moneda
Siempre **`US$`**, nunca `$` pelado: para un lector latinoamericano `$` es su moneda local.
Hay 991 ocurrencias de `US$` en el manuscrito. La única excepción viva es un `R$` (real brasileño).

### Los 8 bloques obligatorios por capítulo numerado
Los 14 capítulos `01`..`14` los cumplen todos. `00_prefacio` y `00a_executive_brief` **no**, y eso
es correcto: son front matter, no capítulos.

1. `> **Resumen Ejecutivo**`
2. `> **Dato verificado:**` (con fuente, metodología y limitaciones)
3. `## Conclusiones y Takeaways`
4. `## Preguntas de Reflexión`
5. `> **Para Tu Próxima Reunión de Liderazgo**`
6. `> **Tarjeta de Referencia Rápida**`
7. `**Referencias:**`
8. `*Fin del Capítulo X*`

### Sintaxis que el pipeline sí procesa

| Sintaxis en markdown | Resultado en LaTeX | Filtro |
|----------------------|--------------------|--------|
| `[término]{.idx}` | `\index{término}` + el texto visible | `index-transform.lua` |
| `[término]{.idx data-sub="padre"}` | `\index{padre!término}` + el texto visible | `index-transform.lua` |
| `![](fig:id)` | figura del manifiesto | `figure-transform.lua` |

El marcador de índice **no borra la palabra**: emite el `\index{}` y a continuación reinserta el
contenido del span, así que el texto sigue leyéndose igual en la página.

- **Índice analítico**: hay 290 spans `.idx` en el contenido. El paquete es `imakeidx` y requiere
  `--shell-escape`, que ya está en el Makefile.
- **Figuras**: `ingenieria_agentica/figuras/manifest.yml` registra **46 figuras, las 46 en status
  `placeholder`**. Los directorios `figuras/tikz/`, `figuras/svg/` y `figuras/pdf/` están vacíos, y
  el texto del libro tiene **cero** referencias `![](fig:id)`. Es infraestructura lista, no una
  funcionalidad activa. Ciclo de vida: `placeholder -> draft -> final`.
  La sintaxis correcta y **única** es `![](fig:id)`: el destino tiene que ir entre paréntesis
  porque pandoc solo construye un `Image` en ese caso. `![fig:id]` no funciona - se queda como
  texto literal y el filtro nunca lo ve. La cabecera de `filters/figure-transform.lua` ya lo
  advierte de forma explícita.

## Estructura de Archivos
```
book/
├── CLAUDE.md                    # este contrato
├── README.md  CONTRIBUTING.md  LICENSE  .gitignore  .gitattributes
├── .claude/
│   ├── settings.json
│   └── skills/<nombre>/SKILL.md  # 5 skills, formato directorio (invocables)
├── .github/workflows/deploy-mcp.yml
├── docs/                         # arquitectura, build, pipeline-latex, figuras-e-indice
├── ingenieria_agentica/          # el manuscrito
│   ├── BOOK_MASTER.md
│   ├── capitulos/                # 00_prefacio, 00a_executive_brief, 01..14
│   ├── apendices/                # A_glosario .. E_modelos_mentales
│   ├── figuras/
│   │   ├── manifest.yml          # 46 figuras, todas placeholder
│   │   ├── tikz/  svg/  pdf/     # vacíos
│   └── templates/capitulo_template.md
├── latex-pipeline/               # el build
│   ├── Makefile  Dockerfile  docker-compose.yml  config.yml
│   ├── cls/paradigma-agentico.cls
│   ├── sty/                      # 6 paquetes: pa-callouts, pa-codeblocks, pa-colors,
│   │                             #   pa-diagrams, pa-tables, pa-typography
│   ├── filters/                  # 12 filtros Lua
│   ├── templates/                # book.tex, figure-wrapper.tex
│   ├── scripts/                  # build-figures.sh, validate.sh
│   ├── fonts/                    # LibertinusSerif, LibertinusSans, FiraMono
│   ├── illustrations/            # chapter-headers/, icons/, part-dividers/ (vacíos)
│   └── output/agentico-por-diseno.pdf
└── mcp-server/                   # Cloudflare Worker "agentico-mcp"
    ├── README.md
    ├── src/index.ts  scripts/prepare-content.ts
    ├── wrangler.jsonc  package.json  tsconfig.json  tsconfig.scripts.json
    └── kv-data.json              # generado por prepare-content, gitignoreado
```

## Formato de Casos de Estudio

Cada caso debe incluir:
1. **El Contexto** - Industria, tamaño, desafío
2. **La Decisión** - Por qué IA agéntica, proceso de evaluación
3. **La Implementación** - Fases, obstáculos, cambio cultural
4. **Los Resultados** - Métricas antes/después, ROI
5. **Lecciones para Líderes** - Qué harían diferente

Todo caso debe ser real y citable. Ver la regla de contenido ficticio arriba.

## Comandos Útiles (Skills)

Los skills viven en `.claude/skills/<nombre>/SKILL.md`. Son 5 skills que definen **27 comandos**
en total. `book-audit-fixes` no define comandos: es una skill de referencia con reglas
anti-regresión que se consultan antes de escribir o editar contenido.

### book-writer (4)
- `/expand [capitulo]` - Expandir un capítulo existente (acepta `--costs` y `--depth concepto`)
- `/case-study [tema]` - Redactar un caso de estudio con el formato de 5 bloques
- `/research [tema]` - Investigar datos actualizados
- `/chapter-outline [numero]` - Generar outline expandido

### book-quality (8)
- `/audit [capitulo|all]` - Auditoría completa (estructura, xrefs, code, badges, footnotes, tono)
- `/xref` - Validación exhaustiva de referencias cruzadas
- `/roi-check` - Consistencia de cifras ROI, métricas y cost coverage
- `/lint` - Verificación rápida: word count, placeholders, datos verificados
- `/redundancy` - Detectar stats, citas y secciones repetidas entre capítulos
- `/shelf-life` - Identificar contenido efímero (precios, versiones, predicciones)
- `/depth-check` - Verificar profundidad de conceptos clave
- `/case-audit` - Comparar casos de estudio por overlap y variedad

### book-editorial (7)
- `/enrich [capitulo]` - Agregar elementos faltantes (takeaways, preguntas, callouts)
- `/standardize [capitulo|all]` - Estandarizar formatos de callouts y badges
- `/stats` - Métricas editoriales completas + gravedad referencial
- `/verify-datos` - Auditar bloques "Dato verificado"
- `/tone-check [capitulo|all]` - Urgencia, densidad persuasiva, balance riesgo/beneficio, jerga
- `/voice-check` - Auditar diversidad de voces citadas (advocates vs. escépticos)
- `/language-check` - Detectar anglicismos inconsistentes y code-switching

### book-build (8)
- `/build` - Build completo del PDF
- `/preview [capitulo]` - Build rápido + abrir PDF
- `/check` - Validar cross-refs y warnings LaTeX
- `/optimize` - Fix tipografía
- `/theme [nombre]` - Cambiar tema visual **(no funciona: ver trampas abajo)**
- `/export [formato]` - Exportar a formato alternativo
- `/illustrations` - Gestionar el sistema de figuras
- `/status` - Estado del pipeline

## Build

Se corre **desde `latex-pipeline/`**, con Docker + Pandoc + LuaLaTeX (imagen base `pandoc/extra`):

```bash
cd latex-pipeline
docker compose run --rm book make pdf
```

Los **14 targets** del Makefile: `pdf`, `digital`, `epub`, `latex`, `chapter` (con `CHAP=NN`),
`validate`, `check-content`, `logcheck`, `optimize`, `preview`, `clean`, `docker-build`, `figures`,
`help`.

Los prerequisitos de `$(BOOK_PDF)` y `$(BOOK_TEX)` cubren hoy **todo** lo que afecta al resultado:
`$(ALL_FILES)`, `templates/book.tex`, el `.cls`, `$(FILTER_FILES)` (`$(wildcard filters/*.lua)`),
`$(STY_FILES)` (`$(wildcard sty/*.sty)`) y `config.yml`. Editar un filtro Lua o un `.sty` dispara
la reconstrucción; ya no hay que borrar el PDF a mano para que `make pdf` te haga caso.

### `make digital`
Genera `output/agentico-por-diseno-digital.pdf` con los hyperlinks en color. Funciona pasando la
**opción de clase** `digital`: existe `PANDOC_OPTS_NOCLASS` (igual que `PANDOC_OPTS` pero sin fijar
`classoption`) y el target añade `-V classoption=twoside -V classoption=digital`, lo que produce
`\documentclass[twoside,digital]{paradigma-agentico}` y activa el `\ifpa@digital` del `.cls`.
No confundir con la clave `mode:` de `config.yml`, que ya no existe y nunca hizo nada.

### `make check-content`
Es el **quality gate del manuscrito**: corre `scripts/validate.sh`, que verifica que estén los 16
ficheros de capítulo (`00`, `00a`, `01`..`14`) y los 5 apéndices (`A`..`E`), avisa de ficheros de
capítulo inesperados, y busca bloques de código, placeholders y demás. El chequeo de "sin código"
excluye a propósito los bloques ` ```{=latex} `, que son LaTeX crudo de maquetación, no código
del libro. Detecta por sí solo si corre en el host (`ingenieria_agentica/`) o dentro del contenedor
(`/book/content`). Última corrida limpia: sale con 0, valida los 16 capítulos y los 5 apéndices y
deja 1 warning (13 marcadores de code fence que no son `{=latex}`).

### `make preview`
Compila el PDF y luego imprime la ruta y el comando para abrirlo. No intenta ejecutar `open`:
todos los targets corren dentro del contenedor, donde ese binario no existe.

### `make logcheck`
`make pdf` encadena `logcheck`, que lee el log del último pase de lualatex y **falla** si hay
errores de TeX, caracteres perdidos, referencias sin resolver o etiquetas duplicadas. Escape:
`make pdf STRICT=0`. Existe porque los tres pases de lualatex corren con `> /dev/null 2>&1 || true`:
sin `logcheck`, un documento roto pasaba por bueno.

Estado del build en la última medición limpia: 0 errores de TeX, 0 caracteres perdidos,
0 referencias sin resolver, 0 etiquetas duplicadas, ~20 overfull hboxes (cosméticos), 577 páginas.
Los cuatro ceros son el contrato y no deben regresar; el número de overfull hboxes varía de build
a build y no es una meta. `output/agentico-por-diseno.log` está gitignoreado y lo reescribe cada
pase de lualatex, así que **no leas cifras de un log a medio escribir**: mídelas con
`make logcheck` sobre un build terminado.

---

## Trampas del Repo (léelas antes de tocar nada)

1. **`latex-pipeline/config.yml` es casi todo letra muerta.** Pandoc lo carga entero con
   `--metadata-file`, pero de todo el fichero solo **dos** claves llegan a algún sitio:
   - `book.date` - es la **única** variable de metadatos que usa `templates/book.tex` (4 veces:
     `\date`, portada, créditos y "Primera edición"). Compruébalo con
     `grep -n 'book\.' latex-pipeline/templates/book.tex`: las otras dos variables de plantilla
     del fichero son `$body$` y `$classoption$`, que las inyecta pandoc, no `config.yml`.
   - `figure-mode` - la lee `filters/figure-transform.lua` en su función `Meta` (default `all`).

   El resto del bloque `book:` (`title`, `tomo`, `subtitle`, `author`, `lang`) **no tiene ningún
   efecto**: se conserva como metadato descriptivo del proyecto y el propio fichero lo marca como
   decorativo. `title`, `tomo`, `subtitle` y `author` están **hardcodeados** en
   `templates/book.tex` (líneas 15-16 y las portadas) y en `\pdftitle`/`\pdfauthor` del `.cls`, y
   `lang: es` es inerte porque el `.cls` carga `\RequirePackage[spanish,es-tabla]{babel}`
   directamente. Las claves muertas que llegó a haber (`theme`, `page_size`, `mode`, `fonts:`,
   `layout:`, `features:`) ya **no están en el fichero**: se eliminaron, y su cabecera explica hoy
   qué se consume y dónde se cambia cada cosa de verdad (geometría y fuentes en el `.cls`, paleta
   en `sty/pa-colors.sty`, modo digital vía opción de clase). No las reintroduzcas: si aparece de
   nuevo un `page_size` o un `size: 11pt` en `config.yml`, es decorado que contradice al `.cls`.
   Para cambiar el título, el autor o la portada se edita `templates/book.tex`, no `config.yml`.
2. **`/theme` no cambia nada** porque promete editar la clave `theme:` de `config.yml` (ver punto
   1), que ni se consume ni existe ya en el fichero. Los colores viven en `sty/pa-colors.sty` y en
   el bloque de color del `.cls`.
3. **`MD_FORMAT = markdown+autolink_bare_uris-tex_math_dollars`.** Desactivar `tex_math_dollars`
   es crítico: sin ello, cada `$` de un precio abre un span de matemáticas que se traga los
   separadores de fila de las tablas. Causaba 31 errores.
4. **Las cabeceras de comentario de varios filtros Lua declaran un orden falso.** El orden real
   lo define `FILTER_CHAIN` en el Makefile (ver abajo). Mienten:
   `callout-transform` (dice 2, es 7), `code-transform` (dice 2, es 3), `checkbox-transform`
   (dice 4, es 6), `crossref-transform` (dice 6, es 9), `table-transform` (dice 7, es 8),
   `hr-transform` (dice 7, es 12 - sí corre último, pero el número está mal) y
   `part-dividers` (dice "runs BEFORE other filters (prepended to filter chain)", pero es el 4º:
   corre después de `figure-transform` y `code-transform`).
   Solo `meta-strip` (1) y `emoji-transform` (5) coinciden. `figure-transform` (2),
   `index-transform` (10) y `drop-caps` (11) no declaran número; `drop-caps` sí describe bien su
   dependencia real ("runs AFTER callout-transform"). No confíes en ninguna cabecera: lee el
   Makefile.
5. **El secret de GitHub `KV_NAMESPACE_ID` ya no se usa.** Se eliminó porque duplicaba el id que
   ya está en `wrangler.jsonc`; si divergían, la subida terminaba en verde escribiendo al
   namespace equivocado mientras el Worker servía un KV vacío devolviendo HTTP 200. Los secrets
   necesarios son `CLOUDFLARE_API_TOKEN` y `CLOUDFLARE_ACCOUNT_ID`.

---

## Pipeline LaTeX

**El orden de los 12 filtros Lua importa.** Orden real de `FILTER_CHAIN` en el Makefile:

1. `meta-strip` 2. `figure-transform` 3. `code-transform` 4. `part-dividers` 5. `emoji-transform`
6. `checkbox-transform` 7. `callout-transform` 8. `table-transform` 9. `crossref-transform`
10. `index-transform` 11. `drop-caps` 12. `hr-transform`

`cls/paradigma-agentico.cls` está basado en `memoir` y define `\partdivider`, `\notespage` y
`\chapterminitoc`. `templates/` tiene 2 ficheros: `book.tex` (el template autocontenido de pandoc)
y `figure-wrapper.tex` (lo usa `scripts/build-figures.sh`).

Los 6 paquetes de `sty/` **no se cargan con `\usepackage`**: `book.tex` los mete con
`\input{pa-colors.sty}` ... `\input{pa-typography.sty}` (líneas 7-12), y se resuelven porque el
Makefile exporta `TEXINPUTS := $(CLS):$(STY):`. Consecuencia práctica: correr `lualatex` a mano
sobre `output/agentico-por-diseno.tex`, fuera del Makefile o del contenedor, falla al no encontrar
ni el `.cls` ni los `.sty`. Ahí viven los callouts (`resumen-ejecutivo`, `reunion-liderazgo`, etc.),
la paleta de color que sobrescribe la del `.cls`, y el `\arraystretch{1.15}` de las tablas.

Partes del libro, según `part-dividers.lua`:

| Parte | Título | Arranca en |
|-------|--------|-----------|
| I | Contexto Estratégico | cap 0 |
| II | Sesgos y Evidencia | cap 5 |
| III | La Tecnología | cap 7 |
| IV | Impacto en el Negocio | cap 9 |
| V | Liderazgo y Estrategia | cap 11 |
| VI | Gobernanza y Futuro | cap 13 |

---

## MCP Server

Cloudflare Worker `agentico-mcp`, dominio `book-mcp.touma.io`. Endpoint MCP en `/mcp` (y `/mcp/`,
que se normaliza); health e info en `/` y `/health`.

- **5 tools**: `search`, `read_chapter`, `get_toc`, `get_glossary`, `get_frameworks`
- **Durable Object**: clase `BookMCP`, binding `MCP_OBJECT` (migración `v1`,
  `new_sqlite_classes`). **KV binding**: `BOOK_KV`, con el id del namespace en `wrangler.jsonc`
- **295 entradas KV**: 21 chapters, 270 sections, 1 glossary, 1 frameworks, 1 toc, 1 search-index.
  91 términos de glosario, 12 frameworks (de los 270 sections, 65 son de apéndices)
- **Node >= 20.11** (por `import.meta.dirname` en `prepare-content.ts`)
- **Scripts npm**: `dev`, `typecheck`, `check`, `deploy`, `prepare-content`, `upload-kv`,
  `cf-typegen`. `typecheck` cubre `src/` (`tsconfig.json`) y `scripts/` (`tsconfig.scripts.json`)
- **CI** (`.github/workflows/deploy-mcp.yml`): checkout, setup-node, `npm ci`, typecheck, dry-run,
  prepare-content, `kv bulk put --binding=BOOK_KV --remote`, deploy

---

## Comportamientos de Eficiencia

### IMPORTANTE: No leer contenido completo innecesariamente

**NUNCA** intentes leer todo el contenido del libro de una sola vez. El libro tiene 577 páginas y
142K palabras; leer todo el markdown o el PDF es ineficiente y excede límites de contexto.

**En su lugar:**
1. **Para verificar formato**: Lee solo las primeras 50-100 líneas de un capítulo
2. **Para buscar patrones**: Usa `Grep` para encontrar secciones específicas
3. **Para revisar estructura**: Lee solo el `BOOK_MASTER.md` o los encabezados
4. **Para verificar PDF**: Compila y revisa visualmente, no leas el LaTeX completo

**Archivos que SÍ puedes leer completos** (son cortos):
- `CLAUDE.md` (este archivo)
- `BOOK_MASTER.md`
- Templates en `/templates/`
- Archivos `.cls` y `.sty` de LaTeX
- Los `SKILL.md`

**Archivos que NUNCA debes leer completos:**
- PDFs generados
- Capítulos individuales (20-40 páginas cada uno)
- El libro compilado
- `mcp-server/kv-data.json` (es contenido del libro serializado)

---

## Especificaciones de Formato (Estilo Editorial)

> **Fuente de verdad: `latex-pipeline/cls/paradigma-agentico.cls`.** No `config.yml`, que ya ni
> siquiera declara geometría ni fuentes (ver trampa #1). Si esta tabla y el `.cls` discrepan, gana
> el `.cls` y esta tabla es la que hay que corregir.

El libro sigue estándares de editoriales técnicas profesionales (O'Reilly, Manning, Apress)
y principios tipográficos clásicos (Tschichold, Butterick).

| Parámetro | Valor | Dónde se define en el `.cls` |
|-----------|-------|------------------------------|
| **Stock** | 11in × 8.5in | `\setstocksize{11in}{8.5in}` |
| **Trim Size** | 9.68in × 7.44in (Crown Quarto) | `\settrimmedsize{9.68in}{7.44in}{*}` |
| **Trims** | 0.66in / 0.53in (centra el trim en el stock) | `\settrims{0.66in}{0.53in}` |
| **Type Block** | 21.0cm alto × 13.5cm ancho | `\settypeblocksize{21.0cm}{13.5cm}{*}` |
| **Font Body** | 10pt Libertinus Serif | `\LoadClass[10pt,...]{memoir}` + `\setmainfont` |
| **Font Sans / Mono** | Libertinus Sans / Fira Mono | `\setsansfont` / `\setmonofont` |
| **Line Spacing** | 1.15 (115%) | `\setSingleSpace{1.15}` |
| **Binding** | twoside, openright | `\LoadClass[10pt,openright,final]{memoir}` |
| **Inner Margin** | 2.2cm | `\setlrmargins{2.2cm}{*}{*}` |
| **Top Margin** | 1.8cm | `\setulmargins{1.8cm}{*}{*}` |
| **Outer Margin** | ~3.2cm (auto) | 18.9cm de trim - 2.2 - 13.5 |
| **Bottom Margin** | auto | `\checkandfixthelayout[nearest]` |

> Nota: el comentario junto a `\setlrmargins` en el `.cls` dice "~3.0cm" para el margen exterior.
> El cálculo real da ~3.2cm. El comentario está desactualizado, el valor no.

### Márgenes Asimétricos (Hardcover)
Optimizado para densidad con espacio moderado de anotación:
- **Inner (gutter)**: 2.2cm - suficiente para case-bound hardcover
- **Outer**: ~3.2cm - permite notas a lápiz
- **Top**: 1.8cm

Nunca escribas "márgenes de 5cm": esa cifra circuló un tiempo y es falsa. El `README.md` ya está
corregido y declara los mismos valores que la tabla de arriba (13.5cm de caja, 2.2 / 1.8 / ~3.2cm).

### Tablas
- Usar `booktabs` style (sin líneas verticales)
- `arraystretch`: 1.15 (definido en `sty/pa-tables.sty`)
- Font: Sans-serif para claridad

### Densidad
- Objetivo de diseño: ~400-450 palabras por página de texto corrido
- Promedio real sobre el PDF completo: ~246 palabras de markdown por página (142,097 / 577).
  `BOOK_MASTER.md` cita ~261 sobre las 544 páginas de contenido (3-546, excluyendo el índice
  analítico): es el mismo número medido sobre otro denominador, no una contradicción
- La brecha con el objetivo de diseño no es contenido faltante: el markdown no cuenta tablas
  renderizadas, callouts ni blanco tipográfico, y el PDF incluye TOC, portadillas de parte,
  páginas de notas, índice analítico y aperturas de capítulo en recto
- Evitar páginas de texto con menos de 60% de contenido
- Tablas y figuras no deben dejar más de 1/3 de página vacía

---

## Dónde Mirar

| Documento | Qué cubre | Estado |
|-----------|-----------|--------|
| `README.md` | Portada del repo: qué es el libro, cómo descargarlo, cómo compilarlo | existe |
| `CONTRIBUTING.md` | Reglas duras de contribución: em dashes, prohibición de código, no fabricar datos, convención `US$` | existe |
| `ingenieria_agentica/BOOK_MASTER.md` | Registro editorial: rangos de páginas y palabras medidos por capítulo | existe |
| `mcp-server/README.md` | El Worker, sus 5 tools y el despliegue | existe |
| `docs/arquitectura.md` | Vista general de las tres piezas: manuscrito, pipeline LaTeX, MCP server | existe |
| `docs/build.md` | Cómo compilar el PDF, los 14 targets del Makefile, `logcheck`, `check-content`, troubleshooting | existe |
| `docs/pipeline-latex.md` | Los 12 filtros Lua y su orden, la clase, los paquetes `sty/`, `config.yml` | existe |
| `docs/figuras-e-indice.md` | Sistema de figuras (`![](fig:id)`, manifest) e índice analítico (`{.idx}`) | existe |

El directorio `docs/` ya está en el repo con los cuatro ficheros. Antes de citar una cifra de
ellos, compruébala contra el repo: son documentación, no fuente de verdad.
