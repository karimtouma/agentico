---
name: book-writer
description: Comandos para escribir y expandir el libro "El Paradigma Agéntico"
---

# Skill: Book Writer

Comandos especializados para la construcción del libro sobre IA agéntica.

## /expand [capitulo]

Expande el capítulo indicado al doble de su tamaño actual.

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
