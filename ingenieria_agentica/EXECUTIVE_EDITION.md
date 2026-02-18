# Agéntico por Diseño - Edición Ejecutiva {.unnumbered}

## Para el Líder que Tiene 2 Horas {.unnumbered}

Este documento condensa los hallazgos principales de *Agéntico por Diseño, Tomo I* (~365 páginas) en una versión de ~60 páginas diseñada para CTOs, VPs, y miembros de board que necesitan tomar decisiones informadas sobre IA agéntica sin leer el libro completo.

**Lo que encontrarás aquí:**

- La tesis central del libro en 3 páginas
- Dos casos reales documentados (startup LATAM + Fortune 100)
- El business case financiero con números verificados
- Los patrones de fracaso más comunes (y cómo evitarlos)
- Un roadmap de adopción ejecutable
- Los controles esenciales de gobernanza

**Lo que NO encontrarás aquí:**

- Profundidad técnica sobre herramientas específicas (ver Cap. 7-8 del libro completo)
- Los 12 frameworks de decisión completos (ver Apéndice B)
- Los 115 checkpoints de implementación (ver Apéndice C)
- Análisis detallado de sesgos cognitivos (ver Cap. 5)

**Vigencia:** Principios y frameworks: 3-5+ años. Cifras de mercado y precios de herramientas: Q1 2025. Verifica antes de usar en presupuestos.

---

# PARTE I: LA TESIS

## 1. La Tercera Revolución Ya Empezó

- 📊 **DATO:** El 30% del código en Microsoft ya es generado por IA (Satya Nadella, 2025)
- 📊 **DATO:** El 46% del código se escribe con asistencia de IA (GitHub Octoverse, Stack Overflow, 2025)
- 🔮 **PROYECCIÓN:** El CTO de Microsoft predice que el 95% del código será generado por IA para 2030
- 🔮 **PROYECCIÓN:** Gartner: 40% de apps empresariales integrarán agentes de IA para finales de 2026

El rol del ingeniero no desaparece - evoluciona de "escribir código" a **"arquitecto de intenciones y decisiones"**. Este cambio requiere nueva evaluación de estrategia de talento, presupuestos y roadmaps.

**IA agéntica** no es simplemente "IA más inteligente." Es un cambio fundamental: de herramientas que **responden** a tu input, a compañeros de trabajo digitales que **actúan y deciden** - entienden un objetivo, lo descomponen en tareas, las ejecutan usando herramientas, manejan errores, ajustan estrategia, y continúan hasta completar o determinar que no es posible.

## 2. Diseñar, No Solo Adoptar

Esta es la tesis central del libro:

> El 88% de empresas adoptan IA, pero solo el 6% capturan valor significativo (McKinsey 2025). La diferencia no es la tecnología - **es el rediseño**.

El patrón es inequívoco. Con la electricidad (1880s), las fábricas que solo reemplazaron motores de vapor con motores eléctricos no ganaron nada. Las que rediseñaron el layout completo de la fábrica multiplicaron su productividad. Con computadoras (1990s), la "paradoja de Solow" - las computadoras aparecen en todos lados menos en las estadísticas de productividad - se resolvió solo cuando las empresas rediseñaron workflows.

Con IA agéntica, el mismo patrón se repite:

- **Empresas que hacen "bolt-on"** (herramienta nueva en proceso viejo): ganancias del 10-20%
- **Empresas que rediseñan** (procesos, roles, métricas): ganancias del 35-55%
- **El factor diferenciador #1**: el 55% de los top performers rediseñaron workflows completos, vs. solo el 20% del resto

**"Agéntico por Diseño"** = rediseñar procesos alrededor de las capacidades agénticas, no insertar agentes en flujos diseñados para humanos.

## 3. Los Riesgos Son Reales - Y Cognitivos

El mayor riesgo de IA agéntica no es técnico - es humano:

- **El 48% de desarrolladores acepta código de IA sin revisarlo** (Stanford, 2024), vs. solo 12% cuando la sugerencia viene de un humano
- **Dunning-Kruger inverso**: con IA, *todos* sobreestiman su desempeño - y paradójicamente, mayor literacy en IA correlaciona con *más* sobreconfianza
- **Cognitive offloading**: los equipos delegan el pensamiento crítico a la máquina, perdiendo gradualmente habilidades fundamentales
- **96% de desarrolladores no confía plenamente** en código generado por IA (pero 48% lo acepta sin revisar - la disonancia es la señal de alerta)

La mitigación requiere intervención en tres niveles: individual (metacognición), equipo (rituales de peer review), y organizacional (métricas de "salud cognitiva").

---

# PARTE II: LA EVIDENCIA - DATOS REALES DE ADOPCIÓN

## 4. La Evidencia: Datos Reales de la Industria

Los datos más sólidos sobre el impacto de IA agéntica provienen de tres fuentes independientes que convergen en conclusiones similares:

### GitHub Research: El Estudio Más Grande

El estudio de Peng et al. (2023, n=95 desarrolladores profesionales) encontró que los usuarios de GitHub Copilot completaron tareas **55.8% más rápido** que el grupo control. Sin embargo, este dato requiere contexto:

| Hallazgo | Dato | Matiz |
|----------|------|-------|
| Velocidad de completado | +55.8% | En tareas predefinidas, no en producción real |
| Aceptación de sugerencias | 30-40% | El 60-70% de sugerencias se descartan |
| Impacto en tareas complejas | Marginal o negativo | METR (2025): -19% en repos complejos |
| Curva de adopción | 11+ semanas | Hasta alcanzar productividad estable |

### Microsoft: Adopción Interna a Escala

Satya Nadella reveló en Microsoft Build (abril 2025) que **20-30% del código en repositorios de Microsoft** se genera con asistencia de IA. Esto equivale a miles de ingenieros-equivalentes en capacidad evitada.

### DORA State of DevOps 2024

Los equipos "elite" (top 10%) ya integran IA en sus workflows, pero la adopción es heterogénea. El impacto medido varía dramáticamente por contexto:

| Contexto | Impacto típico en productividad |
|----------|:-------------------------------:|
| Código nuevo (greenfield) | +25-40% |
| Mantenimiento de legacy | +10-15% |
| Testing y documentación | +30-50% |
| Código crítico (compliance, security) | 0% a -10% (más review) |

---

## 5. Adopción Enterprise: Patrones a Escala

### Lo que Muestran los Datos Agregados

McKinsey (2024, n=1,000+ empresas) reporta que las organizaciones que obtienen mayor valor de IA generativa comparten tres características:

1. **Rediseñan workflows, no solo adoptan herramientas** - el 55% de los top performers rediseñaron procesos completos, vs. solo 20% del resto
2. **Invierten 2-3x más en change management** que en licencias de software
3. **Miden calidad y velocidad**, no solo una de las dos

### Resultados por Tamaño de Organización

| Tamaño | Inversión típica Year 1 | ROI típico (base) | Payback |
|--------|:-----------------------:|:-----------------:|:-------:|
| Startup (<50 devs) | $50K-150K | 300-600% | 2-4 meses |
| Mid-market (100-500 devs) | $200K-800K | 200-400% | 3-6 meses |
| Enterprise (1,000+ devs) | $2M-15M | 150-350% | 4-8 meses |

*Fuentes: Gartner 2024, McKinsey 2024, BCG 2024. ROI calculado incluyendo costos ocultos (curva de aprendizaje, code review adicional, incidentes, governance).*

### La Lección Clave

78% de CTOs reportan que IA agéntica ayudó a evitar contrataciones (Gartner, 2024) - pero esto no equivale a eliminar el costo. La inversión se desplaza de headcount a tooling + change management + governance. El beneficio real es **capacidad incrementada**, no reducción de costos.

---

# PARTE III: EL BUSINESS CASE

## 6. ROI - Los Números Que Importan

### Modelo de ROI para una Organización de 50 Developers

**Inversión COMPLETA Year 1** (con costos ocultos):

| Concepto | Costo |
|----------|-------|
| Costos directos (licencias, training, setup, mantenimiento) | $66,800 |
| Costos ocultos (curva de aprendizaje, code review adicional, incidentes, deuda técnica) | $161,750 |
| **Total inversión real** | **$228,550** |

**Ganancias medibles Year 1:**

| Métrica | Valor | Confianza |
|---------|-------|-----------|
| Productividad ganada (25% neto) | $1,625,000 | 📊 Alta |
| Reducción de onboarding | $100,000 | 📊 Media |
| **Total ganancia** | **$1,725,000** | |

**Tres escenarios:**

| Escenario | Productividad neta | ROI | Payback |
|-----------|:------------------:|:---:|:-------:|
| **Pesimista** | 15% | **248%** | 3.4 meses |
| **Base** | 25% | **655%** | 1.6 meses |
| **Optimista** | 35% | **1,050%** | 1.0 meses |

**Nota crítica**: Si el escenario pesimista sigue siendo positivo, tienes un business case sólido. Desconfía de modelos que muestran ROI de 4,000%+ - están ignorando costos ocultos.

### Calcula Tu Propio ROI en 5 Minutos

| Paso | Fórmula | Tu Valor |
|------|---------|----------|
| **A.** Número de developers | -| ___ |
| **B.** Costo total/dev/año (salario × 1.3) | -| $___ |
| **C.** Costo total de ingeniería | A × B | $___ |
| **D.** Inversión estimada Year 1 | A × $4,570 | $___ |
| **E.** Ganancia (escenario base: 25%) | C × 25% | $___ |
| **F.** **ROI** | (E - D) / D × 100 | ___% |

*Análisis completo con sensibilidad por industria y tamaño: Capítulo 9.*

---

## 7. Cuando Falla - Patrones de Fracaso

🔮 **PROYECCIÓN:** El 40% de proyectos de IA agéntica serán cancelados antes de 2027 (Gartner).

Los fracasos rara vez son técnicos - son organizacionales. Los tres patrones más comunes:

**Patrón 1: FOMO sin Estrategia** - El CEO vuelve de una conferencia y ordena "adoptar IA ya." Sin piloto, sin métricas, sin governance. Resultado: costos descontrolados, bugs en producción, equipo frustrado, y cancelación a los 6 meses.

**Patrón 2: Deuda Técnica Invisible** - La velocidad sube, los dashboards se ven verdes, pero el código generado acumula clonación 4x, dependencias obsoletas, y vulnerabilidades. El precio se paga 12-18 meses después con refactoring masivo o un incidente de seguridad.

**Patrón 3: Atrofia de Skills** - El equipo se vuelve dependiente. Juniors que "resuelven" problemas diariamente con IA no pueden hacerlo en una pizarrón sin ella. Seniors dejan de revisar profundamente. Cuando llega un problema que la IA no puede resolver, nadie está preparado.

**Mitigación**: SAST desde el día 1, "días sin IA" para juniors, métricas de calidad (no solo velocidad), y governance proporcional al riesgo.

*Análisis completo con patrones de fracaso basados en datos de la industria: Capítulo 10.*

---

# PARTE IV: EL PLAYBOOK

## 8. Roadmap de Adopción: Crawl, Walk, Run

### El Framework

| Fase | Timeline | Scope | Objetivo |
|------|----------|-------|----------|
| **CRAWL** | Meses 0-3 | 1-2 equipos, casos no-críticos | Validar con datos reales |
| **WALK** | Meses 4-9 | 3-5 equipos, governance formal | Escalar con control |
| **RUN** | Meses 10-18 | Toda la organización | Madurez operativa |

### Quick Wins para los Primeros 90 Días

Los 3 casos de uso con mayor ROI inmediato y menor riesgo:

1. **Documentación automática** - ROI visible en días, riesgo casi nulo
2. **Generación de tests** - Mejora coverage sin esfuerzo manual
3. **Refactoring asistido** - Reduce deuda técnica existente

### Los 5 Errores Más Comunes (y Cómo Evitarlos)

1. **No tener governance desde día 1** → Define políticas ANTES de dar licencias
2. **Subestimar el cambio cultural** → Dedica 70% del esfuerzo a personas, 30% a tecnología
3. **Medir las métricas incorrectas** → Mide impacto de negocio, no líneas de código
4. **No tener plan de re-skilling** → "Días sin IA" + training continuo
5. **Saltarte fases** → La causa #1 de fracaso es ir directamente a RUN

### Business Case para el Board: 3 Ejes

1. **Ventaja competitiva**: Time-to-market 40-60% más rápido
2. **Eficiencia de costos**: 3-5x productividad por el mismo headcount
3. **Retención de talento**: Los mejores ingenieros quieren trabajar con IA

*Roadmap completo con presupuesto mes a mes: Capítulo 12. Checklist de 115 puntos: Apéndice C.*

---

## 9. Gobernanza: Los Controles Esenciales

### Clasificación de Código (4 Niveles)

| Nivel | Definición | IA Permitida | Aprobación |
|-------|-----------|:------------:|:----------:|
| **Público** | OSS, ejemplos | Sin restricción | Auto |
| **Interno** | Herramientas internas | Copilot + logging | Tech Lead |
| **Confidencial** | Producto core | Solo self-hosted | 2 seniors |
| **Crítico** | Seguridad, pagos, auth | **NO IA** | N/A |

### Controles Mínimos (Aplican a Cualquier Tamaño de Organización)

1. **SAST en CI/CD** (SonarQube o equivalente) - bloquea vulnerabilidades antes de merge
2. **Logging de uso** - quién usa qué herramienta, en qué código
3. **Política documentada** - qué se puede y qué no se puede generar con IA
4. **Review escalado** - PRs con >40% de código IA requieren review adicional
5. **Kill switch** - capacidad de pausar todo si hay un incidente severo

### Niveles de Autonomía (Recomendación: 0-1 en 2025-2026)

| Nivel | Descripción | Supervisión | Riesgo |
|-------|-------------|-------------|--------|
| **0** | IA sugiere, humano decide y ejecuta | Total | Mínimo |
| **1** | IA ejecuta, humano aprueba | Alta | Bajo |
| **2** | IA ejecuta con verificación post-hoc | Media | Medio |
| **3** | IA autónoma con supervisión por excepción | Baja | Alto |

*Framework completo de gobernanza en 3 niveles: Capítulo 13. Templates: Apéndice B, Frameworks #7, #10, #11.*

---

# PARTE V: ACCIÓN INMEDIATA

## 10. Tu Plan de 30 Días

| Semana | Acción | Entregable |
|:------:|--------|-----------|
| **1** | Evalúa readiness organizacional | Score en 4 dimensiones (Cap. 12) |
| **1** | Identifica 5 developers para piloto | Lista de participantes voluntarios |
| **2** | Selecciona herramienta (Copilot o Cursor) | Decisión + licencias |
| **2** | Define política de uso (qué sí, qué no) | Documento de 1 página |
| **3** | Training (4h workshop + 2h hands-on) | Equipo capacitado |
| **3** | Establece baselines (velocity, bugs, coverage) | Dashboard de métricas |
| **4** | Inicia piloto (2 semanas de ejecución) | Primeros datos reales |
| **4** | Programa retrospectiva (fin de semana 6) | Decisión: escalar o ajustar |

**Inversión del primer mes**: ~$2,000-5,000 (licencias + training).
**Lo que sabrás al final del mes**: Si tu equipo puede beneficiarse de IA agéntica, a qué velocidad, y con qué riesgos.

---

## Para Profundizar

| Tema | Capítulo | Páginas |
|------|----------|:-------:|
| Historia y contexto de la revolución | 1-3 | ~45 |
| Por qué diseñar, no solo adoptar (tesis central) | 4 | ~20 |
| Sesgos cognitivos en detalle | 5 | ~25 |
| Guía de adopción por industria | 6 | ~25 |
| Evolución técnica (3 olas) | 7 | ~30 |
| Ecosistema de herramientas | 8 | ~30 |
| ROI completo con sensibilidad | 9 | ~25 |
| Patrones de fracaso | 10 | ~15 |
| Liderando equipos con IA | 11 | ~30 |
| Roadmap de adopción + presupuesto | 12 | ~25 |
| Gobernanza y riesgos | 13 | ~35 |
| Visión 2026-2030 | 14 | ~30 |
| 12 frameworks de decisión | Apéndice B | ~10 |
| 115 checkpoints de implementación | Apéndice C | ~8 |

---

*Esta Edición Ejecutiva fue compilada de "Agéntico por Diseño, Tomo I: Tecnologías de la Información" (2026). Para el libro completo con todos los frameworks, casos detallados, y herramientas de implementación, consulta la edición principal.*
