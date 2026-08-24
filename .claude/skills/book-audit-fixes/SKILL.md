---
name: book-audit-fixes
description: Reglas anti-regresión basadas en 28 correcciones de 5 rondas de auditoría. Consultar ANTES de escribir o editar contenido.
---

# Skill: Audit Fixes & Anti-Regression Rules

Reglas derivadas de 5 rondas de auditoría (28 correcciones). **Consultar antes de escribir contenido nuevo o editar capítulos existentes.**

---

## 1. Fuentes y Datos: NUNCA Fabricar

**Regla:** Toda estadística debe tener fuente real verificable. NUNCA inventar nombres de empresas, estudios o URLs.

**Errores corregidos:**
- "NetCorp Software Development" (Ch01) era ficticio → reemplazado por Snyk (2024) y Pearce et al. (2022)
- "$420M ahorrados por Microsoft" no tenía fuente → corregido a ">$500M" (Judson Althoff, CCO, 2025)
- "96% de desarrolladores con ansiedad" era confusión con otra stat → corregido a ">70%" (EY, 2025)
- "GitHub Internal Productivity Study" era vago → corregido a "Peng et al." (2023)

**Protocolo para nuevas estadísticas:**
1. Buscar la fuente primaria con WebSearch
2. Verificar que el número exacto exista en la fuente
3. Incluir año, autor/organización, y contexto metodológico
4. Agregar bloque `> **Dato verificado:**` con los 4 campos (Fuente, Qué mide, Metodología/Limitaciones, Implicación)

---

## 2. Footnotes: Convención de Prefijo por Capítulo

**Regla:** Las footnotes DEBEN usar prefijo `[^chX-name]` donde **X = número del capítulo donde aparecen**.

**Errores corregidos:**
- Ch07 tenía `[^ch4-1]` (copy-paste del template) → corregido a `[^ch7-1]`
- Ch09 tenía `[^ch6-cost1]` → corregido a `[^ch9-cost1]`

**Protocolo:**
- Al crear footnote en capítulo N, usar `[^chN-descriptivo]`
- Al copiar contenido entre capítulos, SIEMPRE actualizar el prefijo
- Cada referencia inline `[^chN-X]` debe tener exactamente una definición `[^chN-X]:` al final del archivo

---

## 3. Formato Editorial Estricto

### Dato verificado
**Regla:** Siempre `> **Dato verificado:**` con dos puntos al final.

**Error corregido:** Ch04 tenía `> **Dato verificado**` sin `:` → inconsistente con los otros 13 capítulos.

### Heading hierarchy
**Regla:** Nunca saltar niveles (H2 → H4). Siempre H1 → H2 → H3 → H4.

**Error corregido:** Ch13 tenía `## Checklist` seguido de `####` subcategorías (saltaba H3) → corregido a `###`.

### Em dashes
**Regla:** NUNCA usar `—` (em dash). Usar ` - ` (guion con espacios).

### Callouts: preferir blockquote syntax
**Regla para contenido nuevo:** Usar `> **Título**` (blockquote), NO `::: {.callout .tipo}` (fenced div).

El pipeline soporta ambos formatos (el handler Div fue agregado en ronda 5), pero la convención del libro es blockquote. Los 22 fenced divs existentes funcionan gracias al handler, pero NO crear nuevos.

---

## 4. Cross-References: Mapa Canónico Post-Renumeración

Los capítulos se renumeraron. El mapa vigente es:

| Cap # | Tema | Archivo |
|-------|------|---------|
| 0 | Prefacio | 00_prefacio.md |
| 0a | Executive Brief | 00a_executive_brief.md |
| 1 | Introducción | 01_introduccion.md |
| 2 | Paradigmas | 02_paradigmas.md |
| 3 | Qué es IA Agéntica | 03_que_es_ia_agentica.md |
| 4 | Por Qué Diseñar | 04_por_que_diseñar.md |
| 5 | **Sesgos Cognitivos** | 05_sesgos_cognitivos.md |
| 6 | Guía por Industria | 06_guia_por_industria.md |
| 7 | **Evolución Técnica** | 07_evolucion_tecnica.md |
| 8 | Ecosistema Herramientas | 08_ecosistema_herramientas.md |
| 9 | Impacto Negocio | 09_impacto_negocio.md |
| 10 | Cuando Falla | 10_cuando_falla.md |
| 11 | Liderando Equipos | 11_liderando_equipos_ia.md |
| 12 | Estrategia Adopción | 12_estrategia_adopcion.md |
| 13 | **Gobernanza y Riesgos** | 13_gobernanza_riesgos.md |
| 14 | Futuro 2030 | 14_futuro_2030.md |

**Errores comunes de cross-ref (ya corregidos):**
- Cap 5 NO es Evolución Técnica (eso es Cap 7)
- Cap 6 NO es Ecosistema (eso es Cap 8)
- Cap 11 NO es Gobernanza (eso es Cap 13) — error corregido en Ch06:118
- Softmax/temperatura se discuten en Cap 13, no Cap 11

---

## 5. Estadísticas Clave: Fuente Canónica

Estas stats aparecen en múltiples capítulos. Usar SIEMPRE la fuente canónica indicada:

| Stat | Fuente canónica | Cap principal | Nota |
|------|----------------|---------------|------|
| 46% código es IA | GitHub Octoverse **2025** | Prefacio, Ch03, Ch06 | NO "2024" |
| 55% más rápido | Peng et al. (2023), MIT RCT | Ch01, Ch09 | Peer-reviewed |
| 48% vulnerabilidades | **Snyk** AI Code Security (2024) | Ch05, Ch13 | NO Carnegie Mellon |
| 48% acceptance rate | Stanford (Murali et al., 2023) | Ch05 | Diferente del 48% Snyk |
| 88% adopta, 6% rediseña | McKinsey (**2023**) | Ch02, Ch04, Ch09 | NO "2024" |
| 40% cancelaciones | Gartner (predicción 2025→2027) | Ch10 | Específico: proyectos GenAI |
| 40% abandonará GenAI | Gartner (predicción) | Ch14 | Diferente de las cancelaciones |
| Microsoft código IA | **30-35%** (Nadella + Althoff, 2025) | Ch00a | NO solo "30%" ni solo "35%" |
| Microsoft productividad | **>$500M** (Althoff, CCO, 2025) | Ch00a, Ch09 | NO "$420M" |
| GitClear calidad | -39.2% moved code (2024) | Ch05 | Report anual |
| METR productividad | **-19% a +21%** rango (2025) | Ch00a | Dato en tension |
| Ansiedad desarrolladores | **>70%** (EY, 2025) | Ch00a | NO "96%" |

---

## 6. Referencias al Final de Capítulo

**Regla:** Todo capítulo debe tener sección `**Referencias:**` con lista numerada al final, ANTES del footer `*Fin del Capítulo X*`.

**Formato estándar:**
```markdown
**Referencias:**

1. Autor. (Año). "Título". *Publicación*. URL o DOI.
2. Organización. (Año). "Título del reporte". URL.
...

---

*Fin del Capítulo X — Continúa en Capítulo Y: "Título"*
```

**Errores corregidos:**
- Ch00a, Ch01, Ch11, Ch12, Ch13: no tenían sección de Referencias → agregadas
- Ch14: tenía referencia huérfana (Carnegie Mellon) sin cita en el cuerpo → eliminada

---

## 7. Años y Fechas

**Regla:** Verificar el año correcto de cada fuente antes de citar.

**Errores corregidos:**
- McKinsey "State of AI" es de **2023**, no 2024 (corregido en Ch14)
- GitHub Octoverse es de **2025**, no 2024 (corregido en Ch06)
- Ch08 tenía "febrero de 2025" cuando el libro se escribe en 2026 → corregido

---

## Checklist Pre-Escritura

Antes de escribir o editar contenido, verificar:

- [ ] Footnotes usan prefijo `[^chN-...]` correcto para el capítulo N
- [ ] Estadísticas citan fuente de la tabla canónica (sección 5)
- [ ] Cross-references usan números del mapa canónico (sección 4)
- [ ] Callouts usan sintaxis `> **Título**` (blockquote)
- [ ] `> **Dato verificado:**` tiene los dos puntos
- [ ] Headings no saltan niveles (H2→H3→H4)
- [ ] No hay em dashes (`—`), solo ` - `
- [ ] Sección `**Referencias:**` existe antes del footer
- [ ] Años de fuentes son correctos (McKinsey 2023, Octoverse 2025)
- [ ] No se fabrican nombres de empresas, URLs, ni estudios
