# Building agents on Claude (team default)

The team default provider is Claude (Anthropic). This is a quick-start reference; for anything you're
unsure of — exact model IDs, a beta feature, an SDK binding — consult the `claude-api` skill or the
official docs rather than guessing.

## Models (use the exact ID string; don't add date suffixes)

| Model | ID | Use for |
|---|---|---|
| Claude Opus 4.8 | `claude-opus-4-8` | **Default.** Most agentic/coding work; the loop's reasoning model |
| Claude Fable 5 | `claude-fable-5` | Most capable; hardest long-horizon agentic work |
| Claude Sonnet 5 | `claude-sonnet-5` | Near-Opus quality at lower cost; high-volume production |
| Claude Haiku 4.5 | `claude-haiku-4-5` | Fast/cheap narrow sub-tasks and classification |

Default to `claude-opus-4-8` unless the user names another model. Don't downgrade for cost silently —
that's the user's call. When building AI apps, default to the latest and most capable Claude models.

## The request surface (Messages API)

Everything — tool use, structured output, thinking — is the single `messages.create` endpoint.

- **SDKs:** Python `anthropic` (`pip install anthropic`), TypeScript `@anthropic-ai/sdk`. Use the
  official SDK for the project's language; use raw HTTP only if there's no SDK. Zero-arg client
  (`Anthropic()`) reads credentials from the environment.
- **Thinking:** on current models use adaptive thinking — `thinking={"type": "adaptive"}`. The old
  `budget_tokens` form returns a 400 on Opus 4.8 / Fable 5 / Sonnet 5. Control depth with
  `output_config={"effort": "..."}` — `low`/`medium`/`high`/`xhigh`/`max`. Use `high` or `xhigh` for
  coding and agentic work; `low` for cheap sub-tasks.
- **Sampling params** (`temperature`, `top_p`, `top_k`) are rejected on Opus 4.8 / Fable 5 / Sonnet 5
  — steer with prompting instead.
- **Streaming:** stream for large `max_tokens` (≳16k non-streaming risks HTTP timeouts). Use the
  SDK's `.get_final_message()` / `.finalMessage()` to collect the result.

## Tool use (the core of agents)

- Define tools with `name`, `description`, and a JSON-Schema `input_schema`. Write the description to
  say *when* to call it.
- **Tool runner** (SDK beta helper) drives the loop for you: Python `@beta_tool` +
  `client.beta.messages.tool_runner(...)`; TypeScript `betaZodTool(...)` +
  `client.beta.messages.toolRunner(...)`. Use it for the common case.
- **Manual loop** when you need approval gates / logging: loop until `stop_reason == "end_turn"`,
  append the full `response.content`, return each `tool_result` with the matching `tool_use_id`,
  batch parallel results into one user message.
- **Strict tool use:** set `strict: true` on the tool (with `additionalProperties: false` +
  `required`) to guarantee the input validates.
- **Structured output:** use `output_config={"format": {"type": "json_schema", "schema": ...}}`
  (or `client.messages.parse()` with a Pydantic/Zod model). The old `output_format` param is
  deprecated. Assistant-message prefills are not supported on current models — use structured output
  instead.

## Server-side & connected tools

- **Web search / web fetch, code execution** — Anthropic-hosted; declare in `tools`, results come
  back in the same response, no client execution loop.
- **MCP** — connect the agent to external tool servers. Declare the server and reference it via an
  MCP toolset; keep credentials out of the agent definition.
- **Tool search** — when you have many tools, let the model discover the relevant few instead of
  loading every schema up front (preserves the prompt cache).

## Long-running agents

- **Prompt caching:** cache the stable prefix (`tools` → `system` → early `messages`). Any byte
  change in the prefix invalidates the rest — keep timestamps/ids out of the system prompt. Verify
  with `usage.cache_read_input_tokens`.
- **Compaction** and **context editing** are beta features that keep long conversations within the
  context window (summarize vs prune). **Memory tool** gives cross-session persistence.
- **Managed Agents** is the surface when you want Anthropic to run the loop and host a per-session
  container for tool execution (bash/file ops/code) — good for stateful, long-running agents.

## Don't guess

Model IDs, beta headers, and API shapes change. For exact current details — a feature you're unsure
of, a non-Python/TS SDK binding, pricing, or migration — use the `claude-api` skill or fetch the
official docs. Never invent a model ID or an SDK method from memory.
