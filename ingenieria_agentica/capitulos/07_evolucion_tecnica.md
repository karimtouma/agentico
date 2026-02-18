# La Evolución Técnica Hacia la IA Agéntica en Ingeniería

> **Resumen Ejecutivo**
>
> - La IA para código evolucionó en 3 olas desde 2018: Asistente desconectado → Integrado al IDE → Agente autónomo
> - **Ola 1 (2018-2020)**: Copy-paste a ChatGPT. Productividad +10-20%
> - **Ola 2 (2021-2023)**: Copilot integrado. Productividad +30-55%
> - **Ola 3 (2023-presente)**: Agentes autónomos (Devin, Cursor Composer). Productividad +100-200%
> - Cada ola multiplicó las capacidades pero introdujo nuevos desafíos de seguridad, costo y confianza
> - Para 2026, Gartner predice que 60% de desarrollo nuevo usará agentes autónomos

---

## Introducción: Por Qué la Historia Importa

Si eres CTO o VP de Ingeniería, probablemente estás recibiendo presiones:

- Tu CEO pregunta: "¿Por qué no estamos usando IA para codificar más rápido?"
- Tu CFO pregunta: "¿GitHub Copilot vale los $20/usuario/mes?"
- Tu equipo pregunta: "¿Podemos probar Cursor/Devin?"

Para tomar decisiones informadas, necesitas entender **de dónde venimos, dónde estamos, y hacia dónde vamos**.

Este capítulo te da esa perspectiva histórica reciente (2018-2025) para que entiendas:

1. Qué herramienta es apropiada para qué etapa de adopción
2. Qué esperar de cada generación de tecnología
3. Cómo planificar tu hoja de ruta de adopción de IA en ingeniería

**Spoiler:** No todas las organizaciones deberían saltar directo a agentes autónomos (Ola 3). Muchas deberían consolidar primero Ola 2 (Copilot). Pero TODAS deberían tener una estrategia clara de cómo progresar.

> **Contexto LATAM**
>
> En América Latina, la realidad de infraestructura agrega una variable: la latencia a los servidores de OpenAI/Anthropic puede afectar la experiencia del desarrollador, y las herramientas self-hosted requieren cloud local que aún es 20-40% más cara que en US-East. Sin embargo, la ventaja de LATAM es que la mayoría de las empresas tecnológicas ya operan en cloud (AWS São Paulo, Azure Brasil, GCP Santiago), lo que elimina la barrera de adopción de Ola 2 (Copilot integrado al IDE). La decisión práctica: para equipos de <200 personas, SaaS puro es suficiente y más económico. Self-hosting solo se justifica a escala enterprise con requerimientos de soberanía de datos, algo cada vez más relevante conforme avanzan las regulaciones de protección de datos en Brasil (LGPD), México (LFPDPPP), y Colombia (Ley 1581).

---

## Mapa Conceptual: La Evolución de IA en Desarrollo de Software

Antes de entrar en las 3 olas, es útil situar dónde está tu organización en el mapa de evolución completo:

**Tabla 7.1. Progresión de IA generativa a sistemas multi-agente**

| Etapa | Período | Qué Hace | Herramientas Representativas | Autonomía | Adopción 2025 |
|-------|---------|----------|------------------------------|-----------|:-------------:|
| **IA Generativa Base** | 2018-2020 | Genera texto/código aislado, fuera del flujo de trabajo | GPT-2, GPT-3, CodeBERT | Nula (copy-paste) | ~15% (declinando) |
| **Copilots** | 2021-2023 | Autocompleta en el IDE, integrado en flujo | GitHub Copilot, Tabnine, CodeWhisperer | Baja (sugiere, tú aceptas) | ~65% |
| **Agentes** | 2023-2025 | Ejecuta tareas multi-paso autónomamente | Cursor Composer, Claude Code, Devin | Media (ejecuta, tú supervisas) | ~20% (creciendo) |
| **Multi-Agente** | 2025+ | Equipos de agentes coordinados para proyectos complejos | OpenHands, CrewAI, frameworks MAS | Alta (coordinación autónoma) | <5% (emergente) |

> **Para Tu Próxima Reunión de Liderazgo**
>
> Usa este mapa para situar a tu organización: **la mayoría de empresas en 2026 están entre "Copilots" y "Agentes"**. Si tu equipo aún no ha consolidado Copilots (Ola 2), no saltes directamente a Agentes (Ola 3). Consolida primero. Si ya tienes Copilots maduros, el siguiente paso es pilotar agentes en tareas controladas.
>
> El salto a "Multi-Agente" requiere governance madura (ver Capítulo 13) y equipos preparados para supervisar sistemas autónomos (ver Capítulo 11).

---

## El Marco de Referencia: Las 3 Olas de IA para Código

Ahora sí, el framework detallado:

**Tabla 7.2. Las 3 olas de IA para desarrollo de software**

| Dimensión | Ola 1: Asistente Desconectado | Ola 2: Integrado al IDE | Ola 3: Agente Autónomo |
|-----------|-------------------------------|-------------------------|------------------------|
| **Período** | 2018-2020 | 2021-2023 | 2023-presente |
| **Herramientas representativas** | ChatGPT, GPT-3 Playground | GitHub Copilot, Tabnine, CodeWhisperer | Devin, Cursor Composer, GitHub Copilot Workspace |
| **Paradigma de uso** | Copy-paste fuera del IDE | Autocomplete dentro del IDE | "Dale el objetivo, el agente ejecuta" |
| **Alcance de generación** | Snippets (5-20 líneas) | Funciones completas (20-100 líneas) | Features completas (múltiples archivos, 100-1000 líneas) |
| **Autonomía** | Cero: requiere copy-paste manual | Baja: sugiere, tú aceptas línea por línea | Alta: ejecuta múltiples pasos solo |
| **Contexto** | Solo lo que le pastes | Archivo actual + algunos imports | Codebase completo + docs + APIs |
| **Capacidad de acción** | Solo genera texto | Genera código en IDE | Ejecuta comandos, crea archivos, corre tests |
| **Ganancia de productividad** | +10-20% | +30-55% | +100-200% (datos preliminares) |
| **Costo típico** | Gratis - $20/mes | $10-20/usuario/mes | $20-100/usuario/mes |
| **Curva de aprendizaje** | Baja (2-3 días) | Media (2-3 semanas) | Alta (4-8 semanas) |
| **Adopción empresarial 2025** | ~15% (declinando) | ~65% | ~20% (creciendo rápido) |

> **Dato verificado:**
>
> - **Fuente:** Gartner, "Predicts 2025: Software Engineering" (Oct 2024); GitHub Octoverse 2024; Stack Overflow Developer Survey 2024 (90,000+ respondents)
> - **Qué mide:** Las cifras de adopción (~65% Copilots, ~20% Agentes) son triangulación de: encuesta Octoverse (77% de developers usan IA en alguna forma), filtrado por tipo de herramienta. La predicción de 60% de desarrollo con agentes es proyección Gartner a 2026
> - **Limitación:** Las cifras de productividad (+30-55% en Ola 2, +100-200% en Ola 3) provienen de estudios de vendors (GitHub, Google) con posible sesgo de selección. Estudios independientes como Uplevel (2024) encontraron resultados más modestos (+10-15% en code throughput). Las ganancias de Ola 3 son datos preliminares de early adopters, no representativos del mercado general
> - **Implicación:** Usa las cifras de productividad como rangos indicativos, no como promesas. Tu organización puede estar en cualquier punto del rango dependiendo de madurez técnica, tipo de código, y calidad de adopción

---

## Ola 1: IA Como Asistente Desconectado (2018-2020)

### El Contexto Histórico

En 2018, OpenAI lanzó [GPT-2]{.idx data-sub="modelos de lenguaje"}. En 2020, [GPT-3]{.idx data-sub="modelos de lenguaje"}. Estos modelos podían generar código sorprendentemente bueno si les dabas el prompt correcto.

**El flujo de trabajo típico:**

1. **Desarrollador** tiene un bug o necesita implementar función
2. **Abre ChatGPT** o GPT-3 Playground en una pestaña separada
3. **Copia y pega** el código problemático o escribe descripción de lo que quiere
4. **GPT genera** una solución
5. **Desarrollador revisa**, ajusta, copia de vuelta al IDE
6. **Prueba** si funciona. Si no, repite el ciclo.

**Ejemplo real de 2020:**

1. **Desarrollador en VS Code:** Tiene una función vacía que necesita implementar
2. **Copia el código a ChatGPT** y pregunta: *"Implementa esta función para calcular 16% de IVA"*
3. **ChatGPT responde** con la implementación completa
4. **Desarrollador copia de vuelta** a VS Code

**Total:** ~2-3 minutos de friction por cada interacción.

### Qué Funcionaba Bien

**Casos de uso donde era útil:**

- Aprender nueva sintaxis ("¿Cómo itero sobre un array en Python?")
- Generar código boilerplate (getters/setters, constructores)
- Debugging ("¿Por qué este código da error X?")
- Entender código legacy ("¿Qué hace esta función compleja?")

**Ventajas:**

- Gratis o muy barato
- Cero setup (solo abre navegador)
- Educacional (aprendes mientras usas)

### Limitaciones Críticas

**Problema 1: Friction brutal**

- 5-10 segundos para cambiar de ventana
- Copy-paste introduce errores (indentación, caracteres especiales)
- Pierdes [context switching]{.idx} tiempo

**Problema 2: Sin contexto del proyecto**

- La IA no conoce tu codebase
- No sabe qué librerías usas
- No entiende tus convenciones de código

**Problema 3: No actionable directamente**

- Genera texto, no código ejecutable en tu proyecto
- Tú tienes que integrarlo manualmente

### Adopción Empresarial

**Datos de 2020:**

- Stack Overflow Survey: ~12% de developers usaban IA para ayuda con código
- Uso principalmente individual, no organizacional
- Sin herramientas enterprise (no había GitHub Copilot todavía)

**Empresas early adopters (2019-2020):**

- Startups tech-forward
- Equipos de research en grandes empresas
- Developers individuales experimentando

**Por qué NO era estratégico para organizaciones:**

- Ganancias de productividad modestas (+10-20%)
- No escalaba (cada developer usándolo de manera ad-hoc)
- Sin métricas de ROI

### La Transición a Ola 2: ¿Qué Cambió?

**La perspectiva clave:** "¿Y si la IA estuviera DENTRO del IDE, no fuera?"

Esto llevó a GitHub Copilot (lanzado en 2021).

---

## Ola 2: IA Integrada al IDE (2021-2023)

### El Lanzamiento de GitHub Copilot (Junio 2021)

[GitHub]{.idx} anunció [Copilot]{.idx data-sub="GitHub Copilot"}: "Your AI pair programmer".

**La promesa:**

- Autocompleta código mientras escribes
- Entiende el contexto del archivo actual
- Sugiere funciones completas basado en comentarios
- Integrado nativamente en VS Code, JetBrains, Neovim

**Demo famosa que viralizó Copilot:**

El desarrollador escribía un comentario describiendo lo que necesitaba, "función para extraer todos los enlaces de una página web", y Copilot generaba automáticamente las 8-10 líneas de código necesarias para hacerlo: conectarse a la página, analizarla, y devolver la lista de enlaces. Todo en segundos, sin que el desarrollador escribiera una sola línea de lógica. La demostración se volvió viral porque mostraba algo que parecía ciencia ficción: describir una intención en lenguaje natural y obtener código funcional al instante.

**Reacción de la industria:**

- Asombro: "Esto es magia"
- Escepticismo: "¿Funciona en código real?"
- Miedo: "¿Esto reemplazará a developers?"

### La Explosión de Competidores (2021-2023)

Copilot validó el mercado. Inmediatamente surgieron competidores:

**GitHub Copilot (Microsoft/OpenAI)**

- Líder de mercado
- Basado inicialmente en Codex (2021), migrado a modelos GPT-4 en 2023
- 20M usuarios en 2025

**Amazon CodeWhisperer (AWS)** *(renombrado a Amazon Q Developer en 2024)*

- Lanzado 2022
- Integrado con AWS ecosystem
- Gratis para uso individual (Free tier) / $19/mes (Pro)

**Tabnine**

- Lanzado antes que Copilot (2018) pero mejorado significativamente en 2021
- Enfoque en privacy (modelos [self-hosted]{.idx data-sub="deployment"} disponibles)
- Popular en enterprises preocupadas por seguridad

**Replit Ghostwriter**

- Integrado en Replit IDE (cloud-based)
- Orientado a educación y prototipos rápidos

**Codeium**

- Alternativa gratuita a Copilot
- Funciona en 70+ lenguajes

**Tabla 7.3. Comparativa de herramientas de Ola 2 (copilots)**

| Herramienta | Modelo Base | Precio | Fortaleza | Debilidad |
|-------------|-------------|--------|-----------|-----------|
| GitHub Copilot | GPT-4o | Gratis-$39/mes | Mejor calidad de código, mayor adopción | Premium requests limitados en tiers bajos |
| Amazon Q Developer | Propio (Amazon) | Gratis-$19/mes | Integración con AWS, gratis para individuos | Ecosistema más limitado |
| Tabnine | Propio | $39-59/mes (Enterprise) | Self-hosted option, privacy | Solo plan Enterprise (eliminó tier gratuito en 2025) |
| Windsurf (ex-Codeium) | Propio + Claude/GPT | $15-60/mes | Precio accesible, buena integración | Créditos limitados en tier Pro |

### Cómo Funcionaba la Ola 2: El Paradigma "Autocomplete++"

**Diferencias clave vs. Ola 1:**

**Input:**

- Ola 1: Tú explícitamente pides ayuda ("Genera función X")
- Ola 2: La IA observa lo que escribes y sugiere proactivamente

**Contexto:**

- Ola 1: Solo lo que copies y pegues
- Ola 2: Archivo actual + algunos archivos importados + comments en el código

**Output:**

- Ola 1: Texto en otra ventana
- Ola 2: Código sugerido directamente en tu cursor (presiona Tab para aceptar)

**Ejemplo de flujo:**

Imagina que un desarrollador define la estructura de un "Usuario" con tres campos (identificador, nombre, correo electrónico) y comienza a escribir una función llamada "validar usuario". Copilot, al observar el contexto, sugiere automáticamente la lógica completa de validación: verificar que ningún campo esté vacío y que el correo electrónico tenga formato válido. El desarrollador ve la sugerencia en texto gris dentro del editor, presiona una sola tecla (Tab) para aceptarla, y en 2 segundos tiene una función completa que habría tomado 3-5 minutos escribir manualmente. Este es el paradigma "Autocomplete++": la IA no espera a que le preguntes, observa lo que haces y anticipa lo que necesitas.

### Datos de Productividad (2022-2024)

**Estudios peer-reviewed:**

**GitHub/Microsoft Research (2023):**[^ch7-1]

- 55% más rápido completar tareas con Copilot
- [Pull request]{.idx data-sub="métricas de productividad"} cycle time: 9.6 días → 2.4 días (-75%)
- Desarrolladores reportan "more fulfilled" (menos tiempo en boilerplate)

**Ponicode Study (2023):**

- Desarrolladores completan 126% más proyectos por semana con AI assistants
- Pero: código clonado (copy-paste) aumenta 4x

**Axios Survey (2024):**

- 46% de todo el código en GitHub es generado por [IA generativa]{.idx}
- En lenguajes como Java: 61%

**Implicaciones para líderes:**

✅ **Los beneficios son reales y medibles**

- 30-55% ganancia en productividad para tasks rutinarias
- Especialmente efectivo en:
  - Tests unitarios
  - Boilerplate code
  - Data transformations
  - API integrations

⚠️ **Pero con caveats:**

- Aumenta [code cloning]{.idx data-sub="deuda técnica"} (deuda técnica)
- 48% del código generado tiene vulnerabilidades de seguridad
- Requiere 11 semanas de ramp-up para productividad completa

### Adopción Empresarial (2022-2024)

**Datos de Stack Overflow 2024:**

- 84% de developers profesionales usan AI coding tools
- 44% usan diariamente
- Top tool: GitHub Copilot (62%)

**Fortune 500 adoption (Estimados de Gartner 2024):**

- 35% han desplegado AI coding assistants a ≥50% de ingeniería
- 50% en pilotos
- 15% todavía evaluando o rechazando

**Razones para NO adoptar (consolidado de encuestas Gartner 2024 y Stack Overflow Developer Survey 2024):**

1. Preocupaciones de seguridad y secretos filtrados en código (~57% de encuestados, Gartner)
2. Preocupaciones de IP/licencias y resultados sesgados (~58%, Gartner)
3. Dificultad para demostrar ROI (~49%, Gartner)
4. Costo de mantener y corregir artefactos generados (>90% de CIOs citan gestión de costos como limitante)

### Caso de Estudio: Shopify Adopta GitHub Copilot (2023)

**Contexto:**

- 2,000+ engineers
- Codebase de ~10M líneas (Ruby, React, Go)

**Implementación:**

- Q1 2023: Piloto con 200 engineers voluntarios
- Q2 2023: Expande a 1,000 engineers
- Q3 2023: Despliega a todos los 2,000 engineers

**Resultados a 6 meses:**

- Velocity (story points/sprint): mejora significativa (reportada internamente, sin cifra pública auditada)
- PR review time: reducción notable (código más consistente con Copilot)
- Developer satisfaction: mejora alta ("menos tiempo en tareas repetitivas", Pragmatic Engineer, 2024)
- Security incidents: sin cambio significativo (con SAST automático)

**Costo:**

- Licencias: 2,000 × $20/mes × 12 = $480K/año
- Training y enablement: $200K one-time
- Total año 1: $680K

**Ahorro:**

- Shopify reportó que su asistente interno VaultBot resuelve ~32% de preguntas de ingeniería (Pragmatic Engineer, 2024)
- La inversión en AI coding tools fue una fracción del costo de contratar personal equivalente
- **ROI estimado**: significativamente positivo, aunque Shopify no ha publicado cifra auditada

**Lecciones aprendidas:**

1. Piloto es crítico - no despiegues a todos de golpe
2. Training matters - 3 semanas de ramp-up en promedio
3. SAST is non-negotiable - código AI-generado necesita security scanning
4. Code review standards deben evolucionar - enfocarse en lógica, no sintaxis

### Las Limitaciones de Ola 2 (Por Qué No Es Suficiente)

A pesar del éxito, Ola 2 tiene límites fundamentales:

**Limitación 1: Scope de un archivo**

- Copilot funciona archivo por archivo
- Dificulta refactors cross-file
- No puede "crear nueva feature completa end-to-end"

**Limitación 2: Pasivo, no proactivo**

- Tú escribes, IA sugiere
- No puede "tomar el control" y hacer 10 pasos autónomamente

**Limitación 3: Sin capacidad de ejecución**

- Genera código, pero no lo ejecuta
- No puede correr tests y autocorregirse
- No puede interactuar con terminal, APIs, etc.

**Ejemplo de lo que Ola 2 NO puede hacer:**

Tú: "Implementa autenticación de 2 factores en nuestra app"

**Lo que necesitas hacer manualmente:**

1. Instalar librería TOTP (`npm install speakeasy`)
2. Crear migración de DB para `twofa_secret` field
3. Modificar `/auth/login.ts` para setup flow
4. Modificar `/auth/verify.ts` para validation flow
5. Crear endpoints `/auth/2fa/setup` y `/auth/2fa/verify`
6. Actualizar frontend forms
7. Escribir tests para todo el flow
8. Ejecutar tests y debuggear errores
9. Actualizar documentación API

**Lo que Copilot hace:**

- Ayuda con pasos 3-7 (genera código cuando se lo pides)

**Lo que NO hace:**

- Pasos 1, 2, 8, 9 (instalación, migración, testing, docs)
- No puede ejecutar el flow end-to-end

**Esto es lo que motiva Ola 3.**

---

## Ola 3: Agentes Autónomos (2023-Presente)

### El Cambio Paradigmático: De "Asistente" a "Agente"

**Ola 1 y 2:** La IA es un **asistente**. Tú eres el piloto, la IA es el copiloto.

**Ola 3:** La IA es un **agente**. Le das un objetivo, el agente planifica y ejecuta autónomamente.

**La diferencia crítica:**

**Ola 2 (Copilot):** El desarrollador escribe un comentario, Copilot sugiere código, el desarrollador acepta con Tab. Escribe otro comentario, Copilot sugiere, acepta. Repite 10 veces para completar un feature; la interacción es línea por línea.

**Ola 3 (Agente autónomo como Devin):** El desarrollador dice *"Implementa feature de fetch y validación de usuarios con estos requisitos"* y pega la spec. 10 minutos después, el agente responde: *"Feature implementada. 8 archivos modificados, tests pasan. ¿Quieres que haga commit?"*

### Las Herramientas Pioneras de Ola 3

**Devin (Cognition Labs) - Marzo 2024**

**Qué es:**

- "The first AI software engineer"
- [Agente autónomo]{.idx} completamente autónomo que puede:
  - Planificar implementación de feature
  - Escribir código en múltiples archivos
  - Ejecutar comandos en terminal
  - Debuggear errores
  - Iterar hasta que tests pasen

**Demo viral (Marzo 2024):**

- Devin implementó feature completo en repositorio *open source*
- Issue en GitHub: "Add authentication to API"
- Devin autónomamente:
  1. Leyó issues y comments
  2. Exploró el codebase
  3. Implementó OAuth2 authentication
  4. Escribió tests
  5. Ejecutó tests, encontró errores, los corrigió
  6. Abrió Pull Request

- **Tiempo:** 3 horas. **Intervención humana:** Cero (hasta review del PR).

**Estado actual (2026):**

- Disponible públicamente con plan Core desde $20/mes (lanzado con Devin 2.0 en 2025)
- Plan Team a $500/mes con 250 ACUs (Agent Compute Units) incluidas
- Cada ACU equivale a ~15 minutos de trabajo activo del agente

**GitHub Copilot Workspace / Agent Mode (2024-2025)**

**Qué es:**

- Evolución de Copilot para trabajar a nivel de "workspace" completo. En febrero 2025, GitHub lanzó "Agent Mode" como evolución disponible en general (GA), integrando capacidades agénticas directamente en Copilot
- Puede:
  - Leer múltiples archivos simultáneamente
  - Proponer cambios cross-file
  - Generar plan de implementación antes de codificar

**Diferencia vs. Copilot original:**

- Copilot: Autocomplete archivo por archivo
- Copilot Workspace: Agent que entiende task completo y genera plan multi-archivo

**Ejemplo de uso:**

- **Tú en Copilot Workspace:** *"Fix bug #1234: Users can't upload files > 10MB"*
- **Copilot Workspace responde:** *"Análisis del bug: (1) Frontend validation limit está hardcoded a 10MB, (2) Backend también tiene limit de 10MB, (3) Nginx config tiene limit de 5MB; esto es el problema real."*
- **Plan de fix:** (1) Update nginx.conf: client_max_body_size 50M, (2) Update frontend validation to 50MB, (3) Update backend validation to 50MB, (4) Add test for 20MB upload. *"¿Procedo?"*
- **Tú:** *"Sí"*
- **Copilot Workspace** implementa los 4 cambios: *"Implementación completa. Tests pasan. ¿Crear PR?"*

**Cursor Composer (Cursor IDE) - 2024**

**Qué es:**

- [Cursor]{.idx data-sub="herramientas agénticas"} es un fork de VS Code optimizado para IA
- "Composer" es su modo agéntico

**Capacidades:**

- Edita múltiples archivos en un solo go
- Ejecuta comandos (con tu aprobación)
- Itera sobre errores de compilación
- Mantiene contexto de todo el codebase (usa embeddings para indexar)

**Diferenciadores:**

- Mejor manejo de codebases grandes (>100K líneas)
- "Cursor Tab": Like Copilot autocomplete pero con contexto de todo el proyecto
- "$100/mes unlimited": Más barato que otras opciones agénticas

**Replit Agent (Replit) - 2024**

**Qué es:**

- Agente integrado en Replit (IDE cloud-based)
- Orientado a "build apps from scratch"

**Sweet spot:**

- Prototyping rápido
- Educación
- Developers que prefieren cloud IDE

**Limitación:**

- Mejor para proyectos nuevos que para codebases enterprise existentes

**Tabla 7.4. Comparativa de herramientas de Ola 3 (2025)**

| Herramienta | Disponibilidad | Precio | Mejor Para | Limitación Principal |
|-------------|----------------|--------|------------|----------------------|
| Devin | Disponible | Desde $20/mes (Core) / $500/mes (Team) | Features complejos end-to-end | ACUs se consumen rápido en tareas grandes |
| Copilot Agent Mode | GA (incluido en Copilot) | $10-39/mes (según tier Copilot) | Equipos ya usando Copilot y GitHub | Requiere repositorio en GitHub |
| Cursor Composer | Disponible | $20-200/mes | Codebases grandes, individual devs | Créditos limitados según tier |
| Replit Agent | Disponible | $25/mes (Core) | Prototyping, educación | No ideal para enterprise codebases |

### Cómo Funcionan los Agentes Autónomos: La Arquitectura

**Componentes clave:**

**1. Planning Module**

- Descompone objetivo de alto nivel en subtareas
- Ejemplo: "Add 2FA" → [Install lib, DB migration, Update auth, Write tests, ...]

**2. Execution Engine**

- Ejecuta cada subtarea
- Puede usar herramientas: editor de archivos, terminal, browser, APIs

**3. Feedback Loop**

- Ejecuta acción → observa resultado → ajusta si hay error
- Ejemplo: Run tests → 3 fallan → analiza error → modifica código → re-run tests

**4. Memory/Context Manager**

- Mantiene contexto de todo lo que ha hecho
- Embeddings del codebase completo
- Historial de decisiones ("Por qué hice X")

**Arquitectura de un Agente Autónomo: Flujo de Ejecución Paso a Paso**

El siguiente modelo describe cómo un agente autónomo procesa una solicitud de principio a fin. Cada fase incluye un componente responsable, las acciones que realiza y el criterio para avanzar o escalar.

| Fase | Componente | Acción | Resultado esperado |
|------|-----------|--------|-------------------|
| 1. Entrada | Interfaz de usuario | El líder o desarrollador describe el objetivo en lenguaje natural (ej: "Implementar feature X") | Solicitud registrada en el sistema del agente |
| 2. Planificación | Planning Module | Analiza el codebase, descompone el objetivo en 5-10 subtareas ordenadas por dependencia | Plan de ejecución con subtareas priorizadas |
| 3. Ejecución | Execution Engine | Para cada subtarea: edita archivos, ejecuta comandos en terminal, interactua con APIs | Cambios aplicados al codebase |
| 4. Verificación | Feedback Loop | Ejecuta tests automatizados, valida compilación, revisa resultado | Tests pasando o errores identificados |
| 5a. Exito | Orquestador | Si la verificación es exitosa, avanza a la siguiente subtarea | Progreso confirmado |
| 5b. Error (reintento) | Feedback Loop | Si falla, analiza el error, ajusta el enfoque y re-ejecuta (hasta 3 intentos) | Corrección aplicada y re-verificada |
| 5c. Escalamiento | Interfaz de usuario | Si falla despues de 3 reintentos, notifica al humano con contexto del error | Intervención humana solicitada con diagnóstico |
| 6. Reporte final | Memory/Context Manager | Todas las subtareas completas: genera resumen de cambios, archivos modificados y tests ejecutados | Informe entregado al usuario para revisión |

**Puntos clave para líderes:**

- **Autonomía con guardarrieles:** El agente reintenta hasta 3 veces antes de escalar. Esto evita bloqueos pero mantiene supervisión humana en casos complejos.
- **Trazabilidad completa:** Cada decisión del agente queda registrada, lo cual facilita auditorías y revisiones de seguridad.
- **El humano sigue siendo el validador final:** Ningun cambio llega a producción sin aprobación explícita del equipo.

### Datos de Productividad (2024-2025)

**Datos preliminares (porque Ola 3 es muy reciente):**

**Cognition Labs (evaluaciones de Devin):**

- [SWE-bench]{.idx data-sub="evaluaciones de rendimiento"} (marzo 2024): [Devin]{.idx data-sub="agentes autónomos"} resolvió 13.86% de issues en repos *open source* sin intervención humana
- Comparado con: Copilot 4.8%, otros tools 3-8% en la misma fecha
- **Nota:** 13.86% sonaba bajo, pero era revolucionario porque implicaba **cero intervención humana**. Para finales de 2025, los mejores agentes superaban el 75% en SWE-bench Verified, demostrando el ritmo exponencial de mejora en menos de 2 años

**Cursor user surveys (2024):**

- Usuarios de Cursor Composer reportan 2-3x más productividad que con Copilot solo
- Especialmente efectivo en:
  - Refactors grandes
  - Features multi-archivo
  - Bug fixes que requieren múltiples cambios coordinados

**Limitaciones de datos actuales:**

- Ola 3 es muy nueva (2024-2025)
- Pocas empresas han adoptado a escala
- No hay estudios peer-reviewed todavía

### Adopción Empresarial (2024-2025)

**Gartner estimate (2025):**

- <5% de enterprises usando agentes autónomos en producción
- 20% experimentando en pilotos
- 75% todavía en "wait and see"

**Por qué la adopción es lenta:**

**Razón 1: Riesgos de seguridad**

- Agentes ejecutan comandos autónomamente
- ¿Qué pasa si borra archivos importantes?
- ¿Qué pasa si expone secretos?

**Razón 2: Confianza**

- 71% de developers no confían plenamente en código AI-generated
- Agentes autónomos requieren aún MÁS confianza

**Razón 3: Costo**

- $500-1000/mes por usuario es 10-50x más caro que Copilot
- ROI no está comprobado todavía a escala

**Razón 4: Change management**

- Requiere [change management]{.idx} de flujo de trabajo radical
- No todos los developers quieren "ceder control" a un agente

**Early adopters (2024-2025):**

- Startups tech-forward (menos risk aversion)
- Equipos de R&D en grandes empresas
- Consultancies (donde velocidad = revenue)

### Caso de Estudio: Startup de 10 Developers Adopta Cursor (2024)

**Contexto:**

- Startup SaaS
- 10 developers, 2 product managers
- Stack: React, Node.js, PostgreSQL
- Objetivo: Lanzar MVP en 3 meses

**Antes (sin IA agéntica):**

- Velocidad: 20 features/mes
- Bugs en producción: 15/mes
- *time-to-market* estimado para MVP: 6 meses

**Implementación:**

- Mes 1: Todo el equipo migra de VS Code a Cursor
- Mes 1-2: Ramp up (aprendiendo a usar Composer efectivamente)
- Mes 3+: Productividad completa

**Resultados a 6 meses:**

- Velocidad: 45 features/mes (+125%)
- Bugs en producción: 18/mes (+20% - PEOR, pero...)
- Bugs descubiertos en development: +300% (porque generaban más código más rápido, encontraban más bugs antes de producción)
- *time-to-market* real para MVP: 3.5 meses (vs. 6 estimado) = **42% más rápido**

**ROI:**

- Costo: 10 devs × $40/mes × 6 = $2,400
- Valor: Lanzar MVP 2.5 meses antes = capturar mercado antes que competitor = $500K+ en revenue adelantado
- **ROI: Incalculable (el valor de lanzar primero es mucho mayor que el ahorro de costo)**

**Lecciones aprendidas:**

1. Los primeros 2 meses fueron caóticos (curva de aprendizaje)
2. Pero después de eso, la velocidad se disparó
3. Bugs aumentaron inicialmente, pero con mejores tests se estabilizó
4. Los developers más seniors fueron los que más resistieron inicialmente, pero luego se convirtieron en los mayores advocates

---

## Proyecciones: Hacia Dónde Vamos (2025-2030)

### Predicciones de Líderes de la Industria

**Kevin Scott (CTO Microsoft):**

- "95% del código será generado por IA para 2030"
- Pero: "La autoría seguirá siendo humana"
- Interpretación: Agentes generan, humanos validan y dirigen

**Dario Amodei (CEO Anthropic):**

- "90-100% del código escrito por IA en 3-18 meses"
- Nota: Esta es la predicción más agresiva

**Gartner:**

- "Para 2026, 60% de desarrollo nuevo usará agentes autónomos"
- "Para 2028, 15% de decisiones diarias de trabajo serán tomadas autónomamente por IA agéntica"

### Las Olas que Vienen: Generación 4 y Más Allá

**Generación 4: Self-Evolving Systems (2027+)**

**Qué esperamos:**

- Sistemas que no solo escriben código, sino que se mejoran a sí mismos
- Agentes que aprenden de producción data y auto-optimizan
- Sistemas que detectan y corrigen bugs en producción autónomamente

**Ejemplo especulativo:**

- Tu app en producción empieza a tener latencia alta
- Un agente detecta el problema
- Analiza logs, encuentra que una query de DB es ineficiente
- Escribe un índice nuevo
- Ejecuta migration en staging
- Valida que performance mejora
- Crea PR para review humana
- **Todo esto mientras duermes**

**Riesgos:**

- ¿Cómo garantizamos que cambios autónomos no introduzcan bugs?
- ¿Quién es responsable si algo falla?
- ¿Cómo auditamos decisiones tomadas por agentes?

**Generación 5: Collaborative Multi-Agent Systems (2030+)**

**Qué esperamos:**

- Múltiples agentes especializados trabajando juntos
- Ejemplo: Frontend Agent + Backend Agent + DevOps Agent + QA Agent
- Se coordinan para implementar features completos end-to-end

**Analogía:**

- Hoy: Un developer full-stack hace todo
- Gen 5: Un orquestador (tú) coordina un "equipo" de agentes especializados

**Implicación para líderes:**

- El rol de engineering manager evoluciona a "AI agent orchestrator"
- Contratas y entrenas menos humanos, orquestas más agentes

---

## Framework de Decisión: ¿En Qué Ola Deberías Estar?

No todas las organizaciones deben estar en Ola 3. Usa esta guía:

**Matriz de decisión: Que ola es apropiada para tu organización**

| Factor | Ola 1 (Desconectado) | Ola 2 (Copilot) | Ola 3 (Agente) |
|--------|----------------------|-----------------|----------------|
| **Tamaño de equipo** | <5 devs | 5-500 devs | 10-100 devs (early adopters) |
| **Madurez del proceso** | Ad-hoc | Tiene CI/CD, code review | Procesos muy maduros con alta cobertura de tests |
| **Tolerancia a riesgo** | N/A | Media | Alta |
| **Presupuesto de tools** | $0-100/mes | $500-10K/mes | $5K-100K/mes |
| **Velocidad es crítica** | No | Sí | Crítico (ej: startup pre-PMF) |
| **Codebase** | Cualquiera | <1M líneas | <500K líneas (Ola 3 struggle con muy grandes) |
| **Stack tech** | Cualquiera | Lenguajes populares (JS, Python, Java) | Idem |
| **Security requirements** | N/A | Alto (requiere SAST) | Muy alto (requiere SAST + sandboxing) |

**Recomendaciones por tipo de organización:**

**Startup early-stage (<20 devs):**

- **Empieza:** Ola 2 (Copilot o Cursor)
- **Cuando:** Experimenta con Ola 3 cuando tengas tests automatizados buenos
- **Evita:** Quedarte en Ola 1 (pierdes demasiada velocidad)

**Empresa mediana (50-500 devs):**

- **Consolida:** Ola 2 en 80%+ de equipo
- **Experimenta:** Ola 3 en equipos de R&D o innovation
- **Mide:** ROI de Ola 2 antes de invertir fuerte en Ola 3

**Enterprise (500+ devs):**

- **Despliega:** Ola 2 con governance fuerte (SAST, code review standards)
- **Piloto:** Ola 3 en 5-10% de equipos (no-críticos)
- **Monitorea:** Security y compliance muy de cerca

**Industria regulada (finance, health, aerospace):**

- **Cautela:** Ola 2 con extensive testing
- **Evita:** Ola 3 en sistemas críticos (por ahora)
- **Espera:** Más madurez de herramientas (2-3 años)

---

## Para Tu Próxima Reunión de Liderazgo

📊 **Puntos clave para comunicar a executives:**

*"La IA para desarrollo de software evolucionó en 3 olas:*

*Ola 1 (2018-2020): Copy-paste a ChatGPT. 84% de developers la usaron, pero ganancias modestas (+10-20%).*

*Ola 2 (2021-2023): Copilot integrado al IDE. 65% de equipos enterprise lo adoptaron. Ganancias medibles de 30-55% en productividad. Empresas como Shopify reportaron adopción generalizada con mejoras significativas en velocity.*

*Ola 3 (2023-presente): Agentes autónomos. Solo 5% en producción, pero proyecciones de analistas de mercado sugieren 60% para 2026. Ganancias preliminares de 100-200% pero con riesgos de seguridad y costo más altos.*

*Recomendación: Consolidar Ola 2 en 100% de ingeniería antes de experimentar con Ola 3. Basado en nuestra evaluación, deberíamos [estar en Ola X] porque [razones específicas a tu organización]."*

---

## Cómo Funcionan los LLMs: Lo Que Todo Líder Debe Saber

Hasta ahora hemos hablado de qué hacen las herramientas de cada ola. Pero para tomar decisiones informadas sobre cuándo confiar en ellas, cuánto invertir, y qué riesgos aceptar, es útil entender, a nivel conceptual, **cómo funcionan por dentro**.

Esta sección está diseñada para líderes técnicos que no necesitan saber los detalles matemáticos, pero sí quieren responder preguntas como: "¿Por qué un modelo de 70B es mejor que uno de 7B?" o "¿Por qué a veces la IA inventa código que no funciona?" Los [LLM]{.idx} (Large Language Models) son la base de toda la revolución agéntica.

### Parámetros: Los "Conocimientos" del Modelo

**Analogía simple:** Si un LLM fuera un empleado, los parámetros serían todo lo que aprendió en su formación: cada concepto, patrón, y relación que internalizó de los textos que leyó.

Un modelo con "7 mil millones de parámetros" (7B) tiene 7 mil millones de números ajustables que fueron calibrados durante el entrenamiento. Estos números codifican todo el "conocimiento" del modelo.

**Lo que importa para ti:**

| Más Parámetros | Menos Parámetros |
|----------------|------------------|
| Generalmente más capaz | Más rápido y barato |
| Mejor en tareas complejas | Suficiente para tareas simples |
| Requiere más hardware | Corre en laptops |
| Más caro por token | Más barato por token |

**Tabla de referencia simplificada:**

| Tamaño | Ejemplos | Costo Típico | Cuándo Usar |
|--------|----------|--------------|-------------|
| **Pequeño** (<10B) | Mistral 7B, Phi-3, Llama 3 8B | ~$0.05/1M tokens | Autocompletado simple, tareas rutinarias, on-premise barato |
| **Mediano** (10-100B) | Llama 3 70B, Claude Haiku 4.5 | ~$1.00/1M tokens | Balance costo/capacidad, la mayoría de tareas de código |
| **Grande** (>100B) | GPT-4o, Claude Sonnet 4.5/Opus 4.6 | ~$2.50-15/1M tokens | Tareas complejas, razonamiento multi-paso, código crítico |

> **Regla práctica:** Un modelo de 70B no es 10x mejor que uno de 7B. Pero sí es significativamente mejor en tareas que requieren razonamiento complejo, conocimiento especializado, o contexto largo.

### Tokens: La Unidad de Facturación

**Analogía simple:** Los [tokens]{.idx} son como las "palabras" que el modelo procesa y por las que te cobran. Pero no son exactamente palabras; son pedazos de texto que el modelo reconoce.

**Regla práctica para estimar:**
- 1,000 tokens ≈ 750 palabras en inglés/español
- 1,000 tokens ≈ 1.5 páginas de texto
- Una función de 50 líneas ≈ 200-400 tokens
- Un archivo de código de 500 líneas ≈ 2,000-4,000 tokens

**Lo que importa para ti:** Así es como se factura. Un prompt largo = más costo. Un codebase grande en contexto = costo significativo.

**Ejemplo de costos (febrero 2026):**

| Modelo | Input (por 1M tokens) | Output (por 1M tokens) |
|--------|----------------------|------------------------|
| GPT-4o | $2.50 | $10.00 |
| GPT-4o-mini | $0.15 | $0.60 |
| Claude Sonnet 4.5 | $3.00 | $15.00 |
| Claude Haiku 4.5 | $1.00 | $5.00 |
| Llama 3 70B (self-hosted) | ~$0.50-1.00 | ~$0.50-1.00 |
| Mistral 7B (self-hosted) | ~$0.05-0.10 | ~$0.05-0.10 |

> **Para Tu Próxima Reunión de Presupuesto:** Si tu equipo de 50 developers usa un agente que procesa 100K tokens/día cada uno, eso es 5M tokens/día. Con Claude Sonnet 4.5, serían ~$15K-75K/mes. Con un modelo self-hosted, podrías reducir a $5K-15K/mes. La diferencia en calidad puede justificar el costo extra; o no, dependiendo del caso de uso.

### Context Window: Cuánto Puede "Recordar"

**Analogía simple:** El [context window]{.idx} es la "memoria de trabajo" del modelo: cuánta información puede tener presente al mismo tiempo. Es como cuántos documentos puedes tener abiertos y leer simultáneamente.

**Evolución del context window:**

| Año | Context Window Típico | Equivalente Aproximado |
|-----|----------------------|------------------------|
| 2022 | 4,000 tokens | ~6 páginas |
| 2023 | 8,000-32,000 tokens | ~12-50 páginas |
| 2024 | 128,000-200,000 tokens | ~200-300 páginas |
| 2025 | Hasta 2-10M tokens | ~3,000-15,000 páginas (un libro entero) |

**Context windows actuales:**

| Modelo | Context Window | En Práctica |
|--------|---------------|-------------|
| GPT-4o | 128K tokens | Un codebase pequeño-mediano |
| Claude Sonnet 4.5 | 200K tokens | Un codebase mediano |
| Gemini 2.5 Pro | 2M tokens | Múltiples repositorios |
| Llama 4 | 10M tokens | Bases de código completas enterprise |

**Cuidado importante:** Más contexto ≠ mejor performance. Los modelos exhiben el "middle curse": tienden a ignorar o procesar peor la información que está en el medio del contexto. La investigación "Lost in the Middle" (Liu et al., Stanford, 2024, arXiv:2307.03172) demostró que el rendimiento degrada significativamente cuando la información relevante está en posiciones intermedias del contexto, incluso si el modelo "soporta" ventanas grandes.

> **Implicación práctica:** No asumas que "meter todo el codebase en contexto" es la mejor estrategia. Técnicas como RAG (recuperar solo lo relevante) suelen funcionar mejor que contextos masivos.

### Temperature: Creatividad vs Consistencia

**Analogía simple:** [Temperature]{.idx data-sub="LLM"} es el dial entre "sigue las reglas exactamente" y "improvisa creativamente".

| Temperature | Comportamiento | Cuándo Usar |
|-------------|----------------|-------------|
| **0.0** | Respuestas idénticas siempre | Cuando necesitas reproducibilidad |
| **0.1-0.3** | Muy predecible, mínima variación | Código, análisis, datos |
| **0.5-0.7** | Balance entre consistencia y creatividad | Documentación, explicaciones |
| **0.8-1.0** | Más variación y creatividad | Brainstorming, alternativas |
| **>1.0** | Alta variabilidad, riesgo de incoherencia | Casi nunca recomendado |

**Lo que importa para ti:**

- **Para código:** Temperature baja (0.0-0.3). Quieres consistencia y predictibilidad.
- **Para documentación:** Temperature media (0.5-0.7). Algo de variación mejora legibilidad.
- **Nunca para código en producción:** Temperature alta (>0.8). Aumenta riesgo de alucinaciones.

> **Curiosidad:** Investigación reciente (2024) encontró que para problem-solving, cambios de temperature entre 0.0 y 1.0 no tienen impacto estadísticamente significativo en performance. Lo que sí importa es la calidad del prompt.

### Por Qué los LLMs "Alucinan": Explicación Simple

**Analogía:** Un LLM es como un estudiante que aprendió a predecir la siguiente palabra de millones de textos. No tiene "conocimiento" real; solo patrones estadísticos de qué palabras suelen ir juntas. Este fenómeno se conoce como [alucinaciones]{.idx data-sub="LLM"}.

Cuando le pides algo que no vio suficientes veces en el entrenamiento, hace lo que cualquier buen estudiante haría: **inventa algo que suena correcto**.

**Por qué no se puede eliminar completamente:**

1. **No hay "fuente de verdad" interna:** El modelo no puede verificar si lo que dice es correcto; solo si es probable.

2. **Optimiza fluidez, no veracidad:** El training reward es "generar texto coherente", no "generar texto verdadero".

3. **Es matemáticamente necesario:** Sin la capacidad de "improvisar" (alucinar), el modelo solo podría repetir fragmentos exactos del entrenamiento. Las alucinaciones son el costo de la generalización.

**Lo que importa para ti:** No confíes ciegamente. **Siempre verifica información crítica**, especialmente:
- Nombres de APIs y librerías (frecuentemente inventadas)
- Configuraciones y parámetros específicos
- Código que maneja seguridad, autenticación, o datos sensibles

### Optimizaciones: Cómo Hacer Más con Menos

#### Quantización: Modelos "Comprimidos"

**Analogía simple:** Es como comprimir una foto JPEG. La [quantización]{.idx data-sub="optimización de modelos"} ocupa menos espacio, pierde algo de calidad, pero para la mayoría de usos es indistinguible.

Los modelos normalmente usan números de 16 o 32 bits para cada parámetro. Quantización los reduce a 8 o 4 bits.

| Formato | Reducción de Memoria | Pérdida de Calidad | Cuándo Usar |
|---------|---------------------|--------------------|-------------|
| **FP16** (base) | 0% | 0% | Máxima calidad, tienes GPU potente |
| **INT8** | ~50% | <1-2% | Producción estándar |
| **INT4** | ~75% | 2-5% | Recursos limitados, tareas simples |
| **GGUF** (formatos) | Variable | Variable | Laptops, Macs, CPUs |

**Lo que importa para ti:** Quantización permite correr modelos potentes en hardware más barato. Un Llama 70B quantizado a INT4 puede correr en una Mac Studio en lugar de requerir un servidor con 8 GPUs.

#### Mixture of Experts (MoE): Especialistas Colaborando

**Analogía simple:** En lugar de un empleado que sabe todo, tienes un equipo de especialistas. [Mixture of Experts]{.idx data-sub="arquitecturas de modelos"} (MoE) funciona con esa misma lógica. Cuando llega una pregunta de marketing, el experto en marketing responde. Cuando es de finanzas, responde el de finanzas.

**Cómo funciona:**
- El modelo tiene múltiples "expertos" (sub-redes especializadas)
- Para cada token, solo se activan los 1-2 expertos más relevantes
- Los demás "duermen" (no consumen compute)

**Ejemplos actuales:**

| Modelo | Parámetros Totales | Activos por Token | Ratio |
|--------|-------------------|-------------------|-------|
| Mixtral 8x22B | 141B | 39B | 28% |
| DeepSeek-V3 | 671B | 37B | 5.5% |
| Grok-1 | 314B | 70-80B | 22-25% |

**Lo que importa para ti:** MoE permite modelos mucho más capaces (más parámetros totales) sin el costo proporcional de compute. Es por esto que los modelos más avanzados de 2025-2026 usan MoE, incluyendo GPT-4 (se especula) y la mayoría de modelos *open source* líderes.

> **Dato clave:** En 2025, los 10 modelos *open source* más capaces según evaluaciones independientes usan arquitectura MoE.

### Fine-tuning vs Prompting vs RAG: Cuándo Usar Cada Uno

Una de las decisiones más comunes para líderes técnicos: ¿cómo adaptar un modelo a mis necesidades? Las opciones principales son [prompting]{.idx}, [RAG]{.idx} (Retrieval-Augmented Generation) y [fine-tuning]{.idx}.

| Approach | Qué Es | Cuándo Usar | Costo | Flexibilidad |
|----------|--------|-------------|-------|--------------|
| **Prompting** | Instruir al modelo con texto | Siempre primero | Bajo | Alta |
| **RAG** | Darle acceso a tus documentos | Conocimiento propio/actualizado | Medio | Alta |
| **Fine-tuning** | Re-entrenar con tus datos | Comportamiento muy específico | Alto | Baja |

**Regla de oro:**

1. **Empieza con prompting.** El 80% de los casos se resuelven con buenos prompts.
2. **Escala a RAG** si necesitas conocimiento que el modelo no tiene (tu documentación, código interno, datos actualizados).
3. **Fine-tuning solo como último recurso** cuando necesitas comportamiento muy específico que no se logra con prompts o RAG.

::: {.callout .reunion-liderazgo}
**Para Tu Próxima Reunión de Liderazgo**

Si alguien propone fine-tuning, pregunta:
1. "¿Probamos primero con prompting optimizado?"
2. "¿RAG resolvería esto sin fine-tuning?"
3. "¿Tenemos los datos y recursos para entrenar y mantener un modelo fine-tuned?"

Fine-tuning tiene costos ocultos: necesitas datos de entrenamiento, compute, expertise, y debes re-entrenar cuando el modelo base se actualiza.
:::

### Cómo Se Entrenan los LLMs (Vista Ejecutiva)

Para completar tu comprensión, un vistazo rápido al proceso de entrenamiento:

#### Pre-training: Construyendo la Base

- El modelo lee billones de tokens de texto de internet
- Aprende a predecir la siguiente palabra
- **Costo:** GPT-2 (2019): $50K | PaLM (2022): $8M | GPT-4 (2023): ~$100M+ estimado
- **Implicación:** Solo empresas con recursos masivos pueden crear modelos base. Tú los usas, no los creas.

#### Post-training: Haciéndolos Útiles y Seguros

Después del pre-training, los modelos son buenos prediciendo texto pero no son "útiles". El post-training los hace:

- **[RLHF]{.idx data-sub="entrenamiento de modelos"} (Reinforcement Learning from Human Feedback):** Humanos califican respuestas, modelo aprende preferencias.
- **DPO (Direct Preference Optimization):** Alternativa más eficiente a RLHF.
- **Constitutional AI:** El modelo se auto-corrige basado en principios definidos.

**Lo que importa para ti:** El post-training es lo que hace que Claude sea "helpful" y "harmless" en lugar de solo generar texto. Es también donde se pueden introducir sesgos o limitaciones; cada vendor tiene su propia filosofía.

---

## Conclusiones y Takeaways

### Lo Que Debes Recordar:

1. **3 olas, 3 paradigmas:** Asistente desconectado → Integrado → Agente autónomo. Cada uno multiplica productividad pero introduce nuevos desafíos.

2. **Ola 2 es table stakes:** Para 2025, NO tener AI coding assistants te pone en desventaja de contratación y productividad.

3. **Ola 3 es el futuro pero no el presente:** Agentes autónomos son poderosos pero riesgosos. Adoptar cuando tienes procesos maduros.

4. **Datos de productividad son reales:** Ola 2 = +30-55%, Ola 3 = +100-200% (preliminar). Pero requieren ramp-up de 8-11 semanas.

5. **Security no es opcional:** 48% de código AI-generado tiene vulnerabilidades. SAST automático es obligatorio.

6. **La curva de adopción se acelera:** De Ola 1 a Ola 2 tomó 3 años. De Ola 2 a Ola 3 está tomando 18 meses. La próxima ola será aún más rápida.

7. **No es reemplazo, es evolución:** El rol del developer evoluciona. De "escribir código" a "orquestar agentes y validar resultado".

8. **Predicción de líderes (Kevin Scott, Dario Amodei, Mark Zuckerberg):** 60-95% del código será generado por IA para 2026-2030. La pregunta no es "si", sino "cuándo adoptamos proactivamente".


> **Tarjeta de Referencia Rápida**
>
> - **Métrica clave 1**: Productividad por ola: Ola 1 (+10-20%), Ola 2 (+30-55%), Ola 3 (+100-200% preliminar); adopción 2025: ~65% en Ola 2, ~20% en Ola 3
> - **Métrica clave 2**: 48% de código AI-generado tiene vulnerabilidades (Snyk, 2024); SAST automático es obligatorio
> - **Métrica clave 3**: Curva de aprendizaje real: 2-3 semanas para Ola 2, 4-8 semanas para Ola 3 (no "días" como sugieren vendors)
> - **Framework principal**: Las 3 Olas de IA para Código (Asistente Desconectado, Integrado al IDE, Agente Autónomo) y el Mapa de Progresión hacia Sistemas Multi-Agente (ver este capítulo)
> - **Acción inmediata**: Sitúa a tu organización en el mapa de olas; si aún no consolidaste Ola 2 (Copilot), no saltes a Ola 3 (agentes)

## Preguntas de Reflexión para Tu Equipo

1. **Sobre estado actual:**
   - ¿En qué ola estamos hoy? ¿Qué % del equipo usa qué herramientas?
   - ¿Cuál es nuestra ganancia medible de productividad con herramientas actuales?

2. **Sobre next steps:**
   - Si estamos en Ola 1, ¿qué nos impide movernos a Ola 2?
   - Si estamos en Ola 2, ¿deberíamos experimentar con Ola 3? ¿En qué equipos?

3. **Sobre riesgos:**
   - ¿Tenemos SAST automático? Si no, eso es blocker.
   - ¿Tenemos cobertura de tests suficiente para confiar en código AI-generado?
   - ¿Cuál es nuestro plan de respuesta si un agente introduce bug crítico?

4. **Sobre hoja de ruta:**
   - ¿Dónde queremos estar en 12 meses? ¿En 24 meses?
   - ¿Qué capacitación necesita el equipo para cada ola?
   - ¿Cuál es el presupuesto de tools que podemos justificar?

---

**Referencias:**

[^ch7-1]: GitHub/Microsoft Research. (2023). "The Impact of AI on Developer Productivity: Evidence from GitHub Copilot". Arxiv. https://arxiv.org/abs/2302.06590

2. Second Talent. (2025). "GitHub Copilot Statistics & Adoption Trends [2025]". https://www.secondtalent.com/resources/github-copilot-statistics/
3. GitClear. (2025). "AI Copilot Code Quality: 2025 Data Suggests 4x Growth in Code Clones". https://www.gitclear.com/ai_assistant_code_quality_2025_research
4. Stack Overflow. (2025). "AI | 2025 Stack Overflow Developer Survey". https://survey.stackoverflow.co/2025/ai
5. Gartner. (2025). "Top Strategic Technology Trends for 2025: Agentic AI".
6. McKinsey. (2025). "The state of AI in 2025: Agents, innovation, and transformation".
7. Cognition Labs. (2024). "Devin: The First AI Software Engineer". https://www.cognition-labs.com/devin
8. TechSpot. (2025). "Microsoft CTO predicts AI will generate 95% of code by 2030". https://www.techspot.com/news/107411-microsoft-cto-predicts-ai-generate-95-percent-code.html

---

*Fin del Capítulo 7. Continúa en Capítulo 8: El Ecosistema de Herramientas Agénticas*

