% =============================================================================
% paradigma-agentico.cls — Document class for "Agéntico por Diseño, Tomo I"
% Based on memoir class for professional book typesetting
% =============================================================================
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{paradigma-agentico}[2025/01/01 Agentico por Diseno Tomo I book class]

% -----------------------------------------------------------------------------
% Class options
% -----------------------------------------------------------------------------
\newif\ifpa@digital\pa@digitalfalse
\DeclareOption{digital}{\pa@digitaltrue}
\DeclareOption{print}{\pa@digitalfalse}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{memoir}}
\ProcessOptions\relax

% -----------------------------------------------------------------------------
% Base class: memoir
% -----------------------------------------------------------------------------
% 10pt base font: professional publishing standard (O'Reilly uses 10pt)
% openright: chapters always start on recto (odd) pages
\LoadClass[10pt,openright,final]{memoir}

% -----------------------------------------------------------------------------
% Required packages
% -----------------------------------------------------------------------------

% Encoding and language
\RequirePackage{fontspec}
\RequirePackage[spanish,es-tabla]{babel}

% Typography
\RequirePackage{microtype}
\RequirePackage{calc}

% Colors
\RequirePackage[table,dvipsnames,svgnames]{xcolor}

% Graphics and floats
\RequirePackage{graphicx}
\RequirePackage{float}
\RequirePackage{wrapfig}

% Tables
\RequirePackage{booktabs}
\RequirePackage{tabularx}
\RequirePackage{longtable}
\RequirePackage{array}
\RequirePackage{multirow}
\RequirePackage{colortbl}
\RequirePackage{tabularray}
\UseTblrLibrary{booktabs}

% Diagrams
\RequirePackage{tikz}
\usetikzlibrary{positioning, arrows.meta, calc, fit}

% Callout boxes
\RequirePackage[most]{tcolorbox}

% Icons
\RequirePackage{fontawesome5}

% Lists
\RequirePackage{enumitem}

% Verbatim (for code blocks inside tcolorbox)
\RequirePackage{fancyvrb}
% Style fancyvrb line numbers: small, sans-serif, muted gray
\renewcommand{\theFancyVerbLine}{\sffamily\scriptsize\textcolor{pa-midgray}{\arabic{FancyVerbLine}}}

% Truncate long titles in running headers
\RequirePackage[breakall]{truncate}

% Math (for some symbols)
\RequirePackage{amssymb}

% Index (must load before hyperref for clickable page numbers)
\RequirePackage{imakeidx}
\makeindex[columns=2, title=Índice Analítico, intoc]

% Hyperlinks
\RequirePackage{hyperref}
\RequirePackage{bookmark}

% Footnotes
\RequirePackage[bottom,hang]{footmisc}

% Unicode character fallbacks
\RequirePackage{newunicodechar}

% Math symbols (common in text)
\newunicodechar{≈}{$\approx$}
\newunicodechar{≠}{$\neq$}
\newunicodechar{≤}{$\leq$}
\newunicodechar{≥}{$\geq$}

% Arrows
\newunicodechar{↔}{$\leftrightarrow$}
\newunicodechar{↗}{$\nearrow$}

% Check/cross marks
\newunicodechar{✓}{\checkmark}
\newunicodechar{✗}{$\times$}

% Geometric symbols
\newunicodechar{□}{$\square$}
\newunicodechar{▼}{$\blacktriangledown$}

% Emoji-like symbols (fallbacks for chars that survive Lua filter)
\newunicodechar{✅}{\textcolor{pa-success}{\checkmark}}
\newunicodechar{❌}{\textcolor{pa-danger}{$\times$}}
\newunicodechar{⚠}{\textcolor{pa-warning}{$\triangle$}}
\newunicodechar{⭐}{$\star$}
\newunicodechar{📊}{\faChartBar}
\newunicodechar{🔬}{\faMicroscope}
\newunicodechar{🤖}{\faRobot}

% Drop caps - configuración compacta y estable
\RequirePackage{lettrine}
\setcounter{DefaultLines}{2}            % Solo 2 líneas de altura
\renewcommand{\DefaultLoversize}{-0.15} % Letra 15% más pequeña que default
\renewcommand{\DefaultLhang}{0}         % Sin colgado a la izquierda (alineado)
\setlength{\DefaultFindent}{0.4em}      % Margen derecho de la letra capital
\setlength{\DefaultNindent}{0.4em}      % Indentación uniforme línea 2+
\renewcommand{\LettrineFontHook}{\color{pa-primary}\sffamily} % Sans-serif como headers

% Epigraphs
\RequirePackage{epigraph}

% Margin notes for workbook annotations
\RequirePackage{marginnote}
\renewcommand*{\marginfont}{\footnotesize\sffamily\color{pa-midgray}}

% -----------------------------------------------------------------------------
% Page geometry — Crown Quarto trim on letter stock
% Optimized for hardcover binding following Tschichold's principles
% Reference: Butterick's Practical Typography, The Book Designer
% -----------------------------------------------------------------------------
% Stock size: US Letter (for printing)
\setstocksize{11in}{8.5in}
% Trim size: Crown Quarto (7.44 × 9.68 inches = 189 × 246mm)
\settrimmedsize{9.68in}{7.44in}{*}
% Center the trimmed page on the stock
\settrims{0.66in}{0.53in}

% Type block: 21.0cm tall × 13.5cm wide (~68-75 chars/line at 10pt)
% 3cm outer margin for moderate annotation space
\settypeblocksize{21.0cm}{13.5cm}{*}

% Asymmetric margins for hardcover binding (Tschichold-inspired)
% Inner (gutter): 2.2cm - sufficient for case-bound hardcover
% Outer: auto-calculated (~3.0cm) from trim width minus gutter minus type block
\setlrmargins{2.2cm}{*}{*}
% Top: 1.8cm, Bottom: auto-calculated (~2.5cm)
\setulmargins{1.8cm}{*}{*}

\setheadfoot{13pt}{24pt}
\setheaderspaces{*}{11pt}{*}
\checkandfixthelayout[nearest]

% -----------------------------------------------------------------------------
% Color definitions — Modern Blue theme (default)
% Overridden by pa-colors.sty if loaded
% -----------------------------------------------------------------------------
\definecolor{pa-primary}{HTML}{1A5276}
\definecolor{pa-secondary}{HTML}{5D6D7E}
\definecolor{pa-accent}{HTML}{D35400}
\definecolor{pa-light}{HTML}{F4F6F6}
\definecolor{pa-tablehead}{HTML}{E8EAED}
\definecolor{pa-tablealt}{HTML}{F8F9FA}
\definecolor{pa-darktext}{HTML}{2C3E50}
\definecolor{pa-midgray}{HTML}{7F8C8D}
\definecolor{pa-lightgray}{HTML}{F2F3F4}
\definecolor{pa-success}{HTML}{1E8449}
\definecolor{pa-warning}{HTML}{D35400}
\definecolor{pa-danger}{HTML}{922B21}

% -----------------------------------------------------------------------------
% Font configuration — Libertinus Serif/Sans + Fira Mono
% -----------------------------------------------------------------------------
% Libertinus Serif: professional serif with old-style figures, true small caps,
% and proper ligatures. Installed in /book/fonts/ and registered via fc-cache.
\setmainfont{LibertinusSerif-Regular.otf}[
  Path           = /book/fonts/LibertinusSerif/,
  BoldFont       = LibertinusSerif-Bold.otf,
  ItalicFont     = LibertinusSerif-Italic.otf,
  BoldItalicFont = LibertinusSerif-BoldItalic.otf,
  Ligatures      = {TeX, Common},
  Numbers        = OldStyle,
]

% Libertinus Sans: companion sans-serif for headings and UI elements
\setsansfont{LibertinusSans-Regular.otf}[
  Path       = /book/fonts/LibertinusSans/,
  BoldFont   = LibertinusSans-Bold.otf,
  ItalicFont = LibertinusSans-Italic.otf,
  Ligatures  = TeX,
  Numbers    = Lining,
]

% Fira Mono: scaled to match Libertinus x-height
\setmonofont{FiraMono-Regular.otf}[
  Path     = /book/fonts/FiraMono/,
  BoldFont = FiraMono-Bold.otf,
  Scale    = 0.88,
]

% Microtype: optical margin alignment and glyph scaling.
% LuaLaTeX supports protrusion and expansion. Tracking is not supported
% for OpenType fonts under LuaLaTeX (generates warnings).
\microtypesetup{
  protrusion = true,
  expansion  = true,
  tracking   = false,
}

% Hyphenation and tolerance are set in pa-typography.sty (loaded later).
% Line spacing — Based on Butterick's Practical Typography recommendation
% Optimal range: 120-145% of point size. 1.15 (115%) prioritizes density
% Libertinus has generous x-height, so slightly below 120% is acceptable
\setSingleSpace{1.15}
\SingleSpacing

% -----------------------------------------------------------------------------
% Chapter style
% -----------------------------------------------------------------------------
\makechapterstyle{paradigma}{%
  \chapterstyle{default}%
  \renewcommand*{\chapnumfont}{\normalfont\Large\sffamily\bfseries\color{pa-primary}}%
  \renewcommand*{\chaptitlefont}{\normalfont\LARGE\sffamily\bfseries\color{pa-darktext}}%
  \renewcommand*{\chapnamefont}{\normalfont\Large\sffamily\color{pa-midgray}}%
  \renewcommand*{\printchaptername}{}%
  \renewcommand*{\printchapternum}{%
    {\chapnamefont\MakeUppercase{\@chapapp}\enspace}{\chapnumfont\thechapter}%
    \vskip 6pt%
    {\color{pa-primary}\hrule height 2pt}%
    \vskip 12pt%
  }%
  \renewcommand*{\printchaptertitle}[1]{%
    \chaptitlefont ##1%
  }%
  \renewcommand*{\afterchapternum}{}%
  % Reduced from 60pt/36pt for better page density
  \setlength{\beforechapskip}{25pt}%
  \setlength{\afterchapskip}{16pt}%
}
\chapterstyle{paradigma}

% Unnumbered chapter style (for Prefacio)
\makechapterstyle{paradigma-nonumber}{%
  \chapterstyle{paradigma}%
  \renewcommand*{\printchaptername}{}%
  \renewcommand*{\printchapternum}{%
    {\color{pa-primary}\hrule height 2pt}%
    \vskip 10pt%
  }%
}

% -----------------------------------------------------------------------------
% Part page style
% -----------------------------------------------------------------------------
\renewcommand{\partnamefont}{\normalfont\fontsize{14}{18}\selectfont\sffamily\color{pa-midgray}}
\renewcommand{\partnumfont}{\normalfont\fontsize{14}{18}\selectfont\sffamily\bfseries\color{pa-primary}}
\renewcommand{\parttitlefont}{\normalfont\fontsize{24}{30}\selectfont\sffamily\bfseries\color{pa-darktext}}
\renewcommand*{\beforepartskip}{\vspace*{\fill}}
\renewcommand*{\afterpartskip}{\vspace*{\fill}}

% Part page: centered with decorative line
\renewcommand{\printpartname}{\partnamefont\MakeUppercase{\partname}}
\renewcommand{\printpartnum}{\partnumfont\thepart}
\renewcommand{\printparttitle}[1]{%
  \vskip 20pt%
  {\color{pa-primary}\hrule height 2pt}%
  \vskip 15pt%
  \parttitlefont #1%
}

% No chapter on part pages
\aliaspagestyle{part}{empty}

% -----------------------------------------------------------------------------
% Headers and footers
% -----------------------------------------------------------------------------
\makepagestyle{paradigma-page}
% Verso (even): page number left, chapter title in small caps right
\makeevenhead{paradigma-page}{\small\sffamily\thepage}{}{\small\sffamily\textsc{\MakeLowercase{\leftmark}}}
% Recto (odd): section title in italic left, page number right
\makeoddhead{paradigma-page}{\small\sffamily\itshape\rightmark}{}{\small\sffamily\thepage}
\makeevenfoot{paradigma-page}{}{}{}
\makeoddfoot{paradigma-page}{}{}{}

% Horizontal rule under header (refined: 0.3pt)
\makeheadrule{paradigma-page}{\textwidth}{0.3pt}

\pagestyle{paradigma-page}

% Plain page style for chapter openings
\makepagestyle{paradigma-plain}
\makeevenfoot{paradigma-plain}{}{\small\sffamily\thepage}{}
\makeoddfoot{paradigma-plain}{}{\small\sffamily\thepage}{}
\aliaspagestyle{chapter}{paradigma-plain}

% Truncate running headers to fit 11.5cm type block
% Page number + spacing uses ~1.5cm, leaving ~9.5cm for text
\renewcommand*{\chaptermark}[1]{%
  \markboth{\truncate{9cm}{#1}}{}%
}
\renewcommand*{\sectionmark}[1]{%
  \markright{\truncate{9cm}{#1}}%
}

% -----------------------------------------------------------------------------
% Section styles
% -----------------------------------------------------------------------------
\setsecheadstyle{\Large\sffamily\bfseries\color{pa-primary}}
\setsubsecheadstyle{\large\sffamily\bfseries\color{pa-secondary}}
\setsubsubsecheadstyle{\normalsize\sffamily\bfseries\color{pa-darktext}}

% Section numbering depth
\setsecnumdepth{subsection}
\settocdepth{subsection}

% Spacing — Tighter for professional density
\setbeforesecskip{-2.5ex plus -0.8ex minus -0.3ex}
\setaftersecskip{1.0ex plus 0.3ex}
\setbeforesubsecskip{-2.0ex plus -0.6ex minus -0.2ex}
\setaftersubsecskip{0.7ex plus 0.2ex}

% -----------------------------------------------------------------------------
% Table of Contents styling
% -----------------------------------------------------------------------------
\renewcommand{\cftpartfont}{\large\sffamily\bfseries\color{pa-primary}}
\renewcommand{\cftpartpagefont}{\large\sffamily\bfseries\color{pa-primary}}
\renewcommand{\cftchapterfont}{\sffamily\bfseries\color{pa-darktext}}
\renewcommand{\cftchapterpagefont}{\sffamily\bfseries}
\renewcommand{\cftsectionfont}{\sffamily\color{pa-darktext}}
\renewcommand{\cftsectionpagefont}{\sffamily}
\renewcommand{\cftsubsectionfont}{\small\sffamily\color{pa-midgray}}
\renewcommand{\cftsubsectionpagefont}{\small\sffamily\color{pa-midgray}}

% ToC dots
\renewcommand{\cftchapterleader}{\cftdotfill{\cftchapterdotsep}}
\renewcommand{\cftchapterdotsep}{\cftdotsep}

% Part entries in ToC
\cftsetindents{part}{0em}{0em}
\cftsetindents{chapter}{0em}{2em}
\cftsetindents{section}{2em}{2.5em}
\cftsetindents{subsection}{4.5em}{3em}

% Space before parts in ToC
\setlength{\cftbeforepartskip}{2.5em}
\setlength{\cftbeforechapterskip}{0.7em}

% -----------------------------------------------------------------------------
% List styling
% -----------------------------------------------------------------------------
\setlist[itemize]{
  leftmargin=*,
  itemsep=3pt,
  parsep=0pt,
  topsep=4pt,
  label=\textcolor{pa-primary}{\textbullet}
}

\setlist[enumerate]{
  leftmargin=*,
  itemsep=3pt,
  parsep=0pt,
  topsep=4pt
}

\setlist[description]{
  leftmargin=1.2em,
  itemsep=4pt,
  topsep=4pt,
  font=\sffamily\bfseries\color{pa-primary}
}

% Nested lists
\setlist[itemize,2]{label=\textcolor{pa-secondary}{--}}
\setlist[itemize,3]{label=\textcolor{pa-midgray}{\textperiodcentered}}

% -----------------------------------------------------------------------------
% Footnotes
% -----------------------------------------------------------------------------
\setlength{\footnotemargin}{1em}
\renewcommand{\footnoterule}{%
  \kern-3pt%
  {\color{pa-primary}\hrule width 0.35\textwidth height 0.4pt}%
  \kern 3pt%
}

% Reset footnote counter per chapter (memoir handles this by default)

% -----------------------------------------------------------------------------
% Hyperref configuration
% -----------------------------------------------------------------------------
\ifpa@digital
  % Digital mode: visible colored links
  \hypersetup{
    colorlinks=true,
    linkcolor=pa-secondary,
    citecolor=pa-primary,
    urlcolor=pa-secondary,
    bookmarksnumbered=true,
    bookmarksopen=true,
    bookmarksopenlevel=1,
    pdfstartview=FitH
  }
\else
  % Print mode: invisible links
  \hypersetup{
    colorlinks=false,
    hidelinks,
    bookmarksnumbered=true,
    bookmarksopen=true,
    bookmarksopenlevel=1,
    pdfstartview=FitH
  }
\fi

% PDF metadata
\AtBeginDocument{%
  \hypersetup{
    pdftitle={Agéntico por Diseño, Tomo I: Tecnologías de la Información},
    pdfauthor={Karim Touma},
    pdfsubject={IA Agéntica en Ingeniería de Software},
    pdfkeywords={inteligencia artificial, agentes, ingeniería de software, liderazgo, estrategia}
  }%
}

% -----------------------------------------------------------------------------
% Lettrine (Drop caps) configuration
% -----------------------------------------------------------------------------
\renewcommand{\DefaultLoversize}{0.1}
\renewcommand{\DefaultLraise}{0}
\renewcommand{\DefaultLhang}{0.33}
\setcounter{DefaultLines}{3}
\renewcommand{\LettrineFontHook}{\color{pa-primary}\sffamily\bfseries}

% -----------------------------------------------------------------------------
% Custom commands
% -----------------------------------------------------------------------------

% Checkbox symbols
\newcommand{\checkbox}{\textcolor{pa-midgray}{$\square$}}
\newcommand{\checkedbox}{\textcolor{pa-success}{$\boxtimes$}}

% Decorative separator
\newcommand{\separator}{%
  \begin{center}%
    \vspace{0.4em}%
    {\color{pa-midgray}\rule{0.3\textwidth}{0.5pt}}%
    \vspace{0.4em}%
  \end{center}%
}

% Pull quote
\newcommand{\pullquote}[1]{%
  \begin{center}%
    \begin{minipage}{0.85\textwidth}%
      \begin{center}%
        {\Large\color{pa-midgray}\faQuoteLeft}\\[6pt]%
        {\large\itshape\color{pa-darktext}#1}\\[6pt]%
        {\Large\color{pa-midgray}\faQuoteRight}%
      \end{center}%
    \end{minipage}%
  \end{center}%
}

% Part divider page (used by Lua filter)
\newcommand{\partdivider}[2]{%
  \clearpage%
  \thispagestyle{empty}%
  \vspace*{4cm}%
  \begin{center}%
    {\fontsize{12}{16}\selectfont\sffamily\color{pa-midgray}\MakeUppercase{Parte}\enspace}%
    {\fontsize{12}{16}\selectfont\sffamily\bfseries\color{pa-primary}#1}\\[18pt]%
    {\color{pa-primary}\rule{0.3\textwidth}{1.5pt}}\\[18pt]%
    {\fontsize{24}{30}\selectfont\sffamily\bfseries\color{pa-darktext}#2}%
  \end{center}%
  \vspace*{2cm}%
  \clearpage%
}

% Mini Table of Contents (per-chapter, inserted by Lua filter)
\newcommand{\chapterminitoc}[1]{%
  \vspace{6pt}%
  \noindent{\small\sffamily\bfseries\color{pa-midgray}En este capítulo:}%
  \vspace{2pt}%
  \begin{itemize}[leftmargin=1.5em,itemsep=1pt,topsep=2pt,parsep=0pt,label=\textcolor{pa-primary}{\textbullet}]%
    \small\sffamily\color{pa-secondary}%
    #1%
  \end{itemize}%
  \vspace{6pt}%
  {\color{pa-primary}\hrule height 0.4pt}%
  \vspace{10pt}%
}

% Notes page (inserted by Lua filter after part dividers)
\newcount\pa@notelinecount
\newcommand{\notespage}[1]{%
  \clearpage%
  \thispagestyle{empty}%
  \vspace*{1cm}%
  {\centering\fontsize{14}{18}\selectfont\sffamily\bfseries\color{pa-midgray}Mis Notas --- #1\par}%
  \vspace{1cm}%
  \pa@notelinecount=0\relax%
  \loop\ifnum\pa@notelinecount<28%
    \noindent{\color{pa-lightgray}\rule{\textwidth}{0.3pt}}\par\vspace{0.55cm}%
    \advance\pa@notelinecount by 1\relax%
  \repeat%
  \clearpage%
}

% Tight list fix for Pandoc
\providecommand{\tightlist}{%
  \setlength{\itemsep}{0pt}\setlength{\parskip}{0pt}%
}

% Scaling for wide content
\newcommand{\maxwidth}[1]{\ifdim\Gin@nat@width>#1 #1\else\Gin@nat@width\fi}

% Fix for longtable in two-column
\AtBeginEnvironment{longtable}{\small}

% Ensure images don't overflow
\makeatletter
\def\maxwidth#1{\ifdim\Gin@nat@width>#1 #1\else\Gin@nat@width\fi}
\def\maxheight#1{\ifdim\Gin@nat@height>#1 #1\else\Gin@nat@height\fi}
\makeatother

% Fix for Pandoc's \def\LTcaptype{none} — define a dummy 'none' counter
\newcounter{none}

% Fix for Pandoc's code block environments
% code-transform.lua writes verbatim to temp files, reads inside pa-codeblock
\definecolor{pa-codebg}{HTML}{F2F3F5}

\newtcolorbox{pa-codeblock}{
  colback=pa-codebg,
  colframe=pa-codebg,
  coltext=pa-darktext,
  borderline west={2pt}{0pt}{pa-primary},
  arc=0pt,
  boxrule=0pt,
  left=28pt, right=8pt,
  top=6pt, bottom=6pt,
  breakable,
  enhanced,
}

% Fallback: Shaded/Highlighting for Pandoc's native highlighting (if enabled)
\newenvironment{Shaded}{\begin{pa-codeblock}}{\end{pa-codeblock}}
\newenvironment{Highlighting}[1][]{\small\ttfamily}{}

% Inline code styling — subtle highlight for \texttt
\newtcbox{\painlinecode}{
  on line,
  colback=pa-codebg,
  colframe=pa-codebg,
  coltext=pa-darktext,
  arc=1.5pt,
  boxrule=0pt,
  left=2pt, right=2pt,
  top=0pt, bottom=0pt,
  boxsep=1.5pt,
  fontupper=\small\ttfamily,
}
\AtBeginDocument{\let\texttt\painlinecode}
% Pandoc syntax highlighting token commands (no-ops)
\providecommand{\AlertTok}[1]{#1}
\providecommand{\AnnotationTok}[1]{#1}
\providecommand{\AttributeTok}[1]{#1}
\providecommand{\BaseNTok}[1]{#1}
\providecommand{\BuiltInTok}[1]{#1}
\providecommand{\CharTok}[1]{#1}
\providecommand{\CommentTok}[1]{#1}
\providecommand{\CommentVarTok}[1]{#1}
\providecommand{\ConstantTok}[1]{#1}
\providecommand{\ControlFlowTok}[1]{#1}
\providecommand{\DataTypeTok}[1]{#1}
\providecommand{\DecValTok}[1]{#1}
\providecommand{\DocumentationTok}[1]{#1}
\providecommand{\ErrorTok}[1]{#1}
\providecommand{\ExtensionTok}[1]{#1}
\providecommand{\FloatTok}[1]{#1}
\providecommand{\FunctionTok}[1]{#1}
\providecommand{\ImportTok}[1]{#1}
\providecommand{\InformationTok}[1]{#1}
\providecommand{\KeywordTok}[1]{#1}
\providecommand{\NormalTok}[1]{#1}
\providecommand{\OperatorTok}[1]{#1}
\providecommand{\OtherTok}[1]{#1}
\providecommand{\PreprocessorTok}[1]{#1}
\providecommand{\RegionMarkerTok}[1]{#1}
\providecommand{\SpecialCharTok}[1]{#1}
\providecommand{\SpecialStringTok}[1]{#1}
\providecommand{\StringTok}[1]{#1}
\providecommand{\VariableTok}[1]{#1}
\providecommand{\VerbatimStringTok}[1]{#1}
\providecommand{\WarningTok}[1]{#1}

% Fix for Pandoc's CSLReferences
\newlength{\cslhangindent}
\setlength{\cslhangindent}{1.5em}
\newenvironment{CSLReferences}[2]{}{}

% -----------------------------------------------------------------------------
% Widow/orphan control
% -----------------------------------------------------------------------------
\widowpenalty=8000
\clubpenalty=8000
\brokenpenalty=4991
\predisplaypenalty=10000
\postdisplaypenalty=1549
\displaywidowpenalty=1602

% Raggedbottom to avoid excessive spacing
\raggedbottom

\endinput
