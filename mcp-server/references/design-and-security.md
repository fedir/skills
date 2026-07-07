# Designing and securing an MCP server

A great MCP server is easy for a model to use correctly and safe to expose. The two hard parts are
**tool design** (so the model picks and calls the right thing) and **security** (because the caller
is an LLM driven by untrusted content).

## Designing the tool surface

- **Expose the vital few, not every endpoint.** A 1:1 wrapper of a 60-endpoint REST API gives the
  model 60 confusing choices and bloats context. Expose the handful of high-value operations users
  actually need; compose or hide the rest.
- **Name for intent**, in the model's vocabulary: `search_issues`, `create_ticket` — not `do_op` or
  `handler3`.
- **Descriptions are the API.** The model selects tools from name + description alone. State what the
  tool does *and when to use it* ("Use when the user asks about current prices or recent events"),
  and give every parameter a description. This is the single highest-leverage thing you write.
- **Right-size granularity.** One tool per coherent task. Too coarse (one tool with a mode flag) and
  the model misuses it; too fine (a tool per field) and it drowns. Prefer a few focused tools.
- **Constrain inputs in the schema** — types, enums for fixed sets, ranges, `required` — so the model
  can't easily produce an invalid call, and you validate for free.
- **Right primitive:** model-invoked action → **tool**; host-loaded data → **resource**;
  user-invoked template → **prompt**. Don't cram data-loading into tools.
- **Return model-friendly results** — concise, structured, relevant. Errors should say what went
  wrong and how to fix the call.

## Security — the caller is untrusted

The model deciding your tool calls can be steered by prompt injection in the content it reads. Design
so a hijacked model can't cause harm.

- **Validate and normalize every input** before acting — paths (reject traversal), SQL (parameterize,
  never string-build), shell (avoid; if unavoidable, arg arrays + allowlist), URLs, IDs. Treat tool
  arguments as hostile input to your code.
- **Least privilege.** Scope the server's credentials/permissions to exactly the exposed operations.
  A read-only integration should hold read-only keys.
- **Never leak secrets.** Don't return tokens/keys/internal config in tool output or errors; don't
  log them. Keep credentials server-side, injected at the call boundary — not in tool results.
- **Annotate destructive tools** (write/delete/send/pay) so hosts can require user confirmation;
  default to reversible, and gate one-way-door actions.
- **Auth for remote (HTTP) servers.** Streamable-HTTP servers need proper authorization (the MCP spec
  defines an OAuth-based scheme) — don't expose an unauthenticated write-capable server. Verify the
  client/user and enforce per-user scope. Follow the current spec for the exact mechanism.
- **Guard against confused-deputy / over-broad scope.** The server acts on the user's behalf; make
  sure a tool call can't reach data or actions outside that user's authorization.
- **Bound the work.** Rate-limit and cap expensive operations so a runaway agent can't exhaust
  resources or run up costs.

## Testing

- **MCP Inspector** — the official tool for exercising a server without a full host: list and call
  tools, read resources, get prompts, inspect the raw messages. Use it as you build.
- **Validate the schema round-trip** — malformed and edge-case inputs should be rejected cleanly with
  helpful errors, not crash the server.
- **Then test in a real host** (e.g. Claude) end to end: does the model discover the tools, pick the
  right one, and call it correctly from a natural request? If not, the fix is almost always the
  description or the schema.

## Done-when checklist

- [ ] Minimal, well-named tool surface; descriptions say what + when; every param documented
- [ ] Inputs constrained in schema and validated in code; destructive tools annotated
- [ ] Least-privilege credentials; no secrets in output/logs; remote servers authenticated
- [ ] Errors returned as tool errors, concise and actionable
- [ ] Verified with the Inspector and driven from a real host
