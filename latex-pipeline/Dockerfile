FROM --platform=linux/amd64 pandoc/extra:latest

# pandoc/extra includes: Pandoc 3.x + TeX Live (full) + Lua 5.4
# This gives us: lualatex, memoir, tcolorbox, booktabs, fontawesome5, microtype, etc.

RUN apk add --no-cache \
    make \
    bash \
    python3 \
    py3-yaml \
    fontconfig \
    curl

# Install missing TeX Live packages
RUN tlmgr install wrapfig lettrine epigraph pdfcol framed fvextra \
    && tlmgr install babel-spanish hyphen-spanish \
    && tlmgr install tools amsfonts newunicodechar truncate \
    && tlmgr install tabularray ninecolors

# Install custom fonts
COPY fonts/ /usr/share/fonts/custom/
RUN fc-cache -f -v 2>/dev/null || true

# Override pandoc entrypoint so we can run make
ENTRYPOINT []

# Set working directory
WORKDIR /book

# Default command
CMD ["make", "pdf"]
