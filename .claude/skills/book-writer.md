---
name: book-writer
description: Comandos para escribir y expandir el libro "Agéntico por Diseño, Tomo I"
---

# Skill: Book Writer

Comandos especializados para la construcción del libro sobre IA agéntica.

## /expand [capitulo] [--costs|--depth concepto]

Expande el capítulo indicado. Soporta 3 modos:

### Modo estándar: `/expand [capitulo]`

Expande al doble de su tamaño actual.

**Proceso:**
1. Lee el capítulo actual desde `/ingenieria_agentica/capitulos/`
2. Identifica secciones que pueden profundizarse
3. Agrega:
   - Frameworks de decisión
   - Datos de mercado (usar WebSearch si es necesario)
   - Recuadros "Para tu próxima reunión de liderazgo"
   - Ejemplos empresariales (sin código)
   - Preguntas de reflexión
4. Mantiene el tono ejecutivo (para gerentes/líderes técnicos)
5. Guarda el capítulo expandido

**Ejemplo:** `/expand 03` expande el capítulo 03_que_es_ia_agentica.md

### Modo costos: `/expand --costs [capitulo]`

Agrega análisis de costos reales de LLMs, TCO, y vendor lock-in al capítulo.

**Proceso:**
1. Usar WebSearch para buscar datos actuales de pricing: Anthropic (Claude API), OpenAI (GPT-4o API), Google (Gemini API), herramientas (Cursor, Copilot, Cody)
2. Agregar sección con:
   - Tabla comparativa de costos por tipo de herramienta (asistente IDE vs agente vs API directa)
   - Cálculo de TCO para equipo de 50 developers (licencias + API + infra + capacitación)
   - Análisis de vendor lock-in: qué pasa si cambias de herramienta, portabilidad de flujos
   - Bloque "Dato verificado" con fuentes y limitaciones
3. NO expandir genéricamente — solo agregar contenido sobre costos
4. Formato: tablas con datos reales, no rangos vagos

**Ejemplo:** `/expand --costs 05` agrega análisis de costos al capítulo de ecosistema de herramientas

### Modo profundidad: `/expand --depth [capitulo] [concepto]`

Profundiza un concepto específico que fue flaggeado como SUPERFICIAL por `/depth-check`.

**Proceso:**
1. Leer el capítulo y encontrar todas las menciones del concepto
2. Crear subsección dedicada (H3) con:
   - Explicación conceptual SIN código (usar analogías de negocio)
   - Diagrama textual del flujo (paso 1 → paso 2 → paso 3)
   - Ejemplo real de aplicación empresarial
   - Tabla: "Cuándo usar vs cuándo NO usar"
   - Implicación para el líder: "¿Qué preguntar a tu equipo sobre [concepto]?"
3. NO agregar snippets de código — el libro es para ejecutivos
4. Apuntar a ~500-800 palabras de contenido nuevo por concepto

**Ejemplo:** `/expand --depth 03 ReAct` agrega subsección sobre ReAct en el cap de IA agéntica

---

## /case-study [real|ficticio] [tema]

Genera un caso de estudio de aproximadamente 20 páginas.

**Parámetros:**
- `real` - Basado en empresa real, usa WebSearch para investigar
- `ficticio` - Empresa ficticia pero patrones realistas

**Temas sugeridos:**
- fintech-latam
- enterprise-global
- startup-producto
- transformacion-ti
- equipo-hibrido

**Estructura del caso:**
1. El Contexto (3 págs)
2. La Decisión (4 págs)
3. La Implementación (5 págs)
4. Los Resultados (4 págs)
5. Lecciones para Líderes (4 págs)

**Ejemplo:** `/case-study real fintech-latam`

---

## /research [tema]

Investiga datos actualizados usando WebSearch.

**Busca:**
1. Datos de mercado 2024-2026 (Gartner, McKinsey, Forrester)
2. Declaraciones de CEOs/CTOs relevantes
3. Métricas de productividad publicadas
4. Casos documentados de adopción
5. Tendencias de inversión

**Output:** Lista estructurada de hallazgos con fuentes citables.

**Ejemplo:** `/research adopcion-ia-agentica-latam`

---

## /chapter-outline [numero]

Genera un outline expandido para un capítulo específico.

**Incluye:**
- Estructura de secciones sugerida
- Puntos clave a cubrir
- Frameworks relevantes
- Datos que se necesitan investigar
- Estimación de páginas por sección

**Ejemplo:** `/chapter-outline 06` genera outline para el capítulo de impacto en negocio

---

## Notas de Uso

- Todos los comandos respetan las reglas de CLAUDE.md
- El tono siempre es ejecutivo, NO técnico-código
- Citar fuentes cuando se usen datos externos
- Mantener español neutro latinoamericano
