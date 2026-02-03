# Prefacio: Por Qué los Líderes Deben Leer Esto Ahora {.unnumbered}

> **Resumen Ejecutivo**
>
> - En 2025, el 46% del código está siendo escrito por IA, transformando radicalmente la ingeniería de software
> - Gartner predice que el 40% de aplicaciones empresariales integrarán agentes de IA para finales de 2026
> - Sin embargo, más del 40% de proyectos de IA agéntica serán cancelados antes de 2027 por falta de estrategia clara
> - Este libro proporciona frameworks de decisión para líderes técnicos que deben navegar esta transformación ahora

---

## El Momento Crítico: Por Qué 2025-2026 Es el Punto de Inflexión

Si eres CTO, VP de Ingeniería, o Tech Lead, probablemente has notado algo fundamental: el software se está escribiendo de manera diferente.

No me refiero a un nuevo framework JavaScript o a otra metodología ágil. Hablo de algo mucho más profundo: **las máquinas están escribiendo casi la mitad del código que tu equipo produce**.

Según datos de GitHub de 2025, el 46% de todo el código generado por desarrolladores proviene de asistentes de IA como GitHub Copilot[^pref1]. En proyectos Java, esta cifra alcanza el 61%. Esto no es futuro lejano—está sucediendo en este momento en los equipos de ingeniería de todo el mundo.

**Evolución del porcentaje de código generado por IA (2022-2025)**

| Año | % de código generado por IA | Evento clave del mercado |
|-----|:---------------------------:|--------------------------|
| 2022 | ~10% | Lanzamiento de GitHub Copilot (disponibilidad general) |
| 2023 | ~25% | Adopción masiva de asistentes de IA en IDEs; aparición de ChatGPT para código |
| 2024 | ~35% | Integración de IA generativa en flujos de CI/CD; primeros agentes autónomos |
| 2025 | **46%** | IA agéntica en producción; 61% en proyectos Java; 84% de desarrolladores usan herramientas de IA |

*Fuente: GitHub (2025), Second Talent (2025), Stack Overflow Developer Survey (2025)*

> **Dato verificado:**
>
> - **Fuente:** GitHub Octoverse Report 2025; Second Talent analysis
> - **Qué mide:** Porcentaje de código nuevo generado con asistencia de IA (aceptaciones de sugerencias de Copilot como proporción del código total committeado)
> - **Muestra:** 1.8M+ usuarios activos de GitHub Copilot; datos agregados de proyectos Java, Python, JavaScript y otros lenguajes
> - **Limitación:** Solo mide código aceptado vía Copilot en GitHub; no incluye código asistido por otras herramientas (ChatGPT, Claude, Cursor) ni asistencia indirecta. La cifra real de código "asistido por IA" probablemente es mayor
> - **Implicación práctica:** Si al menos 46% del código nuevo ya es asistido por IA, la pregunta para líderes no es "¿debemos adoptar?" sino "¿cómo gobernar lo que ya está sucediendo?"

Pero aquí está el problema: mientras que el 84% de los desarrolladores están usando herramientas de IA[^pref2], menos del 10% de las organizaciones han logrado escalar agentes de IA a nivel de producción en alguna función específica, según el reporte "State of AI 2025" de McKinsey[^pref3].

Existe una brecha masiva entre experimentación y ejecución estratégica.

### Las Cifras que Deberían Preocuparte (y Motivarte)

Gartner ha emitido predicciones que toda la alta dirección técnica debería conocer[^pref4]:

- **40% de aplicaciones empresariales** integrarán agentes de IA específicos para tareas para finales de 2026 (comparado con menos del 5% en 2025)
- **Pero también**: más del **40% de proyectos de IA agéntica serán cancelados** antes de finales de 2027 debido a costos escalados, valor de negocio poco claro, o controles de riesgo inadecuados
- Para 2028, al menos **15% de las decisiones diarias de trabajo** serán tomadas de forma autónoma por IA agéntica
- Para 2029, la IA agéntica resolverá autónomamente el **80% de problemas comunes de servicio al cliente** sin intervención humana

**Timeline de adopción de IA agéntica según Gartner (2025-2029)**

| Año | Hito proyectado | Implicación para líderes |
|-----|-----------------|--------------------------|
| 2025 | Menos del 5% de aplicaciones empresariales integran agentes de IA | Fase de experimentación: pilotos internos, pruebas de concepto |
| 2026 | **40% de aplicaciones empresariales** integrarán agentes de IA para tareas específicas | Punto de inflexión: las organizaciones sin estrategia quedarán rezagadas |
| 2027 | Más del **40% de proyectos de IA agéntica serán cancelados** por costos, valor difuso o riesgo | Fase de consolidación: sobreviven los proyectos con gobernanza y ROI (retorno de inversión) claro |
| 2028 | Al menos **15% de las decisiones diarias de trabajo** serán tomadas de forma autónoma por IA | Rediseño organizacional: nuevos roles, nuevos flujos de aprobación |
| 2029 | IA agéntica resolverá autónomamente el **80% de problemas comunes** de servicio al cliente | Madurez operativa: agentes integrados en procesos core del negocio |

*Fuente: Gartner Press Release, junio 2025; Gartner Top Strategic Technology Trends 2025*

> **Dato verificado:**
>
> - **Fuente:** Gartner Press Release, junio 2025; Gartner Top Strategic Technology Trends 2025
> - **Qué mide:** Proyección de adopción de agentes de IA en aplicaciones empresariales y tasa de cancelación de proyectos
> - **Muestra:** Análisis prospectivo de Gartner basado en encuestas a ejecutivos y modelos de mercado (no son datos observados)
> - **Limitación:** Las proyecciones de Gartner tienen un margen de error histórico significativo. La predicción de 40% de cancelación refleja el patrón típico del Hype Cycle
> - **Implicación práctica:** La dualidad es el mensaje clave: el mercado se moverá rápido (40% adopción), pero sin governance la mayoría fracasará (40% cancelación). Estar en el 60% que sobrevive requiere estrategia deliberada

El mercado de IA alcanzó los **$391 mil millones** en 2025. En el mejor escenario de Gartner, la IA agéntica podría impulsar aproximadamente **30% de los ingresos del software empresarial de aplicaciones** para 2035—más de **$450 mil millones**[^pref5].

### El Costo de la Inacción

Ahora mismo, tus competidores están tomando decisiones críticas sobre IA agéntica. Algunos invertirán sabiamente y transformarán sus organizaciones. Otros desperdiciarán millones en proyectos que serán cancelados.

Según una encuesta de Gartner de enero de 2025 a 3,412 asistentes de webinars[^pref6]:

- 19% han hecho inversiones significativas en IA agéntica
- 42% han hecho inversiones conservadoras
- 31% están en modo "esperar y ver"
- 8% no han hecho ninguna inversión

La pregunta no es **si** tu organización adoptará IA agéntica en ingeniería de software. La pregunta es **cuándo** y **cómo**—y si lo harás de manera estratégica o reactiva.

### Lo Que Está en Juego Para Tu Equipo

Los datos sobre productividad son contundentes pero requieren contexto:

- Desarrolladores usando GitHub Copilot completan **126% más proyectos por semana**[^pref7]
- El tiempo de pull request cayó de 9.6 días a 2.4 días—una **reducción del 75%** en ciclos de desarrollo[^pref8]
- Los equipos ahorran **30-60% del tiempo** en codificación y pruebas rutinarias[^pref9]

Suena increíble, ¿verdad? Pero aquí está el matiz crítico que muchos líderes pasan por alto:

- **48% del código generado por IA contiene vulnerabilidades de seguridad**[^pref10]
- La codificación asistida por IA genera **4 veces más clonación de código**, aumentando la deuda técnica[^pref11]
- Toma aproximadamente **11 semanas** para que los desarrolladores realicen completamente las ganancias de productividad[^pref12]
- Solo **33% de los desarrolladores confían plenamente** en los resultados de IA[^pref13]
- **71% de desarrolladores no fusionan código generado por IA sin revisión manual**[^pref14]

**Beneficios vs. Riesgos de IA Agéntica en Ingeniería de Software**

| Dimensión | Beneficio comprobado | Riesgo documentado |
|-----------|----------------------|--------------------|
| **Productividad** | +126% proyectos completados por semana; 30-60% ahorro en codificación rutinaria | Toma ~11 semanas realizar las ganancias; curva de aprendizaje significativa |
| **Velocidad de entrega** | Tiempo de pull request reducido 75% (de 9.6 a 2.4 días) | Velocidad sin revisión adecuada genera deuda técnica acumulada |
| **Calidad del código** | Automatización de pruebas y detección temprana de errores | 48% del código generado por IA contiene vulnerabilidades de seguridad |
| **Deuda técnica** | Refactorización asistida y documentación automática | 4x más clonación de código; riesgo de degradación arquitectónica |
| **Confianza del equipo** | 84% de desarrolladores ya usan herramientas de IA | Solo 33% confían plenamente en los resultados; 71% no fusionan sin revisión manual |
| **ROI organizacional** | Mercado de IA alcanzó $391B en 2025; potencial de $450B+ para 2035 | 40%+ de proyectos de IA agéntica serán cancelados antes de 2027 |

*Fuentes: GitHub (2025), Gartner (2025), GitClear (2025), Stack Overflow Developer Survey (2025)*

Estas cifras contradictorias explican por qué tantos proyectos fracasan. La tecnología funciona—pero solo cuando los líderes comprenden tanto su potencial como sus limitaciones.

## Para Quién Es Este Libro

Este libro está escrito específicamente para **líderes técnicos y de negocio** que deben tomar decisiones estratégicas sobre IA agéntica en los próximos 12-24 meses:

### Audiencia Principal

- **CTOs y VPs de Ingeniería**: Necesitas decidir qué inversiones hacer, cómo reorganizar equipos, y cómo medir ROI
- **Tech Leads y Engineering Managers**: Debes implementar estas herramientas mientras mantienes calidad, seguridad y moral del equipo
- **Product Managers y PMs Técnicos**: Necesitas entender cómo la IA agéntica cambia los timelines de desarrollo y las capacidades del producto
- **Directores de Innovación y Transformación Digital**: Estás evaluando el impacto organizacional y cultural de estas tecnologías

### Lo Que NO Necesitas Para Leer Este Libro

- **No necesitas ser programador**. No hay código en este libro. Cero líneas. Ni siquiera pseudocódigo.
- **No necesitas experiencia previa con IA**. Explicamos todos los conceptos en términos de impacto al negocio.
- **No necesitas tomar decisiones técnicas de implementación**. Tu equipo técnico puede hacer eso. Tú necesitas tomar decisiones estratégicas.

### Lo Que SÍ Necesitas

- Curiosidad sobre cómo la IA agéntica está cambiando la ingeniería de software
- Responsabilidad por decisiones que afectan equipos, presupuestos o roadmaps de producto
- Disposición para cuestionar tanto el hype como el escepticismo excesivo
- Interés en frameworks prácticos de decisión basados en datos reales

## Qué Encontrarás en Este Libro

Este no es un libro técnico. Es un libro de **estrategia y liderazgo** disfrazado de libro sobre tecnología.

### Lo Que Incluimos

**Frameworks de Decisión Accionables**
Cada capítulo incluye herramientas que puedes usar inmediatamente:

- Matrices de evaluación para seleccionar herramientas
- Checklists de implementación por fase
- Métricas de ROI específicas para IA agéntica
- Preguntas para hacer a tu equipo y vendors

**Datos Verificables con Fuentes**
Todas las estadísticas, métricas y tendencias están citadas con fuentes de investigación reconocidas:

- Gartner, McKinsey, Forrester
- Estudios académicos peer-reviewed
- Datos de plataformas (GitHub, Stack Overflow)
- Reportes financieros de empresas públicas

**Casos de Estudio Reales (y Algunos Ficticios Pero Realistas)**
Verás 5 casos profundos de implementación:

- 2 casos reales completamente documentados
- 3 casos ficticios basados en patrones comunes que he observado en consultoría

Cada caso sigue la estructura: Contexto → Decisión → Implementación → Resultados → Lecciones

**Recuadros "Para Tu Próxima Reunión de Liderazgo"**
Estos resúmenes ejecutivos te dan puntos concretos para comunicar a tu equipo directivo, board, o stakeholders.

### Lo Que NO Encontrarás

- **Código de programación**: Ni una sola línea
- **Tutoriales paso a paso de herramientas**: Para eso están las documentaciones
- **Hype sin sustancia**: Cada afirmación tiene una fuente citada
- **Predicciones sin base**: Nos enfocamos en tendencias con datos, no especulación

## Cómo Leer Este Libro

Diseñé este libro para ser **modular**. No necesitas leerlo de principio a fin.

### Lectura Completa Recomendada (Para CTOs y Líderes de Transformación)

Si eres responsable de la estrategia completa de IA agéntica:

1. **Parte I: Contexto Estratégico (Caps 1-3)** - Establece el marco mental
2. **Parte II: Tecnología (Caps 4-5)** - Entiende las capacidades sin entrar en detalles técnicos
3. **Parte III: Impacto al Negocio (Cap 6)** - Calcula ROI y justifica inversión
4. **Parte IV: Casos de Estudio (Caps 7-11)** - Aprende de implementaciones reales
5. **Parte V: Liderazgo (Caps 12-13)** - Lidera equipos humanos en la era de IA
6. **Parte VI: Gobernanza y Futuro (Caps 14-15)** - Gestiona riesgos y planifica a mediano plazo
7. **Apéndices** - Herramientas de referencia rápida

**Tiempo estimado**: 8-10 horas de lectura enfocada

### Lectura Dirigida (Para Roles Específicos)

**Si eres Tech Lead o Engineering Manager:**

- Empieza con **Caps 4-5** (Tecnología)
- Luego **Caps 7-11** (Casos de Estudio)
- Termina con **Cap 12** (Liderando Equipos)
- Consulta **Apéndice C** (Checklist de Implementación)

**Si eres Product Manager:**

- Empieza con **Cap 6** (Impacto al Negocio)
- Luego **Caps 7-11** (Casos de Estudio)
- Consulta **Cap 13** (Estrategia de Adopción)

**Si estás en un board o comité de inversión:**

- Lee **Cap 1** (Introducción)
- Salta a **Cap 6** (Impacto al Negocio)
- Revisa **Cap 14** (Gobernanza y Riesgos)
- Ojea **Cap 15** (Futuro)

**Flujo de lectura recomendado según rol**

| Rol | Ruta de lectura | Capítulos clave | Tiempo estimado |
|-----|-----------------|-----------------|:---------------:|
| **CTO / VP de Ingeniería** | Lectura completa: Partes I a VI + Apéndices | Todos (Caps 1-15) | 8-10 horas |
| **Tech Lead / Eng. Manager** | Tecnología + Casos + Liderazgo | Caps 4, 5, 7-12 + Apéndice C | 5-6 horas |
| **Product Manager** | Negocio + Casos + Estrategia | Caps 6, 7-11, 13 | 4-5 horas |
| **Board / Comité de inversión** | Visión ejecutiva + Riesgos | Caps 1, 6, 14, 15 | 2-3 horas |
| **Director de Innovación** | Contexto + Impacto + Gobernanza | Caps 1-3, 6, 13-15 | 5-6 horas |

### Usando los Recuadros y Herramientas

A lo largo del libro encontrarás:

- 📊 **Recuadros "Para Tu Próxima Reunión"**: Saca tu teléfono y toma una foto. Úsalo en tu próxima presentación.
- ✅ **Checklists**: Imprime y marca conforme avanzas en implementación.
- ❓ **Preguntas de Reflexión**: Úsalas en sesiones de estrategia con tu equipo.
- ⚠️ **Señales de Alerta**: Indicadores de que algo va mal en tu implementación.

## El Autor: Mi Perspectiva y Sesgos

Debo ser transparente sobre quién soy y qué perspectiva traigo a este libro.

### Mi Trayectoria

Llevo más de 15 años construyendo capacidades de datos e inteligencia artificial en América Latina. Mi carrera ha seguido una trayectoria poco común: la del líder ejecutivo que nunca dejó de escribir código.

Empecé como investigador en la Universidad de Santiago de Chile, diseñando modelos de data mining y optimización cuando el machine learning aún era territorio académico. Después construí desde cero la primera capacidad de Big Data Analytics de una telco en Latinoamérica (Telefónica Chile). Lideré la estrategia de datos para Falabella, uno de los ecosistemas de e-commerce más grandes de la región. Desplegué modelos de personalización en tiempo real para millones de pasajeros en LATAM Airlines. Fundé una startup de datos. Lideré equipos de más de cien ingenieros en seis países.

Hoy, como Group Chief Digital & Data Officer de Grupo DEACERO, lidero la transformación de una de las mayores manufactureras de acero de México hacia una operación AI-native. Construyo sistemas RAG, hago fine-tuning de modelos LLM y los despliego a escala en producción—no como ejercicio teórico, sino como parte de mi trabajo diario.

He pasado por Equifax, Experian, Telefónica, LATAM, Falabella, y ahora DEACERO. He analizado el comportamiento de más de 400 millones de clientes. He visto proyectos de IA generar cientos de millones de dólares en valor—y he visto otros fracasar estrepitosamente.

### Mis Sesgos (Que Debes Conocer)

**Soy optimista pragmático**: Creo que la IA agéntica transformará la ingeniería de software y que es la principal palanca para mejorar la productividad de Latinoamérica. Pero he visto demasiado hype tecnológico para no cuestionar las afirmaciones extraordinarias. Como escribí una vez: "Una organización no se transforma en data-driven al construir un data-lake o hacer proyectos de Machine Learning."

**Pienso desde Latinoamérica**: Veo el mundo tech desde una óptica diferente al Silicon Valley. Los constraints de nuestros mercados—capital limitado, talento escaso, infraestructura variable—nos obligan a ser más creativos y pragmáticos. Eso informa todo lo que escribo.

**Sigo escribiendo código**: A diferencia de muchos ejecutivos que dejaron el teclado hace años, yo sigo construyendo. Arquitecto personalmente plataformas de GenAI, configuro pipelines de datos, y debuggeo en producción. Eso me da una perspectiva que no obtienes solo leyendo reportes de analistas.

**He fracasado**: He visto proyectos de IA prometer mucho y entregar poco. He apostado en tecnologías que no funcionaron. He liderado transformaciones que encontraron resistencia cultural brutal. Esos fracasos informan este libro tanto como los éxitos.

**Priorizo datos sobre anécdotas**: Si lees una afirmación en este libro sin una cita, probablemente sea mi opinión personal—y deberías cuestionar mi opinión tanto como cuestionarías la de cualquier otro.

### Por Qué Escribí Este Libro

Veo muchos equipos definiendo mal los objetivos de integrar IA a su ambiente laboral.

Unos buscan "innovar" sin saber para qué. Otros compran herramientas sin cambiar procesos. Muchos miden las métricas equivocadas. Y casi todos subestiman el cambio cultural necesario.

La IA agéntica no es solo una herramienta más—es un cambio de paradigma en cómo construimos software. Y Latinoamérica tiene una oportunidad única: adoptar estas tecnologías sin cargar el legacy de décadas de procesos obsoletos que frenan a las organizaciones del hemisferio norte.

Este libro es el que hubiera querido leer antes de tomar mis primeras decisiones sobre IA agéntica. Es un framework para pensar, no un tutorial para copiar. Porque las respuestas correctas siempre son "depende"—y necesitas un framework para pensar en **de qué depende**.

## Una Nota Sobre el Ritmo de Cambio

Debo advertirte: parte de este libro estará desactualizado antes de que llegue a tus manos.

La IA agéntica está evolucionando tan rápido que nombres de herramientas, capacidades específicas, y hasta paradigmas de uso cambian cada trimestre.

Por eso este libro se enfoca en **principios sobre herramientas específicas**, y en **frameworks de pensamiento sobre tutoriales**.

Los nombres de productos cambiarán. Las capacidades mejorarán. Pero las preguntas fundamentales que los líderes deben responder permanecerán:

- ¿Cómo evaluamos el valor de negocio?
- ¿Cómo gestionamos el riesgo?
- ¿Cómo lideramos equipos a través del cambio?
- ¿Cómo construimos estrategias sostenibles?

Esas preguntas seguirán siendo relevantes en 2026, 2027, y más allá.

## Antes de Empezar: Una Invitación

Este libro no tiene todas las respuestas. Ningún libro podría tenerlas en un campo tan dinámico.

Lo que sí ofrece es:

- **Estructura** para pensar sobre decisiones complejas
- **Datos** para fundamentar tus argumentos ante stakeholders
- **Casos de estudio** para aprender de éxitos y fracasos de otros
- **Frameworks** para adaptar a tu contexto específico

Mi invitación es simple: **lee críticamente**.

Cuestiona las afirmaciones. Verifica las fuentes. Adapta los frameworks a tu realidad. Comparte lo que aprendes con tu comunidad.

Y sobre todo: **no dejes que el miedo a equivocarte te paralice**.

La IA agéntica transformará la ingeniería de software. Eso ya está sucediendo. La pregunta no es si participas, sino cómo lo haces de manera estratégica, responsable, y efectiva.

Empecemos.

---

**Para tu próxima reunión de liderazgo:**

📊 *"En 2025, el 46% del código ya está siendo escrito por IA. Gartner predice que 40% de nuestras aplicaciones empresariales integrarán agentes de IA para finales de 2026. Pero también advierte que 40% de estos proyectos serán cancelados por falta de estrategia clara. Necesitamos un framework de decisión ahora—no en 6 meses."*

---

## Referencias

[^pref1]: Second Talent. (2025). "AI Coding Assistant Statistics & Trends [2025]". Disponible en: https://www.secondtalent.com/resources/ai-coding-assistant-statistics/

[^pref2]: Index.dev. (2025). "Developer Productivity Statistics with AI Tools 2025". Disponible en: https://www.index.dev/blog/developer-productivity-statistics-with-ai-tools

[^pref3]: McKinsey. (2025). "The state of AI in 2025: Agents, innovation, and transformation". Disponible en: https://www.mckinsey.com/capabilities/quantumblack/our-insights/the-state-of-ai

[^pref4]: Gartner. (2025). "Gartner Predicts Over 40% of Agentic AI Projects Will Be Canceled by End of 2027". Press Release. Disponible en: https://www.gartner.com/en/newsroom/press-releases/2025-06-25-gartner-predicts-over-40-percent-of-agentic-ai-projects-will-be-canceled-by-end-of-2027

[^pref5]: Gartner. (2025). "Top Strategic Technology Trends for 2025: Agentic AI". Disponible en: https://www.gartner.com/en/documents/5850847

[^pref6]: Gartner. (2025). Press Release - Agentic AI Investment Survey Results.

[^pref7]: Second Talent. (2025). "GitHub Copilot Statistics & Adoption Trends [2025]". Disponible en: https://www.secondtalent.com/resources/github-copilot-statistics/

[^pref8]: Arxiv. (2023). "The Impact of AI on Developer Productivity: Evidence from GitHub Copilot". Disponible en: https://arxiv.org/abs/2302.06590

[^pref9]: Index.dev. (2025). "Developer Productivity Statistics with AI Tools 2025".

[^pref10]: NetCorp Software Development. (2026). "AI-Generated Code Statistics 2026: Can AI Replace Your Development Team?". Disponible en: https://www.netcorpsoftwaredevelopment.com/blog/ai-generated-code-statistics

[^pref11]: GitClear. (2025). "AI Copilot Code Quality: 2025 Data Suggests 4x Growth in Code Clones". Disponible en: https://www.gitclear.com/ai_assistant_code_quality_2025_research

[^pref12]: Microsoft Research. (2025). Citado en Second Talent statistics report.

[^pref13]: Stack Overflow. (2025). "AI | 2025 Stack Overflow Developer Survey". Disponible en: https://survey.stackoverflow.co/2025/ai

[^pref14]: Second Talent. (2025). "AI Coding Assistant Statistics & Trends [2025]".

