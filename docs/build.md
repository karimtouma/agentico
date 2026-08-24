# Compilar el libro

Guía de compilación de *Agéntico por Diseño, Tomo I*. Todo lo que sigue está
verificado contra `latex-pipeline/Makefile`, `docker-compose.yml` y la última
corrida real del build.

---

## 1. Prerequisitos

**Docker Desktop corriendo. Nada más.**

Pandoc 3.9, LuaHBTeX (TeX Live 2025), los paquetes TeX (`memoir`, `tcolorbox`,
`tabularray`, `imakeidx`, `lettrine`, `marginnote`...) y las fuentes viven
dentro de la imagen, definida en `latex-pipeline/Dockerfile` sobre la base
`pandoc/extra`. No instales TeX Live en tu máquina: no se usa.

Comprobación previa:

```bash
docker info
```

La primera vez que corras cualquier target, `docker compose` construye la imagen
sola: descarga `pandoc/extra`, corre varios `tlmgr install` y regenera la caché
de fuentes. Son ~1.7 GB y varios minutos. A partir de ahí cada corrida arranca
en segundos.

---

## 2. El comando

Se corre **desde `latex-pipeline/`**, que es donde vive `docker-compose.yml`:

```bash
cd latex-pipeline
docker compose run --rm book make pdf
```

Salida esperada:

```
  [figures] No figure sources found (OK ... using placeholders)
══════════════════════════════════════════════
  Building: Agéntico por Diseño, Tomo I (PDF)
══════════════════════════════════════════════
  [1/5] Generating LaTeX source...
  [2/5] LuaLaTeX pass 1 (generating .idx + .aux)...
  [3/5] Building analytical index...
  [4/5] LuaLaTeX pass 2 (resolving refs + index)...
  [5/5] LuaLaTeX pass 3 (final pagination)...

✓ PDF generated: /book/output/agentico-por-diseno.pdf
  Size: 2.1M

  ── Build health ──────────────────────────
    TeX errors               0
    Missing characters       0
    Undefined references     0
    Multiply-defined labels  0
    Overfull hboxes          20

  ✓ Build is clean (overfull boxes are cosmetic).
```

El resultado queda en `latex-pipeline/output/agentico-por-diseno.pdf`:
577 páginas, 1,902,965 bytes (la línea `Size:` reporta 2.1M porque `du -h`
mide bloques en disco, no el tamaño del archivo). Ese PDF está commiteado a
propósito para que cualquiera lo descargue sin compilar: es la única excepción
al `.gitignore` de `output/`.

### El bloque "Build health"

Lo imprime el target `logcheck`, que corre automáticamente al final de
`make pdf`. Las cinco métricas salen de contar patrones en
`output/agentico-por-diseno.log`:

| Métrica | Qué cuenta en el log | Aceptable | Si es distinta de cero |
|---|---|---|---|
| TeX errors | Líneas que empiezan con `!` | **0** | El documento está roto. El build falla. |
| Missing characters | `Missing character` | **0** | La fuente no tiene ese glifo y el carácter sale **invisible** en el PDF. Suele ser un emoji o un símbolo que `emoji-transform.lua` no filtró. |
| Undefined references | `undefined` | **0** | Hay un `\ref`/`\hyperref` a una etiqueta inexistente: sale `??` en el texto. Típico de un `Capítulo N` mal escrito que `crossref-transform.lua` convirtió en enlace. |
| Multiply-defined labels | `multiply defined` | **0** | Dos capítulos generan el mismo `\label{chap:NN}`. Los enlaces apuntan a cualquiera de los dos. |
| Overfull hboxes | `Overfull \hbox` | **20 hoy** | Cosmético: contenido que se sale del margen (una URL larga, una celda de tabla). No falla el build. Vale la pena revisarlo antes de mandar a imprenta, no antes de cada commit. |

Las primeras cuatro son de cero-tolerancia: si cualquiera sube, `logcheck`
imprime las líneas ofensivas y aborta con estado distinto de cero.

---

## 3. Todos los targets

Leídos de `latex-pipeline/Makefile`. Todos se invocan igual:
`docker compose run --rm book make <target>` desde `latex-pipeline/`.

| Target | Qué hace | Cuándo usarlo | Advertencias |
|---|---|---|---|
| `pdf` | El build completo: pandoc + 3 pases de LuaLaTeX + makeindex + `logcheck`. Es el default del contenedor. | Siempre que quieras el libro. | Sus prerequisitos **no** incluyen filtros ni `.sty`: ver Troubleshooting. |
| `figures` | Compila `figuras/tikz/*.tex` y `figuras/svg/*.svg` a PDF vía `scripts/build-figures.sh`. Es prerequisito de `pdf`. | Cuando agregues fuentes de figuras. | Hoy `tikz/` y `svg/` están **vacíos**, así que imprime `No figure sources found` y sigue. Las 46 figuras del `manifest.yml` están en estado `placeholder`. |
| `latex` | Solo pandoc: genera `output/agentico-por-diseno.tex` para inspección. | Para ver qué LaTeX produjeron los filtros sin esperar a LuaLaTeX. | No ejecuta LuaLaTeX, no produce PDF ni log. |
| `chapter CHAP=NN` | Compila un solo capítulo a `output/chapter-NN.pdf`. | Iterar rápido sobre un capítulo (~40 s). | Ver sección 6. |
| `digital` | Compila a `output/agentico-por-diseno-digital.pdf` pasando `-V mode=digital`. | **Ninguno, hoy.** | `-V mode=digital` define una variable de pandoc que `templates/book.tex` nunca lee, y la opción de clase `digital` (la que activa `colorlinks` en `paradigma-agentico.cls`) no la pasa ningún target: `PANDOC_OPTS` solo manda `-V classoption=twoside`. El PDF que sale es idéntico al de imprenta, con otro nombre. |
| `epub` | Exporta `output/agentico-por-diseno.epub`. | Solo para una lectura rápida en pantalla. | Degradado: los filtros emiten LaTeX crudo, que pandoc descarta al generar EPUB. Verificado en la última corrida: **0 tablas** y solo 4 de las 21 apariciones de "Resumen Ejecutivo" sobreviven. Tampoco lleva metadatos: el `.opf` sale sin `dc:title` y sin `dc:creator`, la portada dice `UNTITLED` y el idioma queda en `en-US` (`config.yml` anida todo bajo `book:`, así que pandoc nunca ve un `title` ni un `lang` de nivel superior). |
| `validate` | Imprime conteos de cross-refs, refs indefinidas, overfull/underfull y warnings. | Casi nunca: usa `logcheck`. | Depende de `latex`, que **no ejecuta LuaLaTeX**. Si el `.tex` está al día, `validate` no corre nada y hace `grep` sobre `output/*.log`, que puede ser el log de una corrida anterior o no existir. Nada en su salida indica que los números son viejos. |
| `logcheck` | Imprime el bloque "Build health" y falla si hay errores reales. | Automático tras `pdf`; a mano para releer el veredicto del último build sin recompilar. | Lee el log existente. Si no hay log, imprime `no log found - skipped` y sale con éxito. |
| `optimize` | Depende de `pdf` y luego lista overfull/underfull boxes y el total de páginas. | En teoría, para cazar problemas tipográficos. | Sus `grep` usan `'Overfull \\\\hbox'`, un patrón con dos barras literales que **nunca** aparece en el log, y el `|| echo "None found"` cuelga del `head`, que siempre sale con éxito: las tres secciones salen vacías incluso habiendo 20 overfull. Para verlos de verdad, usa el comando de la sección 7. |
| `preview` | `pdf` y luego `open` del PDF. | Nada, desde Docker. | El `open` corre **dentro del contenedor**, donde no existe: imprime el mensaje de fallback. Abre el PDF tú desde macOS. |
| `clean` | Borra `output/*.pdf`, `*.tex`, `*.log`, `*.aux`, `*.toc`, `*.idx`, `*.ind` y demás intermedios. | Cuando el build quedó en un estado raro. | **Borra también el PDF commiteado.** Recupéralo con `git restore latex-pipeline/output/agentico-por-diseno.pdf` o recompílalo. |
| `docker-build` | `docker compose build --no-cache`. | Solo tras editar el `Dockerfile`. | **Se corre en el host**, no dentro del contenedor (adentro no hay Docker). Reconstruye desde cero: tarda lo mismo que la primera vez. |
| `help` | Lista los targets. | Recordatorio rápido. | - |

---

## 4. Las cinco fases de `make pdf`

```
[1/5] pandoc      .md × 21  →  output/agentico-por-diseno.tex
[2/5] lualatex    pase 1: escribe .aux, .toc y .idx
[3/5] makeindex   .idx  →  .ind  (el índice analítico)
[4/5] lualatex    pase 2: resuelve refs y compone el índice
[5/5] lualatex    pase 3: pagina definitivo
```

Pandoc lee los 16 capítulos y los 5 apéndices con
`--from markdown+autolink_bare_uris-tex_math_dollars`, los pasa por los 12
filtros Lua de `filters/` en orden estricto y los inyecta en
`templates/book.tex`, que declara `\documentclass[twoside]{paradigma-agentico}`.

**Por qué tres pases.** LaTeX es de una sola pasada: no puede citar un número de
página que todavía no calculó.

- El **pase 1** descubre dónde queda cada capítulo, sección, etiqueta y entrada
  de índice, y lo escribe en `.aux`, `.toc` y `.idx`. En este pase las
  referencias cruzadas y la tabla de contenidos todavía no son confiables: o
  salen como `??`, o traen los números de la corrida anterior.
- `makeindex` ordena y agrupa las 290 entradas `\index{}` (de los spans
  `[término]{.idx}` del markdown) y produce el `.ind`. Es también la razón de
  que los tres pases lleven `--shell-escape` (`--pdf-engine-opt=--shell-escape`
  en `PANDOC_OPTS`): lo pide `imakeidx`.
- El **pase 2** ya tiene `.aux`, `.toc` y `.ind`, así que resuelve las
  referencias e imprime la tabla de contenidos y el índice analítico. Pero al
  insertar esas páginas, la paginación se corre.
- El **pase 3** recompone con la paginación desplazada, de modo que los números
  de página del TOC y del índice coincidan con la realidad.

Quitar el pase 3 no rompe el build: lo deja mintiendo en silencio.

---

## 5. `logcheck` y `STRICT=0`

Los tres pases de LuaLaTeX corren así:

```
lualatex --shell-escape --interaction=nonstopmode ... > /dev/null 2>&1 || true
```

Es decir: **descartan su salida y devuelven éxito pase lo que pase**. Con
`nonstopmode`, LuaLaTeX produce un PDF incluso con el documento roto. Sin nada
más, un build catastrófico terminaba con un `✓ PDF generated` alegre.

`logcheck` existe para eso: es la única cosa del pipeline que puede hacer fallar
`make pdf`. Lee `output/agentico-por-diseno.log` (el que dejó el pase 3), cuenta
las cinco métricas de la sección 2 y sale con error si alguna de las cuatro
críticas es distinta de cero, imprimiendo antes las primeras líneas ofensivas.

Escape hatch, cuando necesitas el PDF aunque esté sucio:

```bash
docker compose run --rm book make pdf STRICT=0
```

Con `STRICT=0` el diagnóstico se sigue imprimiendo completo, pero se degrada a
advertencia. Úsalo para inspeccionar el desastre, no para commitear.

---

## 6. Compilar un solo capítulo

```bash
cd latex-pipeline
docker compose run --rm book make chapter CHAP=13
```

Sale `output/chapter-13.pdf` en unos 40 segundos, contra varios minutos del
libro entero. `CHAP` es el prefijo del nombre del archivo, así que también valen
`CHAP=00`, `CHAP=00a` y `CHAP=04`.

Qué esperar de ese PDF, y por qué no sustituye al build completo:

- Las referencias a otros capítulos quedan sin resolver. Verás en consola cosas
  como `LaTeX Warning: Hyper reference 'chap:12' ... undefined`. Es normal:
  el capítulo 12 no está en ese documento.
- El índice analítico sale vacío. Pandoc compila con un jobname temporal
  (`input`), así que `imakeidx` intenta `makeindex` sobre un `input.idx` que no
  existe y aparece un `Usage: makeindex ...` cuatro veces. Ruido inofensivo.
- Aparecen también `sh: tput: not found`, `pandoc: Ticker: poll failed:
  Interrupted system call` y el aviso `Deprecated: --no-highlight`. Ruido
  inofensivo los tres.
- **No corre `logcheck`.** Aquí la compilación la maneja pandoc, no el Makefile,
  así que este target no te dice si el build está limpio. Confírmalo con
  `make pdf` antes de dar por buena una edición.

---

## 7. Troubleshooting

### Docker no está corriendo

El síntoma es un `Cannot connect to the Docker daemon ... Is the docker daemon
running?`. Abre Docker Desktop, espera a que termine de arrancar y confirma con
`docker info`.

Error distinto, causa distinta: si `docker compose` responde
`no configuration file provided: not found`, el daemon está bien y lo que pasa
es que no estás parado en `latex-pipeline/`.

### `make pdf` no recoge tus cambios

La línea de prerequisitos del Makefile es exactamente:

```make
$(BOOK_PDF): $(ALL_FILES) $(TEMPLATES)/book.tex $(CLS)/paradigma-agentico.cls
```

O sea: los 21 archivos de contenido, el template y la clase. **Nada más.**
Editar un filtro Lua, un `.sty`, `config.yml` o el propio Makefile no vuelve
obsoleto el PDF, y make se queda mirando. Verificado: tras un `touch` a
`filters/hr-transform.lua` y a `sty/pa-tables.sty`, `make -n pdf` no invoca
pandoc ni una vez; tras un `touch` a `templates/book.tex`, sí.

Peor aún: como el PDF está commiteado, un clon fresco suele tenerlo más nuevo
que el contenido, y el primer `make pdf` puede no hacer nada.

Las dos salidas:

```bash
# Forzar una recompilación conservando los intermedios (rápido)
touch templates/book.tex && docker compose run --rm book make pdf

# Empezar de cero
docker compose run --rm book make clean
docker compose run --rm book make pdf
```

Si dudas de si va a hacer algo, pregúntale antes:
`docker compose run --rm book make -n pdf`. Si no aparece ninguna línea con
`pandoc`, no va a reconstruir nada.

Ojo con `make clean`: borra `output/*.pdf`, y eso incluye el PDF que está en el
repo. Si no piensas recompilar de inmediato, recupéralo con
`git restore latex-pipeline/output/agentico-por-diseno.pdf`.

### Editaste `config.yml` y no cambió nada

Es la trampa más cara del repo. `--metadata-file=$(CONFIG)` sí carga el archivo,
pero de todas sus claves solo dos llegan a alguna parte:

- **`figure-mode`** (`all` | `final-only` | `no-placeholders`), que lee
  `filters/figure-transform.lua` para decidir si dibuja los placeholders.
- **`book.date`**, la única que interpola `templates/book.tex` (`$book.date$`):
  aparece en la portada, en la página de créditos y en `\date{}`.

Todo lo demás es letra muerta:

| Clave | Quién manda de verdad |
|---|---|
| `theme`, `page_size`, `mode` | Nadie las lee. El color y el formato están fijos en `cls/paradigma-agentico.cls`. |
| `fonts:`, `layout:` | El `.cls`: stock 11in × 8.5in, trim 9.68in de alto × 7.44in de ancho, caja 21.0cm × 13.5cm, interior 2.2cm, superior 1.8cm, cuerpo 10pt Libertinus Serif, interlineado 1.15. Cambiar `layout.margin_inner` no mueve un margen. |
| `features:` | No aparece en ningún filtro, ni en el `.cls`, ni en el template. |
| `book.title`, `book.tomo`, `book.subtitle`, `book.author` | Están escritos a mano dentro de `templates/book.tex`. |
| `book.lang` | El `.cls`, con `\RequirePackage[spanish,es-tabla]{babel}`. |

Así que: para tocar el formato físico o los colores, edita el `.cls`; para el
título, el subtítulo o el autor, `templates/book.tex`. Ambos sí son prerequisitos
del PDF, así que `make` los detecta. `config.yml` no lo es: aunque lo edites para
cambiar `figure-mode` o `book.date`, `make pdf` puede decidir que no hay nada que
hacer. Fuérzalo como se describe arriba.

### El build falla con errores de TeX

`logcheck` ya imprime las primeras líneas del problema. El log completo está en
`latex-pipeline/output/agentico-por-diseno.log` y es del **último** pase, así
que refleja el estado final:

```bash
cd latex-pipeline
grep -n -A5 '^!' output/agentico-por-diseno.log | head -60   # el error y su contexto
grep -n 'Missing character' output/agentico-por-diseno.log | head
grep -n 'undefined' output/agentico-por-diseno.log | head
grep -n 'Overfull \\hbox' output/agentico-por-diseno.log | head -20
```

Los errores de TeX apuntan a números de línea de
`output/agentico-por-diseno.tex`, no del markdown. Abre ese `.tex` en la línea
indicada y de ahí reconoces el capítulo. Si el LaTeX generado se ve mal, el
culpable casi siempre es un filtro Lua, no LuaLaTeX: regenera solo el `.tex` con
`make latex` e itera contra él, que tarda segundos.

### Un `$` en el texto rompe las tablas

El reader de pandoc está fijado en el Makefile como fuente única de verdad:

```make
MD_FORMAT := markdown+autolink_bare_uris-tex_math_dollars
```

El libro no tiene matemáticas, pero sí 991 apariciones de `US$` (más un `R$`).
Con `tex_math_dollars` activo, cada `$` de un precio abre un span de matemáticas
que se cierra en el siguiente `$` del documento, tragándose todo lo que hay en
medio, incluidos los separadores de fila de las tablas. El resultado son celdas
corruptas y una cascada de errores de TeX difíciles de rastrear hasta su causa.

Si algún día alguien "limpia" ese `-tex_math_dollars`, el síntoma será
exactamente ese. No lo quites. Y no escribas `$` pelado en el contenido: la
moneda se escribe siempre `US$` (para un lector latinoamericano, `$` es su
moneda local).

### `make digital` produce el mismo PDF que el de imprenta

No es tu instalación. `paradigma-agentico.cls` define la opción de clase
`digital` (activa `colorlinks` y bookmarks abiertos), pero ningún target la
pasa: `PANDOC_OPTS` solo manda `-V classoption=twoside`. El `-V mode=digital`
del target define una variable que el template ignora. Arreglarlo sería agregar
`-V classoption=digital` a ese target.

### `make optimize` lista las tres secciones vacías

Hay 20 overfull hboxes y aun así imprime tres encabezados sin nada debajo: es
el bug de escape de barras descrito en la tabla, no un documento perfecto. Lo
único confiable de ese target es el `Total pages`. Usa los `grep` de arriba
sobre el log.

### La imagen quedó vieja

Si editaste el `Dockerfile` (por ejemplo para agregar un paquete de TeX Live),
`docker compose run` **no** la reconstruye sola:

```bash
cd latex-pipeline
docker compose build --no-cache
```

Este es el único target que **no** se corre dentro del contenedor: `make
docker-build` invoca `docker compose build`, y adentro no hay Docker. Córrelo
en el host (`make docker-build` desde `latex-pipeline/`) o usa directamente el
comando de arriba.

Y recuerda que `--rm` destruye el contenedor al terminar: instalar algo a mano
dentro de una corrida no deja rastro en la siguiente.

---

## 8. Dónde queda cada cosa

Todo lo generado vive en `latex-pipeline/output/`, montado read-write en el
contenedor como `/book/output`. El único otro montaje de escritura es
`./illustrations` (donde `build-figures.sh` deja las figuras compiladas y su
caché). Los demás (`../ingenieria_agentica` como `/book/content`,
`../ingenieria_agentica/figuras`, `Makefile`, `cls`, `sty`, `filters`,
`templates`, `config.yml`, `scripts`, `fonts`) van con `:ro`: el build no puede
tocar el manuscrito ni el pipeline.

| Archivo | Qué es | ¿Commiteado? |
|---|---|---|
| `agentico-por-diseno.pdf` | El libro, 577 páginas | **Sí**, excepción explícita del `.gitignore` |
| `agentico-por-diseno.tex` | LaTeX intermedio (~1.2 MB), lo que ven los errores | No |
| `agentico-por-diseno.log` | Log del último pase de LuaLaTeX; la fuente de `logcheck` | No |
| `.aux` / `.toc` | Referencias y tabla de contenidos entre pases | No |
| `.idx` / `.ind` / `.ilg` | Entrada, salida y log de `makeindex` | No |
| `chapter-NN.pdf` | Salida de `make chapter` | No |
| `agentico-por-diseno-digital.pdf`, `.epub` | Salidas de `digital` y `epub` | No |
| `_codeNNN.vrb` | Temporales de los entornos de código | No |

`make clean` borra todos esos, el PDF del repo incluido.

---

## 9. Ver también

- [`docs/pipeline-latex.md`](pipeline-latex.md) - la cadena de 12 filtros Lua, los
  paquetes de `sty/` y la clase `paradigma-agentico`.
- [`docs/figuras-e-indice.md`](figuras-e-indice.md) - el `manifest.yml` de figuras
  y la convención `[término]{.idx}` del índice analítico.
- [`docs/arquitectura.md`](arquitectura.md) - cómo encajan manuscrito, pipeline y
  servidor MCP.
- [`CONTRIBUTING.md`](../CONTRIBUTING.md) - las reglas de contenido que el build
  da por hechas.
