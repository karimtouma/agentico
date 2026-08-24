# =============================================================================
# Agéntico por Diseño, Tomo I — LaTeX Build Pipeline
# =============================================================================

SHELL := /bin/bash

# Directories (Docker paths - project root mounted at /book)
CONTENT    := /book/content
CHAPTERS   := $(CONTENT)/capitulos
APPENDICES := $(CONTENT)/apendices
OUTPUT     := /book/output
TEMPLATES  := /book/templates
FILTERS    := /book/filters
CLS        := /book/cls
STY        := /book/sty
CONFIG     := /book/config.yml
FIGURAS    := /book/figuras
ILLUSTRATIONS := /book/illustrations

# Source files (ordered)
CHAPTER_FILES := $(CHAPTERS)/00_prefacio.md \
                 $(CHAPTERS)/00a_executive_brief.md \
                 $(CHAPTERS)/01_introduccion.md \
                 $(CHAPTERS)/02_paradigmas.md \
                 $(CHAPTERS)/03_que_es_ia_agentica.md \
                 $(CHAPTERS)/04_por_que_diseñar.md \
                 $(CHAPTERS)/05_sesgos_cognitivos.md \
                 $(CHAPTERS)/06_guia_por_industria.md \
                 $(CHAPTERS)/07_evolucion_tecnica.md \
                 $(CHAPTERS)/08_ecosistema_herramientas.md \
                 $(CHAPTERS)/09_impacto_negocio.md \
                 $(CHAPTERS)/10_cuando_falla.md \
                 $(CHAPTERS)/11_liderando_equipos_ia.md \
                 $(CHAPTERS)/12_estrategia_adopcion.md \
                 $(CHAPTERS)/13_gobernanza_riesgos.md \
                 $(CHAPTERS)/14_futuro_2030.md

APPENDIX_FILES := $(APPENDICES)/A_glosario.md \
                  $(APPENDICES)/B_frameworks_decision.md \
                  $(APPENDICES)/C_checklist_implementacion.md \
                  $(APPENDICES)/D_recursos.md \
                  $(APPENDICES)/E_modelos_mentales.md

ALL_FILES := $(CHAPTER_FILES) $(APPENDIX_FILES)

# Filter chain (order matters!)
# FILTER_FILES mirrors FILTER_CHAIN and exists so the targets below can depend
# on the filters themselves. Keep both lists in sync when adding a filter.
FILTER_FILES := $(wildcard $(FILTERS)/*.lua)
STY_FILES    := $(wildcard $(STY)/*.sty)

FILTER_CHAIN := --lua-filter=$(FILTERS)/meta-strip.lua \
                --lua-filter=$(FILTERS)/figure-transform.lua \
                --lua-filter=$(FILTERS)/code-transform.lua \
                --lua-filter=$(FILTERS)/part-dividers.lua \
                --lua-filter=$(FILTERS)/emoji-transform.lua \
                --lua-filter=$(FILTERS)/checkbox-transform.lua \
                --lua-filter=$(FILTERS)/callout-transform.lua \
                --lua-filter=$(FILTERS)/table-transform.lua \
                --lua-filter=$(FILTERS)/crossref-transform.lua \
                --lua-filter=$(FILTERS)/index-transform.lua \
                --lua-filter=$(FILTERS)/drop-caps.lua \
                --lua-filter=$(FILTERS)/hr-transform.lua

# Markdown reader format (single source of truth)
#   -tex_math_dollars: the book contains no math. Leaving it on makes every
#   unescaped "$" in a price open an inline-math span, which swallows table
#   row separators and corrupts the surrounding cells.
MD_FORMAT := markdown+autolink_bare_uris-tex_math_dollars

# Pandoc options
PANDOC_OPTS := --from $(MD_FORMAT) \
               --pdf-engine=lualatex \
               --pdf-engine-opt=--shell-escape \
               --template=$(TEMPLATES)/book.tex \
               $(FILTER_CHAIN) \
               --top-level-division=chapter \
               --number-sections \
               --no-highlight \
               --toc --toc-depth=3 \
               --metadata-file=$(CONFIG) \
               -V documentclass=paradigma-agentico

# PANDOC_OPTS pins the class options; PANDOC_OPTS_NOCLASS lets a target add its
# own (pandoc accepts -V classoption repeatedly and passes them all through).
PANDOC_OPTS_NOCLASS := $(PANDOC_OPTS)
PANDOC_OPTS         := $(PANDOC_OPTS) -V classoption=twoside

# LuaLaTeX needs to find our .cls and .sty files
export TEXINPUTS := $(CLS):$(STY):

# Output file names
BOOK_PDF    := $(OUTPUT)/agentico-por-diseno.pdf
BOOK_TEX    := $(OUTPUT)/agentico-por-diseno.tex
BOOK_EPUB   := $(OUTPUT)/agentico-por-diseno.epub
DIGITAL_PDF := $(OUTPUT)/agentico-por-diseno-digital.pdf
# =============================================================================
# Targets
# =============================================================================

.PHONY: pdf digital epub latex chapter validate check-content logcheck optimize preview clean docker-build figures help

## Build figures (TikZ → PDF, SVG → PDF)
figures:
	@if [ -d "$(FIGURAS)" ] && { ls $(FIGURAS)/tikz/*.tex 1>/dev/null 2>&1 || ls $(FIGURAS)/svg/*.svg 1>/dev/null 2>&1; }; then \
		bash /book/scripts/build-figures.sh; \
	else \
		echo "  [figures] No figure sources found (OK — using placeholders)"; \
	fi

## Build print-ready PDF (default)
pdf: figures $(BOOK_PDF)

$(BOOK_PDF): $(ALL_FILES) $(TEMPLATES)/book.tex $(CLS)/paradigma-agentico.cls $(FILTER_FILES) $(STY_FILES) $(CONFIG)
	@echo "══════════════════════════════════════════════"
	@echo "  Building: Agéntico por Diseño, Tomo I (PDF)"
	@echo "══════════════════════════════════════════════"
	@mkdir -p $(OUTPUT)
	@echo "  [1/5] Generating LaTeX source..."
	cd $(OUTPUT) && pandoc \
		--from $(MD_FORMAT) \
		--template=$(TEMPLATES)/book.tex \
		$(FILTER_CHAIN) \
		--top-level-division=chapter \
		--number-sections \
		--no-highlight \
		--toc --toc-depth=3 \
		--metadata-file=$(CONFIG) \
		-V documentclass=paradigma-agentico \
		-V classoption=twoside \
		-s -o $(BOOK_TEX) \
		$(ALL_FILES)
	@echo "  [2/5] LuaLaTeX pass 1 (generating .idx + .aux)..."
	cd $(OUTPUT) && lualatex --shell-escape --interaction=nonstopmode $(BOOK_TEX) > /dev/null 2>&1 || true
	@echo "  [3/5] Building analytical index..."
	cd $(OUTPUT) && makeindex agentico-por-diseno.idx 2>/dev/null || echo "    (no index entries yet)"
	@echo "  [4/5] LuaLaTeX pass 2 (resolving refs + index)..."
	cd $(OUTPUT) && lualatex --shell-escape --interaction=nonstopmode $(BOOK_TEX) > /dev/null 2>&1 || true
	@echo "  [5/5] LuaLaTeX pass 3 (final pagination)..."
	cd $(OUTPUT) && lualatex --shell-escape --interaction=nonstopmode $(BOOK_TEX) > /dev/null 2>&1 || true
	@echo ""
	@echo "✓ PDF generated: $(BOOK_PDF)"
	@echo "  Size: $$(du -h $(BOOK_PDF) | cut -f1)"
	@$(MAKE) --no-print-directory logcheck

## Fail the build if the final LuaLaTeX pass reported errors.
##   The three lualatex passes run under --interaction=nonstopmode and their
##   output is discarded, so a broken document still produces a PDF and a
##   zero exit status. This target reads the log the passes leave behind and
##   turns real TeX errors back into a build failure.
##   Escape hatch: make pdf STRICT=0
STRICT ?= 1
logcheck:
	@LOG=$(OUTPUT)/agentico-por-diseno.log; \
	if [ ! -f "$$LOG" ]; then echo "  [logcheck] no log found - skipped"; exit 0; fi; \
	ERRS=$$(grep -c '^!' "$$LOG" || true); \
	MISSING=$$(grep -c 'Missing character' "$$LOG" || true); \
	UNDEF=$$(grep -c 'undefined' "$$LOG" || true); \
	DUP=$$(grep -c 'multiply defined' "$$LOG" || true); \
	OVER=$$(grep -c 'Overfull \\hbox' "$$LOG" || true); \
	echo ""; \
	echo "  ── Build health ──────────────────────────"; \
	printf "    %-24s %s\n" "TeX errors"        "$$ERRS"; \
	printf "    %-24s %s\n" "Missing characters" "$$MISSING"; \
	printf "    %-24s %s\n" "Undefined references" "$$UNDEF"; \
	printf "    %-24s %s\n" "Multiply-defined labels" "$$DUP"; \
	printf "    %-24s %s\n" "Overfull hboxes"    "$$OVER"; \
	echo ""; \
	if [ "$$ERRS" -gt 0 ] || [ "$$MISSING" -gt 0 ] || [ "$$UNDEF" -gt 0 ] || [ "$$DUP" -gt 0 ]; then \
		echo "  ✗ Build is NOT clean. First offending lines:"; \
		grep -n -A3 '^!' "$$LOG" | head -40; \
		grep -n 'Missing character' "$$LOG" | head -5; \
		if [ "$(STRICT)" = "1" ]; then \
			echo ""; echo "  (re-run with STRICT=0 to downgrade this to a warning)"; \
			exit 1; \
		fi; \
	else \
		echo "  ✓ Build is clean (overfull boxes are cosmetic)."; \
	fi

## Generate intermediate .tex for inspection
latex: $(BOOK_TEX)

$(BOOK_TEX): $(ALL_FILES) $(TEMPLATES)/book.tex $(CLS)/paradigma-agentico.cls $(FILTER_FILES) $(STY_FILES) $(CONFIG)
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
	cd $(OUTPUT) && pandoc $(PANDOC_OPTS_NOCLASS) \
		-V classoption=twoside \
		-V classoption=digital \
		-o $(DIGITAL_PDF) \
		$(ALL_FILES)
	@echo "✓ Digital PDF: $(DIGITAL_PDF)"

## Export EPUB
epub:
	@echo "Building EPUB..."
	@mkdir -p $(OUTPUT)
	pandoc --from $(MD_FORMAT) \
		--toc --toc-depth=2 \
		--top-level-division=chapter \
		$(FILTER_CHAIN) \
		--metadata-file=$(CONFIG) \
		-o $(BOOK_EPUB) \
		$(ALL_FILES)
	@echo "✓ EPUB: $(BOOK_EPUB)"

## Validate the manuscript sources (chapters present, no code blocks, no placeholders)
check-content:
	@bash /book/scripts/validate.sh

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
	@echo ""
	@echo "  El PDF esta en latex-pipeline/output/agentico-por-diseno.pdf"
	@echo "  Abrelo desde el host (este target corre dentro del contenedor):"
	@echo "    open latex-pipeline/output/agentico-por-diseno.pdf"

## Clean build artifacts
clean:
	rm -rf $(OUTPUT)/*.pdf $(OUTPUT)/*.tex $(OUTPUT)/*.log \
	       $(OUTPUT)/*.aux $(OUTPUT)/*.toc $(OUTPUT)/*.out \
	       $(OUTPUT)/*.idx $(OUTPUT)/*.ind $(OUTPUT)/*.ilg \
	       $(OUTPUT)/*.lof $(OUTPUT)/*.lot $(OUTPUT)/*.vrb \
	       $(OUTPUT)/*.nav $(OUTPUT)/*.snm $(OUTPUT)/*.bbl $(OUTPUT)/*.blg \
	       $(OUTPUT)/*.fdb_latexmk $(OUTPUT)/*.fls $(OUTPUT)/*.synctex.gz
	@echo "✓ Cleaned output/"

## Rebuild Docker image
docker-build:
	docker compose build --no-cache

## Show help
help:
	@echo ""
	@echo "Agéntico por Diseño, Tomo I — Build Targets"
	@echo "══════════════════════════════════════════════"
	@echo ""
	@echo "  make figures      Build figures (TikZ/SVG → PDF)"
	@echo "  make pdf          Build print-ready PDF (default)"
	@echo "  make digital      Build digital PDF (hyperlinks visible)"
	@echo "  make epub         Export EPUB"
	@echo "  make latex        Generate .tex for inspection"
	@echo "  make chapter CHAP=04  Build single chapter"
	@echo "  make check-content Validate the manuscript sources"
	@echo "  make validate     Check cross-refs and warnings"
	@echo "  make logcheck     Fail if the last build had TeX errors"
	@echo "  make optimize     Analyze typography issues"
	@echo "  make preview      Build + open PDF"
	@echo "  make clean        Remove build artifacts"
	@echo "  make docker-build Rebuild Docker image"
	@echo ""
