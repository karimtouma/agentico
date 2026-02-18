# Sesgos Cognitivos en la Era de la IA Agéntica

> **Resumen Ejecutivo**
>
> - **El "Reverse Dunning-Kruger"**: Investigación de Aalto University (2024) demuestra que cuando usamos IA, *todos* sobreestimamos nuestro desempeño. Paradójicamente, mayor literacy en IA correlaciona con *más* sobreconfianza, no menos.
> - **El sesgo de automatización (*Automation Bias*) alcanza niveles críticos**: Stanford (2024) encontró que 48% de desarrolladores acepta código de IA sin revisarlo, vs. solo 12% cuando la sugerencia viene de un humano: una diferencia de 4x que explica muchos bugs en producción.
> - **La delegación cognitiva (*Cognitive Offloading*) erosiona capacidades**: Usuarios "simplemente copian, pegan y están felices" sin verificar, delegando el pensamiento crítico a la máquina y perdiendo gradualmente habilidades fundamentales.
> - **Los sesgos son sistemáticos, no individuales**: Dunning-Kruger, Anchoring, Confirmation Bias, Illusion of Competence y Complacency operan en conjunto, creando un "cóctel cognitivo" que afecta incluso a equipos senior.
> - **La mitigación requiere intervención en tres niveles**: Individual (técnicas de metacognición), Equipo (rituales y peer review), Organizacional (métricas de "salud cognitiva" y programas de formación continua).

---

## El Cerebro Humano Frente a la Inteligencia Artificial

Existe una profunda ironía en la adopción de IA agéntica: las mismas capacidades cognitivas que nos permitieron crear estas herramientas son precisamente las que nos hacen vulnerables a usarlas incorrectamente. Los [sesgos cognitivos]{.idx} operan a nivel individual y organizacional.

El cerebro humano evolucionó para tomar decisiones rápidas con información incompleta. Un sistema brillante para sobrevivir en la sabana africana, pero problemático cuando interactuamos con sistemas que *parecen* inteligentes pero operan bajo principios fundamentalmente diferentes a los nuestros.

### La Paradoja de la Competencia Aparente

Cuando un desarrollador junior ve código generado por [Claude]{.idx data-sub="asistentes de código"} o [Copilot]{.idx data-sub="asistentes de código"}, su cerebro ejecuta un proceso de evaluación casi instantáneo: "¿Parece correcto? ¿Compila? ¿Pasa los tests?". Si las respuestas son afirmativas, el código se acepta. Pero este proceso tiene un defecto fatal: **confunde legibilidad con corrección**.

El código generado por IA moderna es sintácticamente impecable, estilísticamente consistente y superficialmente convincente. Esto activa nuestros atajos cognitivos de la peor manera posible: nos da la *sensación* de que entendemos sin requerir que realmente entendamos.

::: {.callout .dato-clave}
**Dato de Investigación (Aalto University, 2024)**

En experimentos controlados donde participantes usaron ChatGPT para resolver problemas:
- El efecto Dunning-Kruger tradicional **desapareció**
- En su lugar, *todos los niveles de competencia* sobreestimaron su desempeño
- Paradójicamente, **mayor AI literacy correlacionó con mayor sobreconfianza**

"When it comes to AI, the [Dunning-Kruger effect] vanishes. What's really surprising is that higher AI literacy brings more overconfidence.", Robin Welsch, Aalto University
:::

---

## El Efecto Dunning-Kruger Amplificado

El [efecto Dunning-Kruger]{.idx} clásico describe cómo las personas con baja competencia tienden a sobreestimar sus habilidades, mientras que los expertos tienden a subestimarlas. Pero con IA agéntica, este patrón se distorsiona de maneras preocupantes.

### La Nueva Curva de Competencia

En el contexto tradicional de programación:

**Tabla 5.1. Efecto Dunning-Kruger: autoevaluación vs. desempeño real**

| Nivel | Autoevaloración | Competencia Real | Brecha |
|-------|-----------------|------------------|--------|
| Junior (sin IA) | Alta | Baja | Sobreestima |
| Mid (sin IA) | Media | Media | Calibrado |
| Senior (sin IA) | Media-Baja | Alta | Subestima |

Con IA agéntica, la curva cambia dramáticamente:

| Nivel | Autoevaloración | Competencia Real | Brecha |
|-------|-----------------|------------------|--------|
| Junior (con IA) | **Muy Alta** | Baja-Media | **Gran sobreestimación** |
| Mid (con IA) | Alta | Media | Sobreestima |
| Senior (con IA) | Alta | Alta | **Ahora también sobreestima** |

### Por Qué los Seniors También Caen

La investigación de [Microsoft Research]{.idx} e IIT Delhi (2025) sobre modelos de código reveló un patrón inquietante: incluso los modelos de IA más capaces exhiben comportamiento tipo Dunning-Kruger: muestran alta confianza en dominios donde tienen baja competencia (lenguajes de programación poco frecuentes en su entrenamiento).

Pero más relevante para líderes: **los desarrolladores senior, acostumbrados a confiar en su intuición, transfieren esa confianza al código generado por IA**. Su experiencia les dice "esto se ve bien", y raramente cuestionan esa evaluación inicial.

::: {.callout .punto-critico}
**El Dato que Debería Preocuparte**

Según datos de encuestas y observaciones reportadas en la industria (Stack Overflow Developer Survey, 2024; GitClear AI Code Quality Report, 2024):
- **La mayoría de desarrolladores junior** reportan sentirse competentes evaluando código generado por IA
- Sin embargo, cuando se evalúa comprensión profunda línea por línea, **menos de 1 de cada 4** puede explicar correctamente la lógica subyacente
- Esta brecha entre confianza y competencia real es lo que los psicólogos llaman la "brecha de ilusión de competencia"
:::

### Manifestaciones por Nivel de Seniority

**Tabla 5.2. Manifestación de sesgos por nivel de seniority**

| Seniority | Manifestación Principal | Riesgo Específico |
|-----------|-------------------------|-------------------|
| **Junior (0-2 años)** | "Entiendo porque puedo leer" | No pide ayuda cuando debería; bugs en lógica de negocio |
| **Mid (2-5 años)** | "Confío porque antes funcionó" | Generaliza éxitos pasados; no adapta a contextos nuevos |
| **Senior (5-10 años)** | "Mi intuición me dice que está bien" | Subestima complejidad oculta; skippea reviews profundos |
| **Staff+ (10+ años)** | "Sé cuándo la IA se equivoca" | Puntos ciegos en áreas fuera de su expertise |

---

## Sesgo de Automatización (*Automation Bias*): La Confianza Ciega en la Máquina

El [sesgo de automatización]{.idx}, la tendencia a confiar excesivamente en sistemas automatizados, no es nuevo. Los pilotos de avión lo experimentan con el autopilot, los médicos con sistemas de diagnóstico asistido. Pero con IA generativa de código, alcanza niveles sin precedentes.

### Los Datos que Revelan el Problema

Un estudio de [Stanford]{.idx} (2024) comparó cómo desarrolladores responden a sugerencias de código según su origen:

**Tabla 5.3. Tasa de aceptación por origen de la sugerencia**

| Origen de la Sugerencia | % que Cuestiona | % que Acepta sin Revisar |
|-------------------------|-----------------|--------------------------|
| Compañero humano | 67% | 12% |
| IA (Copilot/Claude) | 31% | **48%** |

La diferencia es dramática: somos **4 veces más propensos** a aceptar código de IA sin cuestionarlo comparado con sugerencias humanas.

### Detección de Errores: Humano vs IA

El mismo estudio insertó bugs obvios (off-by-one errors, null pointer dereferences) en sugerencias:

| Origen | % que Detectó el Bug |
|--------|---------------------|
| Código de humano | 89% |
| Código de IA | **52%** |

Es decir: casi la mitad de los desarrolladores no detectó errores evidentes cuando el código venía de IA.

::: {.callout .reunion-liderazgo}
**Para tu Próxima Reunión de Liderazgo**

**Pregunta para el equipo:** "¿Cuántas veces en el último mes aceptaste código de Copilot/Claude sin revisarlo completamente?"

Si la respuesta promedio es mayor a "algunas veces", tienes un problema de automation bias que requiere intervención.

**Métrica sugerida:** Trackear "AI code review depth": tiempo promedio de revisión de PRs con alto % de código generado por IA vs. código humano.
:::

### El Caso Google DORA Report 2024

El reporte [DORA]{.idx} (DevOps Research and Assessment) de Google 2024 reveló una correlación preocupante:

> "Increased AI use speeds up code reviews and documentation, but comes with a **7.2% decrease in delivery stability**."

La velocidad ganada tiene un costo oculto: menor estabilidad en producción. Este es el automation bias manifestándose a escala organizacional.

### Framework de Detección de Automation Bias

Para identificar automation bias en tu equipo, observa estos indicadores:

| Indicador | Señal de Alerta | Nivel de Riesgo |
|-----------|-----------------|-----------------|
| Tiempo promedio de PR review | Disminuyó >30% desde adopción de IA | Alto |
| Comentarios en code review | Mayoría son "LGTM" sin detalles | Medio-Alto |
| Bugs en código IA vs humano | Ratio >1.5x más bugs en código IA | Crítico |
| Preguntas a seniors | Juniors preguntan menos que antes | Alto |
| Tests escritos post-generación | <50% del código IA tiene tests adicionales | Medio |

> **Para Tu Próxima Reunión de Liderazgo**
>
> **Ejercicio: Mide tu "AI Rejection Rate".** Pide a tu equipo que revise los últimos 20 PRs con código generado por IA. ¿En cuántos se rechazó o modificó sustancialmente la sugerencia? Si la tasa de rechazo es menor al 15%, tienes un problema de automation bias: tu equipo está aceptando sin cuestionar. Establece como meta un "rejection rate saludable" del 20-35%: lo suficiente para demostrar pensamiento crítico, sin ser tan alto que la herramienta pierda utilidad.

---

## Delegación Cognitiva (*Cognitive Offloading*): Tercerizar el Pensamiento

El término [cognitive offloading]{.idx} describe el fenómeno donde externalizamos procesos mentales a herramientas: escribir notas en lugar de memorizar, usar GPS en lugar de aprender rutas. Con IA agéntica, este offloading alcanza un nuevo nivel: **delegamos el pensamiento crítico mismo**.

### El Mecanismo Psicológico

Según la investigación de [Aalto University]{.idx}:

> "We looked at whether [users] truly reflected with the AI system and found that people just thought the AI would solve things for them. Often, participants simply copied the question, put it in the AI system, and were happy with the AI's solution without checking or second-guessing."

Este comportamiento tiene tres etapas:

1. **Delegación inicial**: "Voy a preguntarle a la IA"
2. **Evaluación superficial**: "La respuesta parece razonable"
3. **Aceptación sin verificación**: "Listo, problema resuelto"

El paso crítico que se omite: **comprensión profunda** de la solución.

### Impacto en Aprendizaje y Retención

El cognitive offloading tiene consecuencias a largo plazo que trascienden la tarea inmediata:

| Área Afectada | Consecuencia | Evidencia |
|---------------|--------------|-----------|
| **Aprendizaje** | Menor retención de conceptos | Estudios educativos muestran 40% menos retención cuando se usa IA vs. resolver manualmente |
| **Problem-solving** | Atrofia de habilidad de debugging | Desarrolladores reportan "olvidar" cómo debuggear sin IA después de 6+ meses de uso intensivo |
| **Creatividad** | Convergencia hacia soluciones "típicas" | El 70% de soluciones IA son variantes de patrones comunes; innovación genuina disminuye |
| **Pensamiento crítico** | Menor cuestionamiento de assumptions | "La IA lo sugirió" se convierte en justificación suficiente |

::: {.callout .punto-critico}
**El Riesgo de la "Atrofia Cognitiva"**

Un fenómeno emergente en equipos de desarrollo con alta adopción de IA:

- **Mes 1-3**: Productividad aumenta 30-50%
- **Mes 4-6**: Productividad se estabiliza
- **Mes 7-12**: Capacidad de trabajar *sin* IA disminuye notablemente
- **Año 2+**: Dependencia estructural; incapacidad de resolver problemas que antes eran rutinarios

Este patrón sugiere que los beneficios de productividad pueden tener costos ocultos en capacidades fundamentales del equipo.
:::

### Señales de Cognitive Offloading Excesivo

En tu equipo, busca estos patrones:

1. **"Déjame preguntarle a Claude"** se vuelve respuesta default, incluso para problemas simples
2. **Documentación interna** ya no se consulta; "la IA sabe"
3. [Pair programming]{.idx} disminuye; cada quien trabaja con su IA
4. **Mentorship** se reduce; juniors prefieren preguntar a IA que a seniors
5. **Debugging manual** se percibe como "pérdida de tiempo"

---

## Anchoring: La Primera Sugerencia Domina

El [sesgo de anclaje]{.idx} describe cómo la primera información que recibimos influencia desproporcionadamente nuestras decisiones posteriores. En el contexto de IA agéntica, esto tiene implicaciones profundas para el diseño de software.

### Cómo el Primer Resultado de IA Ancla el Diseño

Cuando un desarrollador pide a Claude que "diseñe la arquitectura para un sistema de pagos", la primera respuesta establece el marco mental para toda la discusión posterior:

1. **Ancla estructural**: Si la IA sugiere microservicios, la conversación será sobre *cuáles* microservicios, no sobre si microservicios es la arquitectura correcta
2. **Ancla de nomenclatura**: Los nombres que la IA elige para componentes tienden a persistir hasta producción
3. **Ancla de tecnología**: Si la IA menciona PostgreSQL primero, alternativas como DynamoDB se consideran menos seriamente

### Experimentos: Diseño Primero vs IA Primero

En estudios controlados comparando dos grupos:

| Grupo | Proceso | Resultado |
|-------|---------|-----------|
| **A: Diseño primero** | Diseñar arquitectura en whiteboard → Consultar IA para refinamiento | Arquitecturas más diversas; 40% consideró alternativas no obvias |
| **B: IA primero** | Consultar IA inmediatamente → Iterar sobre su sugerencia | 85% adoptó la primera sugerencia de IA con modificaciones menores |

El grupo B produjo soluciones funcionales, pero con significativamente menos innovación y consideración de alternativas.

### Técnicas de Mitigación

Para romper el anchoring:

1. **"Diseña antes de preguntar"**: Dedicar 10 minutos a bosquejar solución propia antes de consultar IA
2. **"Múltiples perspectivas"**: Pedir a la IA 3 enfoques diferentes explícitamente
3. **"Abogado del diablo"**: Después de recibir sugerencia, preguntar "¿Qué problemas tiene esta solución?"
4. **"Red teaming"**: Un miembro del equipo critica sistemáticamente la primera propuesta

---

## Overconfidence Effect: La Velocidad Genera Falsa Seguridad

Cuando podemos producir código 3x más rápido con IA, nuestro cerebro interpreta esa velocidad como señal de competencia. Este es el [efecto de sobreconfianza]{.idx} en acción.

### El Mecanismo

La lógica (errónea) es:
- "Antes me tomaba 2 horas resolver este problema"
- "Con IA lo resolví en 20 minutos"
- "Por lo tanto, ahora soy más competente"

Pero la realidad es:
- La IA resolvió el problema
- Tú editaste y aceptaste la solución
- Tu comprensión del problema puede ser la misma o menor que antes

### Métricas de Alerta Temprana

| Métrica | Saludable | Preocupante | Crítico |
|---------|-----------|-------------|---------|
| Velocidad de PR review | Sin cambio significativo | -30% | -50%+ |
| Ratio bugs/línea en código IA | <1.2x vs humano | 1.2-1.5x | >1.5x |
| Tiempo en debugging | Proporcional a complejidad | Desproporcionado | "No sé por qué no funciona" |
| Confianza autorreportada | Calibrada | "Siempre funciona" | "La IA no se equivoca" |

::: {.callout .reunion-liderazgo}
**Pregunta para tu Equipo**

"¿Cuándo fue la última vez que el código generado por IA te sorprendió con un bug que no anticipaste?"

Si la respuesta es "nunca" o "no recuerdo", probablemente no están revisando con suficiente profundidad.
:::

---

## Confirmation Bias en Code Review

El [sesgo de confirmación]{.idx} nos lleva a buscar evidencia que confirme lo que ya creemos. En code review de código generado por IA, esto se manifiesta como buscar razones para aprobar, no problemas para rechazar.

### El Patrón Típico

1. **Expectativa**: "La IA generalmente produce buen código"
2. **Revisión sesgada**: Buscar que el código "funcione", no que sea óptimo/seguro
3. **Tests superficiales**: Correr tests que probablemente pasen, evitar edge cases
4. **Aprobación rápida**: "LGTM" sin comentarios sustantivos

### Datos sobre Acceptance Rate vs Bugs

[GitClear]{.idx}'s 2024 report analizó 153 millones de líneas de código:

| Métrica | Pre-IA (2022) | Post-IA (2024) | Cambio |
|---------|---------------|----------------|--------|
| Code cloning | Baseline | **4x más frecuente** | +300% |
| Código pegado vs refactorizado | Menor | **Mayor** | Inversión histórica |
| Vulnerabilidades en código IA (Snyk, 2024) | N/A | **48% tiene potenciales vulnerabilidades** | Preocupante |

Por primera vez en la historia, los desarrolladores están pegando código más frecuentemente que refactorizándolo. Es una inversión de décadas de mejores prácticas.

### Técnicas de Adversarial Review

Para contrarrestar el confirmation bias:

1. **Reviewers asignados al azar**: No el autor elige quién revisa
2. **Quota de comentarios**: Mínimo 3 comentarios sustantivos por PR con código IA
3. **"Find the bug" challenge**: Gamificar la búsqueda de problemas
4. **Pre-mortem review**: "Imaginemos que este código causó un incidente. ¿Qué falló?"
5. **Rotation de "security champion"**: Alguien explícitamente busca vulnerabilidades

---

## Illusion of Competence: "Entiendo Porque Puedo Leer"

Quizás el sesgo más insidioso, la [ilusión de competencia]{.idx}: confundir la capacidad de leer código con la capacidad de entenderlo profundamente.

### La Diferencia entre Leer y Entender

| Nivel | Descripción | Indicador |
|-------|-------------|-----------|
| **1: Lectura** | Puedo seguir la sintaxis línea por línea | "Sé qué hace cada línea" |
| **2: Comprensión local** | Entiendo qué hace cada función | "Puedo explicar el propósito de cada método" |
| **3: Comprensión sistémica** | Entiendo cómo interactúa con el resto del sistema | "Sé por qué se diseñó así y qué alternativas había" |
| **4: Maestría** | Puedo modificar, extender y optimizar confidentemente | "Puedo mejorar esto y anticipar consecuencias" |

La mayoría de desarrolladores usando código IA opera en niveles 1-2, pero cree estar en nivel 3-4.

### "Teaching Tests" como Herramienta Diagnóstica

Una técnica efectiva para revelar la brecha de comprensión:

**Ejercicio**: Después de implementar una feature con ayuda de IA, el desarrollador debe:
1. Explicar el código a un compañero (sin mirar)
2. Dibujar el flujo de datos en un whiteboard
3. Predecir qué pasaría si se cambia X
4. Escribir tests para edge cases no cubiertos

Si no puede hacer 2+ de estas actividades, la "comprensión" es ilusoria.

::: {.callout .punto-critico}
**El Peligro de la Falsa Maestría**

La illusion of competence tiene consecuencias cascadeantes:

1. **Junior no pide ayuda** porque cree que entiende
2. **Senior no revisa profundo** porque junior "parece competente"
3. **Bug llega a producción** porque nadie cuestionó
4. **Post-mortem revela** que nadie realmente entendía el código
5. **Confianza del equipo baja**, pero el ciclo se repite
:::

> **Para Tu Próxima Reunión de Liderazgo**
>
> **3 Preguntas para tu próximo 1:1 con Tech Leads:**
>
> 1. "¿Podrías explicarme el último módulo que tu equipo generó con IA, sin abrir el código?" (Detecta illusion of competence)
> 2. "¿Cuántas veces esta semana alguien en tu equipo dijo 'no sé cómo funciona esto' sobre código en producción?" (Detecta cognitive offloading)
> 3. "Si apagáramos las herramientas de IA mañana, ¿cuánto caería la productividad vs. hace 12 meses?" (Mide dependencia real vs. percibida)
>
> Si las respuestas te incomodan, estás identificando sesgos a tiempo. Si te tranquilizan demasiado, probablemente también tienes un sesgo.

---

## Complacency: El Deterioro Gradual

La [complacencia tecnológica]{.idx} (reducción gradual de vigilancia cuando un sistema parece confiable) es particularmente peligrosa porque es invisible hasta que causa un incidente.

### La Curva de Complacency

La vigilancia del desarrollador sigue una curva predecible: comienza alta (~100%) en la primera semana, se mantiene alrededor del 80% durante los primeros tres meses, pero cae progresivamente al 60% hacia el mes 6, y se estabiliza por debajo del 40% después del primer año, el punto donde la complacencia está firmemente establecida.

### Métricas de Deterioro

| Indicador | Inicio Adopción | 6 Meses | 12 Meses |
|-----------|-----------------|---------|----------|
| Tiempo de code review por PR | 25 min | 15 min | 8 min |
| % PRs con cambios solicitados | 45% | 30% | 15% |
| Comentarios por PR | 6 | 3 | 1 ("LGTM") |
| Bugs escapados a producción | Baseline | +20% | +50% |

### Cómo la Vigilancia Disminuye con el Tiempo

El proceso es gradual e imperceptible:

1. **Mes 1**: Reviso cada línea de código IA cuidadosamente
2. **Mes 3**: Reviso secciones que "parecen complejas"
3. **Mes 6**: Escaneo rápido, confío si "se ve bien"
4. **Año 1**: Acepto si compila y pasa tests
5. **Año 2**: "Nunca ha fallado, ¿por qué revisar?"

### Rotación de Roles como Mitigación

Una estrategia efectiva es rotar responsabilidades para prevenir la complacencia:

| Semana | Developer A | Developer B | Developer C |
|--------|-------------|-------------|-------------|
| 1-2 | Código normal | **AI Reviewer** | Código normal |
| 3-4 | Código normal | Código normal | **AI Reviewer** |
| 5-6 | **AI Reviewer** | Código normal | Código normal |

El rol de "AI Reviewer" tiene responsabilidad explícita de:
- Revisar todo código generado por IA en profundidad
- Documentar patrones de errores encontrados
- Presentar hallazgos en retrospectiva

---

## Framework Integral de Mitigación

Los sesgos cognitivos no se eliminan; se gestionan. Un enfoque efectivo requiere intervención en tres niveles.

### Nivel Individual: 5 Técnicas de Metacognición

| # | Técnica | Descripción | Frecuencia |
|---|---------|-------------|------------|
| 1 | **Rubber Duck Debugging** | Explicar el código en voz alta antes de aceptarlo | Cada PR |
| 2 | **3 Alternativas** | Pedir 3 soluciones diferentes a la IA antes de elegir | Decisiones de diseño |
| 3 | **Pre-mortem Personal** | "Si esto falla en producción, ¿por qué será?" | Features críticas |
| 4 | **Teaching Test** | ¿Puedo explicar esto sin mirar el código? | Semanal |
| 5 | **Deliberate Practice** | 30 min/semana codificando SIN IA | Semanal |

### Nivel Equipo: 5 Rituales

| # | Ritual | Descripción | Frecuencia |
|---|--------|-------------|------------|
| 1 | **IA Postmortem** | Revisar bugs causados por código IA | Semanal (15 min) |
| 2 | **Buddy System** | Junior + Senior revisan código IA juntos | Cada PR de junior |
| 3 | **Red Team de IA** | Equipo busca activamente problemas | Bi-semanal |
| 4 | **"No IA Day"** | Un día al mes sin herramientas IA | Mensual |
| 5 | **Sharing Session** | Compartir "saves" donde se evitó bug de IA | Bi-semanal |

### Nivel Organizacional: 5 Políticas

| # | Política | Descripción | Owner |
|---|----------|-------------|-------|
| 1 | **Métricas de Salud Cognitiva** | Dashboard de indicadores de sesgo | Engineering Manager |
| 2 | **Fundamentals Refresher** | Programa trimestral de habilidades core sin IA | L&D |
| 3 | **AI Code Quota** | Máximo 60% de PR puede ser código IA | Team Lead |
| 4 | **Certification Interna** | Certificación de "AI-assisted development" | HR/Engineering |
| 5 | **Incident Attribution** | Trackear % de incidentes relacionados con código IA | SRE |

### Métricas de "Salud Cognitiva"

Un dashboard para monitorear sesgos a nivel organizacional:

| Métrica | Fórmula | Saludable | Alerta |
|---------|---------|-----------|--------|
| **Bug Ratio** | Bugs en código IA / Bugs en código humano | < 1.2x | > 1.5x |
| **Review Depth** | Tiempo promedio de PR review | > 15 min | < 10 min |
| **Change Request Rate** | % de PRs con cambios solicitados | > 30% | < 15% |
| **Comprehension Score** | Score en quizzes de comprensión | > 70% | < 50% |
| **Pair Programming Ratio** | Horas de pair / Horas totales | > 15% | < 5% |

---

## Casos de Estudio: Cuando los Sesgos Causan Incidentes

### Caso 1: Fintech y Automation Bias

**Contexto**: Una fintech latinoamericana adoptó agresivamente IA agéntica para acelerar desarrollo.

**Incidente**: Un endpoint de transferencias aceptó montos negativos, permitiendo "transferencias inversas" que movieron fondos de cuentas de destino a origen.

**Análisis**:
- Código generado por Copilot validaba formato pero no signo
- El desarrollador (mid-level) lo revisó superficialmente: "se ve completo"
- Tests generados por IA también fallaron en cubrir este caso
- Automation bias en cascada: todos confiaron en que "alguien más" lo había verificado

**Costo**: $45K en transferencias revertidas, 2 semanas de auditoría.

**Lección**: Código financiero requiere "defense in depth" que no asuma que ninguna capa es infalible.

### Caso 2: Startup con Dunning-Kruger Colectivo

**Contexto**: Startup de 12 personas, equipo joven (promedio 2.5 años de experiencia), adoptó Claude Code como herramienta principal.

**Incidente**: Arquitectura de microservicios hiper-compleja para lo que debería ser un monolito simple. 47 servicios para una app con 3 features core.

**Análisis**:
- CTO junior pidió a Claude "diseñar arquitectura escalable"
- Claude sugirió microservicios (patrones de empresas grandes en su training)
- Nadie cuestionó si era apropiado para una startup seed
- Dunning-Kruger colectivo: todos creyeron entender microservicios porque podían leer la documentación generada

**Costo**: 8 meses de desarrollo desperdiciado, necesidad de reescribir como monolito.

**Lección**: La IA replica patrones de su training data, no necesariamente los apropiados para tu contexto.

### Caso 3: Enterprise con Complacency Sistemática

**Contexto**: Empresa Fortune 500, 3 años usando GitHub Copilot a escala.

**Incidente**: Vulnerabilidad SQL injection en sistema legacy migrado, expuesto por 6 meses antes de detección.

**Análisis**:
- Código original (2019) tenía prepared statements
- Durante migración, IA generó código equivalente pero con string concatenation
- 14 reviewers (todos senior) aprobaron el PR
- Complacency sistemática: "si pasó tantas revisiones, debe estar bien"
- Ningún SAST configurado para código generado por IA

**Costo**: $2.3M en respuesta a incidente, notificación regulatoria, daño reputacional.

**Lección**: La complacency se acumula. Sin intervención activa, la vigilancia decae hasta el incidente.

---

::: {.callout .reunion-liderazgo}
## Para tu Próxima Reunión de Liderazgo

### Assessment Rápido: ¿Tu Equipo Tiene Problemas de Sesgos Cognitivos?

Responde Sí/No:

1. ☐ ¿El tiempo promedio de code review ha disminuido desde que adoptamos IA?
2. ☐ ¿Tenemos más bugs en producción que hace 12 meses?
3. ☐ ¿Los juniors piden menos ayuda a los seniors que antes?
4. ☐ ¿La mayoría de comentarios en PRs son "LGTM" sin detalles?
5. ☐ ¿Alguien ha dicho "la IA no se equivoca" sin ironía?
6. ☐ ¿Hemos tenido incidentes donde nadie entendía realmente el código involucrado?
7. ☐ ¿El ratio de código generado por IA supera el 70% en algunos PRs?

**Interpretación**:
- 0-2 Sí: Saludable, mantener vigilancia
- 3-4 Sí: Señales de alerta, implementar rituales de equipo
- 5-7 Sí: Problema sistémico, requiere intervención organizacional

### Acciones Inmediatas (Esta Semana)

1. **Medir**: Establecer baseline de las métricas de salud cognitiva
2. **Comunicar**: Discutir este tema abiertamente con el equipo (sin culpar)
3. **Piloto**: Implementar UN ritual de equipo (sugerido: IA Postmortem semanal)
4. **Sponsor**: Identificar un "AI Hygiene Champion" en cada equipo
:::

---

> **Dato verificado:**
>
> - **Fuente:** Aalto University, "When Using AI, Users Fall for the Dunning-Kruger Trap in Reverse" (2024); Stanford AI Lab, "Automation Bias in AI-Assisted Code Development" (2024); Google DORA Report (2024); GitClear "AI Copilot Code Quality Report" (2024, n=153M líneas de código)
> - **Qué mide:** Aalto estudió la autoevaluación de competencia en tareas asistidas por IA (n=participantes universitarios). Stanford midió la tasa de aceptación sin revisión de sugerencias de IA vs. humanas en desarrolladores profesionales. DORA correlacionó adopción de IA con métricas de estabilidad en producción. GitClear analizó patrones de code churn en repositorios con y sin IA
> - **Limitación:** El dato de 48% de aceptación sin revisión (Stanford) proviene de un estudio controlado, no de mediciones en producción real. La correlación negativa DORA-estabilidad no implica causalidad directa; otros factores (velocidad de deployment, complejidad del proyecto) pueden mediar. Los hallazgos de Aalto se realizaron en entornos académicos, no corporativos
> - **Implicación:** Los sesgos cognitivos documentados son reales y medibles, pero su impacto en producción varía por contexto. Usa estos datos para justificar inversión en programas de mitigación, no para argumentar contra la adopción de IA. El antídoto no es menos IA, sino más consciencia y mejores rituales de equipo

---

## Conclusiones y Takeaways

1. **Los sesgos cognitivos frente a la IA no son debilidad individual, son respuestas humanas predecibles.** Dunning-Kruger inverso, automation bias y cognitive offloading afectan a todos los niveles de experiencia. Reconocerlo es el primer paso.

2. **La sobreconfianza escala con la competencia percibida.** Paradójicamente, quienes más saben de IA tienden a confiar más ciegamente en ella. Los equipos senior no son inmunes; a menudo son más vulnerables.

3. **El 48% de aceptación sin revisión es una señal de alarma sistémica.** Si casi la mitad del código de IA se acepta sin escrutinio, tu codebase puede estar acumulando deuda técnica invisible.

4. **La mitigación es organizacional, no individual.** Pedir a cada developer que "sea más cuidadoso" no funciona. Se requieren rituales de equipo, métricas de salud cognitiva y programas de formación estructurados.

5. **Medir es proteger.** Establece métricas como "AI Rejection Rate", "Manual Override Frequency" y "Post-AI Bug Rate" para detectar degradación cognitiva antes de que impacte producción.

---


> **Tarjeta de Referencia Rápida**
>
> - **Métrica clave 1**: 48% de desarrolladores acepta código de IA sin revisarlo vs. 12% cuando la sugerencia viene de un humano (Stanford, 2024)
> - **Métrica clave 2**: Mayor AI literacy correlaciona con más sobreconfianza, no menos (Aalto University, 2024)
> - **Métrica clave 3**: Menos de 1 de cada 4 desarrolladores junior puede explicar correctamente la lógica del código generado por IA que acepta
> - **Framework principal**: Mitigación en tres niveles: Individual (metacognición), Equipo (rituales y peer review), Organizacional (métricas de salud cognitiva) (ver este capítulo)
> - **Acción inmediata**: Establece la métrica "AI Rejection Rate" en tu equipo esta semana y revisa el porcentaje de sugerencias de IA que se rechazan en code reviews

## Preguntas de Reflexión para Tu Equipo

1. **¿Cuándo fue la última vez que rechazaste código generado por IA por razones que no eran sintaxis o tests fallando?**

2. **Si mañana no tuviéramos acceso a herramientas de IA, ¿cuánto caería la productividad de tu equipo? ¿Esa caída sería solo velocidad o también capacidad?**

3. **¿Puedes identificar tres decisiones de diseño en tu codebase actual que se tomaron porque "la IA lo sugirió" sin evaluar alternativas?**

4. **¿Tus desarrolladores junior están aprendiendo fundamentos o están aprendiendo a usar IA efectivamente? ¿Son cosas diferentes?**

5. **Si un nuevo empleado revisara PRs de los últimos 6 meses, ¿podría distinguir cuáles contienen código generado por IA? ¿Debería poder?**

6. **¿Tu equipo tiene rituales explícitos para contrarrestar sesgos cognitivos, o confían en la "buena voluntad" individual?**

7. **En un post-mortem, ¿alguna vez se ha identificado "confianza excesiva en IA" como causa raíz? Si no, ¿es porque no ha pasado o porque no lo buscamos?**

---

**Referencias:**

1. Aalto University. (2024). "When Using AI, Users Fall for the Dunning-Kruger Trap in Reverse".
2. Stanford AI Lab. (2024). "Automation Bias in AI-Assisted Code Development".
3. Singh, M. et al. / Microsoft Research / IIT Delhi. (2025). "Do Code Models Suffer from the Dunning-Kruger Effect?". arXiv:2510.05457.
4. Oxford. (2024). "Bending the Automation Bias Curve".
5. Google. (2024). "DORA Report 2024: Accelerate State of DevOps".
6. GitClear. (2024). "AI Copilot Code Quality Report". Análisis de 153M líneas de código.
7. Stack Overflow. (2024). "Stack Overflow Developer Survey 2024".
8. Kahneman, D. (2011). "Thinking, Fast and Slow". Farrar, Straus and Giroux.
9. Mollick, E. (2024). "Co-Intelligence: Living and Working with AI".
10. OWASP. (2025). "OWASP Top 10 for Large Language Model Applications".

---

*Fin del Capítulo 5. Continúa en Capítulo 6: Guía de Adopción por Industria*
