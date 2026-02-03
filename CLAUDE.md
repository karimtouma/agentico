# Proyecto: Libro "El Paradigma Agéntico"

## Contexto
Estamos construyendo un libro de 300+ páginas sobre IA agéntica en ingeniería de software.
- **Audiencia**: Gerentes y líderes técnicos (VP Eng, CTO, Tech Leads)
- **Tono**: Profesional, accesible, sin código, enfocado en estrategia y ROI
- **Estructura**: 15 capítulos + 4 apéndices
- **Idioma**: Español neutro latinoamericano

## Reglas de Escritura

### Lo que SÍ incluir:
1. Resumen ejecutivo al inicio de cada capítulo (3-5 bullets)
2. Recuadros "Para tu próxima reunión de liderazgo"
3. Métricas y datos citados con fuente (Gartner, McKinsey, etc.)
4. Frameworks de decisión y matrices
5. Takeaways al final de cada capítulo
6. Preguntas de reflexión para el lector

### Lo que NO incluir:
1. Código de programación (ni siquiera snippets)
2. Jerga técnica sin explicar el "so what" para el negocio
3. Tutoriales paso a paso de herramientas
4. Detalles de implementación técnica

## Estructura de Archivos
```
/ingenieria_agentica/
├── capitulos/
│   ├── 00_prefacio.md
│   ├── 01_introduccion.md
│   ├── 02_paradigmas.md
│   ├── 03_que_es_ia_agentica.md
│   ├── 04_evolucion_tecnica.md
│   ├── 05_ecosistema_herramientas.md
│   ├── 06_impacto_negocio.md
│   ├── 07_caso_fintech_latam.md          (real)
│   ├── 08_caso_enterprise_global.md      (real)
│   ├── 09_caso_startup_producto.md       (ficticio)
│   ├── 10_caso_transformacion_ti.md      (ficticio)
│   ├── 11_caso_equipo_hibrido.md         (ficticio)
│   ├── 12_liderando_equipos_ia.md
│   ├── 13_estrategia_adopcion.md
│   ├── 14_gobernanza_riesgos.md
│   └── 15_futuro_2030.md
├── apendices/
│   ├── A_glosario.md
│   ├── B_frameworks_decision.md
│   ├── C_checklist_implementacion.md
│   └── D_recursos.md
├── templates/
│   └── capitulo_template.md
└── BOOK_MASTER.md
```

## Objetivos de Extensión por Sección

| Parte | Capítulos | Páginas Objetivo |
|-------|-----------|------------------|
| I: Contexto Estratégico | 00-03 | 60 |
| II: Tecnología | 04-05 | 50 |
| III: Impacto Negocio | 06 | 35 |
| IV: Casos de Estudio | 07-11 | 100 |
| V: Liderazgo | 12-13 | 45 |
| VI: Gobernanza y Futuro | 14-15 | 35 |
| Apéndices | A-D | 25 |
| **TOTAL** | | **350** |

## Formato de Casos de Estudio

Cada caso debe incluir:
1. **El Contexto** - Industria, tamaño, desafío
2. **La Decisión** - Por qué IA agéntica, proceso de evaluación
3. **La Implementación** - Fases, obstáculos, cambio cultural
4. **Los Resultados** - Métricas antes/después, ROI
5. **Lecciones para Líderes** - Qué harían diferente

## MCPs Disponibles para Investigación
- `WebSearch` - Datos de mercado, declaraciones de líderes
- `browsermcp` - Navegación de sitios específicos
- `Apify` - Búsqueda de perfiles profesionales

## Comandos Útiles (Skills)
- `/expand [capitulo]` - Expandir un capítulo existente
- `/case-study [real|ficticio] [tema]` - Generar caso de estudio
- `/research [tema]` - Investigar datos actualizados
- `/chapter-outline [numero]` - Generar outline expandido
