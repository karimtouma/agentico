[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-blue)](LICENSE)
[![Deploy MCP Server](https://github.com/karimtouma/agentico/actions/workflows/deploy-mcp.yml/badge.svg)](https://github.com/karimtouma/agentico/actions/workflows/deploy-mcp.yml)
![134K palabras](https://img.shields.io/badge/palabras-134K-informational)
![14 capitulos](https://img.shields.io/badge/cap%C3%ADtulos-14-informational)
![570+ paginas](https://img.shields.io/badge/p%C3%A1ginas-570%2B-informational)
![5 MCP Tools](https://img.shields.io/badge/MCP_tools-5-green)
![Espanol](https://img.shields.io/badge/idioma-espa%C3%B1ol-yellow)

# Agentico por Diseno

### Tomo I: Tecnologias de la Informacion

> **570+ paginas** sobre como disenar organizaciones y equipos de desarrollo
> de software que operan con agentes autonomos de IA.
>
> Sin codigo. Sin ficcion. Solo datos reales y frameworks de decision.

---

## Contenido

- [Sobre el libro](#sobre-el-libro)
- [Estructura](#estructura)
- [MCP Server](#mcp-server)
- [Compilar el PDF](#compilar-el-pdf)
- [Trabajar con Claude Code](#trabajar-con-claude-code)
- [Stack tecnico](#stack-tecnico)
- [Estructura del repositorio](#estructura-del-repositorio)
- [Contribuir](#contribuir)
- [Licencia](#licencia)

---

## Sobre el libro

**Audiencia**: Gerentes y lideres tecnicos (VP Eng, CTO, Tech Leads) en America Latina que necesitan tomar decisiones estrategicas sobre la adopcion de IA agentica.

**Principios editoriales**:

- Sin codigo de programacion - enfocado en estrategia, ROI y decisiones de liderazgo
- Todas las estadisticas con fuente verificable (Gartner, McKinsey, GitClear, METR, Snyk, GitHub Research, DORA, BCG, Deloitte)
- Cero casos de estudio ficticios - solo datos reales de la industria
- Espanol neutro latinoamericano

**134,000 palabras** organizadas en 14 capitulos + 5 apendices con marcos de decision, checklists de implementacion y un glosario de 65+ terminos.

---

## Estructura

El libro se organiza en **6 partes**:

| Parte | Tema | Capitulos |
|-------|------|-----------|
| I | Contexto Estrategico | Prefacio, Executive Brief, Introduccion, Paradigmas, IA Agentica, Por Que Disenar |
| II | Sesgos y Evidencia | Sesgos Cognitivos, Guia por Industria |
| III | La Tecnologia | Evolucion Tecnica, Ecosistema de Herramientas |
| IV | Impacto en el Negocio | ROI y Justificacion Financiera, Cuando la IA Falla |
| V | Liderazgo y Estrategia | Liderando Equipos, Estrategia de Adopcion |
| VI | Gobernanza y Futuro | Gobernanza y Riesgos, Vision 2026-2030 |

<details>
<summary><strong>Capitulos y apendices completos</strong></summary>

### Parte I: Contexto Estrategico

| # | Titulo | Pags |
|---|--------|------|
| 0 | Prefacio: Por que los lideres deben leer esto ahora | 5 |
| - | Resumen Ejecutivo para el Lider | 10 |
| 1 | El momento de inflexion en desarrollo de software | 15 |
| 2 | De los paradigmas tradicionales al paradigma agentico | 20 |
| 3 | Que es la Inteligencia Artificial Agentica? | 20 |
| 4 | Por Que Disenar, No Solo Adoptar | 20 |

### Parte II: Sesgos y Evidencia

| # | Titulo | Pags |
|---|--------|------|
| 5 | Sesgos Cognitivos en la Era de la IA Agentica | 15 |
| 6 | Guia por Industria: Donde Estan los Quick Wins | 25 |

### Parte III: La Tecnologia

| # | Titulo | Pags |
|---|--------|------|
| 7 | La Evolucion Tecnica Hacia la IA Agentica | 25 |
| 8 | Herramientas, plataformas agenticas e integracion con stack empresarial | 35 |

### Parte IV: Impacto en el Negocio

| # | Titulo | Pags |
|---|--------|------|
| 9 | El Impacto en el Negocio: ROI, TCO y Justificacion Financiera | 35 |
| 10 | Cuando la IA Agentica Falla: Patrones Basados en Datos | 15 |

### Parte V: Liderazgo y Estrategia

| # | Titulo | Pags |
|---|--------|------|
| 11 | Liderando equipos con IA | 20 |
| 12 | Estrategia de adopcion: Roadmap y quick wins | 25 |

### Parte VI: Gobernanza y Futuro

| # | Titulo | Pags |
|---|--------|------|
| 13 | Desafios, riesgos y gobernanza | 20 |
| 14 | Vision a futuro: 2026-2030 | 15 |

### Apendices

| # | Titulo | Pags |
|---|--------|------|
| A | Glosario ejecutivo (65+ terminos) | 6 |
| B | Frameworks de decision (12 frameworks) | 10 |
| C | Checklist de implementacion (115 checkpoints) | 7 |
| D | Recursos y lecturas recomendadas | 6 |
| E | Modelos mentales tecnicos para decisores | 10 |

</details>

---

## MCP Server

> **Lee el libro completo a traves de IA.** Conecta cualquier cliente MCP
> y consulta 134K palabras de contenido sobre estrategia de IA agentica.
>
> **Read the entire book through AI.** Connect any MCP-compatible client
> and query 134K words of agentic AI strategy content.

### Quick Connect

Agrega a la configuracion de tu cliente MCP:

```json
{
  "mcpServers": {
    "agentico": {
      "url": "https://book-mcp.touma.io/mcp"
    }
  }
}
```

Endpoint alternativo: `https://agentico-mcp.karim-cfa.workers.dev/mcp`

### Herramientas disponibles / Available Tools

| Tool | Descripcion | Parametros |
|------|-------------|------------|
| `search` | Busqueda por palabra clave en capitulos y apendices | `query` (string), `limit` (number, default 10) |
| `read_chapter` | Leer un capitulo completo o seccion especifica | `chapter_id` (00-14, 00a, appendix-a..e), `section` (slug opcional) |
| `get_toc` | Estructura del libro: capitulos, secciones, word counts | `detail` (chapters \| full \| appendices) |
| `get_glossary` | Buscar terminos en el glosario de 65+ terminos | `term` (string) |
| `get_frameworks` | Acceder a 12 frameworks de decision del Apendice B | `name` (string opcional, omitir para listar todos) |

### Arquitectura

Cloudflare Workers + Durable Objects + KV. El contenido se indexa en deploy desde el markdown fuente y se sirve via [Model Context Protocol](https://modelcontextprotocol.io). Deploy automatico en cada push a `main` via GitHub Actions.

Ver [mcp-server/README.md](mcp-server/README.md) para documentacion completa.

---

## Compilar el PDF

Requiere [Docker](https://www.docker.com/products/docker-desktop/).

```bash
git clone https://github.com/karimtouma/agentico.git
cd agentico/latex-pipeline
docker compose build        # Primera vez: ~5 min
docker compose run --rm book make pdf
```

El PDF se genera en `latex-pipeline/output/agentico-por-diseno.pdf`.

Pipeline: 3 pasadas de LuaLaTeX, 12 filtros Lua de Pandoc, tipografia Libertinus Serif 10pt en formato Crown Quarto (7.44" x 9.68").

---

## Trabajar con Claude Code

Este repositorio esta optimizado para [Claude Code](https://docs.anthropic.com/en/docs/claude-code) con 5 skill files y reglas anti-regresion de 7 rondas de auditoria.

### Skills principales

| Comando | Accion |
|---------|--------|
| `/build` | Compilar el PDF |
| `/preview [cap]` | Build rapido + abrir PDF |
| `/audit [cap\|all]` | Auditoria completa (estructura, xrefs, tono) |
| `/expand [cap]` | Expandir contenido de un capitulo |
| `/enrich [cap]` | Agregar elementos editoriales faltantes |
| `/stats` | Metricas editoriales completas |
| `/tone-check [cap]` | Analisis de tono, urgencia y balance |
| `/xref` | Validacion de referencias cruzadas |

<details>
<summary><strong>Todos los comandos (25+)</strong></summary>

**Escritura**

| Comando | Accion |
|---------|--------|
| `/expand [capitulo]` | Expandir un capitulo existente |
| `/research [tema]` | Investigar datos actualizados |
| `/chapter-outline [numero]` | Generar outline expandido |

**Calidad**

| Comando | Accion |
|---------|--------|
| `/audit [capitulo\|all]` | Auditoria completa |
| `/xref` | Validacion de referencias cruzadas |
| `/roi-check` | Consistencia de cifras ROI y metricas |
| `/lint` | Verificacion rapida: word count, placeholders |
| `/redundancy` | Detectar stats y secciones repetidas |
| `/shelf-life` | Identificar contenido efimero |
| `/depth-check` | Verificar profundidad de conceptos clave |
| `/case-audit` | Comparar casos de estudio por variedad |

**Editorial**

| Comando | Accion |
|---------|--------|
| `/enrich [capitulo]` | Agregar elementos faltantes |
| `/standardize [capitulo\|all]` | Estandarizar formatos de callouts |
| `/stats` | Metricas editoriales + gravedad referencial |
| `/verify-datos` | Auditar bloques "Dato verificado" |
| `/tone-check [capitulo\|all]` | Urgencia, densidad persuasiva, balance |
| `/voice-check` | Diversidad de voces citadas |
| `/language-check` | Anglicismos inconsistentes y code-switching |

**Build**

| Comando | Accion |
|---------|--------|
| `/build` | Build completo del PDF |
| `/preview [capitulo]` | Build rapido + abrir PDF |
| `/check` | Validar cross-refs y warnings LaTeX |
| `/optimize` | Fix tipografia |
| `/export [formato]` | Exportar a formato alternativo |
| `/status` | Estado del pipeline |

</details>

### Flujo de trabajo

```bash
git clone https://github.com/karimtouma/agentico.git
cd agentico
claude   # Abre Claude Code desde la raiz del repo
```

Claude Code tendra acceso automatico a `CLAUDE.md` (reglas editoriales), 5 skill files, y reglas anti-regresion de 7 rondas de auditoria.

---

## Stack tecnico

| Componente | Tecnologia |
|------------|------------|
| Contenido | Markdown + extensiones Pandoc |
| Build | Docker + Pandoc 3 + LuaLaTeX (3 pasadas) |
| Filtros | 12 filtros Lua (callouts, part dividers, figuras, indice analitico, drop caps) |
| Tipografia | Libertinus Serif 10pt, Libertinus Sans, Fira Mono |
| Formato | Crown Quarto (7.44" x 9.68"), workbook con margenes de 5cm |
| MCP Server | Cloudflare Workers + Durable Objects + KV |
| CI/CD | GitHub Actions (deploy automatico del MCP server) |
| AI | Claude Code con 5 skills y CLAUDE.md |

---

## Estructura del repositorio

```
ingenieria_agentica/
├── capitulos/           # 16 archivos Markdown (prefacio + executive brief + 14 capitulos)
├── apendices/           # 5 apendices (A-E)
├── figuras/             # Manifest y fuentes (TikZ, SVG)
└── BOOK_MASTER.md       # Indice maestro con word counts

latex-pipeline/
├── Dockerfile           # Imagen Docker: Pandoc + LuaLaTeX
├── Makefile             # Build pipeline
├── cls/                 # Clase LaTeX (paradigma-agentico.cls)
├── sty/                 # Paquetes de estilo (4 archivos)
├── filters/             # 12 filtros Lua de Pandoc
├── fonts/               # Libertinus Serif, Libertinus Sans, Fira Mono
├── templates/           # Templates LaTeX (front/back matter)
└── scripts/             # Scripts de build y validacion

mcp-server/
├── src/index.ts         # Cloudflare Worker con 5 tools MCP
├── scripts/             # Preparacion de contenido para KV
└── wrangler.jsonc       # Configuracion de Cloudflare

.claude/
└── skills/              # 5 skills para edicion asistida con Claude Code

.github/
└── workflows/           # CI/CD: deploy automatico del MCP server
```

---

## Contribuir

Las contribuciones son bienvenidas. Areas donde puedes aportar:

- **Correcciones** - Erratas, datos desactualizados, enlaces rotos
- **Traducciones** - El contenido esta en espanol; traducciones a otros idiomas son bienvenidas
- **MCP Server** - Mejoras al servidor MCP (nuevos tools, optimizaciones)
- **Build Pipeline** - Mejoras al pipeline de LaTeX
- **Datos verificados** - Si encuentras una estadistica incorrecta o desactualizada, abre un issue

Por favor abre un [issue](https://github.com/karimtouma/agentico/issues) antes de enviar un PR grande.

---

## Licencia

[Unlicense](LICENSE) - Dominio publico. Usa, copia, modifica y distribuye libremente.
