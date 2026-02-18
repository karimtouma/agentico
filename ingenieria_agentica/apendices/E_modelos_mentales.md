# Apéndice E: Modelos Mentales Técnicos para Decisores

---

> **Sobre este apéndice**
>
> Este apéndice explica conceptos técnicos de IA sin código, usando analogías y modelos mentales. El objetivo es que puedas tomar mejores decisiones y hacer mejores preguntas a tu equipo técnico.
>
> No necesitas entender cómo funciona un motor de combustión para decidir qué auto comprar. Pero sí necesitas saber la diferencia entre gasolina y diesel, cuánto cuesta el mantenimiento, y qué preguntas hacerle al mecánico.

---

## E.1 Context Window = Presupuesto de Atención

### La Analogía

Imagina que estás hablando con un consultor muy inteligente pero con una limitación extraña: solo puede "recordar" las últimas N páginas de la conversación. Todo lo anterior desaparece de su memoria.

Eso es el **context window** de un modelo de lenguaje.

### Por Qué Importa para Decisiones

| Context window | Equivalencia aproximada | Qué puede analizar |
|---------------|------------------------|-------------------|
| 8K tokens | ~6 páginas | Un archivo de código mediano |
| 32K tokens | ~25 páginas | Varios archivos relacionados |
| 128K tokens | ~100 páginas | Un módulo completo o PR grande |
| 200K tokens | ~150 páginas | Secciones significativas de un codebase |
| 1M tokens | ~750 páginas | Casi cualquier proyecto completo |

**Implicación práctica:**

Si tu codebase promedio tiene 50,000 líneas de código, un modelo con 8K de context solo puede "ver" ~200 líneas a la vez. Esto significa:

- No puede entender la arquitectura completa
- No puede identificar dependencias entre archivos distantes
- Puede sugerir código que ya existe en otra parte

Un modelo con 200K de context puede ver ~8,000 líneas, suficiente para entender la mayoría de módulos.

### Pregunta para tu equipo técnico

> "Dado nuestro tamaño de codebase y complejidad de archivos, ¿qué context window necesitamos? ¿Estamos pagando por context que no usamos, o tenemos limitaciones por context insuficiente?"

### Red flag

Si tu equipo dice "no importa, cualquier modelo funciona," probablemente no han evaluado esto. El context window afecta directamente la calidad de las sugerencias para código complejo.

---

## E.2 RAG vs Fine-Tuning vs Prompting

### Las Tres Formas de "Enseñarle" a un Modelo

Cuando quieres que un modelo de IA "sepa" cosas específicas de tu empresa (tu codebase, tus estándares, tu documentación), hay tres enfoques:

**1. Prompting (Dile qué quieres)**

- **Qué es:** Le das instrucciones en texto antes de cada pregunta
- **Analogía:** Darle a alguien un resumen ejecutivo antes de cada reunión
- **Costo:** Casi gratis (parte del context window)
- **Velocidad:** Inmediato
- **Cuándo usar:** Siempre empezar aquí. Suficiente para el 80% de casos.

**2. RAG (Retrieval-Augmented Generation)**

- **Qué es:** Le das acceso a una base de datos de documentos que busca automáticamente
- **Analogía:** Darle a alguien acceso a tu wiki/Confluence/documentación
- **Costo:** Medio ($500-5,000/mes para infraestructura)
- **Velocidad:** Días a semanas de setup
- **Cuándo usar:** Cuando tienes mucha documentación específica que cambia frecuentemente

**3. Fine-Tuning (Entrénalo con tus datos)**

- **Qué es:** Modificas los "pesos" internos del modelo con ejemplos de tu empresa
- **Analogía:** Mandar a alguien a un curso de 6 meses sobre tu industria
- **Costo:** Alto ($10,000-100,000+ en compute y expertise)
- **Velocidad:** Semanas a meses
- **Cuándo usar:** Casi nunca para la mayoría de empresas

### Por Qué Fine-Tuning Casi Nunca Es la Respuesta

| Problema | Fine-tuning resuelve? | Mejor alternativa |
|----------|----------------------|-------------------|
| "El modelo no conoce nuestro código" | No | RAG con tu codebase |
| "El modelo no sigue nuestros estándares" | Parcialmente | Prompting con guidelines |
| "El modelo no sabe de nuestra industria" | Parcialmente | RAG con documentación |
| "Necesitamos respuestas más rápidas" | No | Modelo más pequeño |
| "Queremos respuestas en español técnico" | Sí | Fine-tuning puede ayudar aquí |

**Regla general:** Si alguien te propone fine-tuning como primera opción, pregunta por qué prompting + RAG no funciona. El 95% de las veces no tienen una buena respuesta.

### Pregunta para tu equipo técnico

> "¿Por qué necesitamos fine-tuning en lugar de un buen prompt engineering o RAG? ¿Cuál es el ROI estimado de fine-tuning vs. las alternativas?"

### Red flag

Si un vendor o consultor te propone fine-tuning sin haber intentado prompting primero, probablemente está vendiendo servicios, no resolviendo problemas.

---

## E.3 Alucinaciones: El Modelo Miente Con Confianza

### Qué Son

Una "alucinación" es cuando un modelo de lenguaje genera una respuesta que suena correcta, está gramaticalmente perfecta, y es completamente falsa.

**Ejemplo real de alucinación en código:**

Un modelo sugiere usar la función `database.quickSync()` que no existe en ninguna librería. Si el developer la acepta sin verificar, el código no compilará. Si el developer "arregla" el error inventando una implementación basada en el nombre, puede crear bugs sutiles.

### Por Qué Ocurren

Los modelos de lenguaje no "saben" cosas. Predicen la siguiente palabra más probable basándose en patrones estadísticos. No tienen acceso a una base de datos de "hechos verdaderos."

Cuando les preguntas algo que no "conocen" bien, hacen lo mismo que harías tú si te obligaran a responder una pregunta de examen sin saber la respuesta: inventan algo que suena plausible.

### Tasas de Alucinación en Código

| Tipo de tarea | Tasa de alucinación estimada |
|--------------|------------------------------|
| Código trivial (loops, CRUD) | 5-10% |
| APIs de librerías comunes | 15-25% |
| APIs de librerías menos conocidas | 30-50% |
| Configuración de herramientas | 25-40% |
| Código que requiere contexto de negocio | 40-60% |

### Cómo Mitigar

| Mitigación | Efectividad | Costo |
|------------|-------------|-------|
| Code review obligatorio | Alta | Tiempo de seniors |
| Tests automatizados | Alta | Inversión inicial |
| Verificación de imports/APIs | Media | Tooling |
| Prompts que dicen "si no sabes, di 'no sé'" | Baja | Casi gratis |

### Pregunta para tu equipo técnico

> "¿Cuál es nuestra tasa de rechazo de sugerencias de IA en code review? ¿Estamos rastreando cuántas sugerencias aceptadas generan bugs posteriormente?"

### Red flag

Si nadie está midiendo la tasa de alucinaciones, estás asumiendo que el modelo es confiable sin evidencia. Los modelos son útiles, no infalibles.

---

## E.4 Function Calling y Tool Use

### Qué Significa que un Modelo "Use Herramientas"

Los modelos de lenguaje originalmente solo podían generar texto. Los modelos modernos pueden:

1. Reconocer que necesitan información externa
2. Generar una "llamada" a una herramienta (API, base de datos, web)
3. Recibir el resultado
4. Continuar generando respuesta con esa información

**Ejemplo:** Le preguntas a un modelo "¿cuál es el precio actual de Bitcoin?" En lugar de inventar un número (alucinación), el modelo:
1. Reconoce que necesita datos en tiempo real
2. Llama a una API de precios
3. Recibe "$67,234"
4. Responde "El precio actual de Bitcoin es $67,234"

### Por Qué Importa para Agentes

Un "agente" de IA es básicamente un modelo con acceso a herramientas y la capacidad de decidir cuándo usarlas. Las herramientas pueden incluir:

- Ejecutar código
- Leer/escribir archivos
- Hacer búsquedas web
- Llamar APIs
- Interactuar con bases de datos

### Implicaciones de Seguridad

| Capacidad del agente | Riesgo potencial | Mitigación |
|---------------------|-----------------|-----------|
| Leer archivos | Exposición de datos sensibles | Limitar qué directorios puede acceder |
| Escribir archivos | Modificación de código/config | Sandboxing, approval de cambios |
| Ejecutar código | Ejecución arbitraria | Containers aislados, time limits |
| Llamar APIs externas | Filtración de datos, costos | Allowlist de APIs, rate limiting |
| Acceso a bases de datos | Modificación/borrado de datos | Read-only por defecto, audit logs |

### Pregunta para tu equipo técnico

> "¿Qué herramientas/accesos tiene nuestro agente de IA? ¿Tenemos audit logs de qué hace? ¿Qué pasa si el agente decide hacer algo inesperado?"

### Red flag

Si un agente tiene acceso de escritura a producción sin human-in-the-loop, tienes un riesgo sistémico. No es cuestión de "si" algo saldrá mal, sino "cuándo."

---

## E.5 Preguntas Que Todo Gerente Debe Saber Hacer

### Preguntas sobre Costos

1. **"¿Cuál es el costo por token y cuántos tokens usamos por día?"**
   - Por qué importa: Los costos de IA pueden escalar sin aviso. $0.01 por request × 10,000 requests/día = $100/día = $3,000/mes.

2. **"¿Estamos usando el modelo correcto para cada tarea?"**
   - Por qué importa: Usar o1 para tareas que GPT-4o-mini puede hacer cuesta ~100x más sin beneficio proporcional.

3. **"¿Qué pasa con nuestros costos si duplicamos el uso?"**
   - Por qué importa: Algunos modelos tienen pricing no lineal. Verifica antes de escalar.

### Preguntas sobre Calidad

4. **"¿Cuál es nuestra tasa de aceptación de sugerencias de IA?"**
   - Punto de referencia: 30-40% es típico. <20% indica que las sugerencias no son útiles. >60% puede indicar aceptación sin revisión.

5. **"¿Cuántos bugs en producción vienen de código generado por IA?"**
   - Por qué importa: Si no lo estás midiendo, no sabes si la IA está ayudando o causando problemas.

6. **"¿El equipo puede explicar qué hace el código que 'escribieron'?"**
   - Por qué importa: Código que nadie entiende es deuda técnica garantizada.

### Preguntas sobre Riesgos

7. **"¿Qué pasa cuando el servicio de IA está caído?"**
   - Por qué importa: Si la respuesta es "el equipo deja de trabajar," tienes un problema de resiliencia.

8. **"¿Cómo verificamos que el código generado es seguro?"**
   - Por qué importa: 48% del código generado por IA contiene vulnerabilidades (Snyk, 2024).

9. **"¿Qué datos nuestros estamos enviando al proveedor de IA?"**
   - Por qué importa: Código, prompts y contexto pueden contener IP, secretos o datos regulados.

### Preguntas sobre Adopción

10. **"¿Los seniors están usando la herramienta o solo los juniors?"**
    - Por qué importa: Si solo los juniors usan IA, puede significar que los seniors no la encuentran útil o que no confían en ella.

11. **"¿Cuánto tiempo de code review estamos gastando en código generado por IA?"**
    - Por qué importa: Si el tiempo de review aumentó 50%, parte de la productividad ganada se perdió en supervisión.

12. **"¿Hemos medido baseline antes de adoptar?"**
    - Por qué importa: Sin baseline, no puedes probar que la IA ayuda. "Se siente más rápido" no es una métrica.

---

## E.6 Glosario Rápido de Términos que Escucharás

| Término | Traducción para decisores |
|---------|--------------------------|
| **Token** | Unidad de texto (~3/4 de palabra). Determina costos y límites. |
| **Context window** | Cuánto puede "recordar" el modelo en una conversación. |
| **Prompt** | Las instrucciones que le das al modelo. |
| **RAG** | Técnica para que el modelo busque información en tus documentos. |
| **Fine-tuning** | Entrenamiento personalizado del modelo (caro, rara vez necesario). |
| **Alucinación** | Cuando el modelo inventa información falsa con confianza. |
| **Temperature** | Qué tan "creativo" vs "predecible" es el modelo (0 = robótico, 1 = creativo). |
| **Function calling** | Capacidad del modelo de usar herramientas externas. |
| **Agent** | Modelo con acceso a herramientas y capacidad de tomar decisiones. |
| **Embedding** | Representación numérica de texto para búsquedas semánticas. |
| **Inference** | Ejecutar el modelo para obtener una respuesta (lo que cuesta dinero). |
| **Latency** | Tiempo entre tu pregunta y la respuesta del modelo. |

---

## E.7 Cuándo Escalar al Equipo Técnico

### Situaciones donde DEBES involucrar a tu equipo técnico

- Decisiones sobre qué modelo/herramienta adoptar
- Configuración de accesos y permisos de agentes
- Cualquier cosa que toque datos de clientes o producción
- Evaluación de claims de vendors ("50% más productivo")
- Incidentes de seguridad relacionados con IA

### Situaciones donde puedes decidir sin consultar

- Aprobación de presupuesto para piloto (una vez que el equipo lo propone)
- Comunicación a partes interesadas sobre iniciativa de IA
- Definición de métricas de éxito de negocio (no técnicas)
- Decisiones de timeline y priorización

> **Regla general:** Si la decisión involucra "cómo funciona," consulta al equipo técnico. Si involucra "por qué lo hacemos" o "cuánto invertimos," es tu territorio.
