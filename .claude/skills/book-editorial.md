---
name: book-editorial
description: Enriquecimiento de contenido, estandarización y métricas editoriales para "Agéntico por Diseño, Tomo I"
---

# Skill: Book Editorial

Comandos para enriquecer, estandarizar y medir la calidad del contenido editorial. Cada comando modifica o reporta sobre archivos en `/Users/karim/Desktop/book/ingenieria_agentica/`.

---

## /enrich [capitulo]

Enriquecer un capítulo agregando elementos editoriales faltantes.

**Parámetros:**
- Número de capítulo (ej. `03`, `06b`, `14`)

**Proceso:**

1. **Leer las primeras 50 líneas** del capítulo en `/Users/karim/Desktop/book/ingenieria_agentica/capitulos/` para entender su contexto.

2. **Diagnosticar qué falta.** Buscar con Grep en el archivo:

| Elemento | Patrón de búsqueda | Requerido en |
|----------|--------------------|----|
| Resumen Ejecutivo | `Resumen Ejecutivo` (primeras 50 líneas) | Caps 01-16 |
| Takeaways | `Takeaway\|Conclusiones.*Takeaway\|Conclusiones Clave` | Caps 01-16 y 06b |
| Preguntas de Reflexión | `Preguntas de Reflexión\|Preguntas de reflexión` | Caps 01-16 |
| Callout liderazgo | `próxima reunión` | Caps 01-16 (mínimo 1) |
| Dato verificado | `Dato verificado` | Caps con datos de mercado (01, 04, 05, 06, 08, 12, 13, 15, 16) |

3. **Para cada elemento faltante**, generarlo según el formato estándar:

**Formato de Resumen Ejecutivo:**
```
> **Resumen Ejecutivo**
>
> - [Punto clave 1 sobre el tema del capítulo]
> - [Punto clave 2 con dato de impacto]
> - [Punto clave 3 con implicación para líderes]
> - [Punto clave 4 con acción recomendada]
```

**Formato de Takeaways:**
```
## Conclusiones y Takeaways

1. **[Punto clave 1]** — [expansión de 1 línea]
2. **[Punto clave 2]** — [expansión de 1 línea]
3. **[Punto clave 3]** — [expansión de 1 línea]
...
(3-7 takeaways extraídos del contenido del capítulo)
```

**Formato de Preguntas de Reflexión:**
```
## Preguntas de Reflexión para Tu Equipo

1. [Pregunta concreta y accionable sobre el tema del capítulo]
2. [Pregunta que conecte con el negocio/organización del lector]
3. [Pregunta que invite a evaluar la madurez actual del equipo]
4. [Pregunta sobre riesgos o trade-offs]
5. [Pregunta orientada a próximos pasos]
```

**Formato de Callout de liderazgo:**
```
> **Para tu próxima reunión de liderazgo**
>
> [Ejercicio, checklist, o framework accionable de 3-5 líneas]
> [Debe ser algo que el lector pueda usar directamente en su contexto]
```

**Formato de Dato verificado:**
```
> **Dato verificado:**
>
> - **Fuente:** [Organización] ([año]). "[Título del reporte/estudio]"
> - **Qué mide:** [Descripción precisa de la métrica]
> - **Limitación:** [Sesgo de muestra, contexto geográfico, metodología, etc.]
> - **Implicación:** [Qué significa para el lector como líder técnico]
```

4. **Insertar los elementos faltantes** en las posiciones correctas usando Edit:
- Resumen Ejecutivo: después del título H1, antes del primer contenido
- Takeaways: al final del capítulo, antes de Preguntas de Reflexión
- Preguntas de Reflexión: última sección del capítulo
- Callouts: distribuidos donde haya datos o frameworks accionables
- Dato verificado: inmediatamente después de la primera estadística importante

5. **Reportar** qué se agregó y en qué línea.

---

## /standardize [capitulo|all]

Estandarizar formatos de callouts, badges y bloques especiales.

**Parámetros:**
- Con número: estandariza solo ese capítulo
- `all`: todos los capítulos

**Proceso:**

1. **Estandarizar badges de casos de estudio** (solo caps 07-11, 06b).

Para casos **reales** (caps 07, 08), verificar que las primeras líneas contengan:
```
> **Caso Real Documentado**
```

Para casos **ficticios** (caps 09, 10, 11, 06b), verificar:
```
**SOBRE ESTE CASO**

Este caso es **ficticio** ...

| Qué está basado en evidencia | Qué es inferencia del autor |
|------------------------------|----------------------------|
```

2. **Estandarizar callouts "Para tu próxima reunión".** Buscar con Grep `próxima reunión` y verificar formato:

Formato estándar:
```
> **Para tu próxima reunión de liderazgo**
>
> [contenido]
```

Variaciones a corregir:
- Con dos puntos al final del título → sin dos puntos
- Sin `>` al inicio → agregar blockquote
- Sin negrita → agregar `**...**`
- OK: variantes como "reunión de presupuesto", "reunión de board" (permitidas)

3. **Estandarizar encabezados de Takeaways.** Todos deben usar:
```
## Conclusiones y Takeaways
```
Variantes a corregir: `## Takeaways del Capítulo`, `## Puntos Clave`, `### Conclusiones` (nivel incorrecto)

4. **Estandarizar encabezados de Preguntas.** Todos deben usar:
```
## Preguntas de Reflexión para Tu Equipo
```
Variantes a corregir: `### Preguntas` (nivel incorrecto), `## Preguntas de Reflexión:` (con dos puntos)

5. **Verificar formato de "Dato verificado".** Para cada bloque encontrado, verificar los 4 campos. Si falta alguno, **marcar para completar manualmente** (nunca inventar datos de fuentes).

6. **Reportar** todos los cambios realizados y los items pendientes de acción manual.

---

## /stats

Métricas editoriales completas del libro.

**Proceso:**

1. **Métricas de volumen.** Usar `wc -w` en cada archivo:

```
MÉTRICAS EDITORIALES — [fecha]

══ VOLUMEN ══
| Archivo | Palabras | Págs est. |
|---------|----------|-----------|
| 00_prefacio.md | [N] | [N/350] |
| ... | ... | ... |
| TOTAL | [N] | [N/350] |

Objetivo: ~350 páginas (~122,500 palabras)
Estado: [%] del objetivo
```

2. **Métricas de elementos editoriales.** Contar con Grep en cada archivo:

| Elemento | Patrón |
|----------|--------|
| Bloques "Dato verificado" | `Dato verificado` |
| Callouts liderazgo | `próxima reunión` |
| Footnotes inline | `\[\^[a-z0-9-]+\]` |
| Tablas | `\|.*\|.*\|` (líneas con 3+ pipes) |
| Blockquotes | `^> ` |

3. **Score de densidad editorial** por capítulo (1-5):

```
══ DENSIDAD EDITORIAL ══
| Capítulo | Datos verif. | Callouts | Tablas | Footnotes | Score |
|----------|-------------|----------|--------|-----------|-------|
| Cap 01 | 2 | 3 | 12 | 52 | ████░ |
| Cap 02 | 0 | 2 | 8 | 0 | ██░░░ |

Fórmula: 1 punto por tener ≥1 Dato verificado, 1 por ≥2 callouts,
1 por ≥3 tablas, 1 por tener footnotes, 1 por ≥5000 palabras
```

4. **Frameworks referenciados.** Buscar con Grep `Framework #\d+` y contar cuántas veces se referencia cada uno de los 12 del Apéndice B. Identificar frameworks poco referenciados (< 2 menciones fuera del apéndice).

5. **Conectividad.** Buscar `ver Capítulo|ver Cap\.|ver Apéndice|véase` para medir interconexión:

```
══ CONECTIVIDAD ══
Cross-references totales: [N]
Capítulos más referenciados: Cap [X] ([N] refs), Cap [Y] ([N] refs)
Capítulos sin referencias entrantes: [lista]
Frameworks poco referenciados: #[N] ([nombre])
```

6. **Gravedad referencial.** Construir grafo dirigido de cross-references:
- Para cada `Cap. X`, `Capítulo X`, `Cap X` encontrado, registrar (cap_origen → cap_destino)
- Calcular "gravedad" por capítulo: cuántas veces capítulos **anteriores** (número menor) lo referencian
- Flag: capítulos después del 10 que son referenciados **3+ veces** por caps antes del 7
- Output: `| Cap destino | Refs entrantes (desde caps anteriores) | Señal |`
- Señal esperada: Cap 4 (sesgos cognitivos) tiene alta gravedad referencial por estar temprano en la estructura

```
══ GRAVEDAD REFERENCIAL ══
| Cap | Refs entrantes totales | Desde caps anteriores | Señal |
|-----|----------------------|----------------------|-------|
| 14 | 8 | 5 (desde caps 01-06) | ⚠️ MOVER ANTES |
| 06b | 4 | 0 | OK |
```

---

## /verify-datos

Verificar integridad de todos los bloques "Dato verificado" del libro.

**Proceso:**

1. **Encontrar todos los bloques.** Buscar con Grep `Dato verificado` en todos los archivos de `capitulos/` y `apendices/`.

2. **Para cada bloque**, leer las 8 líneas siguientes y verificar los 4 campos obligatorios:
- `Fuente:` — Debe existir y no estar vacío
- `Qué mide:` — Debe existir y no estar vacío
- `Limitación:` — Debe existir y no estar vacío
- `Implicación:` — Debe existir y no estar vacío

3. **Verificar fuentes verificables.** En el campo Fuente:
- Debe contener un año entre paréntesis: `\(\d{4}\)`
- Debe nombrar una organización (al menos una palabra capitalizada)
- Banderas rojas: `"varias fuentes"`, `"datos propios"`, `"estimación del autor"` sin disclaimer

4. **Cross-check contra Apéndice D.** Leer `/Users/karim/Desktop/book/ingenieria_agentica/apendices/D_recursos.md` y verificar que las fuentes principales citadas aparezcan en la sección de recursos.

5. **Generar reporte:**

```
VERIFICACIÓN DE DATOS — [fecha]

Bloques encontrados: [N] en [M] archivos

| Archivo | Línea | Fuente citada | 4 campos | En App D |
|---------|-------|---------------|----------|----------|
| 01_... | 82 | MIT (2024) | ✅ | ✅ |
| 06_... | 254 | McKinsey (2024) | ❌ falta Limitación | ✅ |

ACCIONES REQUERIDAS:
- [archivo:línea]: Completar campo [campo]
- [archivo:línea]: Agregar [fuente] al Apéndice D
```

---

## /tone-check [capitulo|all]

Verificar tono editorial: lenguaje de miedo, jerga sin explicar, voz inconsistente.

**Parámetros:**
- Con número: verifica solo ese capítulo
- `all`: verifica todos

**Proceso:**

1. **Detectar lenguaje de miedo/urgencia apocalíptica.** Buscar con Grep (case insensitive):

| Patrón | Severidad | Nota |
|--------|-----------|------|
| `quedarse atrás` | ALTA | Purga obligatoria |
| `obsolet` | ALTA | OK solo en contexto técnico ("código obsoleto") |
| `amenaza existencial` | ALTA | OK solo en citas textuales |
| `desaparecer` | MEDIA | Evaluar contexto |
| `sobreviv` | MEDIA | OK en citas o preguntas retóricas |
| `urgente` | MEDIA | OK como adjetivo técnico |
| `extinci` | ALTA | No debe aparecer |
| `no hay opción` | MEDIA | Lenguaje coercitivo |
| `si no actúas` | MEDIA | Lenguaje de presión |
| `ventana.*cierra` | MEDIA | Urgencia temporal |
| `antes de que sea tarde` | MEDIA | Urgencia temporal |
| `reloj.*corre` | MEDIA | Urgencia temporal |
| `carrera contra` | MEDIA | Urgencia temporal |
| `morir.*competitiv` | ALTA | Lenguaje apocalíptico |
| `perder.*relevancia` | MEDIA | Urgencia |
| `tiempo se acaba` | MEDIA | Urgencia temporal |
| `actuar ahora` | MEDIA | Urgencia directa |
| `no puedes permitir` | MEDIA | Lenguaje coercitivo |

Excluir líneas dentro de blockquotes que sean citas textuales de terceros.

1b. **Densidad de urgencia normalizada.** Para cada capítulo:
- Contar todas las ocurrencias de patrones de urgencia (tabla anterior)
- Obtener word count del capítulo con `wc -w`
- Calcular: densidad = (ocurrencias / (words / 1000))
- Flag: capítulos con densidad >2.0 por 1,000 palabras = "ALTA densidad persuasiva"
- Output: tabla `| Capítulo | Urgencia raw | Words | Densidad/1K | Nivel |`
- Nivel: ≤0.5 = BAJO, 0.5-2.0 = MEDIO, >2.0 = ALTO

1c. **Balance riesgo/beneficio por capítulo.** Para cada capítulo:
- Contar vocabulario de riesgo: `riesgo|limitaci|fallo|fracas|problema|desventaja|cuidado|advertencia|sesgo|error|vulnerabilid`
- Contar vocabulario de beneficio: `beneficio|ventaja|mejora|productividad|ROI|ahorro|eficiencia|ganancia|oportunidad`
- Calcular ratio riesgo:beneficio
- Flag: ratio <0.1 = "PURO BENEFICIO — falta contrapeso", ratio >5.0 = "PURO RIESGO"
- Reporte global: distribución del vocabulario de riesgo por capítulo. Si >70% concentrado en caps 14-16, recomendar distribuir.

2. **Detectar jerga técnica sin explicar.** Primero, leer los términos definidos en `/Users/karim/Desktop/book/ingenieria_agentica/apendices/A_glosario.md` (buscar encabezados `## ` o `### ` para lista de términos). Luego buscar en los capítulos términos técnicos comunes:
- `LLM|RAG|SAST|SCA|DLP|MCP|CI/CD|SWE-Bench|DAST|SBOM`
- Verificar que la primera aparición en cada capítulo tenga explicación o referencia al glosario

3. **Detectar voz inconsistente:**
- Primera persona fuera de callouts: `debemos|tenemos que` (fuera de blockquotes `>`)
- Demasiado casual: `cool|awesome|wow|genial` (fuera de citas)
- Demasiado académico: `cabe destacar|en el presente documento|a continuación se describe`

4. **Generar reporte:**

```
TONE CHECK — [fecha]
Alcance: [capítulo o "Libro completo"]

══ LENGUAJE DE MIEDO ══
Ocurrencias: [N]
- [archivo:línea]: "[fragmento]" → Sugerencia: [alternativa]

══ JERGA SIN EXPLICAR ══
Términos no en glosario: [lista]
Primera aparición sin contexto:
- [archivo:línea]: "[término]" sin explicación

══ VOZ INCONSISTENTE ══
- [archivo:línea]: "[fragmento]" → [problema]

RESUMEN:
- Miedo: [N] ([LIMPIO si 0])
- Jerga: [N] sin explicar
- Voz: [N] inconsistencias
```

---

## /voice-check

Audita diversidad de voces citadas en el libro: advocates vs. escépticos.

**Proceso:**

1. **Extraer personas citadas.** Buscar con Grep en todos los archivos de `capitulos/`:
- Nombres propios cerca de verbos de atribución: `dijo|afirmó|declaró|según|señaló|argumentó|predijo|proyectó`
- Nombres propios cerca de títulos: `CEO|CTO|VP|director|fundador|investigador|profesor`
- Lista conocida de frecuentes: `Nadella|Amodei|Altman|Huang|Pichai|Zuckerberg|Hadi Partovi|Kevin Scott|Thomas Dohmke|Dario`

2. **Clasificar cada persona:**

| Categoría | Nombres conocidos |
|-----------|-------------------|
| **Advocates** (pro-AI, CEO/founder de empresas de IA) | Satya Nadella, Dario Amodei, Sam Altman, Jensen Huang, Sundar Pichai, Mark Zuckerberg, Thomas Dohmke, Hadi Partovi |
| **Escépticos** (investigadores críticos, voces de cautela) | Gary Marcus, Grady Booch, Timnit Gebru, Emily Bender, Meredith Whittaker, Arvind Narayanan, Ed Zitron, Melanie Mitchell |
| **Neutral/Analista** | Cualquier otro (analistas Gartner/McKinsey, académicos, etc.) |

3. **Generar reporte:**

```
VOICE CHECK — [fecha]

══ PERSONAS CITADAS ══
| Persona | Categoría | Menciones | Archivos |
|---------|-----------|-----------|----------|
| Satya Nadella | Advocate | 20 | 7 |
| Dario Amodei | Advocate | 11 | 5 |
| (ningún escéptico) | — | 0 | 0 |

══ BALANCE ══
- Advocates citados: [N] personas, [M] menciones totales
- Escépticos citados: [N] personas, [M] menciones totales
- Ratio escépticos:advocates: [ratio]

══ FLAGS ══
⚠️ [persona] citada [N] veces (>5) — reducir o diversificar
❌ 0 escépticos citados — ratio 0:N
⚠️ Ratio escépticos:advocates = [X] (<0.2)

══ SUGERENCIAS ══
Considere incluir perspectivas de:
- Gary Marcus: limitaciones fundamentales de LLMs, "Rebooting AI"
- Grady Booch: críticas a sobreestimación de capacidades de IA, experiencia en ingeniería de software
- Arvind Narayanan: "AI Snake Oil", desmitificación de claims inflados
- METR study (2025): desarrolladores experimentados 19% más lentos con IA
- GitClear (2025): duplicación de código 8x con IA, refactoring en declive
```

---

## /language-check

Detecta inconsistencia español/inglés (code-switching, anglicismos sin explicar).

**Proceso:**

1. **Definir tres listas de referencia:**

**Inglés aceptable** (términos de industria sin traducción establecida, NO flag):
```
software, hardware, framework, startup, feedback, sprint, deploy, cloud,
SaaS, API, SDK, CI/CD, DevOps, DevSecOps, pull request, commit, pipeline,
dashboard, backend, frontend, refactoring, scrum, agile, lean, ROI, CTO,
CEO, VP, ML, AI, LLM, IDE, SLA, KPI, OKR, QA, UX, UI, SQL, NoSQL, REST,
GraphQL, Docker, Kubernetes, Git, GitHub, open source, fork, merge, branch,
benchmark, debug, log, token, prompt, embedding, fine-tuning, chat, bot,
copilot, plugin, endpoint, localhost, serverless, microservice, monolith
```

**Traducir o explicar** (tienen equivalente español razonable, FLAG):
```
onboarding → incorporación
kill switch → interruptor de emergencia
quick wins → victorias rápidas
trade-off → compromiso/disyuntiva
bottleneck → cuello de botella
stakeholder → interesado/parte interesada
pain point → punto de dolor
mindset → mentalidad
game changer → cambio de paradigma
burnout → agotamiento profesional
vendor lock-in → dependencia de proveedor
early adopter → adoptante temprano
guardrails → barandas/límites de seguridad
skill decay → deterioro de habilidades
time-to-market → tiempo al mercado
roadmap → hoja de ruta
rollout → despliegue
proof of concept → prueba de concepto
use case → caso de uso
best practice → buena práctica
workaround → solución temporal
```

2. **Para cada término de la lista "Traducir o explicar"**, buscar con Grep en todos los archivos de `capitulos/`:
- Contar ocurrencias totales
- Verificar si la **primera ocurrencia** en cada capítulo incluye equivalente español (buscar paréntesis o "es decir" en ±2 líneas)
- Verificar si el término está en el Glosario (`apendices/A_glosario.md`)
- Verificar consistencia: ¿se usa el mismo término en todo el capítulo o alterna con traducción?

3. **Detectar anglicismos adicionales.** Buscar palabras en inglés que no estén en la lista de "aceptable":
- Grep para palabras comunes no listadas: `early bird|pain point|low-hanging|heads-up|hands-on|plug-and-play|end-to-end|top-down|bottom-up|scale up|spin off|buy-in|check-in|catch-up`
- Evaluar si necesitan traducción o explicación

4. **Generar reporte:**

```
LANGUAGE CHECK — [fecha]

══ ANGLICISMOS A REVISAR ══
| Término | Equivalente | Ocurrencias | En Glosario? | 1ra mención explica? | Consistente? |
|---------|-------------|-------------|--------------|---------------------|-------------|
| onboarding | incorporación | 23 | ✅ | ❌ Cap 01 | ❌ (alterna) |
| quick wins | victorias rápidas | 15 | ❌ | ❌ | ✅ (siempre inglés) |
| kill switch | interruptor de emergencia | 8 | ✅ | ✅ Cap 15 | ✅ |

══ TOP 10 ANGLICISMOS MÁS FRECUENTES SIN EXPLICAR ══
1. [término] — [N] ocurrencias
...

══ RECOMENDACIONES ══
- Para cada término flaggeado: "En primera mención de cada capítulo, agregar equivalente español entre paréntesis"
- Términos no en glosario: "Agregar entrada en Apéndice A"
- Regla propuesta: español con término inglés entre paréntesis en primera mención, luego usar cualquiera consistentemente
```

---

## Notas de Uso

- `/enrich` y `/standardize` MODIFICAN archivos (revisar cambios antes de commit)
- `/stats`, `/verify-datos`, `/tone-check`, `/voice-check` y `/language-check` son de solo lectura
- Usar `/enrich` después de escribir un capítulo nuevo
- Usar `/standardize all` antes de un build de producción
- Usar `/tone-check all` como quality gate final antes de publicación
- Usar `/voice-check` para verificar diversidad de voces citadas
- Usar `/language-check` para detectar anglicismos inconsistentes
- Todos los comandos respetan las reglas de CLAUDE.md
- Tono siempre ejecutivo, NO técnico-código
- Español neutro latinoamericano
