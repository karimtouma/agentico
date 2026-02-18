---
name: book-build
description: Skills para construir, previsualizar y optimizar el libro "Agéntico por Diseño, Tomo I" en LaTeX via Docker
---

# Skill: Book Build Pipeline

Pipeline de producción editorial LaTeX Dockerizado. Convierte los 20 archivos Markdown del libro a PDF profesional listo para imprenta.

## Prerequisitos

- Docker Desktop debe estar corriendo
- Directorio de trabajo: `/Users/karim/Desktop/book/latex-pipeline`

---

## /build

Build completo del libro PDF dentro de Docker.

**Proceso:**
1. `cd /Users/karim/Desktop/book/latex-pipeline`
2. `docker compose run --rm book make pdf`
3. Output: `latex-pipeline/output/agentico-por-diseno.pdf`
4. Revisar warnings de LaTeX en la salida (overfull hbox, etc.)
5. Reportar: tamaño del PDF, número de páginas, warnings críticos

**Si falla:**
- Revisar logs en `output/*.log`
- Errores comunes: LaTeX undefined control sequence, missing fonts, filter errors
- Reconstruir imagen: `docker compose build --no-cache`

---

## /preview [capitulo]

Build rápido de un solo capítulo o el libro completo y abrirlo.

**Parámetros:**
- Sin parámetro: build completo + abrir PDF
- Con número: solo ese capítulo (ej. `/preview 07`)

**Proceso sin parámetro:**
1. `cd /Users/karim/Desktop/book/latex-pipeline`
2. `docker compose run --rm book make pdf`
3. `open output/agentico-por-diseno.pdf`

**Proceso con capítulo:**
1. `cd /Users/karim/Desktop/book/latex-pipeline`
2. `docker compose run --rm book make chapter CHAP=XX` (donde XX es el número del capítulo)
3. `open output/chapter-XX.pdf`

---

## /check

Validar el libro: cross-references, formato, warnings de LaTeX.

**Proceso:**
1. `cd /Users/karim/Desktop/book/latex-pipeline`
2. `docker compose run --rm book make validate`
3. Analizar la salida y reportar:
   - Referencias rotas o indefinidas
   - Tablas que exceden márgenes (overfull hbox)
   - Overfull/underfull boxes
   - Warnings de LaTeX
4. Sugerir fixes específicos para cada problema encontrado

---

## /optimize

Optimizar tipografía: viudas/huérfanas, page breaks, tablas desbordadas.

**Proceso:**
1. `cd /Users/karim/Desktop/book/latex-pipeline`
2. `docker compose run --rm book make optimize`
3. Analizar el log de LaTeX para:
   - Overfull hboxes (contenido que excede márgenes) — reportar cuáles y en qué página
   - Underfull hboxes (spacing excesivo) — reportar los peores
   - Underfull vboxes (posibles viudas/huérfanas) — reportar páginas
4. Para problemas graves:
   - Insertar `\pagebreak` o `\clearpage` en el markdown fuente donde sea necesario
   - Ajustar tablas anchas añadiendo `\small` o reorganizando columnas
   - Sugerir reescritura de párrafos problemáticos

---

## /theme [nombre]

Cambiar el tema visual del libro.

**Temas disponibles:**
- `modern_blue` (default) — Azules profesionales, ideal para tech
- `corporate_gray` — Grises elegantes, estilo corporativo
- `warm_terracotta` — Terracota cálido, estilo editorial premium

**Proceso:**
1. Leer `/Users/karim/Desktop/book/latex-pipeline/config.yml`
2. Cambiar la línea `theme:` al tema seleccionado
3. Rebuild: `cd /Users/karim/Desktop/book/latex-pipeline && docker compose run --rm book make pdf`
4. Abrir el PDF para mostrar preview

**Para activar el tema en el .cls:**
El tema se aplica editando `sty/pa-colors.sty`. Agregar al inicio del archivo:
- `\setthemecorporategray` para corporate_gray
- `\setthemewarmterracotta` para warm_terracotta
- (modern_blue es el default, no requiere comando)

---

## /export [formato]

Exportar a formato alternativo.

**Formatos disponibles:**
- `pdf` (default) — PDF listo para imprenta
- `digital` — PDF optimizado para pantalla (hyperlinks visibles azules)
- `epub` — Formato EPUB para e-readers
- `latex` — Archivo .tex intermedio para inspección/edición manual

**Proceso:**
1. `cd /Users/karim/Desktop/book/latex-pipeline`
2. `docker compose run --rm book make [formato]`
3. Output en `latex-pipeline/output/`

---

## /illustrations

Generar o regenerar las ilustraciones del libro usando TikZ/LaTeX.

**Tipos de ilustraciones:**
- Portada del libro
- 6 divisores de Parte (I-VI)
- 16 mini-iconos de apertura de capítulo
- 8 iconos para tipos de recuadro

**Proceso:**
1. Las ilustraciones se generan como SVG/PDF usando TikZ dentro de LaTeX
2. Verificar si existen en `latex-pipeline/illustrations/`
3. Si no existen, crear scripts TikZ para generarlas
4. Rebuild del libro para incorporar las ilustraciones

**Nota:** Las ilustraciones son opcionales. El libro se genera correctamente sin ellas.

---

## /status

Estado actual del pipeline y diagnóstico.

**Proceso:**
1. Verificar si Docker está corriendo: `docker info > /dev/null 2>&1`
2. Verificar si la imagen existe: `docker images | grep latex-pipeline`
3. Verificar último build: `ls -la /Users/karim/Desktop/book/latex-pipeline/output/`
4. Leer config actual: `cat /Users/karim/Desktop/book/latex-pipeline/config.yml`
5. Reportar:
   - Estado de Docker (corriendo/no corriendo)
   - Imagen Docker (existe/no existe, tamaño)
   - Último PDF generado (fecha, tamaño, páginas)
   - Config actual (tema, fuentes, tamaño de página)
   - Warnings pendientes del último build

---

## Estructura del Pipeline

```
latex-pipeline/
├── Dockerfile              # Imagen Docker (pandoc/extra + deps)
├── docker-compose.yml      # Orquestación de volúmenes
├── Makefile                # Targets de build
├── config.yml              # Configuración (tema, fuentes, etc.)
├── cls/
│   └── paradigma-agentico.cls  # Clase LaTeX (memoir-based)
├── sty/
│   ├── pa-callouts.sty     # 14 ambientes tcolorbox
│   ├── pa-tables.sty       # Estilos de tablas booktabs
│   ├── pa-typography.sty   # Tipografía y microtype
│   └── pa-colors.sty       # Paleta de colores (3 temas)
├── filters/                # Filtros Lua de Pandoc
│   ├── meta-strip.lua      # Eliminar navegación/metadata
│   ├── part-dividers.lua   # Insertar divisores de Parte
│   ├── callout-transform.lua  # Blockquotes → tcolorbox
│   ├── table-transform.lua    # Tablas → booktabs
│   ├── checkbox-transform.lua # Checkboxes → ☐/☑
│   ├── emoji-transform.lua    # Emojis → FontAwesome
│   ├── crossref-transform.lua # "Capítulo X" → hyperref
│   └── hr-transform.lua      # --- → separador decorativo
├── templates/
│   ├── book.tex            # Template principal Pandoc
│   ├── frontmatter.tex     # Portada, copyright, TOC
│   ├── partpage.tex        # Documentación divisores
│   └── backmatter.tex      # Colofón
├── fonts/                  # Fuentes tipográficas (OTF)
│   ├── LibertinusSerif/
│   ├── LibertinusSans/
│   └── FiraMono/
├── illustrations/          # Ilustraciones (opcional)
├── output/                 # PDFs generados
└── scripts/
    ├── build.sh            # Script de build principal
    └── validate.sh         # Validación de calidad
```
