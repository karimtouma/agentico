# Agéntico por Diseño, Tomo I: Tecnologías de la Información

Libro de ~570 páginas sobre cómo diseñar organizaciones y equipos de desarrollo de software que operan con agentes autónomos de IA.

## Audiencia

Gerentes y líderes técnicos (VP Eng, CTO, Tech Leads) que necesitan tomar decisiones estratégicas sobre la adopción de IA agéntica en sus equipos.

## Contenido

**14 capítulos + 5 apéndices** organizados en 6 partes:

| Parte | Capítulos | Tema |
|-------|-----------|------|
| I | 0-4 | Contexto Estratégico |
| II | 5-6 | Sesgos y Evidencia |
| III | 7-8 | La Tecnología |
| IV | 9-10 | Impacto en el Negocio |
| V | 11-12 | Liderazgo y Estrategia |
| VI | 13-14 | Gobernanza y Futuro |

## Principios editoriales

- Sin código de programación - enfocado en estrategia y ROI
- Todas las estadísticas con fuente verificable (Gartner, McKinsey, Snyk, GitHub Research, etc.)
- Cero casos de estudio ficticios - solo datos reales de la industria
- Español neutro latinoamericano

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
├── capitulos/          # 14 capítulos en Markdown
├── apendices/          # 5 apéndices (A-E)
├── figuras/            # Manifest y fuentes de figuras
└── BOOK_MASTER.md      # Índice maestro

latex-pipeline/
├── Dockerfile          # Imagen con Pandoc + LuaLaTeX
├── Makefile            # Build pipeline
├── cls/                # Clase LaTeX del libro
├── sty/                # Paquetes de estilo (callouts, tablas, colores)
├── filters/            # Filtros Lua de Pandoc
├── templates/          # Templates LaTeX
└── output/             # PDF generado (gitignored)
```

## Stack técnico

- **Contenido**: Markdown con extensiones Pandoc
- **Build**: Docker + Pandoc + LuaLaTeX (3 pasadas)
- **Filtros Lua**: callouts, part dividers, mini TOCs, figuras, índice analítico
- **Tipografía**: Libertinus Serif 10pt, Crown Quarto (7.44" x 9.68")

## Licencia

[Unlicense](LICENSE) - Dominio público.
