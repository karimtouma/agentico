# Agentico MCP Server

[![Deploy MCP Server](https://github.com/karimtouma/agentico/actions/workflows/deploy-mcp.yml/badge.svg)](https://github.com/karimtouma/agentico/actions/workflows/deploy-mcp.yml)

Servidor MCP remoto que expone el libro *Agéntico por Diseño, Tomo I* (142,097 palabras, 16 ficheros de capítulo, 5 apéndices) a agentes de IA vía [Model Context Protocol](https://modelcontextprotocol.io).

**Endpoint público:** `https://book-mcp.touma.io/mcp`
**Fallback:** `https://agentico-mcp.karim-cfa.workers.dev/mcp`

El Worker se llama `agentico-mcp`. Es un Cloudflare Worker con un Durable Object (`BookMCP`) y un namespace KV (`BOOK_KV`, id `4405cb4f8f274dbcb850a395f8f1a9fe`, declarado en `wrangler.jsonc`).

---

## Rutas del Worker

| Path | Respuesta |
|------|-----------|
| `/` y `/health` | JSON de info: nombre, versión, `mcp_endpoint`, lista de tools, licencia, repo |
| `/mcp` | Endpoint MCP (Streamable HTTP; responde `text/event-stream`) |
| `/mcp/` | Se reescribe a `/mcp` antes de delegar al handler del SDK |
| cualquier otro | `404` con cuerpo JSON `{"error":"Not found","mcp_endpoint":"/mcp"}` |

El handler del SDK (`BookMCP.serve("/mcp")`) hace match exacto de path, por eso `/mcp/` necesita reescritura explícita en `src/index.ts`. Los paths desconocidos **no** se delegan al handler MCP a propósito: si se delegaran, contestarían con un error JSON-RPC y un cliente HTTP normal creería que llegó al endpoint correcto.

> **Producción va por detrás de este código.** La tabla describe `src/index.ts` tal como está hoy en el repo. El Worker desplegado en `book-mcp.touma.io` todavía no tiene ni la normalización de `/mcp/` ni el cuerpo de 404 propio: hoy `POST /mcp/` responde `404` y los paths desconocidos devuelven un error JSON-RPC (`{"error":{"code":-32000,"message":"Not found"},...}`) con status 404. El próximo `deploy` alinea ambos. Mientras tanto, usar `/mcp` sin barra final.

Prueba rápida:

```bash
curl -s https://book-mcp.touma.io/health
```

---

## Conectar un cliente MCP

### Claude Code

```bash
claude mcp add --transport http agentico https://book-mcp.touma.io/mcp
```

### Claude Desktop

En `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "agentico": {
      "url": "https://book-mcp.touma.io/mcp"
    }
  }
}
```

### Cursor / Windsurf / otros

Registrar la URL `https://book-mcp.touma.io/mcp` como servidor MCP de tipo HTTP. No hay autenticación: el contenido es de dominio público (Unlicense) y el endpoint es abierto.

### Sin cliente, con curl

Handshake completo en tres llamadas. La sesión vive en el header `mcp-session-id` que devuelve `initialize`:

```bash
SID=$(curl -s -D - -o /dev/null -X POST https://book-mcp.touma.io/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"curl","version":"1"}}}' \
  | grep -i '^mcp-session-id' | tr -d '\r' | cut -d' ' -f2)

curl -s -X POST https://book-mcp.touma.io/mcp \
  -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" \
  -H "mcp-session-id: $SID" \
  -d '{"jsonrpc":"2.0","method":"notifications/initialized"}'

curl -s -X POST https://book-mcp.touma.io/mcp \
  -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" \
  -H "mcp-session-id: $SID" \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_toc","arguments":{"detail":"appendices"}}}'
```

Sin el header `Accept: application/json, text/event-stream` el SDK rechaza la petición.

---

## Tools

Las cinco tools devuelven siempre `content: [{ type: "text", text: ... }]`. `search` y `get_toc` devuelven JSON serializado dentro de ese texto; `read_chapter`, `get_glossary` y `get_frameworks` devuelven markdown.

### `search`

Busca por palabra clave y devuelve secciones con capítulo, heading y snippet.

| Parámetro | Tipo | Requerido | Default | Descripción |
|-----------|------|-----------|---------|-------------|
| `query` | string | sí | - | Palabras clave, conceptos o temas |
| `limit` | number | no | `10` | Máximo de resultados |

**Trampa importante:** el scoring cuenta cuántos términos de la query aparecen en `heading + snippet`. El match es por substring sobre el texto en minúsculas y **no** normaliza acentos, así que `adopcion` no encuentra `adopción` (los `slug` sí van sin acentos: los genera `slugify`, que sí los quita). El snippet lo arma `extractSnippet`: toma las **primeras 5 líneas** de la sección que no estén en blanco y que no empiecen por `#`, `>` ni `---`, las une con espacios y corta a 200 caracteres. Dos consecuencias: **el cuerpo completo de la sección no se indexa** (un término que solo aparece a mitad de sección no lo encuentra `search`), y **los callouts en blockquote nunca entran al índice** - `> **Resumen Ejecutivo**` y `> **Dato verificado:**` quedan fuera por empezar con `>`. Para búsqueda exhaustiva hay que traer la sección con `read_chapter` y filtrar del lado del cliente.

Respuesta real (`{"query":"gobernanza de agentes","limit":2}`), formateada:

```json
[
  {
    "chapter": "03",
    "section": "proyecciones-de-mercado-y-adopcion",
    "heading": "Proyecciones de Mercado y Adopción",
    "snippet": "**Predicción principal:** - **2025:** <5% de aplicaciones empresariales tienen agentes de IA integrados - **2026:** 40% de aplicaciones empresariales tendrán agentes de IA para tareas específicas - **...",
    "relevance": 2
  },
  {
    "chapter": "03",
    "section": "los-limites-y-riesgos-de-ia-agentica-lo-que-debes-saber",
    "heading": "Los Límites y Riesgos de IA Agéntica (Lo Que Debes Saber)",
    "snippet": "**Lo que los agentes hacen bien:** - Tareas bien definidas con reglas claras - Problemas que pueden descomponerse en sub-problemas - Acciones donde puede iterar y ajustar **Lo que NO hacen bien todaví...",
    "relevance": 2
  }
]
```

### `read_chapter`

Lee un capítulo completo o una sección concreta. Devuelve el markdown crudo, tal cual está en el repositorio (incluye los spans `[término]{.idx}` del índice analítico).

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|-----------|-------------|
| `chapter_id` | string | sí | `00`-`14`, `00a` para el resumen ejecutivo, `appendix-a` … `appendix-e` |
| `section` | string | no | Slug de sección (de `get_toc`). Omitir para el capítulo completo |

Resuelve la clave KV `chapters:<id>` o `sections:<id>:<slug>`. Si no existe, devuelve un texto de ayuda, no un error de protocolo.

El primer bloque de cada fichero, el que va antes del primer `##`, se indexa siempre con heading `Introduccion` y slug `intro`.

### `get_toc`

Estructura del libro: capítulos, secciones y conteo de palabras.

| Parámetro | Tipo | Requerido | Default | Descripción |
|-----------|------|-----------|---------|-------------|
| `detail` | enum | no | `chapters` | `chapters`, `full`, `appendices` |

- `chapters`: los 16 ficheros de capítulo (`00`, `00a`, `01`-`14`), con `id`, `title`, `wordCount`, `sectionCount`.
- `appendices`: solo los 5 apéndices, mismo formato reducido.
- `full`: **capítulos y apéndices juntos** (no filtra nada), con el array completo de `sections` de cada uno.

Salida sobre el contenido actual del repo (`{"detail":"appendices"}`), recortada a la primera y la última entrada. El servidor en producción devuelve hoy `2004` para `appendix-e`, porque su KV es de un deploy anterior:

```json
[
  { "id": "appendix-a", "title": "Apéndice A: Glosario Ejecutivo", "wordCount": 4428, "sectionCount": 23 },
  { "id": "appendix-e", "title": "Apéndice E: Modelos Mentales Técnicos para Decisores", "wordCount": 2003, "sectionCount": 8 }
]
```

Los `wordCount` de `get_toc` los calcula `prepare-content.ts` partiendo por espacios en blanco. Sobre el contenido que hay hoy en el repo suman 142,077; `wc -w` sobre los mismos ficheros da 142,097. Esa diferencia de 20 palabras es de método de conteo, no de contenido.

Lo que devuelve el servidor en producción es otra cosa: el KV solo se reindexa en cada deploy, así que los conteos vivos corresponden al último despliegue, no al `main` de hoy. Medido contra `book-mcp.touma.io`, la suma actual es 138,523: el KV desplegado va varios commits por detrás del manuscrito. Si necesitas cifras exactas del contenido actual, corre `npm run prepare-content` y lee `kv-data.json`, o espera al siguiente deploy.

### `get_glossary`

Busca un término en el glosario del Apéndice A. Hoy contiene **91 términos**.

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|-----------|-------------|
| `term` | string | sí | Término a buscar (p. ej. `MCP`, `RAG`, `AI Act`) |

Primero intenta coincidencia exacta y devuelve `**Término**\n\n<definición>`. Si no hay exacta, hace coincidencia parcial bidireccional (`término contiene query` **o** `query contiene término`) y concatena todos los aciertos separados por `---`. Ojo con esa segunda dirección: una query larga puede arrastrar términos cortos no relacionados. Si no hay nada, lista los primeros 20 términos del glosario como pista.

Los términos se parsean del markdown por el patrón `**Término**` en una línea sola, seguido de la definición hasta el siguiente `**…**` o `##`. Si alguien cambia ese formato en `A_glosario.md`, el glosario se vacía en silencio.

### `get_frameworks`

Frameworks de decisión del Apéndice B.

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|-----------|-------------|
| `name` | string | no | Nombre o id del framework. Omitir para listar todos |

Sin `name` devuelve la lista con nombre e id. Hay **13 entradas**: los 12 frameworks numerados más la sección final "Cómo Usar Estos Frameworks", que se parsea como una entrada más porque el parser corta por cada `##` del apéndice.

Los ids son el nombre completo slugificado, con el número delante:

```
1-matriz-de-madurez-de-ia-agentica
2-framework-de-readiness-organizacional
3-scorecard-de-evaluacion-de-herramientas
4-matriz-de-beneficio-vs-complejidad-de-adopcion
5-framework-crawl-walk-run
6-niveles-de-autonomia-de-ia
7-modelo-de-gobernanza-en-tres-niveles
8-governance-maturity-model
9-scorecard-de-madurez-de-equipos-con-ia
10-framework-de-clasificacion-de-riesgo-por-tarea
11-incident-response-plan-para-ia
12-modelo-de-roi-para-adopcion-de-ia-agentica
como-usar-estos-frameworks
```

La búsqueda por `name` acepta id exacto o substring del nombre, así que `get_frameworks({ name: "crawl" })` funciona.

---

## Esquema de claves en KV

`prepare-content.ts` genera hoy **295 entradas**:

| Prefijo / clave | Entradas | Contenido |
|-----------------|----------|-----------|
| `chapters:<id>` | 21 | Markdown completo. 16 capítulos + 5 apéndices |
| `sections:<id>:<slug>` | 270 | Markdown de una sección: todo lo que hay entre dos `##`, **sin** la línea del `##` propio (los `###` internos sí van dentro) |
| `glossary` | 1 | JSON `[{term, definition}]`, 91 términos |
| `frameworks` | 1 | JSON `[{id, name, content}]`, 13 entradas |
| `toc` | 1 | JSON `[{id, file, title, sections[], wordCount}]`, 21 elementos |
| `search-index` | 1 | JSON `[{chapter, section, heading, snippet}]`, 270 elementos |

Los ids de capítulo salen del prefijo numérico del nombre de fichero (`00_prefacio.md` → `00`, `00a_executive_brief.md` → `00a`); los de apéndice, de la letra inicial (`A_glosario.md` → `appendix-a`).

`kv-data.json` es el fichero intermedio (~2 MB) que consume `wrangler kv bulk put`. Está en `.gitignore`: se regenera, no se versiona.

---

## Desarrollo local

```bash
cd mcp-server
npm install
npm run prepare-content   # lee ../ingenieria_agentica/ y escribe kv-data.json
npx wrangler kv bulk put kv-data.json --binding=BOOK_KV --local
npm run dev               # worker local en http://localhost:8787
```

**El cuarto comando es obligatorio y es el que todo el mundo olvida.** `wrangler dev` arranca con un KV local vacío (miniflare, persistido en `.wrangler/state/v3/kv/`), y `npm run upload-kv` sube al KV **remoto**, no al local. Sin ese `--local`, el Worker arranca perfectamente, `/health` responde 200, y las cinco tools contestan con su mensaje de fallback:

- `search` → `Search index not available.`
- `get_toc` → `TOC not available.`
- `get_glossary` → `Glossary not available.`
- `get_frameworks` → `Frameworks not available.`
- `read_chapter` → `Chapter "03" not found. Valid IDs: ...`

Ninguno de esos es un error de protocolo: el cliente MCP ve una respuesta exitosa con texto inútil. El KV local persiste entre arranques, así que basta con hacerlo una vez por cada cambio de contenido.

Endpoint MCP local: `http://localhost:8787/mcp`. Health: `curl http://localhost:8787/health`.

### Scripts de npm

| Script | Comando | Para qué |
|--------|---------|----------|
| `dev` | `wrangler dev` | Worker local |
| `typecheck` | `tsc --noEmit && tsc -p tsconfig.scripts.json` | Chequea `src/` **y** `scripts/` |
| `check` | `typecheck` + `wrangler deploy --dry-run --outdir=dist` | Puerta local antes de hacer push |
| `deploy` | `wrangler deploy` | Despliegue manual |
| `prepare-content` | `tsx scripts/prepare-content.ts` | Genera `kv-data.json` |
| `upload-kv` | `wrangler kv bulk put kv-data.json --binding=BOOK_KV --remote` | Sube al KV de producción |
| `cf-typegen` | `wrangler types` | Regenera tipos de bindings |

Hay **dos** tsconfig a propósito, y por eso `typecheck` invoca `tsc` dos veces: `tsconfig.json` compila `src/` con `@cloudflare/workers-types` (corre en workerd), y `tsconfig.scripts.json` compila `scripts/` con `@types/node` (corre bajo `tsx`, en tu máquina y en CI). No pueden compartir un solo `types`.

**Node >= 20.11** (`engines` en `package.json`). `prepare-content.ts` usa `import.meta.dirname`, que no existe antes de esa versión.

---

## Despliegue

Automático vía GitHub Actions (`.github/workflows/deploy-mcp.yml`) al hacer push a `main` que toque:

- `mcp-server/**`
- `ingenieria_agentica/capitulos/**`
- `ingenieria_agentica/apendices/**`
- `.github/workflows/deploy-mcp.yml`

También se puede lanzar a mano con `workflow_dispatch` desde la [pestaña Actions](https://github.com/karimtouma/agentico/actions/workflows/deploy-mcp.yml).

Pasos del workflow, en orden (todos con `working-directory: mcp-server`):

1. `actions/checkout@v4`
2. `actions/setup-node@v4` con Node 20 y caché de npm apuntando a `mcp-server/package-lock.json`
3. `npm ci`
4. `npm run typecheck`
5. `npx wrangler deploy --dry-run --outdir=dist` - build de verificación, no publica
6. `npx tsx scripts/prepare-content.ts` - genera `kv-data.json` desde el markdown recién checkouteado
7. `cloudflare/wrangler-action@v3` con `kv bulk put kv-data.json --binding=BOOK_KV --remote`
8. `cloudflare/wrangler-action@v3` con `deploy`

El contenido se sube **antes** de publicar el Worker, para que el código nuevo nunca se encuentre un KV viejo.

### Secrets de GitHub requeridos

| Secret | Uso |
|--------|-----|
| `CLOUDFLARE_API_TOKEN` | Token con permisos de Workers y de KV |
| `CLOUDFLARE_ACCOUNT_ID` | Id de la cuenta de Cloudflare |

Son solo esos dos. **`KV_NAMESPACE_ID` fue eliminado** y no debe volver: la subida usa `--binding=BOOK_KV`, que resuelve el namespace desde `wrangler.jsonc`. Cuando el CI pasaba el id por secret, ese id estaba duplicado en dos sitios, y si divergían el fallo era completamente silencioso: `kv bulk put` terminaba en verde escribiendo al namespace equivocado, el Worker seguía leyendo el suyo (vacío) y respondía HTTP 200 a todo, con las cinco tools devolviendo "not available". Una sola fuente de verdad, `wrangler.jsonc`, elimina esa clase de fallo.

---

## Arquitectura

```
push a main (mcp-server/** o contenido del libro)
    │
    ▼
GitHub Actions
    │
    ├─► prepare-content.ts ──► kv-data.json ──► Cloudflare KV (BOOK_KV)
    │      lee ../ingenieria_agentica/                    │
    │      capitulos/ + apendices/                        │
    │                                                     ▼
    └─► wrangler deploy ──────────────► Worker agentico-mcp
                                         Durable Object BookMCP
                                         MCP en /mcp
                                              │
                                              ▼
                                   Clientes MCP (Claude, Cursor, ...)
```

| Componente | Tecnología |
|------------|------------|
| Runtime | Cloudflare Workers + Durable Objects (`nodejs_compat`, compat date 2025-03-10) |
| Estado MCP | Durable Object `BookMCP`, migración `v1` como `new_sqlite_classes` |
| Almacenamiento | Cloudflare KV, indexado en tiempo de despliegue |
| SDK | `agents` (`McpAgent`) + `@modelcontextprotocol/sdk` 1.26.0 |
| Validación | Zod 4 en todos los parámetros de tool |
| Dominio | `book-mcp.touma.io` como custom domain, más `workers.dev` |
| Observabilidad | `observability.enabled: true` en `wrangler.jsonc` |

---

## Ficheros

| Fichero | Qué es |
|---------|--------|
| `src/index.ts` | El Worker entero: clase `BookMCP` con las 5 tools, y el `fetch` que rutea `/`, `/health`, `/mcp` |
| `scripts/prepare-content.ts` | Markdown → `kv-data.json`. Slugify, split por `##`, parseo de glosario y frameworks |
| `wrangler.jsonc` | Bindings, id de KV, custom domain, migración del DO |
| `tsconfig.json` | Typecheck de `src/` (workers-types) |
| `tsconfig.scripts.json` | Typecheck de `scripts/` (node types) |

---

## Sobre el libro

Ver el [README principal](../README.md) para el contenido, el build del PDF y la integración con Claude Code. El libro y este código están bajo Unlicense (dominio público).
