# Guía por Industria: Dónde Están los Quick Wins

> **Resumen Ejecutivo**
>
> - La productividad con IA no es uniforme: depende del caso de uso, la industria, y la madurez del codebase
> - Estudio METR (2025): desarrolladores experimentados fueron 19% **más lentos** con IA en codebases maduros
> - BCG (2024): solo el 4% de las organizaciones capturan valor completo de IA; el resto lucha por escalar
> - Los "quick wins" están en boilerplate, testing, y documentación (Tier 1), no en arquitectura ni features complejas
> - SaaS y e-commerce ven ROI en 3-6 meses; banca y healthcare en 12-24 meses por carga regulatoria
> - La deuda técnica generada por IA (duplicación 8x, refactoring en declive) es un riesgo emergente poco discutido

---

## La Paradoja de la Productividad

Hasta este punto del libro, hemos presentado datos que pintan un cuadro optimista: 55% más velocidad en tareas (GitHub, 2023), 46% del código generado por IA ([Octoverse]{.idx data-sub="GitHub"}, 2025), casos de estudio con [ROI]{.idx} de triple dígito. Pero la investigación más rigurosa de 2024-2025 revela una imagen más matizada, y más útil para tomar decisiones.

### Lo Que Dicen los Estudios Rigurosos

**El estudio de Google (2024)** fue el primer [ensayo controlado aleatorizado]{.idx} (RCT) a escala dentro de una empresa real. 96 ingenieros de Google recibieron (o no) acceso a herramientas de IA para completar una tarea de edición de código en 10 archivos y 474 líneas.

**Tabla 6.1. Resultados del RCT de Google (2024)**

| Métrica | Con IA | Sin IA | Diferencia |
|---------|--------|--------|------------|
| Tiempo para completar tarea | 96 minutos | 114 minutos | -16% |
| Mejora estimada (controlada) | - | -| **+21%** |

Un 21% es significativo, pero está lejos del 55% que reportan los estudios financiados por vendors. La diferencia: este estudio usó tareas reales en infraestructura real de Google, no ejercicios controlados de laboratorio.

**El estudio [METR]{.idx} (2025)** fue todavía más revelador. 16 desarrolladores experimentados de proyectos *open source* con más de 22,000 estrellas promedio trabajaron en 246 issues reales de sus propios repositorios, codebases con más de un millón de líneas y más de 10 años de historia.

**Tabla 6.2. Resultados del estudio METR (2025)**

| Métrica | Con IA (Cursor Pro + Claude) | Sin IA | Diferencia |
|---------|------------------------------|--------|------------|
| Tiempo real para completar issues | **Más lento** | Más rápido | **-19%** |
| Percepción subjetiva de velocidad | +20% más rápido | - | **Percepción inversa a realidad** |

Leíste bien: los desarrolladores **creyeron** que eran 20% más rápidos, pero en realidad fueron 19% más lentos. Este es el Efecto Dunning-Kruger aplicado a IA que documentamos en el Capítulo 5: la herramienta se siente productiva porque genera texto rápidamente, pero el tiempo de revisión, debugging, y corrección de [alucinaciones]{.idx} en codebases complejos consume más de lo que ahorra.

> **Dato verificado:**
>
> - **Fuente:** METR, "Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity" (arXiv 2507.09089, julio 2025); Google, "How Much Does AI Impact Development Speed?" (arXiv 2410.12944, octubre 2024)
> - **Qué mide:** METR: productividad real (no percibida) de desarrolladores experimentados en codebases maduros usando Cursor Pro con Claude Sonnet 4.5. Google: velocidad de completar tarea de edición multi-archivo en infraestructura interna
> - **Limitación:** METR tiene muestra pequeña (n=16) y los desarrolladores usaban sus propios repos (sesgo de familiaridad). Google tiene muestra mayor (n=96) pero una sola tarea. Ninguno mide impacto a largo plazo (semanas/meses). Los resultados pueden no generalizar a codebases greenfield o tareas rutinarias
> - **Implicación:** No asumas que "más IA = más rápido" para todos los contextos. La productividad real depende críticamente del tipo de tarea (rutinaria vs. compleja), la madurez del codebase (greenfield vs. legacy), y la experiencia del desarrollador. Diseña tus pilotos para medir *realidad*, no *percepción*

### El Reporte DORA: La Paradoja a Escala

El [DORA Report]{.idx} 2024 (Google, 75,000+ respondents) confirmó la paradoja a nivel de la industria:

**Tabla 6.3. Hallazgos clave del DORA Report 2024**

| Métrica | Efecto de IA |
|---------|-------------|
| Percepción de productividad | **+75%** reportan ganancias |
| Code quality | **+3.4%** mejora |
| Code review speed | **+3.1%** mejora |
| Delivery throughput | **-1.5%** disminución |
| Delivery stability | **-7.2%** disminución |

Las organizaciones que adoptaron IA producen código ligeramente mejor y lo revisan más rápido. Pero entregan menos software funcional y con menos estabilidad. Una hipótesis: los desarrolladores generan changesets más grandes y complejos que son más difíciles de integrar, testear, y desplegar.

### Lo Que Esto Significa para Tu Estrategia

Si estás presentando un caso de negocio para adopción de IA, no uses las cifras de GitHub (55%) como tu escenario base. Usa Google (21%) como tu escenario realista y METR (-19%) como tu peor escenario para codebases maduros. Cualquier resultado mejor será una sorpresa positiva.

---

## Matriz de Quick Wins por Caso de Uso

No todos los casos de uso de IA para código son iguales. La evidencia acumulada de 2024-2025 permite clasificar con razonable confianza dónde empezar y dónde esperar: una [matriz de quick wins]{.idx}.

### Tier 1: Desplegar Ya. ROI Demostrado

Estos casos de uso tienen evidencia consistente de múltiples fuentes independientes.

**Tabla 6.4. Casos de uso con ROI demostrado**

| Caso de Uso | Evidencia | Ganancia Típica | Riesgo |
|-------------|-----------|-----------------|--------|
| **Generación de boilerplate y scaffolding** | GitHub Octoverse, JetBrains 2025, McKinsey 2025 | 40-60% reducción de tiempo | Bajo: errores fáciles de detectar |
| **Tests unitarios** | McKinsey 2025, Google RCT, múltiples surveys | 30-50% reducción de tiempo | Bajo: tests incorrectos fallan visiblemente |
| **Documentación de código y comments** | Stack Overflow 2024, JetBrains 2025 | 30-40% reducción de tiempo | Muy bajo: no afecta runtime |
| **PR drafting y descripción de cambios** | McKinsey 2025, GitHub features | 20-30% reducción de tiempo | Muy bajo: revisión humana natural |
| **Incident summarization** | McKinsey "State of AI" 2025, Walmart case | Significativo (no cuantificado con precisión) | Bajo: no genera código ejecutable |

**Por qué estos funcionan**: Son tareas con entrada bien definida, resultado verificable, y bajo riesgo de daño si la IA comete errores. No requieren comprensión profunda de la arquitectura del sistema.

**Recomendación para líderes**: Si tu equipo aún no usa IA para tests y documentación, estás dejando el valor más seguro sobre la mesa. Estos son los "quick wins" que generan evidencia interna para justificar inversiones mayores.

### Tier 2: Pilotar con Cuidado. Datos Mixtos

Estos casos de uso muestran potencial pero con resultados inconsistentes según el contexto.

| Caso de Uso | Evidencia | Ganancia Típica | Riesgo |
|-------------|-----------|-----------------|--------|
| **Root-cause analysis de incidentes** | McKinsey 2025, Deloitte Q4 2024 | Emergente (datos preliminares) | Medio: puede sugerir causas incorrectas |
| **Code refactoring asistido** | McKinsey, pero GitClear muestra refactoring en declive | Variable (10-30%) | Medio: refactoring incorrecto genera deuda |
| **DevSecOps: análisis SAST/SCA** | Deloitte: ciberseguridad superó expectativas en 44% de casos | Alto en detección | Medio: falsos positivos/negativos |
| **Autocompletar funciones completas** | GitHub (55%), Google (21%), METR (-19%) | 10-55% según contexto | Medio: depende de madurez del codebase |
| **Onboarding de nuevos developers** | GitHub Enterprise data, Cap 08 case | 20-40% reducción de ramp-up | Bajo-medio: riesgo de comprensión superficial |

**Por qué los resultados son mixtos**: Estas tareas requieren más contexto del que la IA típicamente tiene. Un refactoring exitoso requiere entender *por qué* el código se escribió así, no solo *qué* hace.

**Recomendación para líderes**: Pilotar con equipos de alta madurez técnica (seniors que pueden evaluar las sugerencias). Medir no solo velocidad sino calidad: ¿los refactorings generados por IA se mantienen o se revierten?

### Tier 3: Precaución. Evidencia Negativa o Ausente

| Caso de Uso | Evidencia | Riesgo |
|-------------|-----------|--------|
| **Features complejas en codebases maduros (1M+ líneas)** | METR: 19% más lento | Alto: la IA no tiene contexto suficiente |
| **Decisiones de arquitectura** | Sin evidencia positiva | Muy alto: errores costosos y difíciles de revertir |
| **Código regulado (healthcare, fintech compliance)** | Deloitte: regulación es barrera #1 | Alto: requiere supervisión humana estricta |
| **Migración de sistemas legacy** | Datos anecdóticos, sin RCTs | Alto: complejidad contextual extrema |

**Por qué no funcionan (todavía)**: Los modelos de lenguaje actuales optimizan para fluidez, no para corrección (ver Capítulo 13 sobre el problema del softmax). En contextos donde un error tiene costo alto y la verificación es difícil, la IA agéntica introduce más riesgo del que elimina.

**Recomendación para líderes**: No pilotar en sistemas críticos de producción. Si tu codebase tiene más de 500K líneas y tu equipo tiene más de 10 años de experiencia, los resultados de METR aplican directamente a tu caso. Pilota en proyectos greenfield o en componentes aislados.

> **Para Tu Próxima Reunión de Liderazgo**
>
> Presenta la matriz de 3 Tiers a tu equipo y pregunta: "¿En qué Tier estamos invirtiendo la mayor parte de nuestro esfuerzo con IA?" Si la respuesta es Tier 2 o 3, cuestiona por qué no se ha capturado primero el valor del Tier 1, que es más seguro y más fácil de medir.
>
> **Ejercicio**: Pide a cada tech lead que identifique 3 tareas de Tier 1 que su equipo aún hace manualmente. Esa es tu hoja de ruta de quick wins para el próximo trimestre.

---

## Guía por Industria: Speed-to-ROI

La velocidad a la que tu organización verá retorno depende de 3 factores interrelacionados: la [madurez digital]{.idx} de tu equipo, la carga regulatoria de tu industria, y el tipo de código que produces.

### Mapa de Speed-to-ROI por Sector

| Sector | Readiness | Fricción Regulatoria | Dónde Está el Valor | Speed-to-ROI | Caso Real |
|--------|-----------|---------------------|---------------------|:------------:|-----------|
| **SaaS / Software** | Muy alta | Baja | Code generation, testing, DevOps automation | **3-6 meses** | GitHub: 90% de Fortune 100 adoptó Copilot |
| **E-commerce / Retail** | Alta | Baja | Bots de atención al cliente, cart optimization, personalization | **3-6 meses** | Walmart: 4M horas ahorradas, 95% adopción |
| **Fintech** | Alta | Media-alta | Fraud detection, compliance automation, servicio al cliente | **6-12 meses** | BCG: mayor concentración de AI leaders |
| **Manufactura** | Alta | Baja-media | Mantenimiento predictivo, control de calidad, optimización energética | **6-12 meses** | 77% de manufacturers usan IA; -25-40% costos de mantenimiento |
| **Banca / Seguros** | Media-alta | Alta | Servicio al cliente (18-24% del valor según BCG), proceso de claims | **9-18 meses** | Dubai Commercial Bank: 39,000 horas/año ahorradas |
| **Healthcare / Biopharma** | Media | Muy alta | R&D (27% del valor según BCG), diagnóstico, desarrollo de dispositivos | **12-24 meses** | US$3.20 retorno por cada US$1 invertido en 14 meses; ~800 dispositivos AI aprobados por FDA |
| **Gobierno** | Baja-media | Muy alta | Procesamiento de documentos, workforce augmentation | **18-36 meses** | Adopción incipiente; framework NIST AI RMF como guía |

> **Dato verificado:**
>
> - **Fuente:** BCG, "Where's the Value in AI?" (octubre 2024, n=1,800 C-suite executives, 18 industrias); Deloitte, "State of Generative AI in the Enterprise" (Q1-Q4 2024, encuestas trimestrales); McKinsey, "The State of AI" (marzo 2025, encuesta global)
> - **Qué mide:** BCG midió distribución de valor de IA por función de negocio en cada industria. Deloitte midió ROI percibido y barreras por sector. McKinsey midió adopción y reducción de costos por función. Los timeframes de speed-to-ROI son triangulación del autor basada en las 3 fuentes
> - **Limitación:** Los datos de BCG y Deloitte son auto-reportados por ejecutivos C-suite, con posible sesgo de deseabilidad social. "ROI" no está estandarizado entre respondentes. Los timeframes son rangos estimados, no garantías; tu organización puede estar en cualquier punto del rango. Los casos de Walmart y Dubai son empresas de gran escala; resultados no directamente extrapolables a PyMEs
> - **Implicación:** No compares tu timeline con el de SaaS si estás en banca regulada. La carga regulatoria es el mayor determinante de speed-to-ROI, por encima de la madurez tecnológica. Planifica horizontes realistas para tu sector

### Dónde se Concentra el Valor por Sector

[BCG]{.idx} encontró que el valor de IA no se distribuye uniformemente dentro de cada industria:

| Sector | Función #1 de Valor | % del Valor Total | Función #2 |
|--------|---------------------|:-----------------:|------------|
| Software/Tech | Ventas y marketing | 31% | Ingeniería |
| Banca | Servicio al cliente | 18% | Operaciones |
| Seguros | Servicio al cliente | 24% | Claims |
| Biopharma | R&D | 27% | Manufacturing |
| MedTech | R&D | 19% | Regulatory |
| Retail | Operaciones de cliente | 22% | Supply chain |

**Perspectiva para líderes**: Si estás en banca y tu piloto de IA está enfocado exclusivamente en ingeniería de software, estás atacando la segunda fuente de valor, no la primera. Esto no significa que esté mal. Pero sí que tu caso de negocio debe calibrarse contra la fuente #1 de valor para tu sector.

### Latinoamérica: Ventaja de Costo, Desventaja Regulatoria

Para organizaciones en [América Latina]{.idx}, hay factores adicionales:

| Factor | Impacto en Speed-to-ROI | Detalle |
|--------|:------------------------:|---------|
| **Costo laboral menor** | Reduce ROI relativo de IA | Si un developer en LATAM cuesta US$30-50K/año vs. US$150-200K en EE.UU., el ahorro absoluto de IA es menor. Pero el ahorro relativo sigue siendo significativo |
| **Regulación ligera** | Acelera adopción | LATAM tiene menos regulación de IA que UE (AI Act) o EE.UU. (ver Cap. 13). Esto es ventana de oportunidad, no excusa para ignorar governance |
| **Nearshoring boom** | Amplifica valor | Equipos LATAM que adopten IA compiten por contratos de [nearshoring]{.idx} ofreciendo el mismo resultado a menor costo. El diferencial de productividad es multiplicador |
| **Talento técnico en crecimiento** | Facilita adopción | Brasil, México, Colombia producen 100K+ graduados STEM/año. Pool de talento creciente para combinar con IA |

---

## El Problema del 4%

BCG (2024) encontró un dato que debería preocupar a cualquier líder que esté planificando adopción de IA:

- **74%** de las organizaciones luchan por lograr y escalar valor de sus iniciativas de IA
- Solo **26%** han desarrollado las capacidades para ir más allá de pilotos (POCs)
- Solo **4%** capturan valor sustancial y medible

Estos no son datos de startups sin recursos; son empresas del Fortune 500 con presupuestos de millones. ¿Qué separa al 4% del 96%?

### Los 6 Predictores de Éxito

Triangulando los hallazgos de BCG, [McKinsey]{.idx}, y [Deloitte]{.idx}, emergen 6 factores que predicen si una organización capturará valor real de IA agéntica:

| Predictor | Qué Significa | Cómo Medirlo |
|-----------|---------------|--------------|
| **1. Madurez digital** | CI/CD, testing automatizado, monitoring, la base sobre la que IA funciona | ¿Tu pipeline de despliegue es manual o automatizado? ¿Tienes coverage de tests >60%? |
| **2. Edad y complejidad del codebase** | Codebases maduros (>1M líneas, >10 años) obtienen MENOS beneficio de IA que codebases jóvenes | ¿Cuál es la edad promedio de tu codebase principal? ¿Cuántas líneas? |
| **3. Mix de equipo** | Juniors + IA = productivos rápido. Seniors + IA en codebase maduro = posiblemente más lentos (METR) | ¿Qué % de tu equipo son juniors vs seniors? ¿En qué codebases trabajan? |
| **4. Carga regulatoria** | Regulación es barrera #1 (Deloitte). Industries reguladas necesitan governance ANTES de piloto | ¿Tu industria requiere auditorías de código? ¿Compliance con LGPD/GDPR/HIPAA? |
| **5. Compromiso con rediseño de procesos** | McKinsey: los ganadores reconstruyen flujos de trabajo, no "bolt on" IA al proceso existente | ¿Tu plan incluye rediseño de code review, onboarding, y despliegue? ¿O solo "activar Copilot"? |
| **6. [Gobernanza]{.idx} centralizada** | Deloitte: gobernanza centralizada promueve adopción Y escalabilidad | ¿Tienes un AI Council o equivalente? ¿Hay políticas claras de uso de IA? (ver Cap. 13) |

### Tu Scorecard de Readiness

Para cada predictor, evalúa tu organización:

| Predictor | 🟢 Favorable | 🟡 Neutral | 🔴 Riesgo |
|-----------|:------------:|:----------:|:---------:|
| Madurez digital | CI/CD maduro, >60% test coverage | CI/CD básico, tests manuales | Sin CI/CD, sin tests |
| Codebase | <500K líneas, <5 años | 500K-1M líneas | >1M líneas, >10 años |
| Mix equipo | Balance 40/60 junior/senior | >70% junior | >70% senior en codebase maduro |
| Regulación | Baja (SaaS, e-commerce) | Media (fintech con sandbox) | Alta (banca, healthcare, gobierno) |
| Rediseño procesos | Plan de rediseño aprobado | "Vamos a ver cómo va" | "Solo instalar Copilot" |
| Gobernanza | AI Council + políticas + métricas | Políticas informales | Sin governance |

**Interpretación:**
- 4-6 verdes: Tu organización está bien posicionada. Apuntar a Tier 1 + Tier 2 simultáneamente.
- 2-3 verdes: Empezar por Tier 1 exclusivamente. Resolver amarillos antes de escalar.
- 0-1 verdes: Invertir en infraestructura y governance ANTES de adoptar IA. Intentar sin esto es receta para el 74% que falla.

> **Para Tu Próxima Reunión de Liderazgo**
>
> Lleva esta scorecard completa a la reunión. Pide a cada miembro del equipo de liderazgo que la llene independientemente. Compara resultados. Las discrepancias entre cómo el CTO y el VP de Ingeniería ven la madurez digital de la organización son, en sí mismas, un hallazgo valioso.
>
> Si tu score tiene 3+ rojos, la conversación no debería ser "¿qué herramienta de IA elegimos?" sino "¿qué necesitamos resolver antes de que IA tenga sentido?"

---

## La Advertencia de Deuda Técnica

Hay un costo oculto de la adopción de IA que la mayoría de los reportes de productividad no miden: la [deuda técnica]{.idx} generada silenciosamente.

### GitClear: 211 Millones de Líneas Analizadas

[GitClear]{.idx} (2025) analizó 211 millones de líneas cambiadas entre 2020 y 2024 en repositorios privados y 25 proyectos *open source* grandes. Los hallazgos son preocupantes:

| Métrica | 2021 | 2024 | Tendencia |
|---------|------|------|-----------|
| **Código duplicado** | Baseline | **8x aumento** | Fuertemente negativa |
| **Líneas copy-pasted** | 8.3% | 12.3% | Creciente |
| **Código nuevo revertido en <2 semanas** ([code churn]{.idx}) | 3.1% | 5.7% | Creciente |
| **Refactoring como % de cambios** | 25% | **<10%** | En declive dramático |

La interpretación: los desarrolladores con IA producen más código nuevo pero hacen significativamente menos mantenimiento del código existente. La IA es excelente generando; es pésima motivando a los humanos a limpiar.

### Veracode: El Costo de Seguridad

Un estudio de [Veracode]{.idx} evaluó 80 tareas de coding curadas a través de más de 100 LLMs diferentes. El resultado: IA introdujo [vulnerabilidades de seguridad]{.idx} en el **45% de las tareas**. Esto no significa que el código humano sea perfecto. Pero sí que la velocidad de generación de código con IA amplifica la velocidad de generación de vulnerabilidades.

### DORA: Más Rápido ≠ Mejor

El DORA Report 2024 confirma la tendencia a nivel de la industria: las organizaciones que adoptaron IA producen código marginalmente mejor (+3.4% quality) pero entregan software menos frecuentemente (-1.5% throughput) y con menos estabilidad (-7.2%). La hipótesis predominante: los changesets generados por IA son más grandes y más difíciles de revisar, integrar, y desplegar.

**Implicación para líderes**: Si tu equipo reporta que es "más productivo" con IA, pregunta: ¿estamos midiendo líneas generadas o software entregado? ¿Nuestra tasa de bugs en producción ha aumentado? ¿Nuestro refactoring ha disminuido? Si las respuestas son sí, estás acumulando deuda técnica, y la factura llegará.

> **Dato verificado:**
>
> - **Fuente:** GitClear, "AI Copilot Code Quality 2025" (2025, n=211M líneas cambiadas, 2020-2024); DORA Report 2024 (Google, 75,000+ respondents); Veracode, estudio de vulnerabilidades en código generado por IA (2024-2025, 80 tareas, 100+ LLMs)
> - **Qué mide:** GitClear mide tendencias en calidad de código (duplicación, churn, refactoring) correlacionadas temporalmente con la adopción de IA. DORA mide métricas de delivery (throughput, stability, quality) auto-reportadas. Veracode mide presencia de vulnerabilidades conocidas (OWASP) en código generado
> - **Limitación:** GitClear establece correlación temporal, no causalidad directa; otros factores (cambios en la industria, presión económica) podrían contribuir. DORA es encuesta con auto-reporte. Veracode usa tareas curadas que pueden no representar uso real. Ningún estudio mide impacto acumulativo a 3-5 años
> - **Implicación:** Incorpora métricas de calidad y deuda técnica en tu dashboard de IA desde el día 1. No medir solo velocidad; medir también duplicación, code churn, y cobertura de refactoring. El Capítulo 10 documenta patrones de fallo cuando estas señales se ignoran

---

## Framework de Decisión para Tu Organización

Integrando la evidencia de los estudios rigurosos, la matriz de quick wins, y los predictores de éxito, aquí está un árbol de decisión simplificado para decidir por dónde empezar.

### Paso 1: Evalúa Tu Readiness

Usa la scorecard de la sección anterior. Si tienes 3+ rojos, **no empieces con IA**. Invierte en infraestructura (CI/CD, testing, governance) primero. La evidencia de BCG es clara: intentar sin la base es desperdiciar presupuesto.

### Paso 2: Identifica Tu Tier de Entrada

| Si tu codebase es... | Y tu equipo es... | Empieza por... |
|----------------------|-------------------|----------------|
| Greenfield o <100K líneas | Mixto junior/senior | Tier 1 + Tier 2 simultáneamente |
| 100K-500K líneas | Mayoritariamente senior | Tier 1 primero, Tier 2 en mes 3 |
| >500K líneas, >5 años | Experimentado (>5 años promedio) | **Solo Tier 1**: los resultados de METR aplican |
| Legacy (>1M líneas, >10 años) | Cualquiera | Tier 1 en módulos nuevos. NO en código legacy |

### Paso 3: Define Métricas Desde el Día 1

No solo midas velocidad. El DORA Report demostró que velocidad sin calidad es deuda técnica acelerada.

| Categoría | Métricas a Rastrear | Fuente |
|-----------|---------------------|--------|
| **Velocidad** | Cycle time, PR merge time, incidencias cerradas/sprint | Jira/GitHub |
| **Calidad** | Bugs en producción, code review rejections, test pass rate | CI/CD pipeline |
| **Deuda técnica** | Duplicación de código, code churn (<2 semanas), ratio de refactoring | GitClear, SonarQube |
| **Seguridad** | Vulnerabilidades introducidas, [SAST]{.idx data-sub="seguridad de código"} hallazgos, problemas de dependencias | Snyk, Veracode |
| **Humano** | Developer NPS, percepción vs realidad, skill decay indicators | Encuestas internas |

### Paso 4: Establece Gates de Progresión

No escales automáticamente después del piloto. Define criterios claros:

| Gate | Criterio para Avanzar |
|------|-----------------------|
| Piloto → Expansión | ROI neto positivo en Tier 1 durante 90+ días. Deuda técnica no aumentó >10% |
| Expansión → Escala | 60%+ del equipo adoptó voluntariamente. Métricas de calidad estables. Governance operando |
| Escala → Tier 2 | Tier 1 consolidado. Seniors reportan que IA es útil (no solo juniors). Code review throughput no degradó |

---

## Conclusiones y Takeaways

1. **La productividad con IA es real pero exagerada.** Los estudios rigurosos (Google RCT, METR, DORA) muestran ganancias de 0-21%, no el 55% que reportan los vendors. Planifica con el escenario conservador.

2. **El contexto lo es todo.** IA funciona mejor en tareas rutinarias (Tier 1) y codebases jóvenes. En codebases maduros y tareas complejas, puede hacer más lento al equipo.

3. **El 96% falla por las razones equivocadas.** No es la tecnología; es la falta de infraestructura, governance, y rediseño de procesos. Los 6 predictores de éxito son más importantes que la elección de herramienta.

4. **La deuda técnica es el costo oculto.** Duplicación 8x, refactoring en declive, vulnerabilidades en 45% de tareas. Mide calidad desde el día 1, no solo velocidad.

5. **Tu industria determina tu timeline.** SaaS en 3 meses, banca en 12. No compares tu progreso con organizaciones en sectores con diferente carga regulatoria.

6. **Empieza por Tier 1.** Tests, documentación, boilerplate. Es el valor más seguro y genera evidencia interna para justificar lo que sigue.

---


> **Tarjeta de Referencia Rápida**
>
> - **Métrica clave 1**: Estudios rigurosos muestran ganancias de 0-21% (Google RCT, METR), no el 55% de vendors; desarrolladores en codebases maduros fueron 19% más lentos con IA (METR, 2025)
> - **Métrica clave 2**: Solo 4% de organizaciones capturan valor completo de IA (BCG, 2024); duplicación de código aumentó 8x con IA (GitClear, 2024)
> - **Métrica clave 3**: Timeline de ROI varía por industria: SaaS en 3-6 meses, banca/healthcare en 12-24 meses por carga regulatoria
> - **Framework principal**: Matriz de Quick Wins por Tier (Tier 1: tests, docs, boilerplate; Tier 2: refactoring, autocompletar; Tier 3: arquitectura) y 6 Predictores de Éxito (ver este capítulo)
> - **Acción inmediata**: Si tu equipo aún no usa IA para tests unitarios y documentación (Tier 1), empieza ahí esta semana; es el valor más seguro con menor riesgo

## Preguntas de Reflexión para Tu Equipo

1. ¿En qué Tier de casos de uso estamos invirtiendo la mayoría de nuestro esfuerzo con IA? ¿Hemos capturado primero el valor del Tier 1?

2. ¿Cuál es la edad y complejidad de nuestro codebase principal? ¿Los resultados de METR aplican a nuestro contexto?

3. ¿Estamos midiendo velocidad Y calidad? ¿Nuestra tasa de duplicación de código ha cambiado desde que adoptamos IA?

4. De los 6 predictores de éxito, ¿cuántos tenemos en verde? ¿Cuáles son nuestros rojos?

5. ¿Nuestro timeline de ROI es realista para nuestra industria, o estamos comparándonos con SaaS cuando somos banca regulada?

6. ¿Quién en el equipo tiene la responsabilidad de medir deuda técnica generada por IA? Si nadie, ¿por qué?

---

**Referencias:**

1. BCG. (2024). "Where's the Value in AI?". Encuesta a 1,800+ C-suite executives, 18 industrias.
2. BCG. (2025). "Are You Generating Value from AI? The Widening Gap".
3. Deloitte. (2024). "State of Generative AI in the Enterprise". Q1-Q4 2024.
4. Google. (2024). "DORA Report 2024: Accelerate State of DevOps". 75,000+ respondents.
5. GitHub. (2024-2025). "Octoverse 2024" y "Octoverse 2025".
6. GitClear. (2025). "AI Copilot Code Quality 2025". Análisis de 211 millones de líneas.
7. Google. (2024). "How Much Does AI Impact Development Speed?". arXiv:2410.12944. n=96.
8. JetBrains. (2024-2025). "State of Developer Ecosystem". 23,000-24,500 developers.
9. McKinsey. (2025). "The State of AI".
10. McKinsey. (2025). "Unlocking the Value of AI in Software Development".
11. METR. (2025). "Measuring the Impact of Early-2025 AI". arXiv:2507.09089. n=16.
12. Stack Overflow. (2024-2025). "Developer Survey". 65,000+ developers.
13. Veracode. (2024-2025). Estudio de vulnerabilidades en código generado por IA.
14. Walmart / CIO Dive. (2025). Reportes sobre 4M horas ahorradas con IA.

---

*Fin del Capítulo 6. Continúa en Capítulo 7: La Evolución Técnica*
