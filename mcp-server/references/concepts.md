# MCP concepts

The Model Context Protocol is an open standard for connecting AI applications to external
capabilities. It uses JSON-RPC 2.0 messages over a transport. Learn the participants, the three
server primitives, the transports, and the connection lifecycle.

## Participants

- **Host** — the AI application the user interacts with (Claude Desktop/Code, an agent runtime, an
  IDE plugin). It manages one or more clients.
- **Client** — a connector living inside the host, maintaining a **1:1 connection with one server**.
- **Server** — the program you build. It advertises capabilities and responds to the client's
  requests. A server can be local (a subprocess) or remote (a web service).

The model never talks to your server directly — the host mediates. Your server offers capabilities;
the host decides when to surface a tool to the model, load a resource, or run a prompt.

## The three server primitives

- **Tools** (model-controlled) — functions the model can invoke to take an action or fetch computed
  data. Each has a `name`, a `description`, and an `inputSchema` (JSON Schema); optionally an
  `outputSchema` and **annotations** (hints like read-only or destructive). This is the primitive
  you'll use most.
- **Resources** (application-controlled) — data the host can read and place into context, addressed
  by **URI** (e.g. `file:///…`, `db://…`). The client lists resources (`resources/list`) and reads
  them (`resources/read`); **resource templates** parameterize URIs. Use resources for content the
  host loads, not actions the model triggers.
- **Prompts** (user-controlled) — reusable prompt/workflow templates the user invokes (e.g. a slash
  command). They have a `name` and typed `arguments`, and return messages via `prompts/get`.

Servers can also **use client features** where the host supports them: **sampling** (the server asks
the host's LLM to generate something), **elicitation** (the server asks the user for input mid-task),
and **roots** (the client tells the server which filesystem/URI roots it may operate on).

## Transports

- **stdio** — the host launches your server as a subprocess and talks over stdin/stdout. Best for
  local, single-user servers (filesystem access, local tools). Simple, no network, no auth needed.
- **Streamable HTTP** — your server runs as a web service; the client connects over HTTP (with
  server-sent events for streaming). Best for remote/shared servers and multi-user deployments;
  requires authorization. (This is the current remote transport; the older HTTP+SSE transport is
  deprecated.)

Choose stdio for "the host runs it on my machine", HTTP for "it's a service clients connect to".

## Connection lifecycle

1. **Initialize** — client and server exchange `initialize` messages and **negotiate capabilities**
   (which primitives and features each side supports) and protocol version.
2. **Operation** — the client lists and calls tools (`tools/list`, `tools/call`), reads resources,
   gets prompts; the server may send notifications (e.g. list changed) and use client features.
3. **Shutdown** — the connection closes (stdio: process exit; HTTP: session end).

Declare only the capabilities you actually implement during initialization — the host relies on that
negotiation to know what's available.

## Ecosystem note

MCP is client-agnostic: a correct server works across all MCP hosts. The protocol evolves — for the
exact current spec (auth details, newest primitives, protocol version), consult the official MCP
specification and SDK docs rather than relying on memory.
