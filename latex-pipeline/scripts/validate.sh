#!/usr/bin/env bash
# =============================================================================
# validate.sh — Validate book content and build quality
# =============================================================================
# Checks:
#   1. Markdown source consistency (cross-refs, formatting)
#   2. LaTeX build warnings (overfull, underfull, undefined refs)
#   3. Filter effectiveness (callout mapping, table conversion)
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# The script has to work in two layouts. Inside the build container the
# manuscript is bind-mounted at /book/content (see docker-compose.yml); on the
# host it sits next to latex-pipeline/ as ingenieria_agentica/.
if [ -d "$PROJECT_DIR/content" ]; then
    CONTENT_DIR="$PROJECT_DIR/content"
else
    CONTENT_DIR="$(dirname "$PROJECT_DIR")/ingenieria_agentica"
fi
OUTPUT_DIR="$PROJECT_DIR/output"

if [ ! -d "$CONTENT_DIR/capitulos" ]; then
    echo "validate.sh: no encuentro el manuscrito en $CONTENT_DIR" >&2
    exit 2
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

log_section() { echo -e "\n${BLUE}══ $1 ══${NC}"; }
log_ok()      { echo -e "  ${GREEN}✓${NC} $1"; }
log_warn()    { echo -e "  ${YELLOW}⚠${NC} $1"; WARNINGS=$((WARNINGS + 1)); }
log_error()   { echo -e "  ${RED}✗${NC} $1"; ERRORS=$((ERRORS + 1)); }

# =============================================================================
# 1. Source validation
# =============================================================================
log_section "Source Content Validation"

# Check all chapter files exist.
# The book has 00_prefacio, 00a_executive_brief and 01..14. Anything outside
# that set is either a missing chapter or a stray file, and both are worth
# reporting.
EXPECTED_CHAPTERS="00 00a 01 02 03 04 05 06 07 08 09 10 11 12 13 14"
for i in $EXPECTED_CHAPTERS; do
    file=$(ls "$CONTENT_DIR/capitulos/${i}_"*.md 2>/dev/null | head -1 || true)
    if [ -n "$file" ]; then
        log_ok "Chapter $i: $(basename "$file")"
    else
        log_error "Chapter $i: FILE MISSING"
    fi
done

# Any chapter file on disk that is not in the expected set
for file in "$CONTENT_DIR"/capitulos/*.md; do
    [ -e "$file" ] || continue
    prefix=$(basename "$file" | sed -E 's/^([0-9]+[a-z]?)_.*/\1/')
    case " $EXPECTED_CHAPTERS " in
        *" $prefix "*) ;;
        *) log_warn "Unexpected chapter file: $(basename "$file")" ;;
    esac
done

# Check appendix files
for letter in A B C D E; do
    file=$(ls "$CONTENT_DIR/apendices/${letter}_"*.md 2>/dev/null | head -1 || true)
    if [ -n "$file" ]; then
        log_ok "Appendix $letter: $(basename "$file")"
    else
        log_error "Appendix $letter: FILE MISSING"
    fi
done

# Count content
log_section "Content Statistics"
total_words=0
for f in "$CONTENT_DIR"/capitulos/*.md "$CONTENT_DIR"/apendices/*.md; do
    words=$(wc -w < "$f" 2>/dev/null || true)
    words=${words:-0}
    total_words=$((total_words + words))
done
echo "  Total words: $total_words"

# Count blockquotes
blockquotes=$(grep -rc "^> " "$CONTENT_DIR"/capitulos/*.md 2>/dev/null | awk -F: '{sum+=$2} END{print sum+0}' || true)
echo "  Blockquotes: $blockquotes"

# Count tables (lines with |)
tables=$(grep -rc "^|" "$CONTENT_DIR"/capitulos/*.md 2>/dev/null | awk -F: '{sum+=$2} END{print sum+0}' || true)
echo "  Table rows: $tables"

# Check for remaining code blocks (should be 0).
# ```{=latex} blocks are raw LaTeX passthrough used for diagrams and tikz
# figures: they are typesetting, not programming examples, so they do not
# violate the "no code in the book" rule.
code_blocks=$(grep -rh '```' "$CONTENT_DIR"/capitulos/*.md 2>/dev/null | grep -vc '```{=latex}' || true)
if [ "$code_blocks" -gt "0" ]; then
    log_warn "Found $code_blocks code fence markers (book should have no code)"
else
    log_ok "No code blocks found (as expected)"
fi

# Check for placeholder text
placeholders=$(grep -ric '\[PLACEHOLDER\]\|\[TODO\]\|\[INSERT\]\|\[GRÁFICO\]' "$CONTENT_DIR"/capitulos/*.md 2>/dev/null | awk -F: '{sum+=$2} END{print sum+0}' || true)
if [ "$placeholders" -gt "0" ]; then
    log_warn "Found $placeholders placeholder markers"
else
    log_ok "No placeholders found"
fi

# =============================================================================
# 2. Build output validation
# =============================================================================
log_section "Build Output Validation"

LOGFILE="$OUTPUT_DIR/agentico-por-diseno.log"
PDFFILE="$OUTPUT_DIR/agentico-por-diseno.pdf"

if [ ! -f "$PDFFILE" ]; then
    log_warn "No PDF found. Run 'make pdf' first."
else
    size=$(du -h "$PDFFILE" | cut -f1)
    log_ok "PDF exists: $size"
fi

if [ ! -f "$LOGFILE" ]; then
    log_warn "No build log found. Run 'make pdf' first."
else
    # Overfull hboxes
    overfull=$(grep -c "Overfull \\\\hbox" "$LOGFILE" 2>/dev/null || true)
    overfull=${overfull:-0}
    if [ "$overfull" -gt "20" ]; then
        log_warn "Overfull hboxes: $overfull (threshold: 20)"
        echo "    Worst offenders:"
        grep "Overfull \\\\hbox" "$LOGFILE" | sort -t'(' -k2 -rn | head -5 | while read -r line; do
            echo "      $line"
        done
    elif [ "$overfull" -gt "0" ]; then
        log_ok "Overfull hboxes: $overfull (acceptable)"
    else
        log_ok "No overfull hboxes"
    fi

    # Underfull hboxes
    underfull=$(grep -c "Underfull \\\\hbox" "$LOGFILE" 2>/dev/null || true)
    underfull=${underfull:-0}
    if [ "$underfull" -gt "50" ]; then
        log_warn "Underfull hboxes: $underfull (threshold: 50)"
    else
        log_ok "Underfull hboxes: $underfull"
    fi

    # Undefined references
    undef=$(grep -c "undefined" "$LOGFILE" 2>/dev/null || true)
    undef=${undef:-0}
    if [ "$undef" -gt "0" ]; then
        log_warn "Undefined references: $undef"
        grep "undefined" "$LOGFILE" | head -5 | while read -r line; do
            echo "      $line"
        done
    else
        log_ok "No undefined references"
    fi

    # Missing fonts
    missing_fonts=$(grep -c "missing" "$LOGFILE" 2>/dev/null || true)
    missing_fonts=${missing_fonts:-0}
    if [ "$missing_fonts" -gt "0" ]; then
        log_warn "Font issues: $missing_fonts"
    else
        log_ok "No font issues"
    fi

    # Page count
    pages=$(grep -o "Output written on.*([0-9]* page" "$LOGFILE" 2>/dev/null | grep -o '[0-9]* page' | head -1 || echo "unknown")
    echo "  Pages: $pages"
fi

# =============================================================================
# 3. Filter effectiveness
# =============================================================================
log_section "Filter Effectiveness"

TEXFILE="$OUTPUT_DIR/agentico-por-diseno.tex"
if [ ! -f "$TEXFILE" ]; then
    log_warn "No .tex file found. Run 'make latex' to generate."
else
    # Callout environments
    callout_count=$(grep -c '\\begin{resumen-ejecutivo}\|\\begin{reunion-liderazgo}\|\\begin{errores-comunes}\|\\begin{argumento-board}\|\\begin{nota-lideres}\|\\begin{callout-generico}\|\\begin{cita-directa}\|\\begin{ejemplo-practico}' "$TEXFILE" 2>/dev/null || true)
    callout_count=${callout_count:-0}
    echo "  Callout environments: $callout_count"

    # Part dividers
    parts=$(grep -c '\\partdivider' "$TEXFILE" 2>/dev/null || true)
    parts=${parts:-0}
    if [ "$parts" -eq "6" ]; then
        log_ok "Part dividers: $parts (expected 6)"
    else
        log_warn "Part dividers: $parts (expected 6)"
    fi

    # Cross-references
    crossrefs=$(grep -c '\\hyperref\[chap:' "$TEXFILE" 2>/dev/null || true)
    crossrefs=${crossrefs:-0}
    echo "  Cross-references: $crossrefs"

    # Checkbox symbols
    checkboxes=$(grep -c '\\checkbox\|\\checkedbox' "$TEXFILE" 2>/dev/null || true)
    checkboxes=${checkboxes:-0}
    echo "  Checkbox symbols: $checkboxes"

    # FontAwesome icons (emoji replacements)
    fa_icons=$(grep -c '\\fa[A-Z]' "$TEXFILE" 2>/dev/null || true)
    fa_icons=${fa_icons:-0}
    echo "  FontAwesome icons: $fa_icons"

    # Separators
    separators=$(grep -c '\\separator' "$TEXFILE" 2>/dev/null || true)
    separators=${separators:-0}
    echo "  Decorative separators: $separators"
fi

# =============================================================================
# Summary
# =============================================================================
log_section "Summary"
echo ""
if [ "$ERRORS" -gt "0" ]; then
    log_error "Errors: $ERRORS"
fi
if [ "$WARNINGS" -gt "0" ]; then
    log_warn "Warnings: $WARNINGS"
fi
if [ "$ERRORS" -eq "0" ] && [ "$WARNINGS" -eq "0" ]; then
    log_ok "All checks passed!"
fi
echo ""

exit $ERRORS
