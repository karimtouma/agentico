# =============================================================================
# El Paradigma Agéntico — LaTeX Build Pipeline
# =============================================================================

SHELL := /bin/bash

# Directories
CONTENT    := /book/content
CHAPTERS   := $(CONTENT)/capitulos
APPENDICES := $(CONTENT)/apendices
OUTPUT     := /book/output
TEMPLATES  := /book/templates
FILTERS    := /book/filters
CLS        := /book/cls
STY        := /book/sty

# Source files (ordered)
CHAPTER_FILES := $(CHAPTERS)/00_prefacio.md \
                 $(CHAPTERS)/00a_executive_brief.md \
                 $(CHAPTERS)/01_introduccion.md \
                 $(CHAPTERS)/02_paradigmas.md \
                 $(CHAPTERS)/03_que_es_ia_agentica.md \
                 $(CHAPTERS)/04_evolucion_tecnica.md \
                 $(CHAPTERS)/05_ecosistema_herramientas.md \
                 $(CHAPTERS)/06_impacto_negocio.md \
                 $(CHAPTERS)/07_caso_fintech_latam.md \
                 $(CHAPTERS)/08_caso_enterprise_global.md \
                 $(CHAPTERS)/09_caso_startup_producto.md \
                 $(CHAPTERS)/10_caso_transformacion_ti.md \
                 $(CHAPTERS)/11_caso_equipo_hibrido.md \
                 $(CHAPTERS)/12_liderando_equipos_ia.md \
                 $(CHAPTERS)/13_estrategia_adopcion.md \
                 $(CHAPTERS)/14_gobernanza_riesgos.md \
                 $(CHAPTERS)/15_futuro_2030.md

APPENDIX_FILES := $(APPENDICES)/A_glosario.md \
                  $(APPENDICES)/B_frameworks_decision.md \
                  $(APPENDICES)/C_checklist_implementacion.md \
                  $(APPENDICES)/D_recursos.md

ALL_FILES := $(CHAPTER_FILES) $(APPENDIX_FILES)

# Filter chain (order matters!)
FILTER_CHAIN := --lua-filter=$(FILTERS)/meta-strip.lua \
                --lua-filter=$(FILTERS)/code-transform.lua \
                --lua-filter=$(FILTERS)/part-dividers.lua \
                --lua-filter=$(FILTERS)/emoji-transform.lua \
                --lua-filter=$(FILTERS)/checkbox-transform.lua \
                --lua-filter=$(FILTERS)/callout-transform.lua \
                --lua-filter=$(FILTERS)/table-transform.lua \
                --lua-filter=$(FILTERS)/crossref-transform.lua \
                --lua-filter=$(FILTERS)/drop-caps.lua \
                --lua-filter=$(FILTERS)/hr-transform.lua

# Pandoc options
PANDOC_OPTS := --pdf-engine=lualatex \
               --template=$(TEMPLATES)/book.tex \
               $(FILTER_CHAIN) \
               --top-level-division=chapter \
               --number-sections \
               --no-highlight \
               --toc --toc-depth=3 \
               --metadata-file=/book/config.yml \
               -V documentclass=paradigma-agentico \
               -V classoption=oneside

# LuaLaTeX needs to find our .cls and .sty files
export TEXINPUTS := $(CLS):$(STY):

# Output file names
BOOK_PDF    := $(OUTPUT)/el-paradigma-agentico.pdf
BOOK_TEX    := $(OUTPUT)/el-paradigma-agentico.tex
BOOK_EPUB   := $(OUTPUT)/el-paradigma-agentico.epub
DIGITAL_PDF := $(OUTPUT)/el-paradigma-agentico-digital.pdf

# =============================================================================
# Targets
# =============================================================================

.PHONY: pdf digital epub latex chapter validate optimize preview clean docker-build help

## Build print-ready PDF (default)
pdf: $(BOOK_PDF)

$(BOOK_PDF): $(ALL_FILES) $(TEMPLATES)/book.tex $(CLS)/paradigma-agentico.cls
	@echo "══════════════════════════════════════════════"
	@echo "  Building: El Paradigma Agéntico (PDF)"
	@echo "══════════════════════════════════════════════"
	@mkdir -p $(OUTPUT)
	cd $(OUTPUT) && pandoc $(PANDOC_OPTS) \
		-o $(BOOK_PDF) \
		$(ALL_FILES)
	@echo ""
	@echo "✓ PDF generated: $(BOOK_PDF)"
	@echo "  Size: $$(du -h $(BOOK_PDF) | cut -f1)"

## Generate intermediate .tex for inspection
latex: $(BOOK_TEX)

$(BOOK_TEX): $(ALL_FILES) $(TEMPLATES)/book.tex
	@echo "Generating LaTeX source..."
	@mkdir -p $(OUTPUT)
	cd $(OUTPUT) && pandoc $(PANDOC_OPTS) \
		-s -o $(BOOK_TEX) \
		$(ALL_FILES)
	@echo "✓ LaTeX source: $(BOOK_TEX)"

## Build single chapter (usage: make chapter CHAP=04)
chapter:
ifndef CHAP
	$(error Usage: make chapter CHAP=04)
endif
	@echo "Building chapter $(CHAP)..."
	@mkdir -p $(OUTPUT)
	@CHAP_FILE=$$(ls $(CHAPTERS)/$(CHAP)_*.md 2>/dev/null | head -1); \
	if [ -z "$$CHAP_FILE" ]; then \
		echo "Error: No chapter file found for CHAP=$(CHAP)"; \
		exit 1; \
	fi; \
	cd $(OUTPUT) && pandoc $(PANDOC_OPTS) \
		-o $(OUTPUT)/chapter-$(CHAP).pdf \
		"$$CHAP_FILE"
	@echo "✓ Chapter PDF: $(OUTPUT)/chapter-$(CHAP).pdf"

## Build digital PDF (colored hyperlinks, no crop marks)
digital:
	@echo "Building digital PDF..."
	@mkdir -p $(OUTPUT)
	cd $(OUTPUT) && pandoc $(PANDOC_OPTS) \
		-V mode=digital \
		-o $(DIGITAL_PDF) \
		$(ALL_FILES)
	@echo "✓ Digital PDF: $(DIGITAL_PDF)"

## Export EPUB
epub:
	@echo "Building EPUB..."
	@mkdir -p $(OUTPUT)
	pandoc --toc --toc-depth=2 \
		--top-level-division=chapter \
		$(FILTER_CHAIN) \
		--metadata-file=/book/config.yml \
		--css=$(TEMPLATES)/epub.css \
		-o $(BOOK_EPUB) \
		$(ALL_FILES) 2>/dev/null || \
	pandoc --toc --toc-depth=2 \
		--top-level-division=chapter \
		$(FILTER_CHAIN) \
		--metadata-file=/book/config.yml \
		-o $(BOOK_EPUB) \
		$(ALL_FILES)
	@echo "✓ EPUB: $(BOOK_EPUB)"

## Validate cross-references, format, and LaTeX warnings
validate: latex
	@echo "══════════════════════════════════════════════"
	@echo "  Validating book..."
	@echo "══════════════════════════════════════════════"
	@echo ""
	@echo "--- Cross-reference check ---"
	@grep -c '\\hyperref' $(BOOK_TEX) 2>/dev/null || echo "  No cross-references found"
	@echo ""
	@echo "--- Undefined references ---"
	@grep -c 'undefined' $(OUTPUT)/*.log 2>/dev/null || echo "  No undefined references"
	@echo ""
	@echo "--- Overfull boxes ---"
	@grep -c 'Overfull' $(OUTPUT)/*.log 2>/dev/null || echo "  No overfull boxes"
	@echo ""
	@echo "--- Underfull boxes ---"
	@grep -c 'Underfull' $(OUTPUT)/*.log 2>/dev/null || echo "  No underfull boxes"
	@echo ""
	@echo "--- LaTeX warnings ---"
	@grep -c 'Warning' $(OUTPUT)/*.log 2>/dev/null || echo "  No warnings"
	@echo ""
	@echo "✓ Validation complete"

## Optimize typography (check for widows, orphans, overflow)
optimize: pdf
	@echo "Analyzing typography..."
	@echo ""
	@echo "--- Overfull hboxes (content exceeding margins) ---"
	@grep 'Overfull \\\\hbox' $(OUTPUT)/*.log 2>/dev/null | head -20 || echo "  None found"
	@echo ""
	@echo "--- Underfull hboxes (loose spacing) ---"
	@grep 'Underfull \\\\hbox' $(OUTPUT)/*.log 2>/dev/null | head -20 || echo "  None found"
	@echo ""
	@echo "--- Underfull vboxes (potential widows/orphans) ---"
	@grep 'Underfull \\\\vbox' $(OUTPUT)/*.log 2>/dev/null | head -20 || echo "  None found"
	@echo ""
	@PAGES=$$(grep -o 'Output written on.*(\([0-9]*\) page' $(OUTPUT)/*.log 2>/dev/null | grep -o '[0-9]* page' | head -1); \
	echo "Total pages: $$PAGES"

## Build and open preview (macOS)
preview: pdf
	@open $(BOOK_PDF) 2>/dev/null || echo "Open $(BOOK_PDF) manually"

## Clean build artifacts
clean:
	rm -rf $(OUTPUT)/*.pdf $(OUTPUT)/*.tex $(OUTPUT)/*.log \
	       $(OUTPUT)/*.aux $(OUTPUT)/*.toc $(OUTPUT)/*.out \
	       $(OUTPUT)/*.fdb_latexmk $(OUTPUT)/*.fls $(OUTPUT)/*.synctex.gz
	@echo "✓ Cleaned output/"

## Rebuild Docker image
docker-build:
	docker compose build --no-cache

## Show help
help:
	@echo ""
	@echo "El Paradigma Agéntico — Build Targets"
	@echo "══════════════════════════════════════════════"
	@echo ""
	@echo "  make pdf          Build print-ready PDF (default)"
	@echo "  make digital      Build digital PDF (hyperlinks visible)"
	@echo "  make epub         Export EPUB"
	@echo "  make latex        Generate .tex for inspection"
	@echo "  make chapter CHAP=04  Build single chapter"
	@echo "  make validate     Check cross-refs and warnings"
	@echo "  make optimize     Analyze typography issues"
	@echo "  make preview      Build + open PDF"
	@echo "  make clean        Remove build artifacts"
	@echo "  make docker-build Rebuild Docker image"
	@echo ""
