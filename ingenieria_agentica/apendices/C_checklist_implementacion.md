# Apéndice C: Checklist de Implementación

> **Extensión objetivo:** 5 páginas | **Audiencia:** Gerentes y líderes técnicos

Esta guía práctica acompaña el framework Crawl/Walk/Run del Capítulo 12 con checklists detallados para cada fase de implementación. Cada checkpoint incluye guía contextual, responsables sugeridos, KPIs esperados y señales de alerta.

**Cómo usar este apéndice:** Imprime las secciones relevantes a tu fase actual. Asigna un responsable por cada ítem. Revisa el progreso semanalmente en reuniones de seguimiento.

### Formatos Digitales Sugeridos

Para maximizar la utilidad de estos checklists, te recomendamos trasladarlos a una herramienta digital colaborativa:

| Formato | Herramienta | Ventaja |
|---------|-------------|---------|
| **Spreadsheet** | Google Sheets, Excel | Filtros por fase, progreso porcentual, gráficos de avance |
| **Project management** | Notion, Asana, Jira | Asignar responsables, fechas límite, dependencias entre tareas |
| **Wiki/Documentación** | Confluence, Notion | Comentarios del equipo, historial de cambios, links a evidencia |
| **Checklist nativo** | Todoist, TickTick | Simplicidad, recordatorios, acceso mobile para revisión en campo |

**Tip práctico:** Copia las tablas de checkpoint directamente (Ctrl+C desde el PDF o desde la versión digital) y pégalas en tu herramienta preferida. La estructura de columnas (checkpoint, responsable, completado) se preserva en la mayoría de herramientas. Adapta las columnas según tu proceso: agrega "Fecha de inicio", "Evidencia", o "Bloqueado por" si tu organización lo requiere.

---

## Fase 0: Preparación (Semanas 1-2)

> **Propósito:** Sentar las bases organizacionales antes de invertir en herramientas. El 60% de los fracasos en adopción de IA se originan en una preparación inadecuada. Esta fase es la inversión más importante del programa.

### Alineamiento Organizacional

| # | Checkpoint | Responsable | Completado |
|---|-----------|:-----------:|:----------:|
| 1 | Sponsor ejecutivo identificado (VP+ nivel) | CEO/CTO | [ ] |
| 2 | Objetivos claros definidos (máximo 3 objetivos medibles) | Sponsor + PM | [ ] |
| 3 | Métricas de éxito acordadas con baseline actual documentado | PM + Tech Lead | [ ] |
| 4 | Presupuesto aprobado para 6 meses mínimo | Sponsor + Finance | [ ] |
| 5 | Timeline realista establecido (18 meses para escala completa) | PM | [ ] |
| 6 | Comunicación inicial a la organización enviada | Sponsor + HR | [ ] |
| 7 | Expectativas alineadas: esto es un programa, no un proyecto | Sponsor | [ ] |

### Evaluación Inicial

| # | Checkpoint | Responsable | Completado |
|---|-----------|:-----------:|:----------:|
| 8 | Assessment de madurez completado (ver Apéndice B, Framework #1) | Tech Lead | [ ] |
| 9 | Readiness organizacional evaluado (ver Apéndice B, Framework #2) | PM + Tech Lead | [ ] |
| 10 | Top 5 casos de uso priorizados con matriz ROI/Riesgo | Equipo de liderazgo | [ ] |
| 11 | Riesgos identificados y plan de mitigación documentado | Security + Legal | [ ] |
| 12 | Equipo piloto seleccionado (5-8 devs voluntarios) | Tech Lead | [ ] |
| 13 | Evaluación preliminar de 2-3 herramientas candidatas | Tech Lead | [ ] |
| 14 | Requisitos de compliance y seguridad documentados | Security | [ ] |

### KPIs de Fase 0

- Readiness score >= 25/40 puntos
- Sponsor ejecutivo activamente involucrado
- Baseline de métricas documentado (velocity, defect rate, cycle time)

### Señales de Alerta

- No se encuentra sponsor ejecutivo dispuesto a comprometerse
- Readiness score < 20/40 (mejor invertir en fundaciones antes de IA)
- Equipo piloto asignado por obligación en vez de voluntariamente
- Presupuesto aprobado solo para 3 meses (insuficiente para ver resultados)

---

## Fase 1: Piloto (Semanas 3-8)

> **Propósito:** Validar la propuesta de valor con un equipo real en condiciones controladas. El objetivo NO es demostrar ROI todavía, sino aprender qué funciona, qué no, y por qué. El aprendizaje de esta fase define el éxito de las siguientes.

### Setup Técnico

| # | Checkpoint | Responsable | Completado |
|---|-----------|:-----------:|:----------:|
| 15 | Herramienta principal seleccionada (usando Scorecard del Apéndice B) | Tech Lead | [ ] |
| 16 | Entorno de pruebas configurado y validado | DevOps | [ ] |
| 17 | Accesos y permisos establecidos para equipo piloto | IT/Security | [ ] |
| 18 | Políticas de seguridad básicas aplicadas (DLP, acceso a datos) | Security | [ ] |
| 19 | Monitoreo de uso y costos de API configurado | DevOps | [ ] |
| 20 | Kill switch básico implementado (manual está bien en esta fase) | Tech Lead | [ ] |

### Ejecución del Piloto

| # | Checkpoint | Responsable | Completado |
|---|-----------|:-----------:|:----------:|
| 21 | Capacitación inicial del equipo piloto (4-8 horas) | Champion/Vendor | [ ] |
| 22 | 2-3 casos de uso piloto definidos y asignados | Tech Lead | [ ] |
| 23 | Sesiones de pair programming con IA programadas (semana 1-2) | Champion | [ ] |
| 24 | Métricas de tracking configuradas y recopilando datos | PM | [ ] |
| 25 | Canal de retroalimentación establecido (Slack, Teams, encuesta semanal) | PM | [ ] |
| 26 | Reunión semanal de seguimiento del piloto calendarizada | PM + Tech Lead | [ ] |
| 27 | Documentación de mejores prácticas iniciada | Champion | [ ] |

### Revisión del Piloto (Semana 7-8)

| # | Checkpoint | Responsable | Completado |
|---|-----------|:-----------:|:----------:|
| 28 | Datos de uso recopilados y analizados (adopción, frecuencia) | PM | [ ] |
| 29 | Retroalimentación del equipo documentada (encuesta + entrevistas 1:1) | PM | [ ] |
| 30 | Impacto en métricas medido vs. baseline | Tech Lead + PM | [ ] |
| 31 | Problemas identificados y clasificados (técnicos vs. culturales) | Tech Lead | [ ] |
| 32 | Costo real del piloto documentado (licencias + tiempo invertido) | PM + Finance | [ ] |
| 33 | Reporte de piloto presentado a sponsor | PM | [ ] |
| 34 | Decisión go/no-go para expansión tomada y documentada | Sponsor | [ ] |

### KPIs de Fase 1

- Adopción del equipo piloto >= 70%
- Al menos 1 métrica con mejora medible (velocity, defect rate o cycle time)
- Retroalimentación positiva (NPS >= 7) del 70%+ del equipo
- Cero incidentes de seguridad
- Costo del piloto dentro del presupuesto (+/- 15%)

### Señales de Alerta

- Adopción < 50% después de semana 4 (la herramienta no encaja o falta capacitación)
- Equipo reporta que la IA "más estorba que ayuda" (revisar configuración y casos de uso)
- Incidente de seguridad durante el piloto (pausar, remediar, fortalecer controles)
- Sponsor no asiste a la revisión del piloto (riesgo de perder soporte político)
- Métricas empeoran vs. baseline (investigar causa: ¿curva de aprendizaje o problema real?)

### Errores Comunes en Esta Fase (del Cap. 12)

1. **Medir solo velocidad, ignorar calidad** - El código generado más rápido pero con más bugs no es progreso
2. **No dar tiempo de aprendizaje** - Esperar productividad inmediata es irreal; presupueste 2 semanas de ramp-up
3. **Seleccionar equipo escéptico como piloto** - Empiece con voluntarios entusiastas, los escépticos se convencen con resultados

---

## Fase 2: Expansión (Semanas 9-20)

> **Propósito:** Escalar lo que funcionó en el piloto a 3-5 equipos adicionales, formalizando políticas y governance. Esta es la fase donde la adopción pasa de "experimento" a "cómo trabajamos". Es también donde más programas fallan por escalar demasiado rápido.

### Rollout Gradual

| # | Checkpoint | Responsable | Completado |
|---|-----------|:-----------:|:----------:|
| 35 | Plan de rollout por equipos definido (máximo 2 equipos nuevos cada 4 semanas) | PM | [ ] |
| 36 | Criterios de selección de equipos documentados | Tech Lead | [ ] |
| 37 | Capacitación adaptada con lecciones del piloto | Champion | [ ] |
| 38 | Programa de champions internos lanzado (1 champion por equipo) | Tech Lead + HR | [ ] |
| 39 | Documentación de mejores prácticas actualizada y compartida | Champion | [ ] |
| 40 | Soporte interno establecido (FAQ, canal de ayuda, office hours) | Champions | [ ] |
| 41 | Onboarding kit preparado para nuevos equipos | PM + Champion | [ ] |

### Gobernanza Formal

| # | Checkpoint | Responsable | Completado |
|---|-----------|:-----------:|:----------:|
| 42 | Políticas de uso formalizadas y aprobadas por Security/Legal | Security + Legal | [ ] |
| 43 | Niveles de autonomía definidos por tipo de tarea (ver Apéndice B, #6) | Tech Lead + Security | [ ] |
| 44 | Proceso de revisión de código generado por IA establecido | Tech Leads | [ ] |
| 45 | Métricas de seguimiento operativas en dashboard | PM + DevOps | [ ] |
| 46 | Roles y responsabilidades documentados (RACI) | PM | [ ] |
| 47 | Proceso de escalamiento de incidentes definido | Security + Tech Lead | [ ] |
| 48 | Auditoría de seguridad del código generado (primera ronda) | Security | [ ] |

### Medición y Ajuste

| # | Checkpoint | Responsable | Completado |
|---|-----------|:-----------:|:----------:|
| 49 | ROI preliminar calculado (esperado: breakeven o ligeramente positivo) | PM + Finance | [ ] |
| 50 | Comparación de métricas entre equipos documentada | PM | [ ] |
| 51 | Ajustes a herramientas o configuración basados en retroalimentación | Tech Lead | [ ] |
| 52 | Evaluación de herramientas adicionales (agentes autónomos) | Tech Lead | [ ] |
| 53 | Presentación de progreso al board/C-suite | Sponsor + PM | [ ] |
| 54 | Decisión de continuar a Fase 3 tomada | Sponsor | [ ] |

### KPIs de Fase 2

- Adopción >= 60% en todos los equipos nuevos
- Velocity mejorada 20-35% vs. baseline organizacional
- Defect rate reducido 15-25%
- ROI en camino a breakeven
- Governance maturity level >= 2 (ver Apéndice B, Framework #8)
- Dashboard de métricas operativo y revisado mensualmente

### Señales de Alerta

- Disparidad significativa de adopción entre equipos (>30% de diferencia)
- Champions internos sobrecargados o desmotivados
- Costos de API escalando más rápido que los beneficios
- Incidentes de seguridad recurrentes (misma causa raíz)
- Resistencia cultural organizada ("esto es una moda")

---

## Fase 3: Optimización y Escala (Semana 21 en adelante)

> **Propósito:** Llevar la adopción a toda la organización y pasar de "usar IA" a "operar con IA". En esta fase, la IA agéntica deja de ser un programa y se convierte en parte del ADN operativo de la organización.

### Escala Organizacional

| # | Checkpoint | Responsable | Completado |
|---|-----------|:-----------:|:----------:|
| 55 | Rollout a todos los equipos de desarrollo completado | PM | [ ] |
| 56 | Herramientas de IA integradas en proceso de onboarding de nuevos hires | HR + Tech Lead | [ ] |
| 57 | Múltiples agentes autónomos en producción (testing, docs, code review) | Tech Leads | [ ] |
| 58 | Integración con CI/CD pipeline completa | DevOps | [ ] |
| 59 | Dashboard ejecutivo de IA operativo y revisado por C-suite | PM | [ ] |
| 60 | Presupuesto anual de IA aprobado (no más aprobaciones ad-hoc) | Finance + Sponsor | [ ] |

### Mejora Continua

| # | Checkpoint | Responsable | Completado |
|---|-----------|:-----------:|:----------:|
| 61 | Revisión trimestral de métricas y ROI | PM + Finance | [ ] |
| 62 | Evaluación semestral de nuevas herramientas y modelos | Tech Lead | [ ] |
| 63 | Políticas de governance actualizadas según aprendizajes | Security | [ ] |
| 64 | Comparación con la industria (conferencias, reportes, peers) | CTO/VP Eng | [ ] |
| 65 | Plan de innovación: agentes especializados para el dominio del negocio | Tech Lead + Product | [ ] |
| 66 | Programa de re-skilling continuo para el equipo | HR + Tech Lead | [ ] |

### KPIs de Fase 3

- Adopción >= 80% en toda la organización
- Velocity mejorada 40-55% vs. baseline
- Defect rate reducido 25-40%
- ROI >= 300% acumulado
- Governance maturity level >= 3
- Developer NPS mejorado >= 15 puntos vs. baseline

---

## Checklist de Seguridad y Compliance

> **Fuente:** Capítulo 13. Usar como complemento transversal a todas las fases.

### Prevención de Data Leakage

| # | Control | Prioridad | Implementado |
|---|---------|:---------:|:------------:|
| 67 | DLP configurado para detectar código propietario enviado a APIs externas | Alta | [ ] |
| 68 | Credenciales y secrets excluidos del contexto de agentes | Crítica | [ ] |
| 69 | Datos de clientes (PII) no accesibles por herramientas de IA | Crítica | [ ] |
| 70 | Logs de todas las interacciones con APIs de IA habilitados | Alta | [ ] |
| 71 | Política de retención de datos en vendors de IA revisada | Alta | [ ] |
| 72 | Opción de self-hosted evaluada para datos más sensibles | Media | [ ] |

### Seguridad del Código Generado

| # | Control | Prioridad | Implementado |
|---|---------|:---------:|:------------:|
| 73 | SAST (análisis estático) ejecutado en todo código generado | Alta | [ ] |
| 74 | SCA (análisis de dependencias) integrado en CI/CD | Alta | [ ] |
| 75 | Code review humano obligatorio para cambios en producción | Crítica | [ ] |
| 76 | Escaneo de secrets en commits (GitGuardian/TruffleHog) | Alta | [ ] |
| 77 | Validación de licencias de dependencias sugeridas | Media | [ ] |
| 78 | Tests de penetración incluyen escenarios de código IA | Media | [ ] |

### Compliance Regulatorio

| # | Control | Prioridad | Implementado |
|---|---------|:---------:|:------------:|
| 79 | Evaluación de impacto de IA bajo AI Act (si opera en UE) | Alta | [ ] |
| 80 | Documentación de uso de IA para auditorías (SOC 2, ISO) | Alta | [ ] |
| 81 | Política de propiedad intelectual del código generado definida | Alta | [ ] |
| 82 | Proceso de opt-out para datos de entrenamiento configurado | Media | [ ] |
| 83 | Registro de decisiones automatizadas (para GDPR Art. 22) | Alta (si UE) | [ ] |

---

## Checklist de Gestión del Cambio

> **Fuente:** Capítulo 11. La tecnología es el 30% del desafío; la gestión del cambio es el 70%.

### Comunicación

| # | Acción | Timing | Responsable | Completado |
|---|--------|--------|:-----------:|:----------:|
| 84 | Contextualizar: por qué IA agéntica (visión, no amenaza) | Fase 0 | Sponsor | [ ] |
| 85 | Compartir resultados del piloto de forma transparente | Post Fase 1 | PM | [ ] |
| 86 | Publicar historias de éxito de early adopters | Fase 2 | Champions | [ ] |
| 87 | Comunicar plan de re-skilling y oportunidades de crecimiento | Fase 1-2 | HR + Sponsor | [ ] |
| 88 | Town hall trimestral sobre progreso y visión | Ongoing | Sponsor/CTO | [ ] |

### Capacitación y Desarrollo

| # | Acción | Timing | Responsable | Completado |
|---|--------|--------|:-----------:|:----------:|
| 89 | Workshop inicial de herramientas (4-8 horas por equipo) | Inicio de cada fase | Champions | [ ] |
| 90 | Programa de prompt engineering para todos los niveles | Fase 1-2 | Tech Lead | [ ] |
| 91 | Capacitación en revisión de código generado por IA | Fase 2 | Senior Devs | [ ] |
| 92 | Plan de carrera actualizado con roles emergentes de IA | Fase 2-3 | HR + Tech Lead | [ ] |
| 93 | Evaluación de skills de IA incorporada en performance reviews | Fase 3 | HR | [ ] |

### Gestión de Resistencia

| # | Acción | Responsable | Completado |
|---|--------|:-----------:|:----------:|
| 94 | Identificar y abordar las 3 preocupaciones principales del equipo | PM + tech lead | [ ] |
| 95 | Crear safe space para expresar dudas y temores | HR + Champions | [ ] |
| 96 | Demostrar quick wins visibles en las primeras 2 semanas | Champion | [ ] |
| 97 | No forzar adopción: ofrecer soporte, no mandatos | Tech Lead | [ ] |
| 98 | Reconocer públicamente a early adopters y contribuidores | Sponsor | [ ] |

---

## Checklist de Evaluación Post-Implementación

> **Usar trimestralmente a partir de Fase 2.** Scorecard para presentar a liderazgo.

### Scorecard Trimestral

| Dimensión | Métrica | Baseline | Actual | Target | Status |
|-----------|---------|:--------:|:------:|:------:|:------:|
| **Productividad** | Velocity (story points/sprint) | ___ | ___ | +30% | ___ |
| **Calidad** | Defect rate (bugs/versión) | ___ | ___ | -25% | ___ |
| **Velocidad** | PR cycle time (horas) | ___ | ___ | -40% | ___ |
| **Adopción** | % de devs usando IA diariamente | ___ | ___ | 80% | ___ |
| **Satisfacción** | Developer NPS | ___ | ___ | +15pts | ___ |
| **Costo** | Costo mensual de herramientas IA | ___ | ___ | Budget | ___ |
| **ROI** | ROI acumulado | ___ | ___ | 300%+ | ___ |
| **Seguridad** | Incidentes relacionados con IA | ___ | ___ | 0 | ___ |
| **Governance** | Governance maturity level | ___ | ___ | 3+ | ___ |
| **Onboarding** | Tiempo de ramp-up nuevos devs | ___ | ___ | -50% | ___ |

### Preguntas de Reflexión para el Equipo de Liderazgo

1. ¿Estamos viendo mejoras reales o solo percepciones? ¿Los datos lo confirman?
2. ¿El código generado por IA mantiene los estándares de calidad de la organización?
3. ¿Los equipos se sienten empoderados o amenazados por la IA?
4. ¿La governance es suficiente sin ser un cuello de botella?
5. ¿Estamos capturando aprendizajes y compartiendo mejores prácticas?
6. ¿El ROI justifica la inversión continua? ¿Qué ajustes son necesarios?
7. ¿Estamos preparados para el siguiente nivel de autonomía?

---

## Checklist de Go-Live (para cada nueva herramienta o agente)

### Pre-Lanzamiento

| # | Verificación | Responsable | Completado |
|---|-------------|:-----------:|:----------:|
| 99 | Testing de seguridad completado y aprobado | Security | [ ] |
| 100 | Backup y recovery verificados | DevOps | [ ] |
| 101 | Equipo de soporte capacitado | Champions | [ ] |
| 102 | Comunicación a usuarios preparada y revisada | PM | [ ] |
| 103 | Plan de rollback definido y testeado | DevOps + Tech Lead | [ ] |
| 104 | Kill switch configurado y verificado | Security + DevOps | [ ] |
| 105 | Límites de gasto en APIs configurados | Finance + DevOps | [ ] |

### Día del Lanzamiento

| # | Acción | Responsable | Completado |
|---|--------|:-----------:|:----------:|
| 106 | Monitoreo activo establecido (métricas, logs, costos) | DevOps | [ ] |
| 107 | Equipo de respuesta disponible (on-call) | Tech Lead + Security | [ ] |
| 108 | Canales de escalamiento claros y comunicados | PM | [ ] |
| 109 | Comunicación de lanzamiento enviada | PM | [ ] |
| 110 | Sesión de Q&A o demo en vivo para el equipo | Champion | [ ] |

### Post-Lanzamiento (Primera Semana)

| # | Acción | Responsable | Completado |
|---|--------|:-----------:|:----------:|
| 111 | Revisión diaria de métricas (adopción, errores, costos) | PM + DevOps | [ ] |
| 112 | Atención prioritaria a retroalimentación inmediata | Champions | [ ] |
| 113 | Ajustes rápidos de configuración si es necesario | Tech Lead | [ ] |
| 114 | Documentación de lecciones aprendidas del go-live | PM | [ ] |
| 115 | Celebrar el lanzamiento y reconocer al equipo | Sponsor | [ ] |

---

## Resumen: Los 5 Errores Más Comunes y Cómo Evitarlos

| # | Error | Consecuencia | Prevención |
|---|-------|-------------|------------|
| 1 | **Escalar sin piloto** | Costos altos sin aprendizaje, resistencia | Seguir Crawl/Walk/Run estrictamente |
| 2 | **Medir solo velocidad** | Código rápido pero con bugs, deuda técnica | Medir calidad, seguridad y satisfacción también |
| 3 | **Ignorar governance** | Incidentes de seguridad, pérdida de confianza | Establecer políticas desde Fase 1 |
| 4 | **No gestionar el cambio** | Resistencia, baja adopción, talento desmotivado | Comunicación transparente + plan de re-skilling |
| 5 | **Expectativas irreales** | Decepción del sponsor, cancelación prematura | Comunicar que resultados maduros toman 6-12 meses |

---

*Checklists basados en las mejores prácticas documentadas en los Capítulos 9, 11, 12, 13 y 14 de "Agéntico por Diseño, Tomo I". 115 checkpoints organizados por fase de implementación. Última actualización: Febrero 2026.*
