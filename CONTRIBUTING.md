# Cómo contribuir

Este repositorio contiene un libro: *Agéntico por Diseño, Tomo I: Tecnologías de la
Información*, de Karim Touma. Son ~142,000 palabras en español neutro latinoamericano
(16 ficheros en `ingenieria_agentica/capitulos/` y 5 en `ingenieria_agentica/apendices/`),
más el toolchain que las convierte en un PDF de 577 páginas y un servidor MCP que las
sirve por búsqueda.

La audiencia del libro son gerentes y líderes técnicos: VP de Ingeniería, CTOs, tech
leads. Eso condiciona casi todas las reglas que siguen.

El repositorio está bajo **Unlicense** (dominio público), y eso cubre tanto el código
como el contenido del libro. Es una decisión deliberada del autor, ya declarada en la
página de créditos del PDF. No hace falta proponer dual-licensing ni Creative Commons.

---

## 1. Dos tipos de contribución

| | Contenido (manuscrito) | Toolchain |
|---|---|---|
| Dónde vive | `ingenieria_agentica/` | `latex-pipeline/`, `mcp-server/`, `.claude/skills/` |
| Qué es | Markdown de capítulos y apéndices | Makefile, filtros Lua, clase LaTeX, Cloudflare Worker |
| Quién lo revisa | Criterio editorial | Que el build siga limpio |
| Verificación mínima | `make pdf` y `make check-content` sin errores + revisión de las reglas de la sección 2 | `make pdf` sin errores; para el MCP, `npm run check` |

El grueso de las contribuciones es editorial. Si nunca has tocado LaTeX, no importa:
puedes editar markdown y dejar que el pipeline haga el resto, siempre que respetes el
markup propio del libro (sección 4).

---

## 2. Reglas duras del contenido

Estas cinco no son preferencias de estilo. Un PR que las viole se rechaza.

### 2.1 Nada de em dashes

El proyecto usa guion con espacios. Motivo práctico: el manuscrito se compone en LaTeX,
donde `---` produce un em dash, y la mezcla de ambos criterios ya causó una corrección
completa del repositorio. Hoy hay **cero** em dashes en el manuscrito, es decir en
`ingenieria_agentica/capitulos/` y `ingenieria_agentica/apendices/`.

Este documento tampoco puede contener el carácter, así que los ejemplos lo nombran
por su codepoint. `[U+2014]` representa el carácter prohibido:

```
mal:  la adopción es lenta[U+2014]y esa lentitud cuesta
mal:  la adopción es lenta [U+2014] y esa lentitud cuesta
mal:  la adopción es lenta---y esa lentitud cuesta   (en LaTeX, `---` compone U+2014)
bien: la adopción es lenta - y esa lentitud cuesta
```

Antes de mandar tu PR (el `$'...'` evita tener que escribir el carácter literal):

```bash
cd /ruta/al/repo
grep -rn $'\xe2\x80\x94' ingenieria_agentica/capitulos/ ingenieria_agentica/apendices/
```

Debe devolver cero líneas. No amplíes ese grep al resto del repositorio esperando cero:
hoy quedan 18 em dashes fuera del manuscrito y todos están en comentarios que no se
componen (17 en los comentarios YAML de `ingenieria_agentica/figuras/manifest.yml`, uno
en la cabecera `%` de `latex-pipeline/templates/book.tex`), más los de las cabeceras
`--` de los filtros Lua y de los `.sty`/`.cls`. No son violaciones.

Lo que sí importa fuera del manuscrito es el carácter en texto que llega a componerse.
En LaTeX, `% --- sección ---` es un comentario y no imprime nada, pero un `---` fuera de
comentario en `templates/book.tex` o en el `.cls` sí compone el carácter prohibido en las
páginas de apertura. Ya pasó. Y hoy queda un caso vivo en código: `figure-transform.lua`
emite un em dash literal dentro del rótulo `[FIGURE MISSING: ...]`. No se dispara nunca
todavía (ver 4.2), pero si se dispara, el carácter acaba impreso en el PDF.

### 2.2 Nada de código de programación

Ni bloques, ni snippets, ni pseudocódigo. El lector objetivo no lee código en un libro
de estrategia, y el pipeline no tiene resaltado de sintaxis activado (`--no-highlight`).
Si necesitas explicar un mecanismo técnico, descríbelo en prosa y termina con la
implicación de negocio.

```
mal:  El agente usa un bucle ReAct:
      while not done: thought = llm(prompt); action = parse(thought) ...

bien: El agente alterna razonamiento y acción en un bucle: piensa qué hacer,
      ejecuta una herramienta, lee el resultado y vuelve a pensar. Para ti eso
      significa que el costo por tarea no es fijo - crece con el número de
      iteraciones, y hay que presupuestarlo como consumo, no como licencia.
```

### 2.3 Nunca fabricar nada

Prohibido inventar empresas, sitios web, casos de estudio, cifras, citas o fuentes. El
proyecto eliminó deliberadamente todo el contenido ficticio que tenía; incluso el modo
"caso ficticio" del skill `/case-study` fue retirado por esto.

Todo dato lleva fuente identificable y verificable: organización, publicación y año.

```
mal:  "Una fintech regional de 200 desarrolladores redujo su time-to-market 40%."
bien: "El 84% de los desarrolladores ya usa herramientas de IA en su trabajo
      diario (Stack Overflow Developer Survey, 2025)."
```

Si una cifra es central para un argumento, va acompañada de un bloque
`> **Dato verificado:**` (formato exacto en la sección 3.2), que obliga a declarar la
metodología y las limitaciones. Esa es la forma de meter una cifra fuerte sin venderla
como más sólida de lo que es.

### 2.4 Moneda siempre `US$`

Hay 991 ocurrencias de `US$` en el manuscrito. La única excepción deliberada es un `R$`
(real brasileño) en el capítulo 13. Para un lector en México, Colombia, Chile o
Argentina, `$` es su moneda local, no el dólar.

```
mal:  $20-100/dev/mes
mal:  US$50-$300        (rango híbrido: el segundo extremo pierde el prefijo)
bien: US$20-100/dev/mes
bien: US$50-300
```

Verificación:

```bash
grep -rnE '(^|[^SU])\$[0-9[]' ingenieria_agentica/capitulos/ ingenieria_agentica/apendices/
```

La clase de carácter incluye `[` a propósito: sin ella el patrón solo ve `$` seguido de
dígito y se le escapan los marcadores de plantilla.

Hoy devuelve 9 líneas, y solo una de ellas está bien: el `R$50M` del capítulo 13. Las
otras 8 son deuda real, todas en `09_impacto_negocio.md`: las tablas para rellenar
"Calcula Tu Propio ROI" usan `$[A]`, `$[TOTAL]`, `$[C × 0.7]` y similares, sin prefijo y
fuera de cualquier bloque de código. Si tocas esas tablas, corrígelas a `US$[A]`. No
añadas casos nuevos.

Esos `$` sueltos son, además, la razón de que `-tex_math_dollars` sea obligatorio en el
lector de pandoc (ver sección 5): fue justo esa tabla la que salía con filas fusionadas.

### 2.5 Tono para líderes: el "so what" de negocio

Cada explicación técnica cierra en una consecuencia accionable: presupuesto, riesgo,
talento, plazo o decisión. Sin eso, el párrafo no pertenece a este libro. Nada de
tutoriales paso a paso de herramientas ni de detalles de implementación.

```
mal:  MCP expone recursos y herramientas sobre JSON-RPC 2.0 mediante un
      transporte streamable HTTP con sesiones identificadas por cabecera.

bien: MCP estandariza cómo un agente se conecta a tus sistemas internos. La
      consecuencia para ti: cada integración deja de ser un proyecto a medida,
      lo que cambia la aritmética de cuántas fuentes de datos puedes conectar
      con el mismo equipo.
```

---

## 3. Anatomía obligatoria de un capítulo

Los 14 capítulos numerados (`01` a `14`) contienen los 8 bloques siguientes, y los 14
los cumplen hoy. `00_prefacio.md` y `00a_executive_brief.md` no los llevan y es
correcto: son front matter, no capítulos.

Los ejemplos de abajo están tomados de `01_introduccion.md` y `02_paradigmas.md`, y
abreviados donde el original era largo: cópialos por su forma, no como texto literal.
Respeta el formato literal: los filtros Lua reconocen los callouts por el texto en
negrita de la primera línea del blockquote, así que un rótulo mal escrito degrada el
bloque a una cita normal en el PDF.

### 3.1 Resumen ejecutivo (primer bloque tras el H1)

```markdown
# El Nuevo Paradigma de la Ingeniería de Software

> **Resumen Ejecutivo**
>
> - La ingeniería de software atraviesa su tercera gran revolución desde la década de 1950
> - 📊 **DATO:** El 30% del código en Microsoft ya es generado por IA según su CEO Satya Nadella (2025)
> - 🔮 **PROYECCIÓN:** El CTO de Microsoft predice que el 95% del código será generado por IA para 2030
> - El rol del ingeniero no desaparece; evoluciona de "escribir código" a "arquitecto de intenciones y decisiones"
> - Este cambio requiere nueva evaluación de estrategia de talento, presupuestos y hojas de ruta
```

Cinco viñetas en 12 de los 14 capítulos; los capítulos 6 y 7 llevan seis. Apunta a cinco.

Los prefijos `**DATO:**` y `**PROYECCIÓN:**` **no** son una convención del libro: cada
uno aparece exactamente una vez en todo el manuscrito, en este mismo resumen del
capítulo 1. Puedes usarlos, pero no asumas que el resto del libro los lleva ni los
añadas en masa "por consistencia": hoy la consistencia es no llevarlos.

### 3.2 Dato verificado (al menos uno por capítulo, en el cuerpo)

Cuatro campos son el esqueleto estable, en este orden y con estos nombres exactos:
`Fuente`, `Qué mide`, `Limitación`, `Implicación`. El campo de muestra es opcional y va
entre `Qué mide` y `Limitación`:

```markdown
> **Dato verificado:**
>
> - **Fuente:** Kevin Scott, CTO de Microsoft (abril 2025); Gartner "Top Strategic Technology Trends 2025"
> - **Qué mide:** Porcentaje de código generado con asistencia de IA en empresas líderes
> - **Muestra/Metodología:** Declaraciones ejecutivas basadas en datos internos de Microsoft (190,000+ empleados)
> - **Limitación:** Ejecutivos de empresas que venden herramientas de IA tienen incentivo a reportar cifras optimistas
> - **Implicación:** Úsalo como referencia de que la adopción en Big Tech es real, no como promesa para tu organización
```

El campo se llama `Implicación`, no "Implicación práctica": se normalizó en todo el
libro y una variante nueva rompe la consistencia editorial.

Estado real, para que no lo tomes como un formato ya cerrado: hay 26 bloques
`Dato verificado` en el manuscrito. 13 llevan exactamente los cuatro campos del
esqueleto; 7 añaden el campo de muestra, y ahí el nombre **no** está normalizado
(`Muestra:` en 5, `Muestra/Metodología:` en 2, `Metodología:` en 2). Los 6 restantes se
salen del molde por completo, sobre todo en los capítulos 1, 4 y 8. Al escribir un
bloque nuevo usa los cuatro campos; si añades el de muestra, llámalo `Muestra:`, que es
la variante mayoritaria. No repares los bloques viejos dentro de un PR de contenido: eso
es un PR de normalización aparte.

### 3.3 Conclusiones y takeaways

```markdown
## Conclusiones y Takeaways

1. **Los beneficios son medibles:** Transiciones paradigmáticas históricamente
   multiplicaron productividad 3-10x. Datos preliminares de IA muestran 1.5-2.5x.
2. **La ventana de oportunidad es limitada:** Tienes 12-24 meses para ser early adopter.
```

Lista numerada, cada punto abre con una afirmación en negrita seguida de dos puntos.
Es el formato deseable, no el vigente: hoy solo los capítulos 2, 4, 7 y 14 lo cumplen de
principio a fin. Cinco capítulos intercalan un subtítulo `### Lo Que Debes Recordar:`
entre el H2 y la lista (es aceptable), y el capítulo 13 no usa lista numerada en absoluto:
estructura la sección con subtítulos `####`. Lo obligatorio es el H2 exacto
`## Conclusiones y Takeaways`, que sí está en los 14. Para contenido nuevo, usa la lista
numerada.

### 3.4 Tarjeta de referencia rápida

Estructura fija: 3 métricas, 1 framework, 1 acción.

```markdown
> **Tarjeta de Referencia Rápida**
>
> - **Métrica clave 1**: Cada transición paradigmática multiplicó productividad 3-10x
> - **Métrica clave 2**: Adopción de lenguajes de alto nivel pasó de 5% a 50% en 10 años
> - **Métrica clave 3**: Ventana de early adopter advantage: 12-24 meses
> - **Framework principal**: La Escalera de Abstracción (ver este capítulo)
> - **Acción inmediata**: Evalúa en qué paradigma opera tu equipo y propón un piloto de 3 meses
```

### 3.5 Preguntas de reflexión

El encabezado real en los 14 capítulos es `## Preguntas de Reflexión para Tu Equipo`.

```markdown
## Preguntas de Reflexión para Tu Equipo

1. **Sobre historia:**
   - ¿En qué paradigma estamos hoy? ¿Cuándo fue la última transición que vivimos?
2. **Sobre acción:**
   - ¿Qué nos impide hacer un piloto de 3 meses con US$10-50K de inversión?
```

### 3.6 Para tu próxima reunión de liderazgo

Ejercicio concreto que el lector puede llevar a una reunión. Va como blockquote:

```markdown
> **Para Tu Próxima Reunión de Liderazgo**
>
> Usa la tabla anterior como filtro de decisión. Para cada iniciativa de IA en tu
> pipeline, pregunta:
> 1. ¿El problema tiene entrada bien definida y resultado único?
```

Puede aparecer varias veces en un capítulo (el 13 tiene 13 instancias); al menos una
es obligatoria.

### 3.7 Referencias

```markdown
---

**Referencias:**

1. Brooks, F. (1987). "No Silver Bullet - Essence and Accident in Software Engineering". IEEE Computer.
2. Gartner. (2025). "Top Strategic Technology Trends for 2025: Agentic AI".
3. IBM Archives. "The History of FORTRAN". Available: https://www.ibm.com/history/fortran
```

Numeradas, al final del capítulo. Las notas al pie del cuerpo usan el prefijo
`[^chN-M]` (por ejemplo `[^ch1-27]`), único por capítulo.

### 3.8 Pie de capítulo

Última línea del fichero, con la navegación al siguiente:

```markdown
*Fin del Capítulo 2. Continúa en Capítulo 3: ¿Qué es la Inteligencia Artificial Agéntica?*
```

Si tu PR renombra o reordena un capítulo, actualiza también el pie del capítulo
anterior, la tabla de `ingenieria_agentica/BOOK_MASTER.md`, la lista `CHAPTER_FILES` del
`latex-pipeline/Makefile` y el mapa `part_by_chapnum` de
`latex-pipeline/filters/part-dividers.lua`.

---

## 4. Markup propio del libro (no lo borres sin querer)

Un editor que "limpie" el markdown destruye estas tres convenciones sin darse cuenta.
Las tres son invisibles en un visor de markdown normal y las tres tienen efecto en el PDF.

### 4.1 Índice analítico: `[término]{.idx}`

Hay 290 de estos spans en el manuscrito, 122 de ellos con sub-entrada.

```markdown
La adopción de [metodologías ágiles]{.idx} precedió a la de [IA agéntica]{.idx}.
El [MCP]{.idx data-sub="herramientas agénticas"} estandariza las integraciones.
```

`filters/index-transform.lua` los convierte en `\index{término}` y
`\index{padre!término}` respectivamente, y `imakeidx` genera con ellos el índice
analítico del final del libro. **El texto del término se imprime igual con o sin las
llaves**, así que borrarlas no rompe el build ni deja rastro visible en el párrafo: solo
hace desaparecer esa entrada del índice, en silencio. No conviertas `{.idx}` en negrita,
cursiva ni enlace.

### 4.2 Figuras: `![](fig:id)`

```markdown
![](fig:loop-agentico)
```

La sintaxis correcta y única es `![](fig:id)`, con el id entre paréntesis. `![fig:id]`
**no funciona**: pandoc solo construye un `Image` cuando el destino va entre paréntesis,
así que esa variante se queda como texto literal y llega tal cual al PDF.

`filters/figure-transform.lua` resuelve ese id contra
`ingenieria_agentica/figuras/manifest.yml`, que registra 46 figuras.

Estado real hoy, y conviene saberlo antes de invertir tiempo: **las 46 están en status
`placeholder`, los directorios `figuras/tikz/` y `figuras/svg/` están vacíos, y el texto
del libro no contiene ninguna referencia `![](fig:...)`**. El sistema está construido y
funciona, pero todavía no se usa. Es infraestructura lista, no una funcionalidad activa.

Ciclo de vida de una figura: `placeholder` -> `draft` -> `final`. Un placeholder se
compone como un recuadro con su descripción `todo:`; un draft lleva la etiqueta
`[BORRADOR]` en el pie. Un id que no exista en el manifiesto produce un aviso en stderr
y una marca visible en el documento, no un fallo de build: revisa la salida del build,
no solo el exit code.

### 4.3 Referencias cruzadas en prosa

No hay sintaxis especial. `filters/crossref-transform.lua` detecta el texto literal
`Capítulo 12`, `capítulo 12`, `Cap. 12` y `Apéndice B` y los convierte en hiperenlaces.
La etiqueta del capítulo se genera con relleno de ceros, así que "Capítulo 7" apunta a
`chap:07`, no a `chap:7`.

Consecuencia: si escribes "el capítulo doce" o "Capitulo 12" sin tilde, pierdes el
enlace. Y si citas un número de capítulo que no existe, generas una referencia sin
resolver, que ahora **hace fallar el build** (sección 5).

Trampa conocida: el patrón de apéndices es `[Aa]péndice%s+([A-D])`, es decir, **de la A a
la D**. El apéndice E existe, `part-dividers.lua` sí emite su `\label{app:E}`, y la única
mención de "Apéndice E" en el libro se queda sin enlazar en silencio. No es una
referencia rota (el build no falla), es un enlace perdido.

---

## 5. Verifica tu cambio antes de mandarlo

### Compilar el PDF

Se corre desde `latex-pipeline/`, no desde la raíz:

```bash
cd latex-pipeline
docker compose run --rm book make pdf
```

Los 14 targets del Makefile: `pdf`, `digital`, `epub`, `latex`, `chapter` (con
`CHAP=NN`), `validate`, `check-content`, `logcheck`, `optimize`, `preview`, `clean`,
`docker-build`, `figures`, `help`.

Dos de ellos conviene conocerlos antes de usarlos:

- `make digital` produce el PDF de lectura en pantalla
  (`output/agentico-por-diseno-digital.pdf`): pasa la opción de clase `digital` además
  de `twoside`, lo que activa `\ifpa@digital` en el `.cls` y con ello los hiperenlaces
  coloreados. Es un fichero distinto del de imprenta, no lo sustituye.
- `make preview` compila y luego imprime la ruta del PDF y el comando para abrirlo. No
  intenta abrirlo él: todos los targets corren dentro del contenedor, donde no hay
  visor.

Los prerequisitos de `$(BOOK_PDF)` y `$(BOOK_TEX)` cubren los ficheros del manuscrito,
`templates/book.tex`, el `.cls`, **todos los filtros Lua, todos los `.sty` y
`config.yml`**. Si editas un filtro o una hoja de estilo, `make pdf` reconstruye: no
hace falta `make clean` ni tocar un capítulo para forzarlo.

Para iterar sobre un solo capítulo sin recompilar 577 páginas:

```bash
cd latex-pipeline
docker compose run --rm book make chapter CHAP=09
```

### `make pdf` ahora falla si el LaTeX está roto

Esto es nuevo y es importante. Los tres pases de `lualatex` corren con
`> /dev/null 2>&1 || true`, así que durante mucho tiempo un documento con 33 errores
fatales producía un PDF y reportaba éxito. El target `logcheck`, encadenado a `pdf`,
lee el log del último pase y aborta si encuentra:

- errores de TeX (líneas que empiezan por `!`)
- caracteres perdidos (`Missing character`)
- referencias sin resolver (`undefined`)
- etiquetas duplicadas (`multiply defined`)

Los overfull hboxes se cuentan pero no fallan: son cosméticos. La línea base actual es
0 / 0 / 0 / 0 y 20 overfull hboxes. Si tu cambio sube cualquiera de los cuatro primeros
a distinto de cero, el PR no está listo.

Escape para depurar en local (no para mandar el PR):

```bash
cd latex-pipeline
docker compose run --rm book make pdf STRICT=0
```

### `make check-content`: el quality gate del manuscrito

Es el comando que debes correr en cualquier PR de contenido, junto con `make pdf`:

```bash
cd latex-pipeline
docker compose run --rm book make check-content
```

Envuelve `scripts/validate.sh` y revisa, en este orden:

1. Que estén los 16 ficheros de capítulo esperados (`00`, `00a`, `01` a `14`) y los 5
   apéndices (`A` a `E`). Un fichero de capítulo con un prefijo fuera de esa lista se
   reporta como aviso, no se ignora.
2. Estadísticas del manuscrito: palabras totales, blockquotes, filas de tabla.
3. Que no haya bloques de código (regla 2.2) ni marcadores de placeholder. Los bloques
   de LaTeX crudo (los que abren con el atributo `{=latex}`) están excluidos a
   propósito: son maquetación, no ejemplos de programación.
4. La salida del último build, si existe: tamaño del PDF, overfull/underfull hboxes,
   referencias sin resolver, problemas de fuentes, número de páginas.
5. Efectividad de los filtros sobre el `.tex`: callouts convertidos, divisores de parte
   (esperados 6), referencias cruzadas, checkboxes, iconos y separadores.

Línea base actual: sale con código 0, valida los 16 capítulos y los 5 apéndices, y deja
**1 aviso** (13 marcadores de code fence que no llevan el atributo `{=latex}`). Si tu
cambio añade
avisos o cualquier error, el PR no está listo. El código de salida es el número de
errores; los avisos no lo alteran, así que léelos en la salida y no confíes solo en el
exit code.

`make validate` y `make logcheck` son otra cosa y siguen siendo útiles: el primero
resume el `.tex` y el log, el segundo es el que aborta el build.

### Skills de calidad

El repositorio trae 5 skills en `.claude/skills/<nombre>/SKILL.md` con 27 comandos.
Los relevantes antes de un PR de contenido:

| Comando | Skill | Qué hace |
|---|---|---|
| `/lint` | book-quality | Verificación rápida: conteo de palabras, placeholders, datos verificados |
| `/audit` | book-quality | Auditoría completa de un capítulo: estructura, xrefs, código, badges, notas al pie, tono |
| `/xref` | book-quality | Validación exhaustiva de referencias cruzadas |

`book-audit-fixes` no define comandos: es una skill de referencia con las reglas
anti-regresión de cinco rondas de auditoría. Conviene leerla antes de escribir.

### Toolchain del MCP server

```bash
cd mcp-server
npm ci
npm run check     # typecheck de src/ y scripts/ + wrangler deploy --dry-run
```

Requiere Node >= 20.11: `scripts/prepare-content.ts` usa `import.meta.dirname`, que en
Node 20.0-20.10 es `undefined` y falla con un error que no apunta al origen real.
No despliegues a mano; el workflow `.github/workflows/deploy-mcp.yml` se encarga.

### Trampas del pipeline que cuestan una tarde

- **`config.yml` sigue siendo casi todo decorativo.** De todo el fichero solo se
  consumen dos valores: `book.date`, que `templates/book.tex` interpola en portada,
  créditos y metadatos del PDF, y `figure-mode`, que lee
  `filters/figure-transform.lua`. El resto del bloque `book:` (`title`, `tomo`,
  `subtitle`, `author`, `lang`) se conserva como metadato descriptivo del proyecto y
  está marcado como decorativo en el propio fichero: el título, el subtítulo y el autor
  están escritos a mano en `templates/book.tex` y en `\pdftitle`/`\pdfauthor` del
  `.cls`, y el idioma lo resuelve babel. La geometría, las fuentes y los colores viven
  en `cls/paradigma-agentico.cls` y en los `.sty`. Editar `config.yml` para cambiar el
  diseño no tiene ningún efecto. (Las claves muertas que había antes - `theme`,
  `page_size`, `mode`, `fonts:`, `layout:`, `features:` - ya se eliminaron del fichero,
  y su cabecera documenta dónde se cambia cada cosa de verdad.)
- **`/theme` promete lo que no puede cumplir.** El skill dice cambiar el tema editando
  `config.yml`, pero ahí no queda nada que leer: la paleta real está en
  `sty/pa-colors.sty` (`\setthemecorporategray`, `\setthemewarmterracotta`). Si quieres
  cambiar el tema, edita ese `.sty`.
- **`MD_FORMAT` desactiva `tex_math_dollars` a propósito**
  (`markdown+autolink_bare_uris-tex_math_dollars`). Sin esa desactivación, cada `$` de
  un precio abre un span de matemáticas que se traga los separadores de fila de las
  tablas. Causaba 31 de los 33 errores del build antiguo. No lo reactives.
- **El orden de los 12 filtros Lua importa** y el `FILTER_CHAIN` del Makefile es la
  única fuente de verdad: meta-strip, figure-transform, code-transform, part-dividers,
  emoji-transform, checkbox-transform, callout-transform, table-transform,
  crossref-transform, index-transform, drop-caps, hr-transform. Varias cabeceras de
  comentario dentro de los `.lua` declaran un número de orden que no coincide
  (`callout-transform` dice 2 y corre 7º; `code-transform` también dice 2 y corre 3º;
  `crossref-transform` dice 6 y corre 9º; `checkbox-transform` dice 4 y corre 6º;
  `table-transform` dice 7 y corre 8º; `hr-transform` dice "7 (runs last)" y sí corre
  último, con el número equivocado; y `part-dividers` afirma que "runs BEFORE other
  filters", cuando corre 4º, después de `figure-transform` y `code-transform`). Solo
  aciertan `meta-strip` ("1, runs first") y `emoji-transform` ("5"). No te fíes de esos
  comentarios.
- **`drop-caps.lua` es un no-op.** Sigue en la cadena y su cuerpo está comentado con la
  nota "causaban problemas de layout". Editarlo no cambia nada en el PDF hasta que
  alguien lo reactive.
- **El PDF publicado no se recompila solo.** `output/agentico-por-diseno.pdf` está
  versionado y se actualiza a mano, en un commit aparte de tipo `build` (ver sección 7);
  nada detecta que el markdown avanzó y el PDF se quedó atrás. Y `make clean` se lo
  lleva por delante: revisa `git status` después de correrlo.
- **El sistema de figuras está listo pero sin usar**: 46 placeholders en el manifiesto y
  cero referencias `![](fig:...)` en el manuscrito (ver 4.2).

---

## 6. Convención de commits

El repositorio adoptó Conventional Commits **en español** a partir de
`ce15e8b`. Los commits anteriores están en inglés y sin convención; no los tomes como
modelo.

```
<tipo>(<ámbito>): <asunto en minúscula, imperativo, sin punto final>

<cuerpo: qué estaba mal, por qué importaba, y qué verificaste>

Co-Authored-By: ...
```

Tipos usados hasta hoy: `fix`, `docs`, `chore`, `build`.
Ámbitos usados hasta hoy: `libro`, `build`, `mcp`, `repo`, `skills`.
El tipo `build` se usa sin ámbito para recompilaciones del PDF.

Ejemplos reales del historial:

```
fix(libro): alinea la pagina de creditos con el LICENSE y quita em dashes
docs(libro): completa la normalizacion de moneda a US$
fix(build): elimina 33 errores de LaTeX que el Makefile venia ocultando
chore(repo): consolida .gitignore, anade .gitattributes y limpia basura
fix(skills): migra a <nombre>/SKILL.md para que los comandos existan
```

El cuerpo es donde está el valor. La costumbre del repositorio es explicar la causa
raíz y cerrar con lo que se verificó, con números: *"Verificado: 991 US$, 0 $ sin
prefijo fuera de código, build sin errores"*. Un cuerpo que solo repita el asunto no
aporta nada.

Nota: los asuntos del historial van sin tildes. Si prefieres escribirlos con tildes,
adelante; no hay hook que lo valide en ninguna de las dos direcciones.

---

## 7. Qué no se acepta en un PR

**Regenerar el PDF sin necesidad.** `latex-pipeline/output/agentico-por-diseno.pdf` es
un binario de 1.9 MB commiteado a propósito, para que alguien pueda descargar el libro
sin instalar Docker ni compilar nada. Es la única excepción bajo `output/`, escrita como
una negación explícita en `.gitignore`:

```
latex-pipeline/output/*
!latex-pipeline/output/agentico-por-diseno.pdf
```

El problema es que git no puede fusionar un PDF línea a línea (por eso
`.gitattributes` lo marca como binario): cada recompilación guarda **una copia entera
del fichero** en el historial. Un PDF regenerado por costumbre en cada PR editorial
añade 1.9 MB permanentes al clon de todo el mundo, y multiplica los conflictos, porque
dos PRs que toquen el PDF chocan siempre y sin resolución automática posible.

Regla: **manda solo el cambio en markdown**. El PDF se recompila en un commit aparte,
de tipo `build`, cuando el mantenedor decide publicar una versión.

Tampoco se acepta:

- Reformateo masivo del markdown mezclado con cambios de contenido. Separa los PRs; si
  no, la revisión editorial es imposible.
- Ficheros generados en `latex-pipeline/output/` distintos del PDF publicado, o
  artefactos de build (`.aux`, `.log`, `.vrb`, `.idx`). `make clean` los borra.
- Un PR que **borre** el PDF publicado. Aviso: `make clean` incluye `output/*.pdf`, así
  que se lleva por delante el fichero commiteado. Si lo corres, revisa `git status`
  antes de hacer commit.
- Contenido en cualquier idioma que no sea español neutro latinoamericano.
- Casos de estudio, empresas, cifras o citas sin fuente verificable, por buenos que
  suenen. Ver 2.3.
