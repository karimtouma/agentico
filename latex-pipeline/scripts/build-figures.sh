#!/usr/bin/env bash
# =============================================================================
# build-figures.sh — Compile TikZ and convert SVG figures to PDF
# =============================================================================
# Uses MD5 hash-based caching to avoid recompiling unchanged figures.
#
# Usage: bash build-figures.sh
# Runs inside Docker container with paths relative to /book/
# =============================================================================

set -euo pipefail

# Directories
FIGURAS_DIR="/book/figuras"
TIKZ_DIR="${FIGURAS_DIR}/tikz"
SVG_DIR="${FIGURAS_DIR}/svg"
PDF_DIR="/book/illustrations"
CACHE_DIR="${PDF_DIR}/.cache"
WRAPPER="/book/templates/figure-wrapper.tex"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
compiled=0
cached=0
converted=0
errors=0

# Create directories
mkdir -p "${PDF_DIR}" "${CACHE_DIR}"

echo "────────────────────────────────────────────"
echo "  Building figures..."
echo "────────────────────────────────────────────"

# =============================================================================
# Compile TikZ → PDF
# =============================================================================
if [ -d "${TIKZ_DIR}" ] && ls "${TIKZ_DIR}"/*.tex 1>/dev/null 2>&1; then
    echo ""
    echo "  [TikZ → PDF]"
    for tex_file in "${TIKZ_DIR}"/*.tex; do
        basename=$(basename "${tex_file}" .tex)
        output_pdf="${PDF_DIR}/${basename}.pdf"

        # Compute hash for cache
        current_hash=$(md5sum "${tex_file}" | cut -d' ' -f1)
        cache_file="${CACHE_DIR}/${basename}.md5"

        # Check cache
        if [ -f "${output_pdf}" ] && [ -f "${cache_file}" ]; then
            cached_hash=$(cat "${cache_file}")
            if [ "${current_hash}" = "${cached_hash}" ]; then
                echo "    ✓ ${basename} (cached)"
                cached=$((cached + 1))
                continue
            fi
        fi

        echo -n "    ⟳ ${basename}..."

        # Create temp directory for compilation
        tmpdir=$(mktemp -d)
        trap "rm -rf ${tmpdir}" EXIT

        # Create wrapper with correct figure path
        sed "s|FIGURE_FILE|${tex_file}|g" "${WRAPPER}" > "${tmpdir}/figure.tex"

        # Compile with lualatex
        if cd "${tmpdir}" && \
           TEXINPUTS="/book/cls:/book/sty:${TIKZ_DIR}:" \
           lualatex --shell-escape --interaction=nonstopmode figure.tex \
           >/dev/null 2>&1; then
            cp "${tmpdir}/figure.pdf" "${output_pdf}"
            echo "${current_hash}" > "${cache_file}"
            echo -e " ${GREEN}OK${NC}"
            compiled=$((compiled + 1))
        else
            echo -e " ${RED}FAILED${NC}"
            echo "      See: ${tmpdir}/figure.log"
            errors=$((errors + 1))
        fi

        cd /book
        rm -rf "${tmpdir}"
        trap - EXIT
    done
else
    echo "  [TikZ] No .tex files found in ${TIKZ_DIR}"
fi

# =============================================================================
# Convert SVG → PDF
# =============================================================================
if [ -d "${SVG_DIR}" ] && ls "${SVG_DIR}"/*.svg 1>/dev/null 2>&1; then
    echo ""
    echo "  [SVG → PDF]"
    for svg_file in "${SVG_DIR}"/*.svg; do
        basename=$(basename "${svg_file}" .svg)
        output_pdf="${PDF_DIR}/${basename}.pdf"

        # Compute hash for cache
        current_hash=$(md5sum "${svg_file}" | cut -d' ' -f1)
        cache_file="${CACHE_DIR}/${basename}.md5"

        # Check cache
        if [ -f "${output_pdf}" ] && [ -f "${cache_file}" ]; then
            cached_hash=$(cat "${cache_file}")
            if [ "${current_hash}" = "${cached_hash}" ]; then
                echo "    ✓ ${basename} (cached)"
                cached=$((cached + 1))
                continue
            fi
        fi

        echo -n "    ⟳ ${basename}..."

        # Convert with rsvg-convert
        if rsvg-convert -f pdf -o "${output_pdf}" "${svg_file}" 2>/dev/null; then
            echo "${current_hash}" > "${cache_file}"
            echo -e " ${GREEN}OK${NC}"
            converted=$((converted + 1))
        else
            echo -e " ${RED}FAILED${NC}"
            errors=$((errors + 1))
        fi
    done
else
    echo "  [SVG] No .svg files found in ${SVG_DIR}"
fi

# =============================================================================
# Summary
# =============================================================================
echo ""
echo "────────────────────────────────────────────"
total=$((compiled + converted + cached))
echo "  Figures: ${compiled} compiled, ${converted} converted, ${cached} cached, ${errors} errors"

if [ ${errors} -gt 0 ]; then
    echo -e "  ${RED}⚠ ${errors} figure(s) failed to build${NC}"
    # Don't exit with error — let the book build continue with placeholders
fi

echo "────────────────────────────────────────────"
