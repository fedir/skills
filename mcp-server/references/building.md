# Building an MCP server

Use an **official MCP SDK** — don't hand-roll JSON-RPC. Primary options: TypeScript
(`@modelcontextprotocol/sdk`) and Python (`mcp`, which includes the ergonomic **FastMCP** API). SDKs
also exist for other languages; the shapes below carry over.

## Structure

A server, at minimum:
1. Creates a server instance (name + version).
2. Registers its tools / resources / prompts, each with a schema and a handler.
3. Connects to a transport (stdio or streamable HTTP) and runs.

Keep handlers thin: parse+validate input → do the work (call your real API/DB) → return a
model-friendly result. Put business logic behind the handler, not inside it.

## Python (FastMCP) — the fast path

```python
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("weather")

@mcp.tool()
def get_forecast(city: str, days: int = 1) -> str:
    """Get the weather forecast for a city.

    Args:
        city: City name, e.g. "Paris".
        days: Number of days to forecast (1-7).
    """
    # validate, call your real service, return a concise string/structured result
    return f"{city}: sunny, 21°C for the next {days} day(s)"

@mcp.resource("weather://{city}/current")
def current_conditions(city: str) -> str:
    """Current conditions for a city (readable resource)."""
    return f"{city}: 21°C, clear"

if __name__ == "__main__":
    mcp.run()  # stdio by default
```

FastMCP derives the tool schema from the function signature and the docstring — so **type your
params and write a real docstring**; that text is what the model sees.

## TypeScript

```ts
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

const server = new McpServer({ name: "weather", version: "1.0.0" });

server.registerTool(
  "get_forecast",
  {
    description: "Get the weather forecast for a city. Use when the user asks about weather.",
    inputSchema: { city: z.string(), days: z.number().min(1).max(7).default(1) },
  },
  async ({ city, days }) => {
    // validate, call your service
    return { content: [{ type: "text", text: `${city}: sunny for ${days} day(s)` }] };
  },
);

await server.connect(new StdioServerTransport());
```

Use Zod (TS) / typed signatures (Python) so the input schema is precise — the model relies on it to
call correctly, and it doubles as runtime validation.

## Tool results and errors

- **Return concise, relevant output.** It goes straight into an LLM's context — don't dump giant
  blobs. Prefer structured/text content the model can act on.
- **Report failures as tool errors**, not by crashing the server: return an error result (e.g.
  `isError: true` with a message) so the model can see what went wrong and adapt. Reserve protocol
  exceptions for genuinely malformed requests.
- **Set tool annotations** where they apply (read-only vs destructive/irreversible) so hosts can
  decide what to auto-run vs confirm.

## Resources and prompts

- **Resource:** register a URI (or a template like `db://records/{id}`), and a read handler that
  returns the content + `mimeType`. Use for data the host loads into context.
- **Prompt:** register a name + typed arguments and return the message(s) — a reusable template the
  user invokes.

## Running & transport

- **stdio:** `mcp.run()` / `StdioServerTransport` — the host spawns the process. Configure it in the
  host's MCP config (command + args). **Never write logs to stdout on stdio** — it corrupts the
  JSON-RPC stream; log to stderr or a file.
- **Streamable HTTP:** run the server as a web service using the SDK's HTTP transport, behind auth.
  Use for remote/shared deployments.

For exact, current SDK APIs (method names, HTTP transport setup, auth wiring), check the official
SDK README/docs — the surface evolves.
