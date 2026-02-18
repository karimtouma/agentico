/**
 * prepare-content.ts
 *
 * Reads all book markdown files and produces a single JSON file
 * suitable for bulk upload to Cloudflare KV.
 *
 * Output: kv-data.json (array of {key, value} pairs)
 *
 * Usage: tsx scripts/prepare-content.ts
 */

import { readFileSync, readdirSync, writeFileSync } from "node:fs";
import { join, basename } from "node:path";

const BOOK_ROOT = join(import.meta.dirname, "../../ingenieria_agentica");
const CHAPTERS_DIR = join(BOOK_ROOT, "capitulos");
const APPENDICES_DIR = join(BOOK_ROOT, "apendices");
const OUTPUT_FILE = join(import.meta.dirname, "../kv-data.json");

interface KVEntry {
  key: string;
  value: string;
}

interface Section {
  heading: string;
  slug: string;
  content: string;
  wordCount: number;
}

interface ChapterMeta {
  id: string;
  file: string;
  title: string;
  sections: { heading: string; slug: string; wordCount: number }[];
  wordCount: number;
}

interface SearchEntry {
  chapter: string;
  section: string;
  heading: string;
  snippet: string;
}

// --- Helpers ---

function slugify(text: string): string {
  return text
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "") // strip diacritics
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "");
}

function wordCount(text: string): number {
  return text.split(/\s+/).filter(Boolean).length;
}

function extractTitle(content: string): string {
  const match = content.match(/^#\s+(.+)/m);
  return match ? match[1].replace(/\{[^}]*\}/g, "").trim() : "Sin titulo";
}

function splitSections(content: string): Section[] {
  const sections: Section[] = [];
  const lines = content.split("\n");
  let currentHeading = "Introduccion";
  let currentSlug = "intro";
  let currentLines: string[] = [];

  for (const line of lines) {
    const h2Match = line.match(/^##\s+(.+)/);
    if (h2Match) {
      // Save previous section
      if (currentLines.length > 0) {
        const text = currentLines.join("\n");
        sections.push({
          heading: currentHeading,
          slug: currentSlug,
          content: text,
          wordCount: wordCount(text),
        });
      }
      currentHeading = h2Match[1].replace(/\{[^}]*\}/g, "").trim();
      currentSlug = slugify(currentHeading);
      currentLines = [];
    } else {
      currentLines.push(line);
    }
  }

  // Last section
  if (currentLines.length > 0) {
    const text = currentLines.join("\n");
    sections.push({
      heading: currentHeading,
      slug: currentSlug,
      content: text,
      wordCount: wordCount(text),
    });
  }

  return sections;
}

function extractSnippet(text: string, maxLength = 200): string {
  // Get first meaningful paragraph (skip blank lines and metadata)
  const lines = text.split("\n").filter((l) => l.trim() && !l.startsWith("#") && !l.startsWith("---") && !l.startsWith(">"));
  const snippet = lines.slice(0, 5).join(" ").replace(/\s+/g, " ").trim();
  return snippet.length > maxLength ? snippet.slice(0, maxLength) + "..." : snippet;
}

// --- Parse glossary from Appendix A ---

interface GlossaryEntry {
  term: string;
  definition: string;
}

function parseGlossary(content: string): GlossaryEntry[] {
  const entries: GlossaryEntry[] = [];
  const lines = content.split("\n");

  for (let i = 0; i < lines.length; i++) {
    // Glossary format: **Term Name (English)**\nDefinition paragraph...
    const boldMatch = lines[i].match(/^\*\*(.+?)\*\*\s*$/);
    if (boldMatch) {
      const term = boldMatch[1].trim();
      const defLines: string[] = [];
      for (let j = i + 1; j < lines.length; j++) {
        if (lines[j].match(/^\*\*.+\*\*\s*$/) || lines[j].match(/^##\s+/)) break;
        defLines.push(lines[j]);
      }
      const definition = defLines.join("\n").trim();
      if (definition) {
        entries.push({ term, definition });
      }
    }
  }

  return entries;
}

// --- Parse frameworks from Appendix B ---

interface Framework {
  id: string;
  name: string;
  content: string;
}

function parseFrameworks(content: string): Framework[] {
  const frameworks: Framework[] = [];
  const lines = content.split("\n");
  let currentName = "";
  let currentId = "";
  let currentLines: string[] = [];

  for (const line of lines) {
    const h2Match = line.match(/^##\s+(.+)/);
    if (h2Match) {
      if (currentName && currentLines.length > 0) {
        frameworks.push({
          id: slugify(currentName),
          name: currentName,
          content: currentLines.join("\n").trim(),
        });
      }
      currentName = h2Match[1].replace(/\{[^}]*\}/g, "").trim();
      const idMatch = currentName.match(/#(\d+)/);
      currentId = idMatch ? `framework-${idMatch[1]}` : slugify(currentName);
      currentLines = [];
    } else {
      currentLines.push(line);
    }
  }

  if (currentName && currentLines.length > 0) {
    frameworks.push({
      id: currentId || slugify(currentName),
      name: currentName,
      content: currentLines.join("\n").trim(),
    });
  }

  return frameworks;
}

// --- Main ---

function main() {
  const kvEntries: KVEntry[] = [];
  const toc: ChapterMeta[] = [];
  const searchIndex: SearchEntry[] = [];

  // Process chapters
  const chapterFiles = readdirSync(CHAPTERS_DIR)
    .filter((f) => f.endsWith(".md"))
    .sort();

  for (const file of chapterFiles) {
    const content = readFileSync(join(CHAPTERS_DIR, file), "utf-8");
    const id = basename(file, ".md").replace(/^\d+_/, (m) => m.replace("_", ""));
    // Extract chapter number: "00_prefacio.md" -> "00", "00a_executive_brief.md" -> "00a"
    const idMatch = file.match(/^(\d+[a-z]?)/);
    const chapterId = idMatch ? idMatch[1] : file.replace(".md", "");

    const title = extractTitle(content);
    const sections = splitSections(content);

    // Full chapter
    kvEntries.push({
      key: `chapters:${chapterId}`,
      value: content,
    });

    // Individual sections
    for (const section of sections) {
      kvEntries.push({
        key: `sections:${chapterId}:${section.slug}`,
        value: section.content,
      });

      // Search index entry
      searchIndex.push({
        chapter: chapterId,
        section: section.slug,
        heading: section.heading,
        snippet: extractSnippet(section.content),
      });
    }

    // TOC entry
    toc.push({
      id: chapterId,
      file,
      title,
      sections: sections.map((s) => ({
        heading: s.heading,
        slug: s.slug,
        wordCount: s.wordCount,
      })),
      wordCount: wordCount(content),
    });
  }

  // Process appendices
  const appendixFiles = readdirSync(APPENDICES_DIR)
    .filter((f) => f.endsWith(".md"))
    .sort();

  for (const file of appendixFiles) {
    const content = readFileSync(join(APPENDICES_DIR, file), "utf-8");
    const letter = file.match(/^([A-E])/)?.[1] || file.charAt(0);
    const appendixId = `appendix-${letter.toLowerCase()}`;
    const title = extractTitle(content);

    kvEntries.push({
      key: `chapters:${appendixId}`,
      value: content,
    });

    const sections = splitSections(content);
    for (const section of sections) {
      searchIndex.push({
        chapter: appendixId,
        section: section.slug,
        heading: section.heading,
        snippet: extractSnippet(section.content),
      });
    }

    toc.push({
      id: appendixId,
      file,
      title,
      sections: sections.map((s) => ({
        heading: s.heading,
        slug: s.slug,
        wordCount: s.wordCount,
      })),
      wordCount: wordCount(content),
    });
  }

  // Glossary (from Appendix A)
  const glossaryContent = readFileSync(join(APPENDICES_DIR, "A_glosario.md"), "utf-8");
  const glossary = parseGlossary(glossaryContent);
  kvEntries.push({
    key: "glossary",
    value: JSON.stringify(glossary),
  });

  // Frameworks (from Appendix B)
  const frameworksContent = readFileSync(join(APPENDICES_DIR, "B_frameworks_decision.md"), "utf-8");
  const frameworks = parseFrameworks(frameworksContent);
  kvEntries.push({
    key: "frameworks",
    value: JSON.stringify(frameworks),
  });

  // TOC
  kvEntries.push({
    key: "toc",
    value: JSON.stringify(toc),
  });

  // Search index
  kvEntries.push({
    key: "search-index",
    value: JSON.stringify(searchIndex),
  });

  // Write output
  writeFileSync(OUTPUT_FILE, JSON.stringify(kvEntries, null, 2));

  // Summary
  const totalWords = toc.reduce((sum, ch) => sum + ch.wordCount, 0);
  const totalSections = searchIndex.length;
  console.log(`Prepared ${kvEntries.length} KV entries:`);
  console.log(`  ${chapterFiles.length} chapters + ${appendixFiles.length} appendices`);
  console.log(`  ${totalSections} searchable sections`);
  console.log(`  ${glossary.length} glossary terms`);
  console.log(`  ${frameworks.length} frameworks`);
  console.log(`  ${totalWords.toLocaleString()} total words`);
  console.log(`Output: ${OUTPUT_FILE}`);
}

main();
