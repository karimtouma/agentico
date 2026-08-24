# Figuras e Índice Analítico

Dos convenciones de markup propias de este libro que no existen en markdown estándar.
Ambas las resuelven filtros Lua del pipeline: `figure-transform.lua` (posición 2 de la
cadena) e `index-transform.lua` (posición 10). Fuera de este pipeline, ambas sintaxis
son texto muerto.

| Sistema | Estado hoy | Uso en el manuscrito |
|---------|-----------|----------------------|
| Figuras | Infraestructura completa, sin activar | 0 referencias |
| Índice analítico | Activo y en el PDF | 290 marcas en el markdown, 279 llegan al PDF (ver 2.4) |

---

## Parte 1 - Sistema de figuras

### 1.1 El manifiesto

Todas las ilustraciones se declaran en `ingenieria_agentica/figuras/manifest.yml`, bajo
una única clave raíz `figures:`. El id de la figura es la clave del mapa (2 espacios de
indentación); los campos van a 4 espacios.

| Campo | Obligatorio | Valor por defecto en el filtro | Qué hace |
|-------|-------------|-------------------------------|----------|
| `source` | no | `nil` | Ruta al fuente (`tikz/*.tex` o `svg/*.svg`), o `null`. **Se parsea pero nunca se usa al renderizar** (ver 1.8). |
| `status` | sí | `placeholder` | `final` \| `draft` \| `placeholder`. Decide qué se dibuja. |
| `caption` | sí | `""` | Pie de figura, en español. |
| `label` | sí | `fig:<id>` | Etiqueta LaTeX para referencias cruzadas. |
| `chapter` | sí | `""` | Capítulo donde aparece. Solo informativo: se imprime dentro del recuadro de placeholder. Nadie lo valida. |
| `width` | no | `\textwidth` | Ancho LaTeX. Ojo con el escapado (ver 1.8). |
| `tier` | no | `3` | Prioridad: 1 imprescindible, 2 alto valor, 3 complementaria. |
| `complexity` | no | `medium` | `low` \| `medium` \| `high`. Se traduce a baja/media/alta en el recuadro. |
| `todo` | solo placeholders | `""` | Bloque literal (`todo: |`) con la descripción para quien dibuje la figura. Solo las **4 primeras líneas** llegan al PDF. |

Una entrada real, copiada tal cual del fichero:

```yaml
  evolucion-codigo-ia:
    source: null
    status: placeholder
    caption: "Evolucion del porcentaje de codigo generado por IA (2022-2025)"
    label: fig:evolucion-codigo-ia
    chapter: "00"
    width: "0.75\\textwidth"
    tier: 3
    complexity: low
    todo: |
      Grafica de barras verticales con 4 barras:
      - 2022: ~0% (gris claro)
      - 2023: ~8% (gris)
      - 2024: ~18% (azul claro)
      - 2025: ~30% (navy)
      Fuente al pie: GitHub Copilot Research, Gartner 2025
```

Reparto actual de las 46 entradas:

| Dimensión | Reparto |
|-----------|---------|
| `status` | 46 `placeholder`, 0 `draft`, 0 `final` |
| `source` | 46 `null` |
| `tier` | 10 tier 1, 24 tier 2, 12 tier 3 |
| `complexity` | 6 low, 24 medium, 16 high |
| `chapter` | Valores `"00"` a `"14"`: entre 2 y 4 figuras por capítulo. Ninguna asignada a `00a`. |

El parser de YAML es propio: unas 115 líneas de patrones de Lua dentro de
`figure-transform.lua` (la función `parse_manifest`, líneas 18-132). **No es YAML de
verdad.** Solo entiende la forma exacta descrita arriba: clave a 2 espacios, campos a 4
espacios, `todo: |` como único bloque multilínea.
Anclas, listas, comillas anidadas o cualquier otra indentación se ignoran en silencio.

El filtro prueba tres rutas, en orden, y se queda con la primera de la que consiga
extraer al menos una figura:

1. `/book/content/figuras/manifest.yml` (la que gana dentro de Docker)
2. `/book/figuras/manifest.yml`
3. `../ingenieria_agentica/figuras/manifest.yml` (relativa al cwd, útil para probar el
   filtro a mano desde `latex-pipeline/`)

Si ninguna abre, el filtro avisa por stderr y **todas** las referencias de figura se
convierten en marcas rojas de error dentro del PDF.

### 1.2 La sintaxis, y por qué la documentada no funciona

El manifiesto y el `CLAUDE.md` anuncian la sintaxis `![fig:id]`. **Con el pandoc de este
pipeline eso no produce una figura: produce texto literal.** `![texto]` sin paréntesis
es una imagen de referencia, y sin su definición `[texto]: ...` pandoc la deja como los
caracteres `![fig:id]`. Comprobado con pandoc 3.8.3 y la cadena de filtros real:

```
!{[}fig:evolucion-codigo-ia{]}
```

El filtro engancha `Para` y exige que el párrafo contenga **un único elemento `Image`**
cuyo `src` empiece por `fig:`. La única forma de markdown que produce eso es la imagen
con destino y **alt vacío**:

```markdown
![](fig:evolucion-codigo-ia)
```

Sola en su párrafo, sin texto alrededor. Con alt no vacío (`![Algo](fig:id)`) pandoc 3
construye un nodo `Figure`, no un `Para` con `Image` dentro, el filtro no lo ve, y el
resultado es un `\includegraphics{fig:id}` roto que hace fallar la compilación.

Consecuencia práctica: el código del filtro que sobrescribe el pie con el alt text
(`if alt_text ~= "" and alt_text ~= "fig:"..id then render.caption = alt_text`) es
inalcanzable con pandoc 3. **El pie siempre sale del manifiesto.**

Si el id no está en el manifiesto, el filtro escribe un aviso a stderr, cuenta un
`missing`, e inserta en el PDF un párrafo en rojo `pa-danger`. El texto exacto es
`[FIGURE MISSING: fig:<id>`, un em dash, `not in manifest]`. No aborta el build. (De
paso: ese em dash está codificado a fuego en el filtro e incumple la regla tipográfica
del proyecto, aunque solo se ve cuando una referencia ya está rota.)

### 1.3 Los tres estados y cómo se dibuja cada uno

`placeholder -> draft -> final`. Cada estado tiene su propia función de render en
`figure-transform.lua`:

| Estado | LaTeX generado | Aspecto en el PDF |
|--------|----------------|-------------------|
| `final` | `figure` + `\includegraphics[width=<width>]{/book/illustrations/fig-<id>.pdf}` + `\caption` + `\label` | Figura normal. |
| `draft` | Idéntico a `final`, pero el pie va precedido de `{\color{pa-warning}\textsc{[borrador]}}` | Figura normal con distintivo naranja `[BORRADOR]` delante del pie. |
| `placeholder` | `figure` que envuelve un `tcolorbox` gris (`pa-callout-neutral-bg` / `pa-callout-neutral-border`, `arc=2mm`, `boxrule=0.5pt`) con título `\faImage` + el caption, cuerpo en cursiva con las 4 primeras líneas del `todo`, y un pie de caja con complejidad, tier y capítulo | Recuadro visible que dice "Figura pendiente" y describe qué falta dibujar. Igualmente lleva `\caption` y `\label`, así que numera y se puede referenciar. |

Los tres estados emiten `\label`, de modo que un `\ref` a una figura pendiente resuelve
y no rompe `logcheck`.

Al terminar, el filtro imprime en stderr un resumen del tipo
`[figure-transform] Summary: N final, N draft, N placeholder, N missing (mode: all)`.
Es la forma rápida de comprobar qué se renderizó realmente.

### 1.4 `figure-mode`: la única clave viva de config.yml

`latex-pipeline/config.yml` es casi todo letra muerta (el `.cls` codifica a fuego
tipografía, márgenes y tamaño). **`figure-mode` es la excepción**, y sí surte efecto: el
Makefile pasa `--metadata-file=$(CONFIG)`, con lo que la clave raíz `figure-mode` entra
como metadato del documento, y la función `Meta` del filtro la lee.

| Valor | Efecto |
|-------|--------|
| `all` (valor actual) | Dibuja los tres estados. |
| `final-only` | Solo dibuja `final`. `draft` y `placeholder` desaparecen del PDF. |
| `no-placeholders` | Dibuja `final` y `draft`. Solo desaparecen los `placeholder`. |

Comprobado ejecutando el filtro con cada valor: el contador de `placeholder` del resumen
cae a 0 en `final-only` y en `no-placeholders`. Nótese que las figuras suprimidas se
sustituyen por un bloque LaTeX **vacío**: no dejan hueco, pero tampoco emiten `\label`,
así que si alguien escribe un `\ref` a una figura suprimida obtendrá una referencia sin
resolver y `logcheck` hará fallar el build. Las figuras `missing` (id no registrado)
siguen apareciendo en rojo en cualquier modo.

Se puede forzar el modo sin tocar `config.yml` añadiendo `-M figure-mode=final-only` a
la invocación de pandoc.

### 1.5 Compilación de los fuentes

`make figures` (que `make pdf` ejecuta antes que nada) mira si hay algún `.tex` en
`figuras/tikz/` o algún `.svg` en `figuras/svg/`. Si no hay nada, imprime
un aviso `[figures] No figure sources found` y sigue con los placeholders. Si hay algo,
llama a `scripts/build-figures.sh`.

Rutas dentro del contenedor:

| Origen | Herramienta | Destino |
|--------|-------------|---------|
| `/book/figuras/tikz/<n>.tex` | `lualatex --shell-escape` sobre `templates/figure-wrapper.tex` | `/book/illustrations/<n>.pdf` |
| `/book/figuras/svg/<n>.svg` | `rsvg-convert -f pdf` | `/book/illustrations/<n>.pdf` |

`figure-wrapper.tex` es un `standalone[tikz,border=2mm]` que carga Libertinus Serif y
Sans desde `/book/fonts/`, define los colores `pa-*` del libro (12 básicos más 6 de callout), carga `fontawesome5`,
las librerías TikZ `arrows.meta, positioning, shapes.geometric, calc,
decorations.pathreplacing`, y nueve estilos ya listos: `agentbox`, `agentbox-wide`,
`orchbox`, `humanbox`, `processbox`, `decisionbox`, `layerbox`, `diagramarrow`,
`quadaxis`, más el comando `\boxtitle{}`. El script sustituye el marcador
`FIGURE_FILE` por la ruta del fuente y compila en un directorio temporal. **Tu fichero
TikZ no debe llevar preámbulo ni `\begin{document}`: solo el `\begin{tikzpicture}`**,
porque el wrapper lo mete con `\input`.

Caché: para cada fuente se calcula `md5sum` y se guarda en
`/book/illustrations/.cache/<n>.md5`. Si el PDF existe y el hash coincide, se salta la
compilación (`✓ <n> (cached)`). El script nunca aborta el build: si una figura falla,
imprime `FAILED`, incrementa un contador de errores y sigue, para que el libro se pueda
compilar con placeholders.

`latex-pipeline/illustrations/*.pdf` y `illustrations/.cache/` están en `.gitignore`:
los PDF de figura son artefactos, no fuente. Lo que se versiona es el `.tex` o el `.svg`.

### 1.6 Estado real del sistema

Sin adornos:

- 46 figuras registradas en el manifiesto.
- Las 46 en `status: placeholder`, las 46 con `source: null`.
- `ingenieria_agentica/figuras/tikz/` y `figuras/svg/` están **vacíos**.
- El manuscrito (`capitulos/` + `apendices/`) contiene **cero** referencias de figura:
  ni `![fig:...]` ni la forma que sí funciona, `](fig:...)`.
- La cadena `![fig:` sí aparece en el repositorio, pero **solo en documentación y
  comentarios**: la cabecera del manifiesto, las líneas 4 y 276 de
  `figure-transform.lua`, `CLAUDE.md`, `README.md`, `CONTRIBUTING.md`,
  `BOOK_MASTER.md` y los ficheros de `docs/`. En el texto del libro, nada.
- `ingenieria_agentica/figuras/` tiene además un directorio `pdf/` vacío que ningún
  script mira. No pongas nada ahí: los PDF compilados de figura viven en
  `latex-pipeline/illustrations/`.
- Por tanto el PDF de 577 páginas **no contiene ninguna figura**, ni siquiera un
  recuadro de placeholder.

Es infraestructura terminada y probada, esperando su primer uso. No es una
funcionalidad activa.

```bash
# Verificarlo (desde la raíz del repo)
grep -c '^    status: placeholder' ingenieria_agentica/figuras/manifest.yml   # 46
ls ingenieria_agentica/figuras/tikz ingenieria_agentica/figuras/svg           # vacíos
grep -rn '](fig:' ingenieria_agentica/capitulos ingenieria_agentica/apendices # 0
```

### 1.7 Activar la primera figura, paso a paso

Tomemos `evolucion-codigo-ia`, tier 3, complejidad baja.

1. **Dibuja el fuente.** Créalo en
   `ingenieria_agentica/figuras/tikz/fig-evolucion-codigo-ia.tex`. El nombre no es
   negociable: tiene que ser `fig-<id>.tex`, porque el filtro construye la ruta de
   inclusión como `/book/illustrations/fig-<id>.pdf` y el script nombra el PDF por el
   basename del fuente. El campo `source` del manifiesto **no interviene**. Dentro, solo
   el `tikzpicture`, sin preámbulo.

2. **Corrige el `width` del manifiesto.** Cambia `width: "0.75\\textwidth"` por
   `width: '0.75\textwidth'` (comillas simples, una sola barra). Con comillas dobles el
   parser casero deja las dos barras y LaTeX recibe `width=0.75\\textwidth`, que falla
   con `Illegal unit of measure (pt inserted)`. Con comillas simples sale
   `width=0.75\textwidth`, correcto, y sigue siendo YAML válido para cualquier otro
   lector. Comprobado con ambas formas.

3. **Cambia el estado.** `status: draft` mientras iteras (sale el distintivo
   `[BORRADOR]` en el pie), `status: final` cuando esté lista. Actualiza también
   `source: tikz/fig-evolucion-codigo-ia.tex` por higiene documental, aunque el
   pipeline no lo lea.

4. **Referencia la figura en el capítulo.** En `capitulos/00_prefacio.md`, en su propio
   párrafo y con alt vacío:

   ```markdown
   ![](fig:evolucion-codigo-ia)
   ```

5. **Compila.**

   ```bash
   cd latex-pipeline && docker compose run --rm book make pdf
   ```

   `make figures` compilará el TikZ, y el resumen de stderr debe decir
   `1 final, 0 draft, 0 placeholder, 0 missing`. Si dice `1 missing`, el id está mal
   escrito. Si no dice nada, el markdown no produjo un `Image`: revisa que el alt esté
   vacío y que el párrafo no tenga nada más.

6. **Comprueba que el build sigue limpio.** `logcheck` corre al final de `make pdf` y
   falla ante cualquier error de TeX. El baseline actual es 0 errores, 0 caracteres
   perdidos, 0 referencias sin resolver, 0 etiquetas duplicadas.

Si vas a activar figuras en serie, arregla el `width` de las 46 entradas de una vez: 28
de ellas usan un factor (`0.65`, `0.7`, `0.75`, `0.8`, `0.85`, `0.9`) y 18 usan
`"\\textwidth"` a secas.

### 1.8 Trampas del sistema de figuras

| Trampa | Consecuencia |
|--------|--------------|
| `![fig:id]`, la sintaxis documentada en el manifiesto y en `CLAUDE.md` | No hace nada. Sale como texto literal. Usa `![](fig:id)`. |
| Alt text no vacío: `![Pie](fig:id)` | Pandoc 3 crea un nodo `Figure`, el filtro no lo intercepta, y queda un `\includegraphics{fig:id}` que rompe la compilación. |
| `width: "...\\textwidth"` con comillas dobles | Dos barras en el LaTeX final. `Illegal unit of measure`. Afecta a las 46 entradas actuales. Usa comillas simples. |
| El campo `source` | Decorativo. La ruta del PDF se deriva del **id**, no de `source`. El fuente debe llamarse `fig-<id>.tex` o `fig-<id>.svg`. |
| `todo` largo | Solo las 4 primeras líneas llegan al recuadro del PDF. El resto es documentación interna. |
| `figure-mode: final-only` o `no-placeholders` | Las figuras suprimidas no emiten `\label`. Cualquier `\ref` a ellas se queda sin resolver y `logcheck` tumba el build. |
| Manifiesto ilegible o mal indentado | El filtro no aborta: convierte cada referencia en una marca roja dentro del PDF. Revisa siempre el resumen de stderr. |

---

## Parte 2 - Índice analítico

### 2.1 La convención

Se marca el término en el punto del texto donde el lector querría que la página lo
llevara. La marca es un span de pandoc con la clase `idx`:

```markdown
[término]{.idx}
[término]{.idx data-sub="padre"}
```

El texto marcado sigue apareciendo normal en el cuerpo: la marca añade una entrada de
índice, no cambia la maquetación ni la tipografía.

Ejemplos reales del manuscrito:

```markdown
[context switching]{.idx}
[deuda técnica]{.idx}
[RAG]{.idx}
[GitClear]{.idx}

[GPT-3]{.idx data-sub="modelos de lenguaje"}
[GitHub Copilot]{.idx data-sub="asistentes de código"}
[Payback period]{.idx data-sub="métricas financieras"}
[Integration Tax]{.idx data-sub="costos ocultos"}
[código sobreviviente]{.idx data-sub="métricas de calidad"}
```

Los padres más usados hoy: `modelos de lenguaje` (7), `patrones de razonamiento` (6),
`herramientas agénticas` (6), `frameworks agénticos` (5), `adopción` (5).

### 2.2 Qué hace `index-transform.lua`

Filtro de 39 líneas, posición 10 de la cadena. Engancha `Span`, comprueba la clase
`idx`, aplana el contenido a texto plano y devuelve **dos** elementos: un `RawInline`
LaTeX con el comando de índice, seguido del contenido original intacto.

| Markdown | LaTeX resultante |
|----------|------------------|
| `[context switching]{.idx}` | `\index{context switching}context switching` |
| `[GPT-3]{.idx data-sub="modelos de lenguaje"}` | `\index{modelos de lenguaje!GPT-3}GPT-3` |

Verificado ejecutando el filtro sobre esos dos casos.

El único carácter que el filtro escapa es `&` (a `\&`). Los demás caracteres especiales
de makeindex pasan sin tocar, y cada uno tiene un significado que arruinaría la entrada:

| Carácter | Lo que hace makeindex con él |
|----------|------------------------------|
| `!` | Abre un nivel de sub-entrada |
| `@` | Separa clave de ordenación y texto visible |
| `\|` | Introduce un formateador de número de página |
| `"` | Escapa el carácter siguiente |

Hoy ningún término del manuscrito contiene ninguno de los cuatro, así que el problema es
latente, no real. Si necesitas uno, antepón comillas dobles: `X"!Y`.

### 2.3 Del `\index{}` a las páginas impresas

Tres piezas:

- **`imakeidx`**, cargado en `cls/paradigma-agentico.cls` justo **antes** de `hyperref`
  (el orden importa: al revés los números de página del índice no serían enlaces). La
  línea siguiente lo configura: `\makeindex[columns=2, title=Índice Analítico, intoc]`,
  es decir dos columnas, ese título, y entrada propia en la tabla de contenidos.
- **`\printindex`**, invocado en `templates/book.tex` dentro del `\backmatter`, después
  de un `\clearpage` y con el estilo de página `paradigma-plain`. El índice sale al
  final del libro, antes de la sección "Sobre el Autor".
- **`makeindex`**, el programa. `imakeidx` sabe lanzarlo solo durante la compilación,
  pero para eso necesita `--shell-escape`, que ya está en el Makefile por partida doble:
  en `PANDOC_OPTS` (`--pdf-engine-opt=--shell-escape`) y en las tres invocaciones
  directas de `lualatex`.

Además, el target `pdf` lo ejecuta explícitamente. La secuencia completa de cinco pasos:

| Paso | Qué hace | Por qué |
|------|----------|---------|
| 1/5 | `pandoc` genera el `.tex` | Aquí es donde `index-transform.lua` inyecta los `\index{}` |
| 2/5 | `lualatex` pase 1 | Escribe el fichero `.idx` con todas las entradas y sus páginas |
| 3/5 | `makeindex agentico-por-diseno.idx` | Ordena y agrupa el `.idx` en un `.ind` |
| 4/5 | `lualatex` pase 2 | Incluye el `.ind` y resuelve referencias |
| 5/5 | `lualatex` pase 3 | Paginación final, ya con el índice ocupando sitio |

El paso 3 va con `2>/dev/null || echo "(no index entries yet)"`, de modo que un
manuscrito sin ninguna marca `.idx` no rompe el build.

### 2.4 Cuánto hay, y cómo medirlo

Desde la raíz del repositorio:

```bash
# Marcas totales
grep -roh '{\.idx' ingenieria_agentica/capitulos ingenieria_agentica/apendices | wc -l

# Cuántas son sub-entradas
grep -rohE '\{\.idx data-sub=' ingenieria_agentica/capitulos ingenieria_agentica/apendices | wc -l

# Términos distintos
grep -rhoE '\[[^]]{1,60}\]\{\.idx[^}]*\}' ingenieria_agentica/capitulos ingenieria_agentica/apendices \
  | sed -E 's/^\[([^]]*)\].*/\1/' | sort -u | wc -l

# Reparto por fichero
for f in ingenieria_agentica/capitulos/*.md; do
  printf "%-40s %s\n" "$(basename "$f")" "$(grep -o '{\.idx' "$f" | wc -l | tr -d ' ')"
done

# Cuántas llegan realmente al PDF (requiere un build previo)
grep -o '\\index{' latex-pipeline/output/agentico-por-diseno.tex | wc -l   # 279
grep 'entries accepted' latex-pipeline/output/agentico-por-diseno.ilg

# Marcas dentro de tabla o de callout: las que se van a perder
grep -rh '^|.*{\.idx' ingenieria_agentica/capitulos ingenieria_agentica/apendices | grep -o '{\.idx' | wc -l   # 8
grep -rh '^>.*{\.idx' ingenieria_agentica/capitulos ingenieria_agentica/apendices | grep -o '{\.idx' | wc -l   # 3
```

Resultado hoy en el markdown: **290 marcas**, de las cuales **122 son sub-entradas** y
168 entradas principales, sobre **246 términos distintos**.

**Pero al PDF solo llegan 279.** El `.tex` generado contiene 279 comandos `\index{}`, y
`makeindex` deja constancia en el `.ilg`: `279 entries accepted, 0 rejected`. Se pierden
11 marcas, en silencio y sin ningún aviso.

La causa es el orden de la cadena de filtros. `callout-transform.lua` (posición 7) y
`table-transform.lua` (posición 8) devuelven el bloque completo como `RawBlock` LaTeX, lo
que aplana y destruye los nodos `Span` que contenía. Cuando `index-transform.lua` corre
en la posición 10, esas marcas ya no son `Span`: son texto crudo dentro de una cadena.
**Toda marca `.idx` que esté dentro de una tabla markdown o dentro de un blockquote
convertido en callout se descarta.**

Las 11 de hoy son 8 en filas de tabla y 3 en callouts:

| Marca perdida | Dónde |
|---------------|-------|
| `Curva de aprendizaje` (sub de `costos ocultos`) | tabla, `09_impacto_negocio.md:88` |
| `Deuda técnica` y `GitClear` | tabla, `09_impacto_negocio.md:91` |
| `Complejidad ciclomática` (sub de `métricas de calidad`) | tabla, `09_impacto_negocio.md:578` |
| `nearshoring` | tabla, `06_guia_por_industria.md:176` |
| `Gobernanza` | tabla, `06_guia_por_industria.md:202` |
| `code churn` | tabla, `06_guia_por_industria.md:242` |
| `SAST` (sub de `seguridad de código`) | tabla, `06_guia_por_industria.md:292` |
| `América Latina` | callout, `02_paradigmas.md:310` |
| `McKinsey` y `shadow AI` | callout, `08_ecosistema_herramientas.md:41` |

Comprobado end-to-end: un fichero con una marca en un párrafo, otra en una celda de tabla
y otra en un callout, pasado por `callout-transform`, `table-transform` e
`index-transform` en su orden real, produce **un solo** `\index{}`, el del párrafo.

Mientras el orden no cambie (o los filtros de callout y tabla no aprendan a procesar los
`Span` antes de aplanar), la regla práctica es: **marca el término en prosa, nunca dentro
de una tabla ni de un callout**. Si el término solo aparece en una tabla, marca en su
lugar la primera mención en prosa del mismo capítulo.

El índice impreso que sale de esas 279 entradas tiene **187 entradas de primer nivel y
112 sub-entradas**.

Reparto por fichero: los 14 capítulos numerados llevan entre 16 y 33 marcas cada uno
(máximo el 07, evolución técnica, con 33; mínimo el 10, cuando falla, con 16).
`00_prefacio`, `00a_executive_brief` y **los cinco apéndices tienen cero**. En el caso
del glosario (apéndice A) eso es discutible y probablemente valga la pena revisarlo: es
el sitio donde un término indexado sería más útil.

### 2.5 Buenas prácticas

**Qué indexar**

- Conceptos del dominio que el libro define o discute a fondo: `context window`,
  `deuda técnica`, `alucinaciones`, `RAG`.
- Productos y herramientas nombrados: `Cursor`, `GitHub Copilot`, `LangChain`.
- Fuentes recurrentes que el lector querrá rastrear: `Gartner`, `McKinsey`, `GitClear`.
- Métricas y frameworks con nombre propio: `Payback period`, `Integration Tax`.

**Qué no indexar**

- Palabras que aparecen en cada página (`agente`, `IA`, `equipo`). Una entrada con 200
  números de página no ayuda a nadie.
- Términos de una sola mención de pasada, sin sustancia detrás.
- Encabezados: la tabla de contenidos ya los cubre.

**Cómo elegir el padre**

Un `data-sub` solo se gana su sitio si el padre va a agrupar **tres o más** hijos. Con
uno o dos, la sub-entrada solo añade un nivel de sangría y esconde el término.
Reutiliza los padres que ya existen antes de inventar uno. Los 13 que hoy llegan a tres
o más hijos son: `modelos de lenguaje` (7), `patrones de razonamiento` (6),
`herramientas agénticas` (6), `frameworks agénticos` (5), `adopción` (5),
`asistentes de código` (4), `agentes autónomos` (4), `gobernanza` (4), `regulación` (4),
`LLM` (4), `business case` (3), `infraestructura cloud` (3) y `riesgos de IA` (3). Los
otros 52 padres del manuscrito tienen uno o dos hijos, `métricas financieras` y
`costos ocultos` entre ellos: son deuda pendiente de consolidar, no ejemplos a imitar.
Para ver la lista completa:

```bash
grep -rhoE 'data-sub="[^"]+"' ingenieria_agentica/capitulos | sort | uniq -c | sort -rn
```

Y sé consistente con la grafía exacta: `\index{LLM!contexto}` e `\index{LLMs!contexto}`
producen dos entradas distintas y separadas en el índice impreso.

**Lo que no se debe hacer**

- **Indexar la misma palabra en cada aparición.** La regla de facto del manuscrito es
  **una marca por término y por capítulo, en la primera mención sustantiva**. `McKinsey`
  y `GitClear` aparecen cinco veces cada uno, pero en cinco capítulos distintos y una
  sola vez en cada uno. Hoy hay exactamente una excepción: `Claude Code` está marcado dos
  veces en `08_ecosistema_herramientas.md` (líneas 336 y 447), y bajo dos padres
  distintos (`herramientas agénticas` y `agentes autónomos`), así que genera dos entradas
  separadas apuntando a dos páginas del mismo capítulo. Si un término parece merecer dos
  marcas en un capítulo, suele ser señal de que el capítulo lo trata en dos sitios y
  quizá debería tratarlo en uno.
- Marcar dentro de un encabezado. Funciona (hay cuatro casos vivos, los patrones
  `ReAct`, `OODA Loop`, `Tree of Thought` y `Plan-and-Execute` en
  `03_que_es_ia_agentica.md`), pero el número de página que sale es el del encabezado, no
  el de la explicación.
- Marcar el término en su mención más floja. La página que apunte el índice debe ser
  aquella donde el concepto se explica, no la primera vez que se nombra al pasar.
- Cambiar la grafía entre capítulos. El índice no unifica singulares con plurales ni
  mayúsculas con minúsculas, y el índice impreso de hoy ya tiene cuatro pares partidos:
  `Agentes de IA` / `agentes de IA`, `Orquestación agéntica` / `orquestación agéntica`,
  `Paradoja de Jevons` / `paradoja de Jevons` y `Prompt engineering` /
  `prompt engineering`. Entre los padres pasa lo mismo con `LLM` y `modelos de lenguaje`,
  que significan lo mismo y agrupan por separado.

### 2.6 Trampas del índice

| Trampa | Consecuencia |
|--------|--------------|
| Marcar dentro de una tabla o de un callout | La marca se pierde entera y sin aviso: `table-transform` y `callout-transform` aplanan el bloque a LaTeX crudo antes de que `index-transform` lo vea. 11 marcas de las 290 se caen así hoy (ver 2.4). |
| `!`, `@`, `\|`, `"` dentro del término | makeindex los interpreta como sintaxis. El filtro solo escapa `&`. |
| Grafías inconsistentes del mismo concepto | Entradas duplicadas y separadas en el índice impreso. |
| Cargar `imakeidx` después de `hyperref` | Los números de página dejan de ser enlaces. El `.cls` ya lo carga en el orden correcto; no lo muevas. |
| Compilar saltándose el paso 3 | El `.ind` se queda con el contenido del build anterior y el índice sale desfasado sin que nada avise. |
