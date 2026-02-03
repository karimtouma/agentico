#!/usr/bin/env bash
# =============================================================================
# build.sh — Main build script for El Paradigma Agéntico
# =============================================================================
# Usage:
#   ./scripts/build.sh              # Full PDF build
#   ./scripts/build.sh chapter 07   # Single chapter
#   ./scripts/build.sh digital      # Digital PDF
#   ./scripts/build.sh epub         # EPUB export
#   ./scripts/build.sh latex        # .tex export
#   ./scripts/build.sh clean        # Clean output
#   ./scripts/build.sh status       # Show status
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_DIR="$PROJECT_DIR/output"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
log_ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        log_error "Docker is not running. Please start Docker Desktop."
        exit 1
    fi
}

# Build Docker image if needed
ensure_image() {
    if ! docker compose -f "$PROJECT_DIR/docker-compose.yml" images | grep -q "book"; then
        log_info "Building Docker image (first time)..."
        docker compose -f "$PROJECT_DIR/docker-compose.yml" build
        log_ok "Docker image built."
    fi
}

# Run make target inside Docker
run_make() {
    local target="$1"
    shift
    docker compose -f "$PROJECT_DIR/docker-compose.yml" run --rm book make "$target" "$@"
}

# Show build status
show_status() {
    echo ""
    echo "══════════════════════════════════════════════"
    echo "  El Paradigma Agéntico — Pipeline Status"
    echo "══════════════════════════════════════════════"
    echo ""

    # Docker
    if docker info > /dev/null 2>&1; then
        log_ok "Docker: Running"
    else
        log_error "Docker: Not running"
    fi

    # Image
    if docker compose -f "$PROJECT_DIR/docker-compose.yml" images 2>/dev/null | grep -q "book"; then
        log_ok "Docker image: Built"
    else
        log_warn "Docker image: Not built (run ./scripts/build.sh to build)"
    fi

    # Output files
    echo ""
    echo "Output files:"
    if [ -d "$OUTPUT_DIR" ] && ls "$OUTPUT_DIR"/*.pdf 1>/dev/null 2>&1; then
        for f in "$OUTPUT_DIR"/*.pdf; do
            local size=$(du -h "$f" | cut -f1)
            local date=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$f" 2>/dev/null || stat -c "%y" "$f" 2>/dev/null | cut -d' ' -f1,2 | cut -d'.' -f1)
            echo "  $(basename "$f"): $size ($date)"
        done
    else
        echo "  No PDFs generated yet."
    fi

    # Config
    echo ""
    echo "Configuration:"
    if [ -f "$PROJECT_DIR/config.yml" ]; then
        grep "theme:" "$PROJECT_DIR/config.yml" | head -1
        grep "page_size:" "$PROJECT_DIR/config.yml" | head -1
        grep "mode:" "$PROJECT_DIR/config.yml" | head -1
    fi

    echo ""
}

# Analyze build log for issues
analyze_log() {
    local logfile="$OUTPUT_DIR/el-paradigma-agentico.log"
    if [ ! -f "$logfile" ]; then
        return
    fi

    echo ""
    echo "── Build Analysis ──"

    local overfull=$(grep -c "Overfull" "$logfile" 2>/dev/null || echo "0")
    local underfull=$(grep -c "Underfull" "$logfile" 2>/dev/null || echo "0")
    local warnings=$(grep -c "Warning" "$logfile" 2>/dev/null || echo "0")
    local pages=$(grep -o "Output written on.*([0-9]* page" "$logfile" 2>/dev/null | grep -o '[0-9]* page' | head -1 || echo "unknown")

    echo "  Pages: $pages"
    echo "  Overfull boxes: $overfull"
    echo "  Underfull boxes: $underfull"
    echo "  Warnings: $warnings"

    if [ "$overfull" -gt "10" ]; then
        log_warn "High number of overfull boxes. Run: ./scripts/build.sh optimize"
    fi
}

# Main
case "${1:-pdf}" in
    pdf)
        check_docker
        ensure_image
        log_info "Building print-ready PDF..."
        run_make pdf
        analyze_log
        ;;
    digital)
        check_docker
        ensure_image
        log_info "Building digital PDF..."
        run_make digital
        ;;
    epub)
        check_docker
        ensure_image
        log_info "Building EPUB..."
        run_make epub
        ;;
    latex)
        check_docker
        ensure_image
        log_info "Generating LaTeX source..."
        run_make latex
        ;;
    chapter)
        if [ -z "${2:-}" ]; then
            log_error "Usage: $0 chapter <number> (e.g., $0 chapter 07)"
            exit 1
        fi
        check_docker
        ensure_image
        log_info "Building chapter $2..."
        run_make chapter "CHAP=$2"
        ;;
    validate)
        check_docker
        ensure_image
        log_info "Validating book..."
        run_make validate
        ;;
    optimize)
        check_docker
        ensure_image
        log_info "Analyzing typography..."
        run_make optimize
        ;;
    clean)
        log_info "Cleaning output..."
        rm -rf "$OUTPUT_DIR"/*.pdf "$OUTPUT_DIR"/*.tex "$OUTPUT_DIR"/*.log \
               "$OUTPUT_DIR"/*.aux "$OUTPUT_DIR"/*.toc "$OUTPUT_DIR"/*.out
        log_ok "Cleaned."
        ;;
    rebuild)
        check_docker
        log_info "Rebuilding Docker image..."
        docker compose -f "$PROJECT_DIR/docker-compose.yml" build --no-cache
        log_ok "Image rebuilt."
        ;;
    status)
        show_status
        ;;
    help|--help|-h)
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  pdf        Build print-ready PDF (default)"
        echo "  digital    Build digital PDF (visible hyperlinks)"
        echo "  epub       Export EPUB"
        echo "  latex      Generate .tex source"
        echo "  chapter N  Build single chapter (e.g., chapter 07)"
        echo "  validate   Check cross-refs and warnings"
        echo "  optimize   Analyze typography issues"
        echo "  clean      Remove build artifacts"
        echo "  rebuild    Rebuild Docker image from scratch"
        echo "  status     Show pipeline status"
        echo "  help       Show this help"
        ;;
    *)
        log_error "Unknown command: $1"
        echo "Run '$0 help' for usage."
        exit 1
        ;;
esac
