# Agentico por Diseno, Tomo I: Tecnologias de la Informacion

Libro de ~570 paginas sobre como disenar organizaciones y equipos de desarrollo de software que operan con agentes autonomos de IA.

## Audiencia

Gerentes y lideres tecnicos (VP Eng, CTO, Tech Leads) que necesitan tomar decisiones estrategicas sobre la adopcion de IA agentica en sus equipos.

## Contenido

**14 capitulos + 5 apendices** organizados en 6 partes:

| Parte | Capitulos | Tema |
|-------|-----------|------|
| I | 0-4 | Contexto Estrategico |
| II | 5-6 | Sesgos y Evidencia |
| III | 7-8 | La Tecnologia |
| IV | 9-10 | Impacto en el Negocio |
| V | 11-12 | Liderazgo y Estrategia |
| VI | 13-14 | Gobernanza y Futuro |

## Principios editoriales

- Sin codigo de programacion - enfocado en estrategia y ROI
- Todas las estadisticas con fuente verificable (Gartner, McKinsey, Snyk, GitHub Research, etc.)
- Cero casos de estudio ficticios - solo datos reales de la industria
- Espanol neutro latinoamericano

## Compilar el PDF

Requiere Docker.

```bash
cd latex-pipeline
docker compose build
docker compose run --rm book make pdf
```

El PDF se genera en `latex-pipeline/output/agentico-por-diseno.pdf`.

## Estructura del repo

```
ingenieria_agentica/
├── capitulos/          # 16 archivos Markdown (prefacio + 14 capitulos)
├── apendices/          # 5 apendices (A-E)
├── figuras/            # Manifest y fuentes de figuras (TikZ, SVG)
├── templates/          # Template para nuevos capitulos
└── BOOK_MASTER.md      # Indice maestro con word counts

latex-pipeline/
├── Dockerfile          # Imagen con Pandoc + LuaLaTeX
├── Makefile            # Build pipeline
├── cls/                # Clase LaTeX del libro
├── sty/                # Paquetes de estilo (callouts, tablas, colores)
├── filters/            # Filtros Lua de Pandoc (12 filtros)
├── fonts/              # Libertinus Serif, Libertinus Sans, Fira Mono
├── templates/          # Templates LaTeX (front/back matter, parts)
├── scripts/            # Scripts de build y validacion
└── output/             # PDF generado (gitignored)

.claude/
├── settings.json       # Permisos para Claude Code
└── skills/             # 5 skills para edicion asistida
    ├── book-build.md       # /build, /preview, /check, /status
    ├── book-writer.md      # /expand, /research, /chapter-outline
    ├── book-editorial.md   # /enrich, /standardize, /stats, /tone-check
    ├── book-quality.md     # /audit, /xref, /roi-check, /lint
    └── book-audit-fixes.md # Reglas anti-regresion (28 fixes documentados)
```

## Contribuir con Claude Code

Este repo esta configurado para trabajar con [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Al abrir el proyecto, Claude tiene acceso a:

- **CLAUDE.md** - Reglas de escritura, estructura, formato editorial
- **Skills** - Comandos como `/build`, `/audit`, `/expand`, `/enrich`
- **Anti-regression rules** - 28 correcciones documentadas de 7 rondas de auditoria

### Flujo de trabajo tipico

```bash
# Clonar y compilar
git clone https://github.com/karimtouma/agentico.git
cd agentico/latex-pipeline
docker compose build
docker compose run --rm book make pdf

# Editar con Claude Code
claude   # desde la raiz del repo
```

Dentro de Claude Code puedes usar:
- `/build` - Compilar el PDF
- `/audit` - Auditar coherencia del libro
- `/expand [capitulo]` - Expandir contenido de un capitulo
- `/enrich [capitulo]` - Agregar elementos editoriales faltantes

## Stack tecnico

- **Contenido**: Markdown con extensiones Pandoc
- **Build**: Docker + Pandoc + LuaLaTeX (3 pasadas)
- **Filtros Lua**: callouts, part dividers, mini TOCs, figuras, indice analitico, drop caps
- **Tipografia**: Libertinus Serif 10pt, Crown Quarto (7.44" x 9.68")
- **Formato workbook**: Margenes anchos (5cm) para anotaciones, paginas de notas entre partes

## Licencia

[Unlicense](LICENSE) - Dominio publico.
