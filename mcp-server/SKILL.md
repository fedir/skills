---
name: mcp-server
description: Build Model Context Protocol (MCP) servers that expose tools, resources, and prompts to AI clients (Claude, agents, IDEs). Use when the user asks to build or design an MCP server, expose an API/tool/data source over MCP, mentions @modelcontextprotocol, FastMCP, stdio or streamable-HTTP transport, or wants an agent to connect to their system via MCP.
license: MIT
metadata:
  short-description: Build MCP servers — tools, resources, prompts, transports, auth
  audience: engineers
---

# MCP Server

You build Model Context Protocol servers: programs that expose your tools, data, and prompts to any
MCP-compatible AI client (Claude Desktop/Code, agents, IDEs) over a standard protocol. The judgment
you add — designing a small, well-described capability surface that a model can actually use, and
securing the boundary between an untrusted model and your system.

## When to use

- "Build / design an MCP server", "expose our API / database / tool to an agent over MCP"
- "@modelcontextprotocol", "FastMCP", "MCP tool / resource / prompt", "stdio vs HTTP transport"
- "Let Claude connect to X", "wrap this service as an MCP server"

## Mental model (read first)

MCP is a client–server standard (JSON-RPC based) with three participants:

- **Host** — the AI app the user runs (Claude, an agent, an IDE).
- **Client** — a connector inside the host, one per server, that speaks MCP.
- **Server** — *what you build*: it exposes capabilities to the client.

A server exposes three primitives — know which one fits:

| Primitive | Controlled by | Use for |
|---|---|---|
| **Tools** | the model | Actions/functions the model calls (query, create, send) — the most common |
| **Resources** | the application | Readable data addressed by URI (files, records, docs) the host loads into context |
| **Prompts** | the user | Reusable prompt/workflow templates the user invokes |

Details: `references/concepts.md`.

## Workflow

1. **Decide it should be an MCP server.** MCP is for exposing capabilities to *AI clients* over a
   shared protocol. If only your own code calls it, a plain library/API is simpler.
2. **Design the capability surface** — the few tools/resources/prompts worth exposing, each with a
   clear name and a description that says *when* to use it. See `references/design-and-security.md`.
3. **Pick a transport** — **stdio** for a local server the host launches as a subprocess; **streamable
   HTTP** for a remote/shared server. See `references/concepts.md`.
4. **Implement with the official SDK** (TypeScript `@modelcontextprotocol/sdk`, Python `mcp` /
   FastMCP): register each tool/resource/prompt with a schema and handler. See `references/building.md`.
5. **Handle errors and validate inputs** — the model is an untrusted caller; validate every argument.
6. **Secure the boundary** — auth for remote servers, least privilege, no secret leakage.
7. **Test with the MCP Inspector**, then wire it into a host and try it end to end.

## Principles

- **Small, sharp surface.** Expose a few high-value tools, not a 1:1 dump of every API endpoint. Too
  many tools confuse the model and bloat context.
- **Descriptions are the interface.** The model chooses tools from their names and descriptions —
  write them to say what the tool does *and when to call it*; document every parameter.
- **Right primitive for the job.** Model-invoked action → tool; app-loaded data → resource;
  user-invoked template → prompt. Don't force everything into tools.
- **Treat the caller as untrusted.** Validate/normalize all inputs; scope credentials to the minimum;
  never return secrets. Annotate destructive/irreversible tools so hosts can gate them.
- **Return model-friendly output.** Concise, structured, with clear errors — the result goes back
  into an LLM's context, so keep it relevant and cheap.

## References

- `references/concepts.md` — participants, primitives, transports, protocol lifecycle
- `references/building.md` — building a server with the SDK (tools/resources/prompts, schemas, errors)
- `references/design-and-security.md` — tool design, auth, input validation, safety, testing

## Done when

The server exposes a minimal, well-described set of tools/resources/prompts with validated inputs
and clear errors; uses the right transport; secures the boundary (auth where remote, least
privilege, no secret leakage); and has been verified with the Inspector and a real host.
