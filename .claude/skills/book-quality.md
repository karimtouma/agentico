---
name: book-quality
description: Auditoría, validación y quality gates para el libro "Agéntico por Diseño, Tomo I"
---

# Skill: Book Quality

Comandos de auditoría automatizada para detectar los problemas editoriales recurrentes del libro. Cada comando genera un reporte accionable con archivo:línea.

Directorio base del libro: `/Users/karim/Desktop/book/ingenieria_agentica/`
Capítulos: `/Users/karim/Desktop/book/ingenieria_agentica/capitulos/`
Apéndices: `/Users/karim/Desktop/book/ingenieria_agentica/apendices/`

---

## /audit [capitulo|all]

Auditoría completa de calidad editorial. Ejecuta TODAS las validaciones en un solo comando.

**Parámetros:**
- Sin parámetro o `all`: audita todos los capítulos y apéndices
- Con número (ej. `03`): audita solo ese capítulo

**Proceso:**

1. **Definir alcance.** Si se indicó un capítulo, buscar el archivo con Glob en `/Users/karim/Desktop/book/ingenieria_agentica/capitulos/*{NUMERO}*.md`. Si es `all`, procesar todos los `.md` en `capitulos/` y `apendices/`.

2. **Ejecutar las 6 validaciones** y acumular hallazgos:

### Validación 1: Elementos estructurales requeridos
Para cada capítulo (excluyendo `00_prefacio.md` y `00a_executive_brief.md` que son front matter), verificar con Grep:

- **Resumen Ejecutivo**: patrón `Resumen Ejecutivo` (primeras 50 líneas)
- **Takeaways**: patrón `Takeaway|Conclusiones.*Takeaway|Conclusiones Clave|Puntos Clave`
- **Preguntas de Reflexión**: patrón `Preguntas de Reflexión|Preguntas de reflexión`
- **Callout de liderazgo**: patrón `próxima reunión` (al menos 1 ocurrencia)

Reportar como FALTA si alguno no existe en el archivo.

### Validación 2: Cross-references
Buscar con Grep en todos los archivos del alcance:

- Patrón de referencias a capítulos: `Capítulo \d+|Cap\.\s*\d+`
- Patrón de referencias a apéndices: `Apéndice [A-E]`
- Patrón de referencias a frameworks: `Framework #\d+`

Validar:
- Números de capítulo entre 0-14
- Apéndices A, B, C, D o E
- Framework # entre 1-12
- **CRÍTICO**: Cap 5 = Sesgos Cognitivos, Cap 13 = Gobernanza, Cap 14 = Futuro 2030
- Buscar específicamente: `Cap.*5.*evolución|Cap.*5.*técnica` → ERROR (Cap 5 es Sesgos, no Evolución)

### Validación 3: Code snippets (debe ser CERO)
Buscar con Grep bloques de código con lenguaje de programación:

- Patrón: ` ```python|```bash|```javascript|```sql|```java|```yaml|```json|```typescript|```go|```rust|```html|```css|```xml|```shell|```c |```cpp`
- Excepción PERMITIDA: ` ```markdown` (templates editoriales)

Reportar cada violación con archivo:línea.

### Validación 4: Badges de casos de estudio
Solo para caps 06-08 y 10. Verificar con Grep las primeras 20 líneas:

- Caps 06, 07: debe existir `Caso Real|CASO REAL`
- Cap 08: debe existir `Investigación|Guía|Quick Wins`
- Cap 10: debe existir `ficticio|composites|Caso Compuesto`
- Tabla de transparencia: `Qué está basado en evidencia|Qué es inferencia`

### Validación 5: Footnote integrity
Para archivos con footnotes. Buscar con Grep:

- Referencias inline: patrón `\[\^[a-z0-9-]+\]` (en texto, NO al inicio de línea)
- Definiciones: patrón `^\[\^[a-z0-9-]+\]:` (al inicio de línea, final del archivo)

Comparar: cada referencia debe tener su definición. Reportar footnotes huérfanas y rotas.

### Validación 6: Lenguaje de miedo
Buscar con Grep (case insensitive):

- `quedarse atrás`
- `obsolet` (obsoleto/obsoletos fuera de contexto técnico)
- `amenaza existencial`
- `desaparecer`
- `extinci`
- `apocal`

Excluir líneas que comiencen con `>` (blockquotes/citas textuales).

3. **Generar reporte** con formato:

```
═══════════════════════════════════════════
AUDITORÍA DE CALIDAD — [fecha]
Alcance: [capítulo o "Libro completo"]
═══════════════════════════════════════════

## 1. ELEMENTOS ESTRUCTURALES
✅ Resumen Ejecutivo: [N] de [M] capítulos
✅ Takeaways: [N] de [M] capítulos
⚠️ Preguntas de Reflexión: [N] de [M] capítulos
✅ Callouts de liderazgo: [N] de [M] capítulos

FALTAN:
- [archivo.md]: Falta [elemento]

## 2. CROSS-REFERENCES
Total: [N] | Válidas: [N] | Sospechosas: [N]
PROBLEMAS:
- [archivo.md:línea]: "Capítulo X" → [problema]

## 3. CODE SNIPPETS
Violaciones: [N]
- [archivo.md:línea]: ```[lenguaje]

## 4. BADGES CASOS DE ESTUDIO
✅ | ❌ Cap 08: [estado]
...

## 5. FOOTNOTES
Refs: [N] | Defs: [N] | Huérfanas: [N] | Rotas: [N]

## 6. LENGUAJE DE MIEDO
Ocurrencias: [N]
- [archivo.md:línea]: "[contexto]"

═══════════════════════════════════════════
RESUMEN: [N] problemas
- Críticos: [N] | Advertencias: [N]
═══════════════════════════════════════════
```

**Criterios:**
- CRÍTICO: Footnote rota, cross-ref a capítulo inexistente, code snippet
- ADVERTENCIA: Elemento estructural faltante, lenguaje de miedo, badge faltante

---

## /xref

Validación exhaustiva de referencias cruzadas entre TODOS los archivos del libro.

**Proceso:**

1. **Construir mapa de capítulos vigente.** Leer las primeras 5 líneas de cada archivo en `capitulos/` para obtener el título real. El mapa canónico es:

| Cap # | Archivo | Contenido |
|-------|---------|-----------|
| 0 | 00_prefacio.md | Prefacio |
| 0a | 00a_executive_brief.md | Executive Brief |
| 1 | 01_introduccion.md | Introducción |
| 2 | 02_paradigmas.md | Paradigmas |
| 3 | 03_que_es_ia_agentica.md | IA Agéntica |
| 4 | 04_por_que_diseñar.md | Por Qué Diseñar |
| 5 | 05_sesgos_cognitivos.md | Sesgos Cognitivos |
| 6 | 06_guia_por_industria.md | Guía por Industria |
| 7 | 07_evolucion_tecnica.md | Evolución Técnica |
| 8 | 08_ecosistema_herramientas.md | Ecosistema |
| 9 | 09_impacto_negocio.md | Impacto Negocio |
| 10 | 10_cuando_falla.md | Cuando Falla |
| 11 | 11_liderando_equipos_ia.md | Liderazgo |
| 12 | 12_estrategia_adopcion.md | Estrategia |
| 13 | 13_gobernanza_riesgos.md | Gobernanza y Riesgos |
| 14 | 14_futuro_2030.md | Futuro 2030 |

2. **Escanear TODAS las referencias** en todos los archivos (capitulos/ + apendices/ + BOOK_MASTER.md) con Grep:

- `Capítulo \d+` — menciones generales
- `Cap\.\s*\d+` — formato abreviado
- `Apéndice [A-E]` — apéndices
- `Framework #\d+` — frameworks del Apéndice B

3. **Validar cada referencia** contra el mapa:
- Cap 5 + contexto "evolución/técnica" = **ERROR** (Cap 5 es Sesgos, evolución es Cap 7)
- Cap 6 + contexto "ecosistema/herramientas" = **ERROR** (Cap 6 es Guía por Industria, ecosistema es Cap 8)
- Cap 7 + contexto "impacto/negocio" = **ERROR** (Cap 7 es Evolución Técnica, impacto es Cap 9)
- Cap > 14 = **ERROR**
- Framework # > 12 = **ERROR**

4. **Generar reporte** con cada referencia categorizada: OK, ADVERTENCIA, ERROR.

---

## /roi-check

Auditoría de consistencia de cifras ROI, métricas financieras y estadísticas.

**Proceso:**

1. **Extraer TODAS las cifras ROI** con Grep en todos los archivos:

- `ROI.*\d+[%x]|\d+[%x].*ROI` — ROI con porcentaje/multiplicador
- `\$[\d,.]+` — cifras en dólares
- `\d+%\s*(mejora|aumento|reducción|incremento|productividad)` — métricas de productividad

2. **Construir tabla de ROI por caso de estudio.** Buscar en caps 08-12 las cifras clave: inversión, beneficio, ROI declarado.

3. **Comparar contra Executive Brief** (`00a`) y `09_impacto_negocio.md` para verificar consistencia.

4. **Detectar cifras sin caveat.** Para ROI > 1,000%, verificar que en un rango de ±5 líneas exista algún caveat:
- Patrón de caveats: `P25|P50|P75|P90|sensibilidad|distribución|percentil|mediana|outlier|caveat|conservador|ajust|brut`

5. **Detectar estadísticas sobre-repetidas** (>5 apariciones):

- `55%.*productividad|productividad.*55%` (MIT RCT)
- `30%.*código.*IA|30-40%` (Gartner)
- `96%.*confía|96%.*confianza` (GitHub Survey)
- `40%.*cancelad|40%.*proyectos` (Gartner predicción)

6. **Validación 6: Cost Coverage.** Verificar presencia de análisis de costos reales:

- Token/API pricing: grep `costo.*token|precio.*API|costo.*infer|pricing` en caps 05, 06, 07
- Vendor lock-in: grep `lock.in|dependencia.*proveedor|portabilidad`
- TCO: grep `TCO|costo total|costo oculto`
- Tabla comparativa de costos: buscar tabla con 3+ vendors y columna de precio

Flag si alguno está completamente ausente del libro. Flag si datos de costos no tienen "Dato verificado" o fecha.

7. **Generar reporte** con tabla consolidada, inconsistencias, cifras sin caveat, estadísticas sobre-repetidas, y gaps de cost coverage.

---

## /lint

Verificación rápida de formato y estilo (pre-build, sin leer contenido completo).

**Proceso:**

1. **Verificar estructura de archivos.** Usar Glob para confirmar que existen todos los archivos listados en BOOK_MASTER.md (18 caps + 5 apéndices).

2. **Verificar word count por capítulo.** Usar `wc -w` en cada archivo. Comparar contra objetivos:

| Parte | Objetivo (palabras) | Archivos |
|-------|---------------------|----------|
| I: Contexto | ~21,000 (60 págs) | 00, 00a, 01, 02, 03, 04 |
| II: Sesgos y Evidencia | ~14,000 (40 págs) | 05, 06 |
| III: Tecnología | ~21,000 (60 págs) | 07, 08 |
| IV: Impacto en el Negocio | ~17,500 (50 págs) | 09, 10 |
| V: Liderazgo y Estrategia | ~15,750 (45 págs) | 11, 12 |
| VI: Gobernanza y Futuro | ~12,250 (35 págs) | 13, 14 |
| Apéndices | ~12,250 (35 págs) | A, B, C, D, E |

Reportar archivos <70% o >130% del objetivo proporcional.

3. **Verificar bloques "Dato verificado".** Para caps que citan datos de mercado (01, 05, 06, 07, 09, 10, 13, 14): buscar con Grep `Dato verificado` y contar. Mínimo 1 por capítulo.

4. **Verificar formato de "Dato verificado".** Para cada bloque, verificar los 4 campos requeridos buscando en las 6 líneas siguientes:
- `Fuente:`
- `Qué mide:`
- `Limitación:`
- `Implicación:`

5. **Buscar placeholders olvidados** con Grep: `<<[A-Z]|TODO|FIXME|TBD|PLACEHOLDER|XXX` (case insensitive).

6. **Generar reporte** en formato tabla compacta:

```
LINT REPORT — [fecha]

ESTRUCTURA: [N] archivos presentes de [M] esperados
PLACEHOLDERS: [N] encontrados

WORD COUNT:
| Archivo | Palabras | Objetivo | % | Estado |
|---------|----------|----------|---|--------|
| 01_... | 8,790 | ~7,000 | 126% | ✅ |
Total: [N] palabras (~[N/350] páginas)

DATOS VERIFICADOS:
| Archivo | Bloques | Formato OK |
|---------|---------|------------|
| 01_... | 2 | 2/2 ✅ |
```

---

## /redundancy

Detecta contenido repetido entre capítulos — stats, citas, y overlap temático.

**Proceso:**

1. **Stats duplicadas (dinámico).** Grep `\d+[%x]` en todos los archivos de `capitulos/`. Para cada stat encontrada:
- Extraer el número + contexto (±5 palabras)
- Agrupar por valor numérico (ej. todos los "55%" juntos, todos los "40%" juntos)
- Flag: cualquier stat que aparezca en **3+ archivos distintos**
- Output: tabla `| Stat | Contexto | Archivos | Ocurrencias | Recomendación |`

Ejemplos conocidos que deben detectarse: `46%`, `55%`, `40%.*cancel`, `126%`, `48%.*vulnerab`, `84%.*desarroll`.

2. **Citas duplicadas.** Grep para nombres propios en contexto de cita:
- Buscar: `Nadella|Amodei|Altman|Huang|Pichai|Zuckerberg` y contar por archivo
- Buscar: `dijo|afirmó|declaró|según|señaló|predijo` cerca de nombres propios
- Flag: persona citada **>5 veces** en todo el libro
- Output: tabla `| Persona | Menciones | Archivos | Acción sugerida |`

3. **Overlap temático entre capítulos.** Extraer todos los H2 (`^## `) y H3 (`^### `) de cada capítulo:
- Comparar pares de capítulos por similitud de headings (mismas palabras clave)
- Flag: pares con >30% de headings compartiendo palabras clave
- **Foco especial**: Prefacio (00) / Executive Brief (00a) / Cap 01 / Cap 02 / Cap 03 — zona de máxima redundancia reportada
- Output: `| Cap A | Cap B | Headings similares | % Overlap | Acción |`

4. **Generar reporte consolidado:**

```
ANÁLISIS DE REDUNDANCIA — [fecha]

══ STATS REPETIDAS ══
Total: [N] stats en 3+ archivos
| Stat | Contexto | Archivos (N) | Recomendación |

══ CITAS REPETIDAS ══
| Persona | Total | Archivos | Acción |

══ OVERLAP TEMÁTICO ══
| Cap A | Cap B | Overlap | Acción |

RECOMENDACIÓN GLOBAL:
- [N] stats a deduplicar (mantener en cap principal, citar brevemente en otros)
- [N] personas sobre-citadas (diversificar voces)
- [N] pares de caps con overlap alto (considerar fusión o cross-reference)
```

---

## /shelf-life

Detecta contenido que envejecerá rápido (precios, versiones, predicciones con año, modelos específicos).

**Proceso:**

1. **Buscar patrones efímeros** con Grep en todos los archivos de `capitulos/`:

| Patrón | Tipo | Regex |
|--------|------|-------|
| Versiones de software | EFÍMERO | `v\d+\.\d+\|versión \d+` |
| Precios específicos | EFÍMERO | `\$\d+.*mes\|\$\d+.*token\|\$\d+.*seat\|USD\s*\d+` |
| Modelos específicos | EFÍMERO | `GPT-4o\|GPT-4\|Claude 3\.5\|Claude 3\|Gemini.*Pro\|o1-preview\|Sonnet 3\.5\|Opus\|Haiku` |
| Predicciones con año | FECHADO | `para 20\d{2}\|en 20\d{2}\|antes de 20\d{2}\|para finales de 20\d{2}` |
| Market share | FECHADO | `\d+%.*market\|\d+%.*mercado\|\d+%.*cuota` |
| Tablas comparativas | FECHADO | Tablas con 3+ herramientas (Cursor, Copilot, Cody, Tabnine, Windsurf, Devin, OpenHands) |

2. **Clasificar cada hallazgo:**

- **EFÍMERO** (caduca <6 meses): precios de API, benchmarks de modelos, versiones de software
- **FECHADO** (caduca <2 años): predicciones con año, comparativas de herramientas, market share
- **PERENNE** (seguro): frameworks, principios organizacionales, patrones de comportamiento

3. **Generar reporte:**

```
SHELF-LIFE ANALYSIS — [fecha]

══ EFÍMERO (actualizar antes de publicación) ══
| Archivo | Línea | Contenido | Tipo | Recomendación |
| 05_... | 234 | "$19/usuario/mes" | Precio | Agregar "a fecha de publicación" |
| 04_... | 187 | "GPT-4o" | Modelo | Reescribir como "modelos frontier" |

══ FECHADO (revisar en 12-24 meses) ══
| Archivo | Línea | Contenido | Tipo | Recomendación |
| 16_... | 45 | "para 2028" | Predicción | Agregar fuente y caveat |

══ PERENNE (sin acción) ══
[N] secciones identificadas como contenido atemporal

RESUMEN:
- [N] items efímeros → considerar mover a apéndice/recurso online
- [N] items fechados → agregar calificador "a fecha de publicación"
- [N] items perennes → sin acción necesaria
```

---

## /depth-check

Detecta conceptos clave del libro tratados superficialmente.

**Proceso:**

1. **Registro de conceptos clave** (centrales a la tesis del libro):

```
ReAct, OODA, MCP, Model Context Protocol, RAG, Retrieval-Augmented Generation,
function calling, chain-of-thought, tool use, agentic loop,
human-in-the-loop, guardrails, context window, fine-tuning,
prompt engineering, multi-agent, orchestration, embeddings
```

2. **Para cada concepto**, buscar con Grep en todos los archivos de `capitulos/`:
- Contar ocurrencias totales
- Identificar en cuántos capítulos aparece
- Para cada ocurrencia, leer ±20 líneas y estimar palabras de contexto
- Verificar si tiene subsección dedicada: buscar H2/H3 que contenga el término

3. **Clasificar profundidad:**

| Criterio | Veredicto |
|----------|-----------|
| Total palabras contexto <500 | **SUPERFICIAL** |
| Aparece en solo 1 capítulo | **AISLADO** |
| Mencionado >5 veces sin subsección (H2/H3) | **NECESITA SECCIÓN** |
| >1000 palabras contexto + subsección dedicada | **ADECUADO** |

4. **Generar reporte:**

```
DEPTH CHECK — [fecha]

| Concepto | Menciones | Caps | Palabras ctxt | Subsección? | Veredicto |
|----------|-----------|------|---------------|-------------|-----------|
| ReAct | 3 | 1 | ~200 | ❌ | SUPERFICIAL |
| MCP | 8 | 3 | ~400 | ❌ | NECESITA SECCIÓN |
| human-in-the-loop | 12 | 7 | ~1500 | ✅ Cap 13 | ADECUADO |

ACCIONES RECOMENDADAS:
- [concepto]: Agregar subsección dedicada en Cap [X]
- [concepto]: Profundizar con diagrama conceptual y ejemplo de negocio
- Usar `/expand --depth [cap] [concepto]` para cada concepto SUPERFICIAL
```

---

## /case-audit

Compara los casos de estudio del libro para detectar overlap temático, monotonía de formato, y oportunidades de consolidación.

**Proceso:**

1. **Identificar capítulos de caso.** Buscar en `capitulos/` archivos que contengan `caso|Caso|case` en el nombre o que tengan badge de caso (Grep `Caso Real|ficticio|CASO` en primeras 20 líneas). Incluir explícitamente 10.

2. **Para cada caso**, leer primeras 50 líneas + sección de Takeaways y extraer:

| Campo | Cómo obtenerlo |
|-------|----------------|
| Industria/sector | De las primeras 30 líneas (contexto de la empresa) |
| Tamaño empresa | Grep `empleados|developers|equipo|personas` |
| Geografía | Grep `LATAM|Colombia|Chile|México|global|EE.UU|Europa` |
| Tema central | Del título H1 y Resumen Ejecutivo |
| Formato | Comparar H2/H3 headings contra template estándar (5-secciones) |
| Word count | `wc -w` |
| H3 headings | Lista completa para comparar estructura |

3. **Construir matriz comparativa:**

```
CASE AUDIT — [fecha]

══ MATRIZ COMPARATIVA ══
| Cap | Industria | Tamaño | Geo | Tema | Formato | Words |
|-----|-----------|--------|-----|------|---------|-------|
| 07 | Fintech | Mediana | LATAM | Adopción ágil | Estándar 5-sec | 5,067 |
| 08 | Software | Enterprise | Global | Gobernanza | Estándar 5-sec | 5,098 |
```

4. **Detectar problemas:**

- **Formato monótono**: Si >80% de los casos usan exactamente la misma estructura de H2/H3 → Flag "MONOTONÍA DE FORMATO — variar: narrativo, Q&A, postmortem, financiero"
- **Overlap industria**: 2+ casos en la misma industria → Flag "OVERLAP INDUSTRIA"
- **Overlap tamaño**: 3+ casos del mismo tamaño de empresa → Flag "FALTA DIVERSIDAD DE TAMAÑO"
- **Overlap temático**: Comparar H3 headings entre pares. Si >50% de headings son similares → Flag "CONSOLIDAR"

5. **Generar recomendaciones:**

```
DIAGNÓSTICO:
- Formato: [VARIADO | MONÓTONO]
- Diversidad industria: [ALTA | MEDIA | BAJA]
- Diversidad tamaño: [ALTA | MEDIA | BAJA]
- Overlap temático: [BAJO | MEDIO | ALTO]

RECOMENDACIONES:
- [Cap X] y [Cap Y]: >50% overlap → considerar fusión
- Todos los casos usan formato 5-secciones → variar al menos 2
- Falta caso en [industria/tamaño/geografía no representada]
```

---

## Notas de Uso

- Todos los comandos son de solo lectura (no modifican archivos)
- Usar `/audit all` como quality gate antes de cada `/build`
- Usar `/lint` para checks rápidos durante la escritura
- Usar `/xref` después de cualquier renumeración de capítulos
- Usar `/roi-check` después de editar cifras en cap 09 o casos de estudio
- Usar `/redundancy` para detectar stats, citas y secciones repetidas
- Usar `/shelf-life` antes de publicación para identificar contenido efímero
- Usar `/depth-check` para verificar que conceptos clave tienen profundidad adecuada
- Usar `/case-audit` para evaluar diversidad y overlap de casos de estudio
