/**
 * Agentico MCP Server
 *
 * Remote MCP server exposing the book "Agentico por Diseno, Tomo I"
 * to AI agents via Cloudflare Workers + KV.
 *
 * Tools: search, read_chapter, get_toc, get_glossary, get_frameworks
 */

import { McpAgent } from "agents/mcp";
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";

interface Env {
  MCP_OBJECT: DurableObjectNamespace;
  BOOK_KV: KVNamespace;
}

// --- Types ---

interface SearchEntry {
  chapter: string;
  section: string;
  heading: string;
  snippet: string;
}

interface ChapterMeta {
  id: string;
  file: string;
  title: string;
  sections: { heading: string; slug: string; wordCount: number }[];
  wordCount: number;
}

interface GlossaryEntry {
  term: string;
  definition: string;
}

interface Framework {
  id: string;
  name: string;
  content: string;
}

// --- MCP Agent ---

export class BookMCP extends McpAgent<Env> {
  server = new McpServer({
    name: "Agentico por Diseno",
    version: "1.0.0",
  });

  async init() {
    // Tool 1: Search across all chapters and appendices
    this.server.tool(
      "search",
      "Search the book by keyword. Returns matching sections with chapter, heading, and snippet.",
      {
        query: z.string().describe("Search query (keywords, concepts, or topics)"),
        limit: z.number().optional().default(10).describe("Max results to return"),
      },
      async ({ query, limit }) => {
        const raw = await this.env.BOOK_KV.get("search-index");
        if (!raw) {
          return { content: [{ type: "text" as const, text: "Search index not available." }] };
        }

        const index: SearchEntry[] = JSON.parse(raw);
        const queryLower = query.toLowerCase();
        const queryTerms = queryLower.split(/\s+/).filter(Boolean);

        // Score each entry: how many query terms match heading + snippet
        const scored = index
          .map((entry) => {
            const text = `${entry.heading} ${entry.snippet}`.toLowerCase();
            const matchCount = queryTerms.filter((term) => text.includes(term)).length;
            return { entry, score: matchCount };
          })
          .filter((s) => s.score > 0)
          .sort((a, b) => b.score - a.score)
          .slice(0, limit);

        if (scored.length === 0) {
          return {
            content: [{ type: "text" as const, text: `No results found for "${query}".` }],
          };
        }

        const results = scored.map((s) => ({
          chapter: s.entry.chapter,
          section: s.entry.section,
          heading: s.entry.heading,
          snippet: s.entry.snippet,
          relevance: s.score,
        }));

        return {
          content: [
            {
              type: "text" as const,
              text: JSON.stringify(results, null, 2),
            },
          ],
        };
      }
    );

    // Tool 2: Read a specific chapter or section
    this.server.tool(
      "read_chapter",
      "Read a full chapter or a specific section. Use get_toc first to discover chapter IDs and section slugs.",
      {
        chapter_id: z
          .string()
          .describe(
            "Chapter ID: '00'-'14' for chapters, '00a' for executive brief, 'appendix-a' through 'appendix-e' for appendices"
          ),
        section: z
          .string()
          .optional()
          .describe("Optional section slug (from get_toc). Omit to read the full chapter."),
      },
      async ({ chapter_id, section }) => {
        const key = section
          ? `sections:${chapter_id}:${section}`
          : `chapters:${chapter_id}`;

        const content = await this.env.BOOK_KV.get(key);

        if (!content) {
          const hint = section
            ? `Section "${section}" not found in chapter "${chapter_id}". Use get_toc to see available sections.`
            : `Chapter "${chapter_id}" not found. Valid IDs: 00, 00a, 01-14, appendix-a through appendix-e.`;
          return { content: [{ type: "text" as const, text: hint }] };
        }

        return { content: [{ type: "text" as const, text: content }] };
      }
    );

    // Tool 3: Get table of contents
    this.server.tool(
      "get_toc",
      "Get the book structure: chapters, sections, and word counts.",
      {
        detail: z
          .enum(["chapters", "full", "appendices"])
          .optional()
          .default("chapters")
          .describe("'chapters' = titles only, 'full' = with sections, 'appendices' = appendices only"),
      },
      async ({ detail }) => {
        const raw = await this.env.BOOK_KV.get("toc");
        if (!raw) {
          return { content: [{ type: "text" as const, text: "TOC not available." }] };
        }

        const toc: ChapterMeta[] = JSON.parse(raw);

        let filtered = toc;
        if (detail === "appendices") {
          filtered = toc.filter((ch) => ch.id.startsWith("appendix-"));
        } else if (detail === "chapters") {
          filtered = toc.filter((ch) => !ch.id.startsWith("appendix-"));
        }

        const output =
          detail === "full"
            ? filtered
            : filtered.map((ch) => ({
                id: ch.id,
                title: ch.title,
                wordCount: ch.wordCount,
                sectionCount: ch.sections.length,
              }));

        return {
          content: [{ type: "text" as const, text: JSON.stringify(output, null, 2) }],
        };
      }
    );

    // Tool 4: Look up glossary terms
    this.server.tool(
      "get_glossary",
      "Look up a term in the book glossary (Appendix A). Returns definition and context.",
      {
        term: z.string().describe("Term to look up (e.g., 'IA agentica', 'MCP', 'RAG')"),
      },
      async ({ term }) => {
        const raw = await this.env.BOOK_KV.get("glossary");
        if (!raw) {
          return { content: [{ type: "text" as const, text: "Glossary not available." }] };
        }

        const glossary: GlossaryEntry[] = JSON.parse(raw);
        const termLower = term.toLowerCase();

        // Exact match first, then partial
        const exact = glossary.find((g) => g.term.toLowerCase() === termLower);
        if (exact) {
          return {
            content: [
              {
                type: "text" as const,
                text: `**${exact.term}**\n\n${exact.definition}`,
              },
            ],
          };
        }

        const partial = glossary.filter(
          (g) =>
            g.term.toLowerCase().includes(termLower) ||
            termLower.includes(g.term.toLowerCase())
        );

        if (partial.length > 0) {
          const results = partial
            .map((g) => `**${g.term}**\n${g.definition}`)
            .join("\n\n---\n\n");
          return { content: [{ type: "text" as const, text: results }] };
        }

        return {
          content: [
            {
              type: "text" as const,
              text: `Term "${term}" not found in glossary. Available terms include: ${glossary
                .slice(0, 20)
                .map((g) => g.term)
                .join(", ")}...`,
            },
          ],
        };
      }
    );

    // Tool 5: Get decision frameworks
    this.server.tool(
      "get_frameworks",
      "Get decision frameworks from Appendix B. Lists all frameworks or reads a specific one by name/ID.",
      {
        name: z
          .string()
          .optional()
          .describe(
            "Framework name or ID to retrieve. Omit to list all available frameworks."
          ),
      },
      async ({ name }) => {
        const raw = await this.env.BOOK_KV.get("frameworks");
        if (!raw) {
          return { content: [{ type: "text" as const, text: "Frameworks not available." }] };
        }

        const frameworks: Framework[] = JSON.parse(raw);

        if (!name) {
          const list = frameworks.map((f) => `- **${f.name}** (id: ${f.id})`).join("\n");
          return {
            content: [
              {
                type: "text" as const,
                text: `Available frameworks (${frameworks.length}):\n\n${list}\n\nUse get_frameworks with a name to read the full framework.`,
              },
            ],
          };
        }

        const nameLower = name.toLowerCase();
        const match = frameworks.find(
          (f) =>
            f.id === nameLower ||
            f.name.toLowerCase().includes(nameLower) ||
            nameLower.includes(f.id)
        );

        if (match) {
          return {
            content: [
              {
                type: "text" as const,
                text: `# ${match.name}\n\n${match.content}`,
              },
            ],
          };
        }

        return {
          content: [
            {
              type: "text" as const,
              text: `Framework "${name}" not found. Use get_frameworks without a name to list all available frameworks.`,
            },
          ],
        };
      }
    );
  }
}

// --- Worker entry point ---

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    const url = new URL(request.url);

    if (url.pathname === "/mcp" || url.pathname === "/mcp/") {
      // Route to MCP Durable Object
      const id = env.MCP_OBJECT.idFromName("book");
      const stub = env.MCP_OBJECT.get(id);
      return stub.fetch(request);
    }

    // Health check / info page
    if (url.pathname === "/" || url.pathname === "/health") {
      return new Response(
        JSON.stringify({
          name: "Agentico por Diseno - MCP Server",
          version: "1.0.0",
          description:
            "Remote MCP server for the book 'Agentico por Diseno, Tomo I: Tecnologias de la Informacion'",
          mcp_endpoint: "/mcp",
          tools: ["search", "read_chapter", "get_toc", "get_glossary", "get_frameworks"],
          license: "Unlicense (public domain)",
          source: "https://github.com/karimtouma/agentico",
        }),
        {
          headers: { "Content-Type": "application/json" },
        }
      );
    }

    return new Response("Not found. MCP endpoint is at /mcp", { status: 404 });
  },
};
