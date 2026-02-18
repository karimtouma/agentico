# Proyecto: Libro "Agéntico por Diseño, Tomo I: Tecnologías de la Información"

## Contexto
Estamos construyendo un libro de 300+ páginas sobre ingeniería de software para la era de los agentes.
El libro es fundacional: cómo diseñar organizaciones y equipos de desarrollo que operan con agentes autónomos.
Este es el **Tomo I** de la serie, enfocado en **Tecnologías de la Información**.
- **Audiencia**: Gerentes y líderes técnicos (VP Eng, CTO, Tech Leads)
- **Tono**: Profesional, accesible, sin código, enfocado en estrategia y ROI
- **Estructura**: 14 capítulos + 5 apéndices
- **Idioma**: Español neutro latinoamericano

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
5. **Em dashes (—)** — Usar siempre guion con espacios ( - ) en su lugar. Ejemplo: `palabra - otra palabra`, nunca `palabra—otra` ni `palabra — otra`

## Estructura de Archivos
```
/ingenieria_agentica/
├── capitulos/
│   ├── 00_prefacio.md
│   ├── 00a_executive_brief.md
│   ├── 01_introduccion.md
│   ├── 02_paradigmas.md
│   ├── 03_que_es_ia_agentica.md
│   ├── 04_por_que_diseñar.md
│   ├── 05_sesgos_cognitivos.md
│   ├── 06_guia_por_industria.md
│   ├── 07_evolucion_tecnica.md
│   ├── 08_ecosistema_herramientas.md
│   ├── 09_impacto_negocio.md
│   ├── 10_cuando_falla.md
│   ├── 11_liderando_equipos_ia.md
│   ├── 12_estrategia_adopcion.md
│   ├── 13_gobernanza_riesgos.md
│   └── 14_futuro_2030.md
├── apendices/
│   ├── A_glosario.md
│   ├── B_frameworks_decision.md
│   ├── C_checklist_implementacion.md
│   ├── D_recursos.md
│   └── E_modelos_mentales.md
├── templates/
│   └── capitulo_template.md
└── BOOK_MASTER.md
```

## Objetivos de Extensión por Sección

| Parte | Capítulos | Páginas Objetivo |
|-------|-----------|------------------|
| I: Contexto Estratégico | 00-04 | 60 |
| II: Sesgos y Evidencia | 05-06 | 50 |
| III: La Tecnología | 07-08 | 60 |
| IV: Impacto en el Negocio | 09-10 | 40 |
| V: Liderazgo y Estrategia | 11-12 | 45 |
| VI: Gobernanza y Futuro | 13-14 | 35 |
| Apéndices | A-E | 35 |
| **TOTAL** | | **~325** |

## Formato de Casos de Estudio

Cada caso debe incluir:
1. **El Contexto** - Industria, tamaño, desafío
2. **La Decisión** - Por qué IA agéntica, proceso de evaluación
3. **La Implementación** - Fases, obstáculos, cambio cultural
4. **Los Resultados** - Métricas antes/después, ROI
5. **Lecciones para Líderes** - Qué harían diferente

## MCPs Disponibles para Investigación
- `WebSearch` - Datos de mercado, declaraciones de líderes
- `browsermcp` - Navegación de sitios específicos
- `Apify` - Búsqueda de perfiles profesionales

## Comandos Útiles (Skills)

### Escritura
- `/expand [capitulo]` - Expandir un capítulo existente
- `/case-study [real|ficticio] [tema]` - Generar caso de estudio
- `/research [tema]` - Investigar datos actualizados
- `/chapter-outline [numero]` - Generar outline expandido

### Calidad
- `/audit [capitulo|all]` - Auditoría completa (estructura, xrefs, code, badges, footnotes, tono)
- `/xref` - Validación exhaustiva de referencias cruzadas
- `/roi-check` - Consistencia de cifras ROI, métricas y cost coverage
- `/lint` - Verificación rápida: word count, placeholders, datos verificados
- `/freshness` - ¿Está BOOK_FINAL.md sincronizado?
- `/redundancy` - Detectar stats, citas y secciones repetidas entre capítulos
- `/shelf-life` - Identificar contenido efímero (precios, versiones, predicciones)
- `/depth-check` - Verificar profundidad de conceptos clave
- `/case-audit` - Comparar casos de estudio por overlap y variedad

### Editorial
- `/enrich [capitulo]` - Agregar elementos faltantes (takeaways, preguntas, callouts)
- `/standardize [capitulo|all]` - Estandarizar formatos de callouts y badges
- `/stats` - Métricas editoriales completas + gravedad referencial
- `/verify-datos` - Auditar bloques "Dato verificado"
- `/tone-check [capitulo|all]` - Urgencia, densidad persuasiva, balance riesgo/beneficio, jerga
- `/voice-check` - Auditar diversidad de voces citadas (advocates vs. escépticos)
- `/language-check` - Detectar anglicismos inconsistentes y code-switching

### Build
- `/build` - Build completo del PDF
- `/preview [capitulo]` - Build rápido + abrir PDF
- `/check` - Validar cross-refs y warnings LaTeX
- `/optimize` - Fix tipografía
- `/theme [nombre]` - Cambiar tema visual
- `/export [formato]` - Exportar a formato alternativo
- `/status` - Estado del pipeline

---

## Comportamientos de Eficiencia

### IMPORTANTE: No leer contenido completo innecesariamente

**NUNCA** intentes leer todo el contenido del libro de una sola vez. El libro tiene 350+ páginas y leer todo el markdown o el PDF es ineficiente y excede límites de contexto.

**En su lugar:**
1. **Para verificar formato**: Lee solo las primeras 50-100 líneas de un capítulo
2. **Para buscar patrones**: Usa `Grep` para encontrar secciones específicas
3. **Para revisar estructura**: Lee solo el BOOK_MASTER.md o los encabezados
4. **Para verificar PDF**: Compila y revisa visualmente, no leas el LaTeX completo

**Archivos que SÍ puedes leer completos** (son cortos):
- `CLAUDE.md` (este archivo)
- `BOOK_MASTER.md`
- Templates en `/templates/`
- Archivos `.cls` y `.sty` de LaTeX

**Archivos que NUNCA debes leer completos:**
- PDFs generados
- Capítulos individuales (20-40 páginas cada uno)
- El libro compilado

---

## Especificaciones de Formato (Estilo Editorial)

El libro sigue estándares de editoriales técnicas profesionales (O'Reilly, Manning, Apress)
y principios tipográficos clásicos (Tschichold, Butterick).

| Parámetro | Valor | Notas |
|-----------|-------|-------|
| **Trim Size** | 7.44" × 9.68" (Crown Quarto) | Similar a O'Reilly Animal |
| **Font Body** | 10pt Libertinus Serif | Estándar profesional |
| **Line Spacing** | 1.15 (115%) | Butterick recomienda 120-145%; denso pero legible |
| **Type Block** | 21.0cm × 13.5cm | ~68-75 chars/línea |
| **Binding** | Twoside, openright | Hardcover, capítulos en recto |
| **Inner Margin** | 2.2cm | Gutter para encuadernación |
| **Outer Margin** | ~3.2cm | Espacio moderado para anotaciones |

### Márgenes Asimétricos (Hardcover)
Optimizado para densidad con espacio moderado de anotación:
- **Inner (gutter)**: 2.2cm - suficiente para case-bound hardcover
- **Outer**: ~3.2cm - permite notas a lápiz
- **Top**: 1.8cm
- **Bottom**: ~2.5cm (auto-calculado)

### Tablas
- Usar `booktabs` style (sin líneas verticales)
- `arraystretch`: 1.15 (compacto)
- Font: Sans-serif para claridad

### Densidad Objetivo
- ~400-450 palabras por página (con spacing 1.15 y type block 13.5cm)
- Evitar páginas con menos de 60% de contenido
- Tablas y figuras no deben dejar más de 1/3 de página vacía
