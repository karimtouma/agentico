# Arquitectura del repositorio

Este documento describe cómo encajan los tres subsistemas de `book/`, por qué están
separados y qué se rompe al tocarlos. Está escrito para quien va a **modificar** el
sistema, no solo a usarlo.

Todos los datos de este documento se midieron sobre el repo. Cuando algo está roto o es
letra muerta, se dice.

Documentos hermanos: [build.md](build.md) (targets, Docker, `logcheck` en detalle),
[pipeline-latex.md](pipeline-latex.md) (cada filtro Lua, la clase, los `sty/`),
[figuras-e-indice.md](figuras-e-indice.md), [../CONTRIBUTING.md](../CONTRIBUTING.md)
(reglas duras del manuscrito) y [../mcp-server/README.md](../mcp-server/README.md).

---

## 1. Los tres subsistemas

| Directorio | Rol | Salida | Lenguaje / stack |
|---|---|---|---|
| `ingenieria_agentica/` | Fuente de verdad. El manuscrito. | nada, es la entrada | Markdown |
| `latex-pipeline/` | Markdown a PDF de imprenta | `output/agentico-por-diseno.pdf` | Docker + Pandoc + LuaLaTeX + 12 filtros Lua |
| `mcp-server/` | Markdown a KV a API MCP | Worker en `book-mcp.touma.io` | TypeScript + Cloudflare Workers |

El manuscrito son 16 ficheros en `ingenieria_agentica/capitulos/` (`00_prefacio`,
`00a_executive_brief` y `01` a `14`) más 5 en `ingenieria_agentica/apendices/`
(`A_glosario` a `E_modelos_mentales`). En conjunto, 142,097 palabras medidas con `wc -w`.

Ningún subsistema depende de otro. `latex-pipeline/` no sabe que existe `mcp-server/` y
viceversa. Lo único que comparten es el directorio de markdown, y lo leen de forma
independiente y con reglas distintas.

---

## 2. Flujo de datos

```
                     ingenieria_agentica/            <-- ÚNICA FUENTE DE VERDAD
                     capitulos/*.md   (16 ficheros)
                     apendices/*.md   ( 5 ficheros)
                     142,097 palabras
                              |
              +---------------+----------------+
              |                                |
       DISPARO: MANUAL                  DISPARO: push a main
       (nadie lo automatiza)            (.github/workflows/deploy-mcp.yml)
              |                                |
              v                                v
   +----------------------+          +------------------------------+
   |   latex-pipeline/    |          |         mcp-server/          |
   +----------------------+          +------------------------------+
   | cd latex-pipeline    |          | npm ci                       |
   | docker compose run   |          | npm run typecheck            |
   |   --rm book make pdf |          | wrangler deploy --dry-run    |
   |                      |          | tsx scripts/prepare-content  |
   | 1. pandoc            |          |                              |
   |    + 12 filtros Lua  |          |   readdirSync(capitulos/)    |
   |    + book.tex        |          |   readdirSync(apendices/)    |
   |    + config.yml      |          |   .sort() lexicográfico      |
   |    -> .tex           |          |   parte por H2 (##)          |
   | 2. lualatex pase 1   |          |          |                   |
   | 3. makeindex (.idx)  |          |          v                   |
   | 4. lualatex pase 2   |          |   kv-data.json (295 pares)   |
   | 5. lualatex pase 3   |          |          |                   |
   | 6. logcheck (gate)   |          |   wrangler kv bulk put       |
   +----------------------+          |   --binding=BOOK_KV --remote |
              |                      +------------------------------+
              v                                |
   output/agentico-por-diseno.pdf              v
   577 páginas, 1,902,906 bytes       Cloudflare KV "BOOK_KV"
   COMMITEADO a git a propósito       21 chapters + 270 sections
   (.gitignore lo exceptúa)           + glossary + frameworks
              |                       + toc + search-index
              v                                |
        el lector lo descarga                  | wrangler deploy
                                               v
                                     Worker "agentico-mcp"
                                     Durable Object: BookMCP
                                     https://book-mcp.touma.io/mcp
                                     5 tools: search, read_chapter,
                                     get_toc, get_glossary,
                                     get_frameworks

   LOS DOS CAMINOS NO SE HABLAN. No hay representación intermedia común,
   ni orden compartido, ni validación cruzada. Cada uno reinterpreta el
   markdown a su manera.
```

### La consecuencia práctica

Editar un capítulo deja el sistema en estado inconsistente hasta que se ejecutan **dos**
acciones distintas:

1. Recompilar el PDF (manual, local, con Docker) y commitear el PDF resultante.
2. Redesplegar el KV (automático, en cuanto el push llega a `main`).

Solo la segunda está automatizada. Si haces push de un cambio de contenido y no
recompilas, el MCP server sirve el texto nuevo mientras el PDF commiteado sigue mostrando
el viejo. Nadie te avisa: no hay ningún check que compare el PDF contra el markdown.

---

## 3. Qué dispara qué

### Automatizado: solo el MCP server

`.github/workflows/deploy-mcp.yml` corre en `push` a `main` cuando cambia alguno de estos
paths:

```
mcp-server/**
ingenieria_agentica/capitulos/**
ingenieria_agentica/apendices/**
.github/workflows/deploy-mcp.yml
```

Pasos, en orden: `checkout` -> `setup-node` -> `npm ci` -> `npm run typecheck` ->
`wrangler deploy --dry-run --outdir=dist` -> `tsx scripts/prepare-content.ts` ->
`wrangler kv bulk put kv-data.json --binding=BOOK_KV --remote` -> `wrangler deploy`.

Secretos de GitHub necesarios: `CLOUDFLARE_API_TOKEN` y `CLOUDFLARE_ACCOUNT_ID`. Nada
más. El id del namespace KV vive **solo** en `wrangler.jsonc`
(`4405cb4f8f274dbcb850a395f8f1a9fe`) y se resuelve por el binding `--binding=BOOK_KV`. No
lo dupliques en un secreto: si los dos valores divergen, la subida termina en verde
escribiendo al namespace equivocado mientras el Worker sirve un KV vacío y responde
HTTP 200.

Detalle latente: el workflow fija `node-version: "20"`, pero `package.json` declara
`"engines": { "node": ">=20.11" }` porque `prepare-content.ts` usa `import.meta.dirname`.
Hoy `"20"` resuelve al último 20.x y funciona; si alguna vez se pinnea a un 20.x anterior
al 20.11, el script falla con `dirname` indefinido.

Fíjate en lo que el workflow **no** valida: no compara `figuras/`, no compila LaTeX, no
verifica que el markdown siga cumpliendo los ocho bloques editoriales. Es un pipeline de
publicación, no un quality gate de contenido. El quality gate del manuscrito existe, pero
es local y hay que invocarlo a mano: `make check-content` (sección 5.2).

### Manual: todo lo demás

El PDF se compila a mano, siempre. Desde `latex-pipeline/`:

```bash
cd latex-pipeline
docker compose run --rm book make pdf
```

Los 14 targets del `Makefile`: `figures`, `pdf`, `latex`, `chapter` (con `CHAP=NN`),
`digital`, `epub`, `validate`, `check-content`, `logcheck`, `optimize`, `preview`,
`clean`, `docker-build`, `help`.

La regla de `$(BOOK_PDF)` depende de `$(ALL_FILES)`, `templates/book.tex`, el `.cls`,
`$(FILTER_FILES)` (`$(wildcard filters/*.lua)`), `$(STY_FILES)` (`$(wildcard sty/*.sty)`)
y `config.yml`. `$(BOOK_TEX)` lleva la misma lista. Es decir: tocar un filtro Lua, un
paquete de `sty/` o el `config.yml` **sí** dispara la reconstrucción, no solo editar el
markdown.

`make pdf` encadena `figures` primero y `logcheck` al final. Los tres pases de LuaLaTeX
corren como `lualatex ... > /dev/null 2>&1 || true`, así que por sí solos **siempre**
devuelven éxito, incluso con un documento roto. `logcheck` es lo único que convierte eso
en un fallo: lee `output/agentico-por-diseno.log` y aborta si encuentra errores de TeX
(`^!`), caracteres perdidos, referencias sin resolver o etiquetas duplicadas. Los overfull
hboxes se reportan pero no rompen el build, porque son cosméticos.

Escape hatch, para cuando necesitas el PDF aunque esté sucio:

```bash
docker compose run --rm book make pdf STRICT=0
```

Estado del último build en `output/`: 0 errores de TeX, 0 caracteres perdidos, 0
referencias sin resolver, 0 etiquetas duplicadas, 20 overfull hboxes, 577 páginas.

El PDF está commiteado a propósito. `.gitignore` ignora todo `latex-pipeline/output/*`
con una única excepción explícita:

```
latex-pipeline/output/*
!latex-pipeline/output/agentico-por-diseno.pdf
```

Es decir: el artefacto binario es parte del repo y hay que acordarse de regenerarlo y
commitearlo. Es el punto más fácil de olvidar de todo el sistema.

### Trampa del reader de Pandoc

`MD_FORMAT := markdown+autolink_bare_uris-tex_math_dollars`. La desactivación de
`tex_math_dollars` no es opcional: el libro tiene 991 ocurrencias de `US$` y sin esa
bandera cada `$` abre un span de matemáticas que se traga los separadores de fila de las
tablas. Causaba 31 errores de compilación. Si alguna vez cambias el formato de entrada,
mantén el `-tex_math_dollars`.

---

## 4. Dónde vive cada decisión de formato

**Manda `latex-pipeline/cls/paradigma-agentico.cls`.** Está basada en `memoir` y hardcodea
la geometría completa:

| Parámetro | Valor real | Nota |
|---|---|---|
| Stock | `\setstocksize{11in}{8.5in}` | US Letter |
| Trim | `\settrimmedsize{9.68in}{7.44in}{*}` | Crown Quarto |
| Caja de texto | `\settypeblocksize{21.0cm}{13.5cm}{*}` | alto x ancho |
| Margen interior | `\setlrmargins{2.2cm}{*}{*}` | gutter |
| Margen superior | `\setulmargins{1.8cm}{*}{*}` | |
| Margen exterior | ~3.2cm | calculado: 18.9cm de trim - 2.2 - 13.5 |
| Cuerpo | `\LoadClass[10pt,openright,final]{memoir}` | 10pt |
| Interlineado | `\setSingleSpace{1.15}` | 115% |

La clase también define `\partdivider`, `\notespage` y `\chapterminitoc`, que los filtros
Lua inyectan como `RawBlock`.

**`config.yml` es casi todo letra muerta.** Se pasa con `--metadata-file`, pero
`templates/book.tex` solo interpola tres variables en todo el fichero: `$book.date$`,
`$classoption$` y `$body$`. Todo lo demás está escrito literal en el template o
hardcodeado en el `.cls`.

Estas son todas las claves que quedan hoy en el fichero:

| Clave de `config.yml` | ¿Se usa? | Quién manda de verdad |
|---|---|---|
| `book.date` | **Sí** | `templates/book.tex` |
| `figure-mode` | **Sí** | `filters/figure-transform.lua` lo lee de `meta` |
| `book.title`, `book.tomo`, `book.subtitle`, `book.author` | No | texto literal en `templates/book.tex` (portada y portadilla) |
| `book.lang` | No | Pandoc solo reacciona a `lang` de nivel superior; el idioma se fija con babel en el `.cls` |

Las claves que antes fingían configurar el libro (`theme`, `page_size`, `mode`, `fonts:`,
`layout:`, `features:`) ya **no existen** en el fichero: se borraron, y la cabecera del
`config.yml` explica hoy qué se consume y dónde se cambia cada cosa de verdad. Lo que
queda de decorativo (`book.title`, `book.tomo`, `book.subtitle`, `book.author`,
`book.lang`) está marcado como tal con un comentario al lado.

Aun así la trampa no desaparece del todo: sigue habiendo cinco claves con pinta de
configuración que nadie lee, y **desde `config.yml` no se puede cambiar ni la geometría,
ni las fuentes, ni los colores**. Eso se edita en `cls/paradigma-agentico.cls` y en
`sty/pa-colors.sty`.

Corolario: el comando `/theme` de la skill `book-build` sigue mandando editar la línea
`theme:` de `config.yml` - una clave que ya ni siquiera existe en el fichero. Ese paso no
hace nada. La misma skill añade después la vía que sí tocaría los colores, invocar
`\setthemecorporategray` o `\setthemewarmterracotta`, pero
tampoco sirve tal como está escrita: manda ponerlas "al inicio" de `sty/pa-colors.sty`,
donde todavía no existen (son `\newcommand` de ese mismo fichero), y aunque se pusieran al
final solo redefinirían `pa-primary` .. `pa-danger`. Los colores de los callouts
(`pa-callout-*-bg` y `pa-callout-*-border`) están escritos en hexadecimal literal y ningún
switcher los toca. No hay un tema conmutable de verdad en este repo.

Sobre las opciones de clase, dos notas:

- `make digital` sí produce un PDF distinto. El `Makefile` define `PANDOC_OPTS_NOCLASS`
  (idéntico a `PANDOC_OPTS` pero sin el `-V classoption=twoside` fijo) y el target añade
  `-V classoption=twoside -V classoption=digital`. Pandoc acumula las dos y emite
  `\documentclass[twoside,digital]{paradigma-agentico}`, que activa `\ifpa@digital` en el
  `.cls` y con él los hipervínculos coloreados. La salida es
  `output/agentico-por-diseno-digital.pdf`.
- El `Makefile` pasa `--toc --toc-depth=3`, pero `book.tex` no tiene variable `$toc$`:
  llama a `\tableofcontents*` por su cuenta con `\setcounter{tocdepth}{1}`. Las dos
  banderas de Pandoc son inertes.

### La cadena de filtros

El orden importa y el orden real es el de `FILTER_CHAIN` en el `Makefile`:

```
1  meta-strip          7  callout-transform
2  figure-transform    8  table-transform
3  code-transform      9  crossref-transform
4  part-dividers      10  index-transform
5  emoji-transform    11  drop-caps
6  checkbox-transform 12  hr-transform
```

**Las cabeceras de comentario de varios `.lua` mienten sobre su posición.** Verificado:

| Fichero | Dice su cabecera | Posición real |
|---|---|---|
| `meta-strip.lua` | 1 (runs first) | 1, correcto |
| `code-transform.lua` | 2 | 3 |
| `emoji-transform.lua` | 5 | 5, correcto |
| `checkbox-transform.lua` | 4 | 6 |
| `callout-transform.lua` | 2 | 7 |
| `table-transform.lua` | 7 | 8 |
| `crossref-transform.lua` | 6 | 9 |
| `hr-transform.lua` | 7 (runs last) | 12, sí es el último |
| `part-dividers.lua` | "runs BEFORE other filters (prepended to filter chain)" | 4, corre después de otros tres |
| `drop-caps.lua` | "runs AFTER callout-transform.lua" | 11, y eso sí es cierto (callout es 7) |
| `figure-transform.lua`, `index-transform.lua` | no declaran nada | 2 y 10 |

Confía en el `Makefile`, nunca en la cabecera.

Un detalle más de esa cadena: **`drop-caps.lua` está desactivado**. Su `Pandoc(doc)`
devuelve el documento sin tocar, bajo un comentario que dice que las capitulares causaban
problemas de layout. Sigue listado en `FILTER_CHAIN` y sigue costando un paso de Pandoc,
pero no hace nada, y su propia cabecera describe un comportamiento que ya no existe. No
hay ninguna clave de `config.yml` que lo reactive: para revivirlo hay que editar el
filtro.

Los estilos viven en 6 paquetes bajo `sty/`: `pa-callouts`, `pa-codeblocks`, `pa-colors`,
`pa-diagrams`, `pa-tables`, `pa-typography`. No los carga el `.cls`: los carga
`templates/book.tex` con seis `\input{pa-*.sty}` seguidos. Un paquete nuevo en `sty/` no
entra en el build hasta que se añade ahí.

En `templates/` hay exactamente dos ficheros: `book.tex` (el template de Pandoc; solo
interpola `$classoption$`, `$book.date$` y `$body$`, todo lo demás es LaTeX literal) y
`figure-wrapper.tex` (lo usa `scripts/build-figures.sh`).

Todo esto se monta dentro del contenedor en rutas `/book/*`, definidas en
`docker-compose.yml`. El contenido y la configuración van montados **read-only**; solo
`output/` e `illustrations/` son escribibles.

---

## 5. Puntos de acoplamiento frágiles

### 5.1 La lista de capítulos existe tres veces, con tres reglas distintas

Este es el acoplamiento peligroso del repo. La identidad y el orden de los capítulos se
determinan de forma independiente en tres sitios:

**(a) `latex-pipeline/Makefile`, variable `CHAPTER_FILES`.** Lista explícita, escrita a
mano, con las 16 rutas en el orden exacto en que se concatenan. Alimenta `ALL_FILES`, que
es parte de los prerequisitos de la regla del PDF (junto con el template, el `.cls`, los
filtros Lua, los `.sty` y `config.yml`), así que `make` decide si recompilar comparando
mtimes contra ese conjunto.

Un capítulo nuevo que no esté en `CHAPTER_FILES` simplemente **no aparece en el PDF**, sin
error ni warning. Peor: como no es prerequisito de nada, `make pdf` puede darte "up to
date" después de haberlo añadido al directorio.

**(b) `mcp-server/scripts/prepare-content.ts`.** No tiene lista. Hace
`readdirSync(CHAPTERS_DIR).filter(f => f.endsWith(".md")).sort()` y lo mismo con
`apendices/`. El identificador sale del nombre del fichero con `/^(\d+[a-z]?)/`, de donde
`00_prefacio.md` da `00` y `00a_executive_brief.md` da `00a`. Los apéndices usan
`/^([A-E])/` y se convierten en `appendix-a` .. `appendix-e`.

Es decir: el MCP recoge automáticamente cualquier `.md` nuevo, y el PDF no. Divergen en
silencio. El orden coincide con el del `Makefile` hoy solo porque `.sort()` lexicográfico
sobre estos nombres da el mismo resultado (`_` es 0x5F y ordena antes que `a` de 0x61, por
eso `00_prefacio` precede a `00a_executive_brief`). Cualquier esquema de nombres nuevo
puede romper esa coincidencia sin que nada lo detecte.

**(c) `latex-pipeline/filters/part-dividers.lua`, implícitamente.** El filtro intenta
extraer el número de capítulo del texto del H1 con dos patrones: `^Capítulo%s+(%d+)` y,
si ese falla, `^Cap%.?%s*(%d+)`. Verificado sobre los 21 H1 del libro: **ninguno empieza
por "Capítulo N" ni por "Cap. N"**. Los títulos son cosas como `# El Nuevo Paradigma de la
Ingeniería de Software`. Así que ninguno de los dos acierta jamás y el filtro cae siempre
al contador secuencial `chapter_counter`, que arranca en -1 y se incrementa con cada H1.

O sea: **el número de capítulo es puramente posicional**. Sale del orden de
`CHAPTER_FILES`, no del nombre del fichero ni del título. Solo hay dos casos especiales:
`^Prefacio` fuerza `chapnum = "0"`, y `^Resumen Ejecutivo` fuerza el centinela `"-1"`, que
no empareja ninguna parte y no incrementa el contador.

De ese número posicional cuelgan dos cosas:

- **Los divisores de parte.** `part_by_chapnum` mapea 0 -> Parte I "Contexto Estratégico",
  5 -> II "Sesgos y Evidencia", 7 -> III "La Tecnología", 9 -> IV "Impacto en el Negocio",
  11 -> V "Liderazgo y Estrategia", 13 -> VI "Gobernanza y Futuro". Existe además una
  lista `part_dividers` que empareja por texto del título ("Sesgos Cognitivos",
  "Evolución Técnica", "Desafíos, Riesgos"...), pero solo se consulta cuando el número no
  está en `part_by_chapnum`, y el flag `parts_inserted` impide insertar dos veces la misma
  parte. No es una red de seguridad: el número posicional casi siempre llega primero.
- **Las etiquetas `\label{chap:%02d}`**, que es a lo que apunta `crossref-transform.lua`
  cuando convierte el texto "Capítulo 7" del manuscrito en `\hyperref[chap:07]`.

**Qué se rompe al insertar un capítulo en medio.** Digamos que metes un capítulo nuevo
entre el 06 y el 07. Todos los capítulos posteriores se desplazan una posición, así que:

1. `\label{chap:07}` deja de estar en el capítulo que el texto llama "Capítulo 7". Los
   `\hyperref` siguen resolviendo (la etiqueta existe) pero apuntan al capítulo
   equivocado. `logcheck` no lo detecta: no hay referencias sin resolver, hay referencias
   correctamente resueltas hacia el sitio erróneo.
2. Los divisores de parte se insertan antes de los capítulos equivocados, porque las
   partes III a VI están ancladas a los números 7, 9, 11 y 13.
3. El MCP server, en cambio, se reindexa solo y con los ids derivados del nombre del
   fichero, así que su numeración y la del PDF dejan de coincidir.

**Ficheros a tocar al añadir o renombrar un capítulo** (los cinco primeros son
obligatorios; sin ellos el build es incorrecto o silenciosamente incompleto):

1. El `.md` en `ingenieria_agentica/capitulos/`, con los ocho bloques editoriales.
2. `latex-pipeline/Makefile`, `CHAPTER_FILES`, en la posición correcta.
3. `latex-pipeline/filters/part-dividers.lua`, `part_by_chapnum`, si el desplazamiento
   mueve alguna frontera de parte.
4. Las referencias cruzadas textuales del manuscrito ("Capítulo N") en todos los capítulos
   afectados.
5. El pie `*Fin del Capítulo X*` y su navegación en el capítulo anterior y el nuevo.
6. `ingenieria_agentica/BOOK_MASTER.md` (tabla y conteo).
7. `CLAUDE.md` (árbol de ficheros).
8. `capitulos/00_prefacio.md` (rutas de lectura) y `capitulos/00a_executive_brief.md`
   (tabla de navegación).

`mcp-server/` no requiere ningún cambio: se entera solo. Esa asimetría es exactamente la
que hace que se olvide el resto.

### 5.2 `make check-content`: el quality gate del manuscrito

`latex-pipeline/scripts/validate.sh` no es lo que corre `make validate`; ese target del
`Makefile` depende de `latex` y luego cuenta `\hyperref` en el `.tex` y hace greps sobre el
`.log`. El script tiene su propio target: **`make check-content`**, que lo invoca dentro
del contenedor.

Lo que comprueba, en tres bloques:

1. **Fuentes.** Que existan los 16 capítulos (lista explícita `00 00a 01 .. 14`) y los 5
   apéndices (`A B C D E`), y avisa de cualquier `.md` en `capitulos/` cuyo prefijo no
   esté en esa lista. Cuenta palabras, blockquotes y filas de tabla, y busca bloques de
   código y marcadores de placeholder. El chequeo de "sin código" excluye los bloques
   `` ```{=latex} ``, que son LaTeX crudo de maquetación y no ejemplos de programación.
2. **Salida del build.** Lee `output/agentico-por-diseno.log` y el PDF: overfull y
   underfull hboxes contra umbrales, referencias sin resolver, problemas de fuentes y
   número de páginas.
3. **Efectividad de los filtros.** Sobre el `.tex`: entornos de callout, divisores de
   parte (espera exactamente 6), referencias cruzadas, checkboxes, iconos FontAwesome y
   separadores.

Detecta la disposición del repo por sí solo: dentro del contenedor el manuscrito está
montado en `/book/content`, y en el host vive en `../ingenieria_agentica`. El script
prueba las dos.

Ejecución medida hoy: recorre entero, valida los 16 capítulos y los 5 apéndices, reporta
142,097 palabras, 6 divisores de parte, 577 páginas, 0 referencias sin resolver, y sale
con código 0 dejando **1 warning** (13 marcadores de code fence que no son `{=latex}`).
Sale con `exit $ERRORS`, así que los warnings informan pero no rompen; los ficheros
ausentes sí.

Ojo con la asimetría que queda: `check-content` es **local y manual**. El workflow de CI
no lo llama, así que un push puede desplegar el KV sin que nadie haya pasado el gate.

### 5.3 `crossref-transform.lua` no conoce el apéndice E

El patrón de apéndices es `([Aa]péndice)%s+([A-D])`. Cualquier "Apéndice E" en el texto se
queda sin hipervínculo. La etiqueta `\label{app:E}` **sí** se genera (`part-dividers.lua`
usa la lista `A B C D E F`), así que no es una referencia rota, solo un enlace que nunca
se crea. Silencioso.

### 5.4 El PDF commiteado puede quedar viejo

Ya descrito en la sección 3. No hay ningún check que lo detecte. La única defensa es el
hábito: si tocaste markdown y vas a hacer push, recompila.

---

## 6. Estado del sistema de figuras: construido, cero uso

La infraestructura está completa y funciona. No se usa.

- `ingenieria_agentica/figuras/manifest.yml` registra **46 figuras**, con `caption`,
  `label`, `chapter`, `tier`, `complexity` y un `todo` descriptivo para cada una.
- **Las 46 están en `status: placeholder`.** Ninguna en `draft`, ninguna en `final`.
- Los directorios `figuras/tikz/` y `figuras/svg/` están **vacíos**.
- El manuscrito tiene **cero** ocurrencias de la sintaxis `![](fig:id)`. Ni una.
  (Esa es la sintaxis correcta y la única: Pandoc solo construye una `Image` cuando el
  destino va entre paréntesis, así que el viejo `![fig:id]` que circuló en algunos
  comentarios de cabecera se queda como texto literal y nunca llega al filtro.)

Es decir: `figure-transform.lua` (filtro #2) se ejecuta en cada build y no encuentra nada
que transformar, y el target `figures` del `Makefile` reporta que no hay fuentes de figuras
y sigue adelante, porque su guarda comprueba si existen `figuras/tikz/*.tex` o
`figuras/svg/*.svg` antes de llamar a `scripts/build-figures.sh`.

El ciclo de vida previsto es `placeholder -> draft -> final`, y `figure-mode` en
`config.yml` (`all` | `final-only` | `no-placeholders`) controla qué se renderiza. Esa
clave sí se lee de verdad, desde `figure-transform.lua`.

Para activar el sistema hacen falta dos cosas que hoy no existen: fuentes en `tikz/` o
`svg/`, y referencias `![](fig:id)` insertadas en el markdown. Hasta entonces, es
infraestructura lista, no una funcionalidad.

Nota arquitectónica: las figuras son, hoy por hoy, exclusivas de la rama del PDF. El MCP
server no lee `manifest.yml` ni sabe que existe. El día que el manuscrito incluya
`![](fig:id)`, esa cadena aparecerá literal en las secciones que sirve la API, igual que
ocurre ya con los spans `{.idx}`. Detalles en
[figuras-e-indice.md](figuras-e-indice.md).

---

## 7. El índice analítico, en una nota

A diferencia de las figuras, el índice sí está en uso: hay **290** spans `[término]{.idx}`
en el manuscrito, que `index-transform.lua` (#10) convierte en `\index{}` e `imakeidx`
compone. Arquitectónicamente lo relevante es que **vive solo en la rama del PDF**: el MCP
server ignora por completo la sintaxis `.idx` y sirve esos spans como texto crudo dentro
del markdown de la sección. No hay búsqueda por índice en la API.

Detalles de uso en [figuras-e-indice.md](figuras-e-indice.md).

---

## 8. El MCP server en detalle

Worker de Cloudflare llamado `agentico-mcp`, servido en `book-mcp.touma.io` como
custom domain.

- Endpoint MCP: `/mcp`. El `fetch` acepta también `/mcp/` y reescribe la ruta a `/mcp`
  antes de delegar, porque el handler del SDK empareja la ruta exacta. `/` y `/health`
  devuelven información de salud en JSON.
- Durable Object `BookMCP` (binding `MCP_OBJECT`, migración `v1` con
  `new_sqlite_classes`). El handler se construye una sola vez con
  `BookMCP.serve("/mcp")`.
- KV binding `BOOK_KV`.
- 5 tools: `search`, `read_chapter`, `get_toc`, `get_glossary`, `get_frameworks`.

Contenido en KV, medido sobre `kv-data.json`: **295 entradas** = 21 `chapters:` (16
capítulos + 5 apéndices) + 270 `sections:` + `glossary` + `frameworks` + `toc` +
`search-index`. El glosario tiene 91 términos y hay 12 frameworks.

`prepare-content.ts` parte cada fichero por encabezados `##`. Todo lo que va antes del
primer `##` cae en una sección sintética llamada `Introduccion` con slug `intro`. El
glosario se extrae de `A_glosario.md` buscando líneas que sean exactamente `**Término**`,
y los frameworks de `B_frameworks_decision.md` por sus H2 **numerados** (`/^##\s+(\d+\.\s+.+)/`),
que es lo que los distingue de las secciones de cierre del apéndice.

Consecuencia editorial: **cambiar un encabezado `##` cambia su slug**, y con él la clave
KV `sections:<cap>:<slug>`. Cualquier cosa que hubiera guardado el slug viejo deja de
resolver. El `bulk put` no borra claves obsoletas, así que las secciones renombradas dejan
huérfanas las anteriores en el namespace hasta que se limpien a mano.

Scripts npm: `dev`, `typecheck`, `check`, `deploy`, `prepare-content`, `upload-kv`,
`cf-typegen`. `typecheck` corre dos veces `tsc`: `tsconfig.json` para `src/` y
`tsconfig.scripts.json` para `scripts/`.

Para probar la generación de KV sin desplegar nada:

```bash
cd mcp-server
npm run prepare-content
```

Escribe `mcp-server/kv-data.json` en local y no toca Cloudflare.

---

## 9. Por qué esta separación, y cuándo dejaría de servir

La separación es deliberada y se sostiene sobre un principio: **el markdown es la única
fuente y ninguno de los dos consumidores puede modificarlo**. `latex-pipeline/` lo monta
read-only en Docker (`../ingenieria_agentica:/book/content:ro`). `mcp-server/` solo lo lee
con `readFileSync`. Ninguno genera markdown, ninguno lo reescribe.

Eso compra tres cosas concretas:

1. **Ciclos de vida distintos.** El PDF se publica por versión; el KV se publica por
   commit. Acoplarlos obligaría al ciclo lento a gobernar al rápido, o a meter LuaLaTeX en
   CI para un artefacto que casi nadie necesita en cada push.
2. **Dependencias que no se contaminan.** El pipeline de LaTeX vive entero dentro de una
   imagen Docker basada en `pandoc/extra`; el Worker vive en Node y Wrangler. No comparten
   ni un paquete.
3. **Fallos aislados.** Un error de TeX no impide desplegar el MCP. Una caída de
   Cloudflare no impide compilar el libro.

Lo que se paga a cambio es la consistencia: los dos artefactos pueden divergir y nada lo
detecta. Ese es el trade-off, y está aceptado a conciencia.

El día que eso deje de valer la pena es el día en que las figuras entren en uso de verdad,
porque entonces habrá un artefacto derivado (`figuras/pdf/`, hoy ignorado por git) que sí
tendrá que estar sincronizado entre las dos ramas del flujo, y el "no se hablan" empezará
a costar más de lo que ahorra.

---

## 10. Afirmaciones falsas que siguen vivas en el código

Estas no están en la documentación, están en el propio código, así que no se arreglan
editando un README. Verificadas hoy:

| Dónde | Afirma | Realidad medida |
|---|---|---|
| Cabeceras de `code-transform`, `checkbox-transform`, `callout-transform`, `table-transform`, `crossref-transform`, `hr-transform` | posiciones 2, 4, 2, 7, 6, 7 | 3, 6, 7, 8, 9, 12 (sección 4) |
| Cabecera de `part-dividers.lua` | "runs BEFORE other filters (prepended to filter chain)" | es el filtro 4 de 12 (sección 4) |
| Cabecera de `drop-caps.lua` | describe cómo aplica capitulares `\lettrine` | el filtro está desactivado: `Pandoc(doc)` devuelve `doc` intacto (sección 4) |
| `config.yml`: `book.title`, `book.tomo`, `book.subtitle`, `book.author`, `book.lang` | describen el libro | nadie las lee; el fichero las marca ya como decorativas (sección 4) |
| `Makefile`, `--toc --toc-depth=3` | genera el índice | `book.tex` llama a `\tableofcontents*` con `tocdepth 1`; las banderas son inertes |
| Skill `book-build`, comando `/theme` | cambia el tema vía `config.yml`, o invocando un switcher "al inicio" de `pa-colors.sty` | la clave `theme` ya ni existe en `config.yml`, y el switcher al inicio del fichero se usaría antes de definirse; los colores de callout no los cambia ningún switcher (sección 4) |
| `crossref-transform.lua` | enlaza apéndices | solo `[A-D]`; el E queda sin enlace (sección 5.3) |

---

## 11. Referencia rápida de rutas

```
book/
├── .claude/skills/<nombre>/SKILL.md   5 skills, 27 comandos en total
├── .github/workflows/deploy-mcp.yml   único pipeline automatizado
├── ingenieria_agentica/               FUENTE DE VERDAD
│   ├── capitulos/                     16 .md
│   ├── apendices/                     5 .md
│   ├── figuras/manifest.yml           46 figuras, todas placeholder
│   └── BOOK_MASTER.md
├── latex-pipeline/                    markdown -> PDF (manual)
│   ├── cls/paradigma-agentico.cls     manda toda la geometría
│   ├── sty/                           6 paquetes
│   ├── filters/                       12 filtros Lua, el orden importa
│   ├── templates/                     book.tex, figure-wrapper.tex
│   ├── scripts/                       build-figures.sh, validate.sh (make check-content)
│   ├── fonts/                         LibertinusSerif, LibertinusSans, FiraMono
│   ├── illustrations/                 chapter-headers/, icons/, part-dividers/
│   ├── output/agentico-por-diseno.pdf commiteado a propósito
│   ├── Makefile  Dockerfile  docker-compose.yml
│   └── config.yml                     solo book.date y figure-mode se leen
├── mcp-server/                        markdown -> KV -> MCP (automático)
│   ├── src/index.ts                   Worker + Durable Object BookMCP
│   ├── scripts/prepare-content.ts     lee el directorio, no una lista
│   └── wrangler.jsonc                 id de KV, custom domain
├── docs/                              arquitectura, build, pipeline-latex,
│                                      figuras-e-indice
├── CLAUDE.md  README.md  CONTRIBUTING.md  LICENSE
└── .gitignore  .gitattributes
```

La licencia es Unlicense (dominio público) y cubre tanto el código como el contenido del
libro. Es una decisión tomada y confirmada, declarada en la página de créditos del PDF.
