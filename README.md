[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-blue)](LICENSE)
[![Deploy MCP Server](https://github.com/karimtouma/agentico/actions/workflows/deploy-mcp.yml/badge.svg)](https://github.com/karimtouma/agentico/actions/workflows/deploy-mcp.yml)
![142K palabras](https://img.shields.io/badge/palabras-142%2C097-informational)
![577 paginas](https://img.shields.io/badge/p%C3%A1ginas-577-informational)
![14 capitulos](https://img.shields.io/badge/cap%C3%ADtulos-14%20%2B%205%20ap%C3%A9ndices-informational)
![5 MCP tools](https://img.shields.io/badge/MCP_tools-5-green)
![Espanol](https://img.shields.io/badge/idioma-espa%C3%B1ol-yellow)

# Agéntico por Diseño

### Tomo I: Tecnologías de la Información

Un libro sobre cómo diseñar organizaciones y equipos de desarrollo de software que
operan con agentes autónomos de IA. Este repositorio contiene el manuscrito completo,
el pipeline que lo compila a PDF y un servidor MCP que sirve el libro a clientes de IA.

Sin código. Sin casos ficticios. Datos con fuente y frameworks de decisión.

---

## Contenido

- [Sobre el libro](#sobre-el-libro)
- [Leer el libro ahora](#leer-el-libro-ahora)
- [Compilar el PDF](#compilar-el-pdf)
- [Servidor MCP](#servidor-mcp)
- [Estructura del repositorio](#estructura-del-repositorio)
- [Skills de Claude Code](#skills-de-claude-code)
- [Documentación](#documentación)
- [Trampas conocidas](#trampas-conocidas)
- [Contribuir](#contribuir)
- [Licencia](#licencia)

---

## Sobre el libro

**Autor**: Karim Touma.
**Audiencia**: gerentes y líderes técnicos (VP Eng, CTO, Tech Leads) que tienen que
decidir sobre adopción de IA agéntica y justificarla ante un comité.
**Idioma**: español neutro latinoamericano.

**Estado real, medido sobre el repositorio:**

| Métrica | Valor |
|---|---|
| Palabras | 142,097 (`wc -w` sobre `capitulos/` + `apendices/`) |
| Páginas del PDF compilado | 577 |
| Capítulos numerados | 14, más prefacio y resumen ejecutivo |
| Apéndices | 5 (A-E) |
| Términos de glosario (Apéndice A) | 91 |
| Frameworks de decisión (Apéndice B) | 12 |
| Checkpoints de implementación (Apéndice C) | 115 |
| Entradas de índice analítico marcadas | 290 |

**Reglas editoriales del proyecto** (las mismas que aplican a cualquier PR de contenido):

- Cero código de programación en el libro, ni siquiera snippets.
- Cero empresas, sitios, casos, cifras o citas inventadas. Todo dato lleva fuente
  (Gartner, McKinsey, GitClear, METR, Snyk, GitHub Research, DORA, BCG, Deloitte).
  El proyecto eliminó deliberadamente todo su contenido ficticio previo.
- Prohibido el em dash. Se usa guion con espacios: `palabra - otra palabra`.
- La moneda siempre se escribe `US$`, nunca `$` a secas: para un lector
  latinoamericano `$` es su moneda local. Hay 991 ocurrencias de `US$` en el texto.

Cada uno de los 14 capítulos numerados incluye ocho bloques obligatorios: Resumen
Ejecutivo, Dato verificado, Conclusiones y Takeaways, Preguntas de Reflexión, Para Tu
Próxima Reunión de Liderazgo, Tarjeta de Referencia Rápida, Referencias y el pie
"Fin del Capítulo X". El prefacio y el resumen ejecutivo no los llevan, y es correcto:
son front matter, no capítulos.

### Estructura en seis partes

| Parte | Tema | Arranca en |
|---|---|---|
| I | Contexto Estratégico | Prefacio (cap. 0) |
| II | Sesgos y Evidencia | Cap. 5 |
| III | La Tecnología | Cap. 7 |
| IV | Impacto en el Negocio | Cap. 9 |
| V | Liderazgo y Estrategia | Cap. 11 |
| VI | Gobernanza y Futuro | Cap. 13 |

<details>
<summary><strong>Capítulos y apéndices, con extensión real</strong></summary>

| # | Título | Palabras |
|---|---|---|
| 0 | Prefacio: Por Qué los Líderes Deben Leer Esto Ahora | 3,692 |
| - | Resumen Ejecutivo para el Líder | 2,218 |
| 1 | El Nuevo Paradigma de la Ingeniería de Software | 10,747 |
| 2 | De los Paradigmas Tradicionales al Paradigma Agéntico | 6,552 |
| 3 | ¿Qué Es Realmente la Inteligencia Artificial Agéntica? | 7,975 |
| 4 | Por Qué Diseñar, No Solo Adoptar: La Lección Que Toda Revolución Tecnológica Nos Enseña | 7,201 |
| 5 | Sesgos Cognitivos en la Era de la IA Agéntica | 4,986 |
| 6 | Guía por Industria: Dónde Están los Quick Wins | 4,391 |
| 7 | La Evolución Técnica Hacia la IA Agéntica en Ingeniería | 8,959 |
| 8 | El Ecosistema de Herramientas Agénticas - Guía de Selección para Líderes | 13,202 |
| 9 | El Impacto en el Negocio - ROI, TCO y Justificación Financiera | 8,260 |
| 10 | Cuando la IA Agéntica Falla: Lecciones de Implementaciones Fallidas | 2,825 |
| 11 | Liderando Equipos en la Era de la IA | 10,185 |
| 12 | Estrategia de Adopción - Hoja de Ruta de IA Agéntica | 7,422 |
| 13 | Desafíos, Riesgos y Gobernanza del Paradigma Agéntico | 13,706 |
| 14 | Visión a Futuro - 2026-2030 | 10,271 |
| A | Glosario Ejecutivo (91 términos) | 4,428 |
| B | Frameworks de Decisión (12 frameworks) | 4,365 |
| C | Checklist de Implementación (115 checkpoints) | 3,579 |
| D | Recursos y Lecturas Recomendadas | 5,130 |
| E | Modelos Mentales Técnicos para Decisores | 2,003 |

</details>

---

## Leer el libro ahora

El PDF compilado está commiteado en el repositorio a propósito, para que se pueda leer
sin instalar nada:

**[latex-pipeline/output/agentico-por-diseno.pdf](latex-pipeline/output/agentico-por-diseno.pdf)**
- 577 páginas, 1.9 MB.

Descarga directa:

```bash
curl -LO https://github.com/karimtouma/agentico/raw/main/latex-pipeline/output/agentico-por-diseno.pdf
```

Es el único archivo de `latex-pipeline/output/` bajo control de versiones. El resto de
esa carpeta (`.aux`, `.log`, `.tex`, `.idx`, `.epub`) está en `.gitignore` porque lo
regenera el build. En un conflicto de merge sobre el PDF la respuesta siempre es
recompilar, nunca resolverlo a mano: `.gitattributes` lo marca como `binary`.

El manuscrito en Markdown vive en `ingenieria_agentica/capitulos/` y
`ingenieria_agentica/apendices/`, y se lee perfectamente en GitHub.

---

## Compilar el PDF

Único prerequisito: [Docker](https://www.docker.com/products/docker-desktop/) corriendo.
No hace falta LaTeX, ni Pandoc, ni las fuentes instaladas en el sistema: todo va dentro
de la imagen. Los comandos se corren **desde `latex-pipeline/`**, no desde la raíz.

```bash
git clone https://github.com/karimtouma/agentico.git
cd agentico/latex-pipeline
docker compose build                       # primera vez
docker compose run --rm book make pdf
```

El resultado queda en `latex-pipeline/output/agentico-por-diseno.pdf`.

El target `pdf` corre Pandoc (que aplica los 12 filtros Lua), luego tres pasadas de
LuaLaTeX con `makeindex` en medio para el índice analítico, y termina invocando
`logcheck`. Las tres pasadas de LuaLaTeX descartan su salida y terminan en `|| true`,
así que sin `logcheck` un documento roto produciría un PDF y un exit code cero.
`logcheck` lee el log de la última pasada y **falla el build** si encuentra errores de
TeX, caracteres perdidos, referencias sin resolver o etiquetas duplicadas. Los overfull
hboxes son cosméticos y no lo rompen. Escape: `make pdf STRICT=0`.

Los prerequisitos de `$(BOOK_PDF)` y `$(BOOK_TEX)` cubren el manuscrito completo, el
template, la clase, **todos los filtros Lua** (`$(FILTER_FILES)`), **todos los paquetes
de `sty/`** (`$(STY_FILES)`) y `config.yml`. Editar un filtro o un `.sty` dispara la
reconstrucción, así que `make pdf` no te devuelve un PDF viejo.

Estado actual del build:

```
TeX errors                 0
Missing characters         0
Undefined references       0
Multiply-defined labels    0
Overfull hboxes            20
```

### Targets del Makefile

| Target | Qué hace |
|---|---|
| `make figures` | Compila `figuras/tikz/*.tex` y `figuras/svg/*.svg` a PDF. Hoy no hay fuentes, así que solo informa y sigue |
| `make pdf` | Build completo listo para imprenta, con `logcheck` al final |
| `make latex` | Genera solo el `.tex` intermedio, para inspeccionarlo |
| `make chapter CHAP=NN` | PDF de un solo capítulo |
| `make digital` | PDF digital en `output/agentico-por-diseno-digital.pdf`. Pasa `-V classoption=twoside -V classoption=digital`, que activa la opción `digital` de la clase y con ella los hyperlinks coloreados |
| `make epub` | Exporta EPUB |
| `make check-content` | Corre `scripts/validate.sh` sobre el manuscrito: los 16 capítulos y los 5 apéndices presentes, bloques editoriales, ausencia de código y de placeholders, salud del último build y efectividad de los filtros |
| `make validate` | Genera el `.tex` y cuenta cross-refs, referencias sin resolver, cajas overfull/underfull y warnings sobre los logs. Es el chequeo del build; el del manuscrito es `make check-content` |
| `make logcheck` | Solo el chequeo de salud del último log |
| `make optimize` | Build y luego listado de overfull/underfull hboxes y vboxes del log, más el total de páginas. Solo diagnostica: no modifica nada |
| `make preview` | Build y luego imprime la ruta del PDF y el comando para abrirlo desde el host (el target corre dentro del contenedor) |
| `make clean` | Limpia `output/`. Borra también el PDF versionado; se recupera con `git checkout latex-pipeline/output/agentico-por-diseno.pdf` |
| `make docker-build` | Reconstruye la imagen |
| `make help` | Lista los targets |

### Formato físico

Definido en `latex-pipeline/cls/paradigma-agentico.cls`, sobre la clase `memoir`.

| Parámetro | Valor |
|---|---|
| Stock | 11in x 8.5in |
| Trim | 9.68in x 7.44in (Crown Quarto) |
| Caja de texto | 21.0cm x 13.5cm |
| Margen interior (gutter) | 2.2cm |
| Margen superior | 1.8cm |
| Margen exterior | ~3.2cm |
| Cuerpo | 10pt Libertinus Serif |
| Interlineado | 1.15 |
| Encuadernación | `twoside`, `openright` |

---

## Servidor MCP

El libro completo es consultable desde cualquier cliente compatible con
[Model Context Protocol](https://modelcontextprotocol.io). Es un Cloudflare Worker
(`agentico-mcp`) con Durable Objects y KV, desplegado automáticamente en cada push a
`main` que toque `mcp-server/` o el contenido del libro.

| | |
|---|---|
| Endpoint MCP | `https://book-mcp.touma.io/mcp` |
| Alternativo | `https://agentico-mcp.karim-cfa.workers.dev/mcp` |
| Health / info | `https://book-mcp.touma.io/health` |

### Conectar un cliente

```json
{
  "mcpServers": {
    "agentico": {
      "url": "https://book-mcp.touma.io/mcp"
    }
  }
}
```

Desde Claude Code, en la raíz de cualquier proyecto:

```bash
claude mcp add --transport http agentico https://book-mcp.touma.io/mcp
```

Comprobación rápida de que el servicio responde:

```bash
curl -s https://book-mcp.touma.io/health
```

### Las 5 tools

| Tool | Qué devuelve | Parámetros |
|---|---|---|
| `search` | Secciones que hacen match, con capítulo, encabezado y snippet | `query` (string), `limit` (number, default 10) |
| `read_chapter` | Un capítulo completo o una sección suya | `chapter_id` (`00`-`14`, `00a`, `appendix-a`..`appendix-e`), `section` (slug opcional) |
| `get_toc` | Estructura del libro con word counts | `detail`: `chapters` (default), `full`, `appendices` |
| `get_glossary` | Definición de un término del Apéndice A | `term` (string) |
| `get_frameworks` | Un framework del Apéndice B, o el listado completo | `name` (string opcional) |

El contenido no se lee del repositorio en tiempo real: se preprocesa a KV en el deploy.
El namespace `BOOK_KV` guarda 295 entradas - 21 capítulos, 270 secciones, el glosario,
los frameworks, la tabla de contenidos y el índice de búsqueda.

### Desarrollo

Requiere Node >= 20.11, porque `scripts/prepare-content.ts` usa `import.meta.dirname`.

```bash
cd mcp-server
npm ci
npm run typecheck        # tsc sobre src/ y sobre scripts/
npm run check            # typecheck + wrangler deploy --dry-run
npm run dev              # wrangler dev
npm run prepare-content  # genera kv-data.json desde el markdown
```

El workflow `.github/workflows/deploy-mcp.yml` necesita dos secrets de GitHub:
`CLOUDFLARE_API_TOKEN` y `CLOUDFLARE_ACCOUNT_ID`. No hace falta ningún secret con el id
del namespace de KV: ese id vive en `wrangler.jsonc` y es la única fuente de verdad.
Tenerlo duplicado en un secret era peligroso, porque si los dos valores divergían la
subida terminaba en verde escribiendo al namespace equivocado mientras el Worker servía
un KV vacío y respondía HTTP 200.

Documentación completa: [mcp-server/README.md](mcp-server/README.md).

---

## Estructura del repositorio

```
.claude/
  settings.json
  skills/                          5 skills, cada una en <nombre>/SKILL.md
    book-audit-fixes/  book-build/  book-editorial/  book-quality/  book-writer/

.github/workflows/
  deploy-mcp.yml                   CI: typecheck, dry-run, subida a KV, deploy

ingenieria_agentica/               el manuscrito
  BOOK_MASTER.md                   índice maestro con word counts
  capitulos/                       16 .md: 00_prefacio, 00a_executive_brief, 01..14
  apendices/                       5 .md: A_glosario .. E_modelos_mentales
  figuras/                         manifest.yml + tikz/ svg/ pdf/ (fuentes aún vacías)
  templates/capitulo_template.md

latex-pipeline/                    el build
  Dockerfile  docker-compose.yml  Makefile  config.yml
  cls/paradigma-agentico.cls       clase basada en memoir
  sty/                             6 paquetes: pa-callouts, pa-codeblocks, pa-colors,
                                   pa-diagrams, pa-tables, pa-typography
  filters/                         12 filtros Lua de Pandoc
  templates/                       book.tex (template de pandoc), figure-wrapper.tex
  scripts/                         build-figures.sh, validate.sh (make check-content)
  fonts/                           LibertinusSerif, LibertinusSans, FiraMono
  illustrations/                   chapter-headers/, icons/, part-dividers/
  output/                          solo el PDF está versionado

mcp-server/                        el Worker
  src/index.ts                     las 5 tools MCP
  scripts/prepare-content.ts       markdown -> kv-data.json
  wrangler.jsonc  package.json  tsconfig.json  tsconfig.scripts.json

CLAUDE.md  README.md  LICENSE  .gitignore  .gitattributes
```

### Orden de los filtros Lua

El orden importa y el que manda es el de `FILTER_CHAIN` en el `Makefile`:

```
1  meta-strip          5  emoji-transform     9   crossref-transform
2  figure-transform    6  checkbox-transform  10  index-transform
3  code-transform      7  callout-transform   11  drop-caps
4  part-dividers       8  table-transform     12  hr-transform
```

Varios `.lua` traen en su cabecera de comentario un número de orden que no coincide con
este. El Makefile es la fuente de verdad; las cabeceras no.

---

## Skills de Claude Code

El repositorio está preparado para [Claude Code](https://docs.anthropic.com/en/docs/claude-code).
Abre `claude` desde la raíz y tendrás `CLAUDE.md` (las reglas editoriales) y cinco skills
en `.claude/skills/<nombre>/SKILL.md`, que definen 27 comandos entre todas.

`book-audit-fixes` no define comandos: es una skill de referencia con las reglas
anti-regresión derivadas de 28 correcciones a lo largo de 5 rondas de auditoría. Se
consulta antes de escribir o editar contenido.

**`book-build`** - 8 comandos

| Comando | Acción |
|---|---|
| `/build` | Build completo del PDF |
| `/preview [capitulo]` | Build rápido y abrir el PDF |
| `/check` | Validar cross-refs y warnings de LaTeX |
| `/optimize` | Ajustes tipográficos |
| `/theme [nombre]` | Cambiar el tema visual (ver [Trampas conocidas](#trampas-conocidas)) |
| `/export [formato]` | Exportar a un formato alternativo |
| `/illustrations` | Trabajar sobre las ilustraciones |
| `/status` | Estado del pipeline |

**`book-quality`** - 8 comandos

| Comando | Acción |
|---|---|
| `/audit [capitulo\|all]` | Auditoría completa: estructura, xrefs, código, badges, notas, tono |
| `/xref` | Validación exhaustiva de referencias cruzadas |
| `/roi-check` | Consistencia de cifras de ROI, métricas y cobertura de costos |
| `/lint` | Chequeo rápido: word count, placeholders, datos verificados |
| `/redundancy` | Estadísticas, citas y secciones repetidas entre capítulos |
| `/shelf-life` | Contenido efímero: precios, versiones, predicciones |
| `/depth-check` | Profundidad de los conceptos clave |
| `/case-audit` | Casos de estudio: overlap y variedad |

**`book-editorial`** - 7 comandos

| Comando | Acción |
|---|---|
| `/enrich [capitulo]` | Agregar los bloques editoriales que falten |
| `/standardize [capitulo\|all]` | Estandarizar callouts y badges |
| `/stats` | Métricas editoriales y gravedad referencial |
| `/verify-datos` | Auditar los bloques "Dato verificado" |
| `/tone-check [capitulo\|all]` | Urgencia, densidad persuasiva, balance riesgo/beneficio, jerga |
| `/voice-check` | Diversidad de voces citadas: advocates contra escépticos |
| `/language-check` | Anglicismos inconsistentes y code-switching |

**`book-writer`** - 4 comandos

| Comando | Acción |
|---|---|
| `/expand [capitulo]` | Expandir un capítulo existente |
| `/case-study` | Trabajar un caso de estudio |
| `/research [tema]` | Investigar datos actualizados |
| `/chapter-outline [numero]` | Generar un outline expandido |

---

## Documentación

| Documento | Contenido |
|---|---|
| [CONTRIBUTING.md](CONTRIBUTING.md) | Reglas duras del proyecto y cómo enviar un PR |
| [docs/arquitectura.md](docs/arquitectura.md) | Cómo encajan manuscrito, pipeline y Worker |
| [docs/build.md](docs/build.md) | El build a fondo: targets, Docker, logcheck |
| [docs/pipeline-latex.md](docs/pipeline-latex.md) | Filtros Lua, clase, paquetes `sty/`, templates |
| [docs/figuras-e-indice.md](docs/figuras-e-indice.md) | Sistema de figuras e índice analítico |
| [mcp-server/README.md](mcp-server/README.md) | El servidor MCP a fondo |
| [CLAUDE.md](CLAUDE.md) | Instrucciones para agentes que editen el libro |
| [ingenieria_agentica/BOOK_MASTER.md](ingenieria_agentica/BOOK_MASTER.md) | Índice maestro del manuscrito |

---

## Trampas conocidas

Cosas que parecen funcionar y no funcionan. Vale la pena leerlas antes de tocar nada.

**`latex-pipeline/config.yml` es casi todo letra muerta.** Pandoc lo carga con
`--metadata-file`, pero de todo el fichero solo se leen dos valores: `book.date`, que
`templates/book.tex` interpola en portada y página de créditos, y `figure-mode`, que
consume `figure-transform.lua`. Lo demás que queda en el fichero - `book.title`,
`book.tomo`, `book.subtitle`, `book.author`, `book.lang` - no lo lee nadie, y está
marcado como decorativo con un comentario en cada línea: el título y el autor están
escritos a mano dentro de `templates/book.tex`, el idioma lo resuelve babel, y la clase
`paradigma-agentico.cls` hardcodea fuentes, tamaños y márgenes. Editar esas claves no
cambia el PDF. La cabecera del fichero explica qué se consume y en qué archivo se
cambia de verdad cada cosa.

**`/theme` no hace nada si solo tocas `config.yml`.** El skill `book-build` manda editar
la clave `theme:`, que es letra muerta. La ruta que sí funciona es la que el propio skill
documenta después: añadir `\setthemecorporategray` o `\setthemewarmterracotta` al inicio
de `sty/pa-colors.sty` y recompilar.

**El sistema de figuras existe pero todavía no se usa.** `figuras/manifest.yml` registra
46 figuras y las 46 están en status `placeholder`; `figuras/tikz/` y `figuras/svg/` están
vacíos, y el texto del libro no tiene ni una referencia `![](fig:id)`. Ojo con la
sintaxis: la única forma que funciona es `![](fig:id)`, con el destino entre paréntesis.
`![fig:id]` no construye una imagen en Pandoc y se queda como texto literal. Es
infraestructura lista para usarse, no una funcionalidad activa. El ciclo de vida previsto es
`placeholder` -> `draft` -> `final`, y `figure-mode` en `config.yml` controla qué se
renderiza (esta clave sí se lee, a diferencia del resto del fichero).

**No reactives `tex_math_dollars`.** El formato del reader es
`markdown+autolink_bare_uris-tex_math_dollars`. El libro no tiene matemáticas, y con esa
extensión activa cada `$` de un precio abre un span de matemáticas que se traga los
separadores de fila de las tablas. Costaba 31 errores de build.

**El índice analítico se marca a mano.** La convención es `[término]{.idx}` en el
markdown, que `index-transform.lua` convierte en `\index{término}`. Para sub-entradas,
`[término]{.idx data-sub="padre"}` produce `\index{padre!término}`. Hay 290 marcas en el
contenido. Requiere `--shell-escape`, que ya está en el Makefile.

---

## Contribuir

Lee [CONTRIBUTING.md](CONTRIBUTING.md) antes de abrir un PR. Las reglas duras (sin em
dashes, sin código, sin datos inventados, `US$` para la moneda) no son preferencias de
estilo: son criterios de aceptación.

El quality gate del manuscrito es `docker compose run --rm book make check-content`
desde `latex-pipeline/`. Comprueba que estén los 16 capítulos y los 5 apéndices, que
cada capítulo lleve sus bloques editoriales, que no haya código ni placeholders, y de
paso revisa la salud del último build y la efectividad de los filtros. Hoy sale limpio
con un solo warning: 13 marcadores de code fence que no son bloques `{=latex}`.
Córrelo antes de abrir un PR de contenido.

Dónde aporta más una contribución:

- **Erratas y datos desactualizados.** Si una estadística ya no se sostiene, abre un
  issue con la fuente nueva.
- **Figuras.** Hay 46 placeholders esperando una implementación en TikZ o SVG, cada uno
  con su descripción en `manifest.yml`.
- **Pipeline.** Empezando por las trampas de la sección anterior.
- **Servidor MCP.** Tools nuevas, mejor ranking en `search`.
- **Traducciones.** El contenido está en español.

Abre un [issue](https://github.com/karimtouma/agentico/issues) antes de mandar un PR
grande.

---

## Licencia

[Unlicense](LICENSE): dominio público. Aplica **tanto al código como al contenido del
libro**. Es una decisión deliberada del autor, y la página de créditos del PDF la
declara explícitamente. Puedes copiar, modificar, publicar, traducir, imprimir y vender
cualquier parte de este repositorio, con o sin atribución, para cualquier fin.
