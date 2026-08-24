# Agéntico por Diseño, Tomo I: Tecnologías de la Información

**Índice Maestro del Libro**

---

## Metadata

- **Título**: Agéntico por Diseño
- **Tomo**: I - *Tecnologías de la Información*
- **Serie**: Agéntico por Diseño. El Tomo I es este; el Capítulo 14 anuncia un **Tomo II: Operaciones**. No hay ningún otro tomo comprometido en el repositorio.
- **Subtítulo**: Tecnologías de la Información
- **Autor**: Karim Touma
- **Audiencia**: Gerentes y líderes técnicos (VP Eng, CTO, Tech Leads) en América Latina
- **Extensión real**: 142,097 palabras / 577 páginas compiladas
- **Idioma**: Español (neutro latinoamericano)
- **Licencia**: Unlicense (dominio público), aplica al código y al contenido del libro
- **Estado**: Contenido completado + revisión editorial + cirugía de contenido (eliminación de todos los casos ficticios)

### Cómo se midieron estas cifras

Palabras (fuente de verdad, sobre el markdown):

```bash
cd ingenieria_agentica && wc -w capitulos/*.md apendices/*.md
```

Páginas (fuente de verdad, sobre el PDF compilado y su `.toc`):

```bash
pdfinfo latex-pipeline/output/agentico-por-diseno.pdf | grep Pages
grep -E '\\contentsline \{chapter\}' latex-pipeline/output/agentico-por-diseno.toc
```

Advertencia sobre la columna **Págs**: el rango va desde la página de inicio del
capítulo hasta la página anterior al inicio del siguiente. Por eso los capítulos 4,
6, 8, 10 y 12 "cargan" con las páginas del divisor de parte y la hoja de notas que
los siguen. La densidad real es de ~261 palabras de markdown por página de contenido
(142,097 / 544 páginas, de la 3 a la 546, excluyendo el índice analítico), no las
400-450 que declara `CLAUDE.md` (el markdown no cuenta tablas renderizadas, callouts
ni espacio en blanco tipográfico).

---

## Estructura del Libro

Las seis partes no son una convención editorial suelta: están implementadas en
`latex-pipeline/filters/part-dividers.lua`, que inserta `\partdivider` antes del
capítulo disparador y, justo después de esa página divisoria, una `\notespage` (la
Parte I se salta la hoja de notas). La hoja de notas abre la parte, no la cierra.

| Parte | Título | Capítulo disparador | Págs PDF | Palabras |
|-------|--------|---------------------|----------|----------|
| I | Contexto Estratégico | Cap. 0 (Prefacio) | 3-136 | 38,385 |
| II | Sesgos y Evidencia | Cap. 5 | 137-174 | 9,377 |
| III | La Tecnología | Cap. 7 | 175-256 | 22,161 |
| IV | Impacto en el Negocio | Cap. 9 | 257-300 | 11,085 |
| V | Liderazgo y Estrategia | Cap. 11 | 301-368 | 17,607 |
| VI | Gobernanza y Futuro | Cap. 13 | 369-462 | 23,977 |

### PARTE I: CONTEXTO ESTRATÉGICO (134 págs, 38,385 palabras)

| # | Archivo | Título (H1 real del fichero) | Págs | Palabras | Estado |
|---|---------|------------------------------|------|----------|--------|
| 0 | [00_prefacio.md](capitulos/00_prefacio.md) | Prefacio: Por Qué los Líderes Deben Leer Esto Ahora | 3-14 | 3,692 | Completado (front matter) |
| - | [00a_executive_brief.md](capitulos/00a_executive_brief.md) | Resumen Ejecutivo para el Líder | 15-24 | 2,218 | Completado (front matter) |
| 1 | [01_introduccion.md](capitulos/01_introduccion.md) | El Nuevo Paradigma de la Ingeniería de Software | 25-60 | 10,747 | Completado |
| 2 | [02_paradigmas.md](capitulos/02_paradigmas.md) | De los Paradigmas Tradicionales al Paradigma Agéntico | 61-86 | 6,552 | Completado |
| 3 | [03_que_es_ia_agentica.md](capitulos/03_que_es_ia_agentica.md) | ¿Qué Es Realmente la Inteligencia Artificial Agéntica? | 87-114 | 7,975 | Completado |
| 4 | [04_por_que_diseñar.md](capitulos/04_por_que_diseñar.md) | Por Qué Diseñar, No Solo Adoptar: La Lección Que Toda Revolución Tecnológica Nos Enseña | 115-136 | 7,201 | Completado |

### PARTE II: SESGOS Y EVIDENCIA (38 págs, 9,377 palabras)

| # | Archivo | Título (H1 real del fichero) | Págs | Palabras | Estado |
|---|---------|------------------------------|------|----------|--------|
| 5 | [05_sesgos_cognitivos.md](capitulos/05_sesgos_cognitivos.md) | Sesgos Cognitivos en la Era de la IA Agéntica | 137-154 | 4,986 | Completado |
| 6 | [06_guia_por_industria.md](capitulos/06_guia_por_industria.md) | Guía por Industria: Dónde Están los Quick Wins | 155-174 | 4,391 | Completado |

### PARTE III: LA TECNOLOGÍA (82 págs, 22,161 palabras)

| # | Archivo | Título (H1 real del fichero) | Págs | Palabras | Estado |
|---|---------|------------------------------|------|----------|--------|
| 7 | [07_evolucion_tecnica.md](capitulos/07_evolucion_tecnica.md) | La Evolución Técnica Hacia la IA Agéntica en Ingeniería | 175-206 | 8,959 | Completado |
| 8 | [08_ecosistema_herramientas.md](capitulos/08_ecosistema_herramientas.md) | El Ecosistema de Herramientas Agénticas - Guía de Selección para Líderes | 207-256 | 13,202 | Completado |

### PARTE IV: IMPACTO EN EL NEGOCIO (44 págs, 11,085 palabras)

| # | Archivo | Título (H1 real del fichero) | Págs | Palabras | Estado |
|---|---------|------------------------------|------|----------|--------|
| 9 | [09_impacto_negocio.md](capitulos/09_impacto_negocio.md) | El Impacto en el Negocio - ROI, TCO y Justificación Financiera | 257-288 | 8,260 | Completado |
| 10 | [10_cuando_falla.md](capitulos/10_cuando_falla.md) | Cuando la IA Agéntica Falla: Lecciones de Implementaciones Fallidas | 289-300 | 2,825 | Completado (el capítulo numerado más corto; el Apéndice E, con 2,003, es la pieza más corta del libro) |

### PARTE V: LIDERAZGO Y ESTRATEGIA (68 págs, 17,607 palabras)

| # | Archivo | Título (H1 real del fichero) | Págs | Palabras | Estado |
|---|---------|------------------------------|------|----------|--------|
| 11 | [11_liderando_equipos_ia.md](capitulos/11_liderando_equipos_ia.md) | Liderando Equipos en la Era de la IA | 301-336 | 10,185 | Completado |
| 12 | [12_estrategia_adopcion.md](capitulos/12_estrategia_adopcion.md) | Estrategia de Adopción - Hoja de Ruta de IA Agéntica | 337-368 | 7,422 | Completado |

### PARTE VI: GOBERNANZA Y FUTURO (94 págs, 23,977 palabras)

| # | Archivo | Título (H1 real del fichero) | Págs | Palabras | Estado |
|---|---------|------------------------------|------|----------|--------|
| 13 | [13_gobernanza_riesgos.md](capitulos/13_gobernanza_riesgos.md) | Desafíos, Riesgos y Gobernanza del Paradigma Agéntico | 369-424 | 13,706 | Completado (el más largo del libro) |
| 14 | [14_futuro_2030.md](capitulos/14_futuro_2030.md) | Visión a Futuro - 2026-2030 | 425-462 | 10,271 | Completado |

### APÉNDICES (84 págs, 19,505 palabras)

| # | Archivo | Título (H1 real del fichero) | Págs | Palabras | Estado |
|---|---------|------------------------------|------|----------|--------|
| A | [A_glosario.md](apendices/A_glosario.md) | Apéndice A: Glosario Ejecutivo | 463-474 | 4,428 | Completado (91 términos) |
| B | [B_frameworks_decision.md](apendices/B_frameworks_decision.md) | Apéndice B: Frameworks de Decisión | 475-494 | 4,365 | Completado (12 frameworks numerados) |
| C | [C_checklist_implementacion.md](apendices/C_checklist_implementacion.md) | Apéndice C: Checklist de Implementación | 495-514 | 3,579 | Completado (115 checkpoints) |
| D | [D_recursos.md](apendices/D_recursos.md) | Apéndice D: Recursos y Lecturas Recomendadas | 515-538 | 5,130 | Completado |
| E | [E_modelos_mentales.md](apendices/E_modelos_mentales.md) | Apéndice E: Modelos Mentales Técnicos para Decisores | 539-546 | 2,003 | Completado |

**Índice analítico**: páginas 547-577 (31 págs), generado por `imakeidx` (declarado en
`cls/paradigma-agentico.cls`, invocado desde `templates/book.tex` con `\printindex` y
`--shell-escape`) a partir de 290 spans `[término]{.idx}`. Esas 290 marcas están **solo**
en los capítulos 01-14: el Prefacio, el Resumen Ejecutivo y los cinco apéndices tienen
cero.

**Nota sobre el conteo de frameworks**: el Apéndice B contiene 12 frameworks numerados
más una sección final "Cómo Usar Estos Frameworks". El MCP server reporta **13** porque
`mcp-server/scripts/prepare-content.ts` trocea el apéndice por encabezados `##` y trata
esa sección de cierre como un framework más. La cifra editorial correcta es 12.

---

## Progreso de Escritura

### Estado Final

- **Capítulos numerados completados**: 14 de 14 (01-14), más 2 piezas de front matter (00 Prefacio, 00a Resumen Ejecutivo)
- **Apéndices completados**: 5 de 5 (A-E)
- **Palabras totales**: 142,097 (122,592 en capítulos + 19,505 en apéndices)
- **Páginas compiladas**: 577
- **Patrones editoriales**: los 14 capítulos numerados cumplen los 8 bloques obligatorios (Resumen Ejecutivo, Dato verificado, Conclusiones y Takeaways, Preguntas de Reflexión, Para Tu Próxima Reunión de Liderazgo, Tarjeta de Referencia Rápida, Referencias, Fin del Capítulo). El Prefacio y el Resumen Ejecutivo no los llevan, y es correcto: son front matter, no capítulos.
- **Salud del build**: 0 errores de TeX, 0 caracteres perdidos, 0 referencias sin resolver, 0 etiquetas duplicadas, 20 overfull hboxes cosméticos

### Ilustraciones: infraestructura lista, no activa

`figuras/manifest.yml` registra 46 figuras y **las 46 están en status `placeholder`**.
Los directorios `figuras/tikz/` y `figuras/svg/` están vacíos, y el texto del libro
contiene **cero** referencias `![fig:id]`. El pipeline de figuras funciona; nadie lo
ha usado todavía. Ciclo de vida previsto: `placeholder` → `draft` → `final`.

### Historial de Sesiones

| Sesión | Contenido | Palabras Agregadas |
|--------|-----------|-------------------|
| Sesión 1 | Capítulos 00-12 (estructura + contenido base) | ~94,000 |
| Sesión 2 | Capítulos 11-12 (gobernanza, futuro) | ~29,500 |
| Sesión 3 | Apéndices A-D (glosario, frameworks, checklists, recursos) | ~13,500 |
| Sesión 4 | Revisión editorial: takeaways, preguntas de reflexión, corrección de inconsistencias | ~6,000 |
| Sesión 5 | Feedback editorial: badges, datos verificados, Executive Brief, placeholders | ~4,500 |
| Sesión 6 | Revisión estratégica: ROI reality check, purga lenguaje de miedo, contenido LATAM | ~5,000 |
| Sesión 7 | Cirugía de contenido: eliminación de 3 casos ficticios (~19,600 palabras), nuevo Cap basado en investigación (~10,000 palabras), sidebars con lecciones únicas rescatadas, renumeración caps 8-12, mejora de skills (6 nuevos comandos) | -9,600 netas |
| Sesión 8 | Eliminación completa de casos ficticios: FinNova y GlobalSoft (2 capítulos eliminados), 8 sidebars narrativos removidos, Ch10b y Ch14 reestructurados con datos reales, renumeración caps 5-12 | -15,000 netas |

Las cifras de esta tabla son el registro histórico de cada sesión y no suman las
142,097 palabras actuales: las sesiones posteriores de expansión y enriquecimiento
editorial no quedaron registradas aquí. La cifra vigente es siempre la que devuelve
`wc -w`, no esta tabla.

### Cambios de la Sesión 8 (Eliminación Total de Casos Ficticios)

**Eliminados:**
- Cap 05 (FinNova - caso fintech LATAM ficticio) - capítulo completo
- Cap 06 (GlobalSoft - caso enterprise ficticio) - capítulo completo
- 8 sidebars "En la Práctica" que referenciaban FinNova/GlobalSoft
- 3 viñetas ficticias en Cap 14 (MedicoAI, CodeAssist Pro, TechCorp)
- 3 casos ficticios en Cap 10b (DataFlow, CloudBridge, FinanceCore)

**Reestructurado:**
- Cap 10 (antes 10b): 3 patrones de fracaso basados en datos (Gartner, GitClear, METR, Snyk)
- Cap 12 (antes 14): Viñetas reemplazadas con datos reales (Cursor, Gartner Hype Cycle, McKinsey)

**Renumeración:**
- Caps 7-14 → Caps 5-12 (eliminación de 2 capítulos reduce numeración)
- 9 archivos renombrados, ~60+ referencias cruzadas actualizadas
- Part dividers actualizados en esa sesión: I→0, II→4, III→6, IV→8, V→9, VI→11.
  **Ese mapeo ya no es el vigente**: tras la renumeración posterior a numeración
  puramente numérica, `part-dividers.lua` usa I→0, II→5, III→7, IV→9, V→11, VI→13.

### Cambios de la Sesión 7 (Cirugía de Contenido Anterior)

**Eliminados:**
- Cap 09 ficticio (Startup Producto) -6,546 palabras
- Cap 4 ficticio (Transformación TI) -6,523 palabras
- Cap 9 ficticio (Equipo Híbrido) -6,541 palabras

**Creado:**
- Cap 05 (Guía por Industria) basado en 15+ fuentes reales (METR, BCG, GitClear, DORA, McKinsey, Deloitte)

**Lecciones únicas rescatadas como sidebars:**
- Métricas AI-first para VCs → Cap 9 (Impacto Negocio)
- Garantía de no despidos → Cap 12 (Estrategia Adopción)
- Negociación con sindicatos/reguladores → Cap 13 (Gobernanza)
- Equipo mínimo viable (3 roles) + Span of control → Cap 11 (Liderando Equipos)

---

## Próximos Pasos

1. [x] Expandir capítulos existentes
2. [x] Crear casos de estudio reales
3. [x] Purgar todo caso de estudio ficticio (regla dura del proyecto: no se fabrican empresas, sitios, casos, cifras ni citas)
4. [x] Escribir prefacio
5. [x] Crear apéndices
6. [x] Revisión de coherencia y pulido editorial
7. [x] Feedback editorial implementado (Sesión 5)
8. [x] Revisión estratégica (Sesión 6)
9. [x] Cirugía de contenido (Sesión 7)
    - Eliminación de 3 casos ficticios redundantes (-19,600 palabras)
    - Nuevo Cap basado en investigación real (+10,000 palabras)
    - Sidebars con lecciones únicas preservadas
    - Renumeración de capítulos 8-12
    - 6 nuevos skills de calidad y editorial
10. [x] Eliminación total de casos ficticios (Sesión 8)
    - FinNova y GlobalSoft (2 capítulos completos eliminados)
    - 8 sidebars narrativos, 6 viñetas ficticias reemplazadas con datos reales
    - Renumeración caps 5-12, actualización de ~60+ referencias cruzadas
11. [x] Maquetación profesional en LaTeX (`latex-pipeline/`)
    - Clase `paradigma-agentico.cls` sobre memoir, trim 9.68in x 7.44in (Crown Quarto)
    - 577 páginas, build limpio con `logcheck` como quality gate
12. [ ] Producir las 46 ilustraciones y referenciarlas desde el texto (hoy: 46/46 en placeholder, 0 referencias en el manuscrito)
13. [ ] Revisión por pares / beta readers
14. [ ] Publicación

---

## Cómo Regenerar el PDF

Desde el directorio `latex-pipeline/`:

```bash
cd latex-pipeline && docker compose run --rm book make pdf
```

`make pdf` encadena `logcheck`, que falla si el log del último pase de LuaLaTeX
contiene errores de TeX, caracteres perdidos, referencias sin resolver o etiquetas
duplicadas. Para saltarse ese control: `make pdf STRICT=0`.

**Trampa conocida:** en `latex-pipeline/config.yml` solo se consumen las claves bajo
`book:` (title, tomo, subtitle, author, lang, date), vía `--metadata-file`, más
`figure-mode`, que lee `filters/figure-transform.lua` (`all` | `final-only` |
`no-placeholders`). Las claves `theme`, `page_size`, `mode`, `fonts:`, `layout:` y
`features:` son letra muerta: el `.cls` hardcodea todo eso. Editarlas no cambia nada
en el PDF, aunque `config.yml` diga lo contrario (por ejemplo, declara `size: 11pt` y
márgenes de 3cm/2.5cm cuando el `.cls` fija 10pt, caja de 21.0 x 13.5 cm, interior
2.2cm y superior 1.8cm).
