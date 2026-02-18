# Agentico MCP Server

[![Deploy MCP Server](https://github.com/karimtouma/agentico/actions/workflows/deploy-mcp.yml/badge.svg)](https://github.com/karimtouma/agentico/actions/workflows/deploy-mcp.yml)

Remote MCP server that exposes the book *Agentico por Diseno, Tomo I* (134K words, 14 chapters, 5 appendices) to AI agents via the [Model Context Protocol](https://modelcontextprotocol.io).

**Live endpoint:** `https://book-mcp.touma.io/mcp`

---

## Quick Start

### Claude Desktop

Add to `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "agentico": {
      "url": "https://book-mcp.touma.io/mcp"
    }
  }
}
```

### Cursor / Other MCP Clients

Use the endpoint URL:

```
https://book-mcp.touma.io/mcp
```

Fallback: `https://agentico-mcp.karim-cfa.workers.dev/mcp`

---

## Tools

### `search`

Search the book by keyword. Returns matching sections with chapter, heading, and snippet.

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `query` | string | yes | - | Keywords, concepts, or topics to search for |
| `limit` | number | no | 10 | Maximum number of results to return |

Results include relevance scoring based on how many query terms match each section's heading and content.

---

### `read_chapter`

Read a full chapter or a specific section.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `chapter_id` | string | yes | `00`-`14` for chapters, `00a` for executive brief, `appendix-a` through `appendix-e` for appendices |
| `section` | string | no | Section slug from `get_toc`. Omit to read the full chapter. |

**Tip:** Use `get_toc` with `detail: "full"` first to discover available chapter IDs and section slugs.

---

### `get_toc`

Get the book structure: chapters, sections, and word counts.

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `detail` | enum | no | `chapters` | `chapters` = titles and word counts, `full` = with all sections, `appendices` = appendices only |

---

### `get_glossary`

Look up a term in the 65+ term glossary (Appendix A).

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `term` | string | yes | Term to look up (e.g., "IA agentica", "MCP", "RAG", "prompt engineering") |

Supports exact and partial matching. If no exact match is found, returns all terms containing the query.

---

### `get_frameworks`

Access 12 decision frameworks from Appendix B.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `name` | string | no | Framework name or ID. Omit to list all available frameworks. |

---

## Architecture

```
GitHub Actions (on push to main)
    │
    ▼
prepare-content.ts ──► kv-data.json ──► Cloudflare KV
    │                                        │
    reads markdown                           serves content
    from /ingenieria_agentica/               │
                                             ▼
                                 Cloudflare Worker (Durable Object)
                                         │
                                    MCP Protocol
                                    /mcp endpoint
                                         │
                                         ▼
                                  AI Agents & IDEs
                            (Claude, Cursor, Windsurf, etc.)
```

| Component | Technology |
|-----------|------------|
| Runtime | Cloudflare Workers + Durable Objects |
| Storage | Cloudflare KV (content indexed at deploy time) |
| Framework | `agents` SDK + `@modelcontextprotocol/sdk` |
| Validation | Zod schemas for all tool parameters |
| Deploy | GitHub Actions (automatic on content changes) |

---

## Local Development

```bash
cd mcp-server
npm install
npm run prepare-content   # Index book content → kv-data.json
npm run dev               # Start local worker at http://localhost:8787
```

The MCP endpoint will be available at `http://localhost:8787/mcp`.

Health check: `curl http://localhost:8787/health`

---

## Deployment

Deployment is automatic via GitHub Actions when changes are pushed to `main` in:

- `mcp-server/**`
- `ingenieria_agentica/capitulos/**`
- `ingenieria_agentica/apendices/**`

Manual deploy: trigger the workflow from the [Actions tab](https://github.com/karimtouma/agentico/actions/workflows/deploy-mcp.yml).

### Required GitHub Secrets

| Secret | Description |
|--------|-------------|
| `CLOUDFLARE_API_TOKEN` | API token with Workers and KV permissions |
| `CLOUDFLARE_ACCOUNT_ID` | Cloudflare account ID |
| `KV_NAMESPACE_ID` | ID of the `BOOK_KV` namespace |

---

## About the Book

See the [main README](../README.md) for full details about the book content, PDF build instructions, and Claude Code integration.
