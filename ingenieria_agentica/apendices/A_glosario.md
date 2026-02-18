# Apéndice A: Glosario Ejecutivo

> **Extensión objetivo:** 5 páginas | **Audiencia:** Gerentes y líderes técnicos

Este glosario reúne los términos clave utilizados a lo largo del libro, con definiciones orientadas a líderes de tecnología. Cada término incluye una explicación ejecutiva que prioriza el impacto en el negocio sobre los detalles técnicos.

---

## A

**Agente de IA / AI Agent**
Sistema de inteligencia artificial capaz de actuar autónomamente para lograr objetivos, tomando decisiones y ejecutando acciones en secuencia con mínima intervención humana. A diferencia de un chatbot, un agente puede usar herramientas, acceder a sistemas y completar tareas complejas de múltiples pasos. Para líderes: representa el salto de "IA que sugiere" a "IA que ejecuta".

**AI Act (Regulación Europea de IA)**
Regulación de la Unión Europea que clasifica sistemas de IA por nivel de riesgo y establece requisitos de transparencia, supervisión humana y evaluación de impacto. Entró en vigor en 2025. Relevante para cualquier organización que opere en mercados europeos o procese datos de ciudadanos de la UE.

**AI Auditor**
Rol emergente responsable de revisar y validar el código, las decisiones y los resultados generados por sistemas de IA. Combina habilidades de ingeniería de software con entendimiento de sesgos algorítmicos y cumplimiento normativo. Es uno de los roles de mayor demanda proyectada para 2026-2028.

**AI Code Reviewer**
Especialista en evaluar la calidad, seguridad y corrección del código generado por IA. A diferencia de un code reviewer tradicional, debe identificar patrones típicos de alucinaciones, vulnerabilidades introducidas por modelos y dependencias no verificadas.

**Agent Orchestrator**
Rol que gestiona equipos híbridos de humanos e IA, definiendo qué tareas delegar a agentes, estableciendo niveles de autonomía y supervisando resultados. Es la evolución natural del tech lead en organizaciones que adoptan IA agéntica.

**Agent Trainer**
Especialista en fine-tuning y personalización de modelos de IA para dominios específicos. Trabaja en la intersección entre ciencia de datos y conocimiento de dominio del negocio.

**Alucinación (Hallucination)**
Cuando un modelo de IA genera información que parece plausible pero es incorrecta o inventada. En código, puede manifestarse como llamadas a funciones inexistentes, APIs obsoletas o lógica incorrecta que compila pero produce resultados erróneos. Según estudios de Carnegie Mellon (2024), hasta un 40% del código generado por IA puede contener vulnerabilidades no evidentes. Las alucinaciones son matemáticamente inevitables en arquitecturas Transformer: son el costo de la capacidad de generalización. Ver también: Grounding, Benchmarks de Alucinación (Cap. 11).

**Anchoring Bias (Sesgo de Anclaje)**
Sesgo cognitivo donde la primera información recibida (el "ancla") influye desproporcionadamente en decisiones posteriores. En IA agéntica: si la primera sugerencia de arquitectura es microservicios, el equipo tiende a optimizar esa arquitectura en lugar de considerar alternativas como monolitos. Mitigación: pedir múltiples alternativas antes de decidir.

**Automation Bias (Sesgo de Automatización)**
Tendencia a confiar excesivamente en sugerencias de sistemas automatizados sobre el propio juicio. Stanford (2024) encontró que 48% de desarrolladores acepta código de IA sin revisar, vs. solo 12% para sugerencias humanas. Es uno de los principales sesgos cognitivos que afectan la adopción de IA (Cap. 4).

**AutoGen**
Framework de Microsoft para crear sistemas multi-agente conversacionales. Permite definir agentes con roles específicos que colaboran mediante conversaciones estructuradas. Destaca por su integración con el ecosistema Azure.

**Automatización Inteligente**
Evolución de la automatización tradicional (RPA) que incorpora capacidades de razonamiento y adaptación mediante IA. No sigue scripts rígidos sino que puede tomar decisiones ante situaciones no previstas.

---

## B

**Bias (Sesgo Algorítmico)**
Tendencia sistemática de un modelo de IA a producir resultados que favorecen o perjudican a ciertos grupos. En desarrollo de software, puede manifestarse en sugerencias de código que reflejan patrones históricos discriminatorios. El caso de Amazon (2018) con su sistema de reclutamiento es el ejemplo más citado.

**Bucle Agéntico (Agentic Loop)**
Ciclo fundamental de operación de un agente de IA: Percibir → Razonar → Actuar → Aprender → Repetir. Cada iteración del bucle permite al agente refinar su comprensión del problema y ajustar su estrategia. Es el concepto central que diferencia a los agentes de los asistentes de una sola interacción.

---

## C

**Caja Negra Institucional**
Riesgo organizacional donde ninguna persona en la empresa comprende completamente el código que la hace funcionar. Ocurre cuando: (1) juniors generan código con IA sin entenderlo, (2) reviews se hacen superficialmente, (3) rotación de personal elimina conocimiento institucional. Señales de alerta: "bus factor" de 1 en sistemas críticos, incapacidad de explicar decisiones arquitectónicas, tiempo para modificar sistemas > tiempo para reescribirlos. Mitigación: Regla del 2x2 (2 personas entienden, 2 lugares documentado). Ver Cap. 11.

**CI/CD (Continuous Integration / Continuous Delivery)**
Práctica de desarrollo que automatiza la integración y entrega de código. En el contexto de IA agéntica, los pipelines de CI/CD deben adaptarse para incluir validación de código generado por IA, verificación de seguridad adicional y gates de aprobación humana.

**Cognitive Offloading (Tercerización Cognitiva)**
Fenómeno psicológico donde usuarios delegan procesos mentales a herramientas externas. Con IA agéntica, alcanza niveles preocupantes: investigación de Aalto University (2024) encontró que usuarios "simplemente copian, pegan y están felices" sin verificar respuestas de IA. Puede causar "atrofia cognitiva" de habilidades fundamentales. Ver Cap. 4.

**Complacency (Complacencia)**
Reducción gradual del esfuerzo y atención cuando los sistemas "funcionan bien". En adopción de IA, se manifiesta como deterioro progresivo de la profundidad de code review: Mes 1 "reviso todo", Mes 12 "la IA casi nunca se equivoca". Es un riesgo invisible hasta que causa un incidente.

**Claude Code**
Agente de desarrollo de Anthropic que opera directamente en la terminal del desarrollador. Puede navegar repositorios, editar archivos, ejecutar tests y completar tareas de desarrollo complejas con supervisión humana. Ejemplo representativo de la nueva generación de agentes autónomos de código.

**Code Completion (Autocompletado)**
Capacidad de IA para sugerir las siguientes líneas de código mientras el desarrollador escribe. Funciona en tiempo real dentro del IDE. GitHub Copilot popularizó esta categoría en 2021. Representa el primer nivel de adopción de IA en desarrollo (Nivel 1-2 en la Matriz de Madurez).

**Code Coverage (Cobertura de Código)**
Porcentaje del código fuente que es ejecutado por las pruebas automatizadas. Con IA agéntica, es posible incrementar la cobertura significativamente al generar tests automáticos para código existente. Organizaciones reportan incrementos de 40-60% en cobertura tras adoptar agentes de testing.

**Code Generation (Generación de Código)**
Capacidad de crear archivos, módulos o componentes completos a partir de descripciones en lenguaje natural. Herramientas como Cursor, v0.dev y bolt.new permiten generar aplicaciones funcionales desde prompts. Representa el siguiente nivel después del autocompletado.

**Contexto (Context Window)**
Cantidad de información que un modelo de IA puede procesar en una sola interacción, medida en tokens. Modelos modernos manejan desde 8K hasta 200K+ tokens. Un contexto más amplio permite al agente comprender proyectos más grandes sin perder coherencia. Es un factor clave en la selección de herramientas.

**Copilot**
Término genérico para asistentes de IA integrados en herramientas de desarrollo que sugieren código mientras el desarrollador escribe. GitHub Copilot es el ejemplo más conocido, pero el término se ha extendido a Microsoft 365 Copilot y otros productos. Representa el modelo "IA como copiloto" donde el humano mantiene el control.

**CrewAI**
Framework para crear sistemas multi-agente donde cada agente tiene un rol, objetivo y herramientas específicas. Inspirado en la metáfora de una "tripulación" donde cada miembro tiene responsabilidades definidas. Popular por su simplicidad y curva de aprendizaje accesible.

**Cursor**
IDE (entorno de desarrollo integrado) con capacidades agénticas nativas. Su función "Composer" permite describir cambios en lenguaje natural y el agente modifica múltiples archivos coordinadamente. Representa la convergencia entre IDE y agente de IA.

---

## D

**Defect Rate (Tasa de Defectos)**
Número de bugs o errores encontrados por unidad de tiempo o por versión. Es una métrica clave para evaluar el impacto de IA agéntica: organizaciones maduras reportan reducciones del 20-40% en defect rate tras 6 meses de adopción.

**Developer Experience (DX)**
Calidad de la experiencia del desarrollador al usar herramientas, procesos y sistemas. La adopción de IA agéntica impacta directamente en DX: puede mejorarla (menos tareas repetitivas) o empeorarla (flujos interrumpidos, confianza excesiva).

**Developer NPS (Net Promoter Score)**
Métrica que mide la satisfacción de los desarrolladores con sus herramientas y procesos de trabajo. Se obtiene preguntando "¿Recomendarías nuestro stack de herramientas a un colega?". Es indicador adelantado de retención de talento.

**Devin**
Agente autónomo de ingeniería de software desarrollado por Cognition AI. Fue uno de los primeros agentes en demostrar capacidad de completar tareas complejas de desarrollo de forma autónoma, incluyendo debugging, refactoring y despliegue. Su lanzamiento en 2024 marcó un punto de inflexión en la industria.

**DevSecOps**
Integración de prácticas de seguridad (Sec) directamente en el flujo de desarrollo (Dev) y operaciones (Ops). En el contexto agéntico, los agentes de IA pueden automatizar análisis SAST/SCA como parte del pipeline CI/CD, acelerando la detección de vulnerabilidades sin frenar el delivery. Ver Cap. 11 para gobernanza de seguridad en entornos agénticos.

**DLP (Data Loss Prevention)**
Conjunto de tecnologías y prácticas para prevenir la fuga de datos sensibles. En el contexto de IA agéntica, es crítico configurar DLP para evitar que agentes envíen código propietario, credenciales o datos de clientes a APIs externas de modelos de lenguaje.

**DPO (Direct Preference Optimization)**
Técnica de post-training más eficiente que RLHF para alinear modelos con preferencias humanas. No requiere un modelo de recompensa separado. Está ganando adopción como alternativa a RLHF en modelos recientes. Para líderes: es parte de lo que hace que modelos como Claude sean "helpfull" y seguros.

**Dunning-Kruger Effect (Efecto Dunning-Kruger)**
Sesgo cognitivo donde personas con baja competencia sobreestiman sus habilidades. Con IA agéntica, se amplifica: un junior que genera código rápidamente cree que lo "entiende" cuando solo puede leerlo. Aalto University (2024) encontró un "Reverse Dunning-Kruger" donde mayor AI literacy correlaciona con *más* sobreconfianza, no menos. Ver Cap. 4.

---

## E

**Embedding**
Representación numérica de texto, código o datos que captura su significado semántico. Los embeddings permiten buscar código "por significado" en lugar de por coincidencia textual. Son la base técnica de RAG y búsqueda semántica en repositorios.

**Escalamiento (Scaling)**
Proceso de expandir el uso de IA agéntica de pilotos iniciales a adopción organizacional. El framework Crawl/Walk/Run (Cap. 10) proporciona una hoja de ruta de 18 meses para este proceso. El escalamiento prematuro es uno de los 5 errores más comunes documentados.

---

## F

**Fine-tuning**
Proceso de ajustar un modelo de IA pre-entrenado con datos específicos de un dominio para mejorar su rendimiento en tareas particulares. Permite que un modelo genérico aprenda los patrones, convenciones y lenguaje específico de una organización. El costo y complejidad varían significativamente según el proveedor.

**Framework de Orquestación**
Software que permite coordinar múltiples modelos de IA, herramientas y flujos de trabajo. Ejemplos: LangChain, LangGraph, AutoGen, CrewAI. Son el equivalente a un "sistema operativo" para agentes de IA.

---

## G

**GDPR (General Data Protection Regulation)**
Reglamento europeo de protección de datos personales. Impone restricciones sobre cómo los sistemas de IA pueden procesar datos personales, incluyendo el derecho a explicación de decisiones automatizadas y limitaciones en el uso de datos para entrenamiento de modelos.

**Generative AI (IA Generativa)**
Categoría de IA capaz de crear nuevo contenido (texto, código, imágenes) en lugar de solo analizar o clasificar datos existentes. Los LLMs son la tecnología base de la IA generativa aplicada a desarrollo de software.

**GitGuardian**
Herramienta de seguridad que detecta secretos (credenciales, API keys, tokens) expuestos en repositorios de código. Especialmente relevante cuando agentes de IA generan código que puede incluir inadvertidamente información sensible en commits.

**Gobernanza de IA**
Marco de políticas, procesos y controles que rigen el uso responsable de sistemas de IA en una organización. Incluye definición de roles, niveles de autonomía permitidos, auditoría de resultados y cumplimiento regulatorio. El Cap. 11 presenta un modelo de gobernanza en tres niveles (estratégico, táctico, operativo).

**Grounding (Anclaje)**
Técnica para reducir alucinaciones "anclando" las respuestas de IA a fuentes externas verificables. RAG es la implementación más común. Stanford (2024) encontró que RAG + RLHF + guardrails reduce alucinaciones hasta 96%. Sin embargo, grounding es "necesario pero no suficiente"; no puede imponer veracidad arquitectónicamente.

**Guardrail (Barrera de Seguridad)**
Restricción o límite diseñado para mantener el comportamiento de un agente de IA dentro de parámetros seguros y aceptables. Incluye validaciones de entrada/salida, filtros de contenido, límites de autonomía, y controles de acceso a herramientas y datos. Es el equivalente en IA de las "barandillas" en una carretera: permiten avanzar rápido pero previenen salidas peligrosas. Son fundamentales en cualquier implementación agéntica (Cap. 11).

**GGUF (GPT-Generated Unified Format)**
Formato de archivo estándar para modelos quantizados, optimizado para CPU y Apple Silicon. Usado con llama.cpp para despliegue local. Variantes como Q4_K_M y Q5_K_M ofrecen buen balance entre tamaño y calidad. Para líderes: permite correr modelos potentes en hardware de consumidor.

---

## H

**HaluEval / HalluLens**
Puntos de referencia para medir tendencia a alucinar de modelos de IA. HaluEval (2023) contiene 10,000-35,000 ejemplos para detectar alucinación semántica. HalluLens (2025) es más reciente con tareas de LongWiki, PreciseQA y Nonsense. Útiles para evaluar modelos antes de adopción, pero ningún punto de referencia captura todos los tipos de alucinación.

**Human-in-the-loop (HITL)**
Modelo de operación donde un humano supervisa y aprueba las decisiones críticas de un sistema de IA antes de que se ejecuten. Es el enfoque recomendado para organizaciones en niveles iniciales de madurez (0-3). El nivel de supervisión debe calibrarse según el riesgo de la tarea.

---

## I

**IDE (Integrated Development Environment)**
Entorno de desarrollo integrado donde los programadores escriben, prueban y depuran código. La nueva generación de IDEs (Cursor, Windsurf) integra agentes de IA como componente central, no como extensión adicional.

**Infrastructure as Code (IaC)**
Práctica de definir y gestionar infraestructura tecnológica mediante archivos de configuración en lugar de procesos manuales. Los agentes de IA pueden generar y mantener configuraciones de IaC, reduciendo errores de infraestructura.

**Integration Tax (Impuesto de Integración)**
Costo oculto de incorporar código generado por IA a un codebase existente. Incluye: tiempo de review (2-4 horas por PR complejo), refactoring para alinear con patrones del proyecto (30-50% del tiempo de generación), mantenimiento futuro de código no comprendido, y deuda técnica acumulada. El Integration Tax es más alto en proyectos brownfield (legacy) que greenfield (nuevos). Fórmula: ROI Neto = ROI Bruto × (1 - Integration Tax %). Ver Cap. 8.

---

## K

**Kill Switch**
Mecanismo automático de detención de agentes de IA cuando se detectan anomalías o comportamientos fuera de parámetros esperados. Incluye criterios como: consumo excesivo de tokens, cambios en archivos sensibles, acceso a sistemas no autorizados, o loops infinitos. Es un componente esencial de cualquier framework de gobernanza.

---

## L

**LangChain**
Framework de código abierto para construir aplicaciones basadas en modelos de lenguaje. Proporciona abstracciones para conectar LLMs con fuentes de datos, herramientas externas y flujos de trabajo. LangGraph es su extensión para orquestación de agentes con grafos de estado.

**LLM (Large Language Model)**
Modelo de lenguaje de gran escala, entrenado con enormes cantidades de texto, capaz de generar y entender lenguaje natural y código. Ejemplos: GPT-4, Claude, Gemini, Llama. Son el "cerebro" detrás de los agentes de IA. La selección del modelo impacta directamente en costo, calidad y latencia.

---

## M

**MCP (Model Context Protocol)**
Protocolo estándar para conectar modelos de IA con fuentes de datos y herramientas externas. Desarrollado por Anthropic, permite que agentes accedan a bases de datos, APIs y sistemas empresariales de forma estandarizada. Análogo a lo que USB hizo para conectar dispositivos.

**Model Poisoning (Envenenamiento de Modelo)**
Ataque donde se contaminan los datos de entrenamiento de un modelo de IA para que produzca resultados maliciosos. En el contexto de desarrollo, puede resultar en agentes que introducen vulnerabilidades de seguridad de forma sutil e intencional.

**Mixture of Experts (MoE)**
Arquitectura donde el modelo tiene múltiples "expertos" especializados, pero solo activa los relevantes para cada token. Permite modelos con más parámetros totales sin el costo proporcional de compute. DeepSeek-V3 tiene 671B parámetros pero solo usa 37B por consulta (5.5%). En 2026, los 10 modelos *open source* más capaces usan MoE.

**Multi-agente (Multi-agent System)**
Arquitectura donde múltiples agentes de IA con roles especializados colaboran para resolver tareas complejas. Cada agente puede tener capacidades y herramientas diferentes. Ejemplos: un agente escribe código, otro lo revisa, otro escribe tests. Requiere un orquestador para coordinar la colaboración.

---

## N

**NIST AI RMF (AI Risk Management Framework)**
Marco del National Institute of Standards and Technology de EE.UU. para gestionar riesgos de IA. Proporciona un enfoque estructurado para identificar, evaluar y mitigar riesgos en sistemas de IA. Es el estándar de referencia para organizaciones en Estados Unidos.

---

## O

**Onboarding Acelerado**
Proceso de integración de nuevos desarrolladores a un equipo, significativamente acelerado por agentes de IA que pueden explicar código existente, generar documentación contextual y guiar al nuevo miembro por la arquitectura del proyecto. Organizaciones reportan reducciones del 50-70% en tiempo de onboarding.

**OOP (Object-Oriented Programming)**
Paradigma de programación basado en la organización del código en "objetos" que combinan datos y comportamiento. Fue el paradigma dominante desde los años 90. La IA agéntica representa una transición hacia un paradigma donde la intención (qué construir) importa más que la estructura (cómo organizarlo).

**OpenHands (anteriormente OpenDevin)**
Plataforma de código abierto para agentes de desarrollo de software. Permite crear agentes que pueden modificar código, ejecutar comandos y navegar la web. Es la alternativa *open source* más notable a Devin.

**Orquestador**
Componente o agente que coordina las acciones de otros agentes, distribuyendo tareas, resolviendo conflictos y combinando resultados. En sistemas multi-agente, el orquestador determina qué agente trabaja en qué tarea y en qué orden.

**OWASP Top 10 for LLM Applications**
Lista de las 10 vulnerabilidades más críticas en aplicaciones basadas en modelos de lenguaje, publicada por la Open Web Application Security Project. Incluye prompt injection, data leakage, insecure output handling y supply chain vulnerabilities. Es lectura obligatoria para equipos de seguridad.

---

## P

**Pair Programming con IA**
Práctica donde un desarrollador trabaja en colaboración con un agente de IA, combinando la creatividad y juicio humano con la velocidad y conocimiento enciclopédico de la IA. Evolución del pair programming tradicional entre dos humanos.

**Paradoja de Jevons (en Código)**
Principio económico (William Stanley Jevons, 1865) que establece que aumentos en eficiencia frecuentemente llevan a mayor consumo total, no menor. Aplicado a IA agéntica: si generas código 10x más rápido, produces 10x más código, que requiere 10x más mantenimiento. El ahorro de tiempo se reinvierte en generar más, no en reducir trabajo total. Métrica de control: "líneas generadas vs. líneas en producción a 6 meses". Organizaciones maduras reportan que solo 30-50% del código generado sobrevive sin modificaciones mayores. Ver Cap. 8.

**Parámetros (de Modelos)**
Valores numéricos que un modelo aprende durante entrenamiento: los "conocimientos" codificados. Un modelo de 7B tiene 7 mil millones de números ajustables. Más parámetros generalmente = más capacidad pero más costo. Un modelo 7B requiere ~14GB de memoria; uno de 70B requiere ~140GB. Ver Cap. 07 para explicación simple.

**PR Cycle Time (Tiempo de Ciclo de Pull Request)**
Tiempo transcurrido desde que se crea un Pull Request hasta que se fusiona al código principal. Es una métrica clave de productividad. Organizaciones con IA agéntica reportan reducciones del 30-50% en PR cycle time gracias a revisiones automatizadas y generación de tests.

**Prompt**
Instrucción o consulta que se da a un modelo de IA para guiar su respuesta. La calidad del prompt determina directamente la calidad del resultado. En el contexto agéntico, los prompts pueden ser complejos, incluyendo contexto, restricciones, ejemplos y formato de salida esperado.

**Prompt Engineering**
Disciplina de diseñar instrucciones efectivas para modelos de IA. Va más allá de "hacer buenas preguntas" e incluye técnicas como few-shot learning, chain-of-thought y role-based prompting. Es una habilidad crítica para todos los niveles de seniority en equipos que adoptan IA.

**Prompt Injection**
Ataque de seguridad donde un usuario malicioso manipula el prompt de un sistema de IA para que ejecute acciones no autorizadas. Según la taxonomía de Carnegie Mellon, el 32% de las vulnerabilidades en código generado por IA están relacionadas con injection. Es el riesgo de seguridad #1 en el OWASP Top 10 for LLM.

---

## Q

**Quantización (Quantization)**
Técnica para reducir el tamaño de modelos comprimiendo la precisión numérica de sus parámetros (de 32-bit a 8 o 4 bits). Reduce memoria 50-75% con pérdida mínima de calidad (<5%). Formatos comunes: GPTQ y AWQ (para GPU), GGUF (para CPU/Mac). Permite correr modelos de 70B en hardware de consumidor. Ver Cap. 08.

---

## R

**RAG (Retrieval-Augmented Generation)**
Técnica que combina búsqueda de información en bases de datos con generación de texto, permitiendo a los modelos acceder a información actualizada y específica del dominio. Permite que un agente "sepa" sobre el código propietario de una organización sin necesidad de fine-tuning.

**Rework Rate (Tasa de Retrabajo)**
Porcentaje de código que debe ser reescrito o corregido después de su entrega inicial. Es una métrica reveladora del impacto real de IA: si el código generado requiere mucho retrabajo, el beneficio neto es menor al aparente.

**ROI (Return on Investment)**
Retorno de inversión, calculado como (Beneficios - Costos) / Costos x 100. En adopción de IA agéntica, el Cap. 10 documenta un ROI proyectado de 645% en 18 meses para implementaciones bien ejecutadas. Incluir costos ocultos (supervisión, retrabajo, capacitación) es crucial para un cálculo realista.

**RLHF (Reinforcement Learning from Human Feedback)**
Técnica de post-training donde humanos califican respuestas del modelo y el modelo aprende de esas preferencias. Es lo que hace que modelos como Claude sean "helpful" y seguros, en lugar de solo predecir texto. Costoso y complejo, pero esencial para modelos de producción. Ver también: DPO (alternativa más eficiente).

---

## S

**SAST (Static Application Security Testing)**
Análisis automático de código fuente para detectar vulnerabilidades de seguridad sin necesidad de ejecutar el programa. Herramientas como Snyk, SonarQube y Semgrep son esenciales cuando se incorpora código generado por IA, ya que los modelos pueden introducir patrones inseguros.

**SCA (Software Composition Analysis)**
Análisis de las dependencias y bibliotecas de terceros utilizadas en un proyecto para identificar vulnerabilidades conocidas y problemas de licenciamiento. Crítico cuando agentes de IA sugieren dependencias que pueden tener vulnerabilidades o licencias incompatibles.

**Self-hosted Models**
Modelos de IA desplegados en infraestructura propia de la organización (on-premise o nube privada). Ofrecen mayor control sobre datos y privacidad, pero requieren inversión significativa en infraestructura. Herramientas como Ollama y LM Studio facilitan el despliegue local.

**SOC 2 (Service Organization Control 2)**
Marco de compliance que evalúa los controles de seguridad, disponibilidad, integridad y confidencialidad de organizaciones de servicio. Las herramientas de IA utilizadas deben cumplir SOC 2 para ser aceptables en entornos enterprise con requisitos de compliance.

**SWE-Bench**
Punto de referencia estándar para medir la capacidad de agentes de IA en resolver issues reales de repositorios *open source*. Los resultados de SWE-Bench son el indicador más citado para comparar la efectividad de agentes de desarrollo. Los mejores agentes actuales resuelven ~50% de los issues del punto de referencia.

**Soberanía Intelectual**
Derecho y capacidad de una organización para comprender, modificar, explicar y evolucionar independientemente los sistemas que la hacen funcionar, independientemente de quién (o qué) escribió el código original. Diferente de "ownership legal" (propiedad del código): puedes tener ownership sin soberanía si nadie entiende lo que posees. Cuatro capacidades requeridas: (1) Entender cómo funciona, (2) Modificar sin asistencia externa, (3) Explicar decisiones a reguladores, (4) Evolucionar según necesidades cambiantes. Ver Cap. 11.

---

## T

**TCO (Total Cost of Ownership)**
Costo total de propiedad que incluye no solo licencias, sino también infraestructura, capacitación, tiempo de implementación, supervisión continua y costos de oportunidad. Es la métrica financiera correcta para evaluar adopción de IA (no solo el costo de la licencia mensual).

**Temperature (Temperatura)**
Parámetro de inferencia que controla la aleatoriedad de respuestas del modelo. Temperature 0 = respuestas deterministas; Temperature 1+ = más creativas pero con mayor riesgo de alucinación. Para código: usar 0.0-0.3. Para escritura creativa: 0.5-0.7. Nunca usar >0.8 para código en producción. Ver Cap. 08.

**Top-P (Nucleus Sampling)**
Parámetro de inferencia que limita los tokens considerados a aquellos cuya probabilidad acumulada suma P. Top-P=0.9 significa considerar solo el 90% más probable del vocabulario. Complementa a Temperature para controlar aleatoriedad. Para la mayoría de casos de código, valores 0.9-0.95 son apropiados.

**TruthfulQA**
Punto de referencia de 817 preguntas diseñadas para provocar respuestas incorrectas de modelos de IA, cubriendo 38 dominios (salud, finanzas, historia). Fue el estándar para medir factualidad, pero está ahora "saturado"; muchos modelos lo incluyen en entrenamiento, reduciendo su utilidad como punto de referencia independiente.

**Technical Debt (Deuda Técnica)**
Costo acumulado de decisiones técnicas subóptimas que facilitan entregas rápidas pero requieren corrección futura. La IA agéntica puede tanto reducir deuda técnica (refactoring automatizado) como incrementarla (código generado sin supervisión adecuada).

***time-to-market***
Tiempo desde la concepción de una idea hasta su disponibilidad en producción. Es una de las métricas donde la IA agéntica muestra mayor impacto: reducciones del 30-60% son comunes en organizaciones con adopción madura.

**Token**
Unidad básica de texto que procesan los modelos de lenguaje. Aproximadamente 4 caracteres en inglés equivalen a 1 token, algo más en español. Los costos de APIs se calculan por token consumido. Comprender tokens es necesario para estimar costos operativos de agentes.

**Tool Use / Function Calling**
Capacidad de los modelos de IA de invocar herramientas externas (APIs, bases de datos, navegadores, terminales) como parte de su procesamiento. Es lo que transforma a un modelo de lenguaje en un agente capaz de actuar en el mundo real. Sin tool use, un LLM solo puede generar texto.

---

## V

**Velocity (Velocidad de Entrega)**
Medida de la capacidad de un equipo para entregar funcionalidad en un período dado, típicamente medida en story points por sprint. La IA agéntica impacta velocity directamente: organizaciones maduras reportan incrementos del 40-80%, aunque con rendimientos decrecientes después de los primeros 6 meses.

**Vendor Lock-in**
Dependencia excesiva de un proveedor específico de tecnología que dificulta migrar a alternativas. En IA agéntica, es un riesgo real dado que los agentes se integran profundamente con los flujos de trabajo. La estrategia recomendada es mantener abstracciones que permitan cambiar de proveedor.

---

## W

**Windsurf**
IDE con capacidades agénticas desarrollado por Codeium (anteriormente conocido como Codeium Editor). Compite con Cursor en el espacio de IDEs nativamente integrados con IA. Representa la tendencia de que el IDE del futuro será inherentemente agéntico.

---

## Nota para el Lector

Este glosario es una referencia viva. A medida que el ecosistema de IA agéntica evoluciona, nuevos términos emergen y otros se redefinen. Recomendamos consultar los recursos del Apéndice D para mantenerse actualizado con la terminología emergente.

Los términos marcados con contexto de "para líderes" buscan traducir conceptos técnicos en implicaciones de negocio, que es precisamente el puente que este libro busca construir.

---

*Términos referenciados a lo largo de los 16 capítulos de "Agéntico por Diseño, Tomo I". Última actualización: Febrero 2026.*
