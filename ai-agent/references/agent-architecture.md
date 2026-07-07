# Agent architecture

Provider-agnostic design guidance for building the agent loop, its tool surface, and its context.

## The loop

```
messages = [system, user_goal]
loop:
    response = model(messages, tools)
    if response is a final answer: return it
    for each tool_call in response:
        result = execute(tool_call)          # your code runs the tool
        append tool_call + result to messages
    if iteration_cap hit or guard trips: stop
```

- **Append the model's full response** (including its tool-call blocks) to the history before adding
  results, and **pair each result with its tool-call id** — mismatches break the conversation.
- **Return all results from parallel tool calls in one batch**, not spread across turns.
- **Cap iterations** and set a per-tool timeout so a confused agent can't loop forever.

## Designing the tool surface

The model emits tool calls; your harness executes them. The *shape* of your tools determines what
the harness can do.

- **A generic "run any command" tool** (bash/exec) gives maximum breadth but an opaque call the
  harness can't reason about — every action looks the same.
- **A dedicated, typed tool** (`send_email`, `create_ticket`, `search_docs`) gives the harness an
  action-specific hook it can **gate, render in the UI, audit, or run in parallel**.

Promote an action to a dedicated tool when you need to:
- **Gate it** — irreversible/high-blast-radius actions (send, delete, pay, external write) behind a
  confirmation.
- **Validate it** — e.g. an `edit` tool that rejects a write if the file changed since last read.
- **Render it** — actions that need custom UI (ask-the-user, show-a-diff).
- **Parallelize it** — mark read-only tools parallel-safe; a generic exec tool must be serialized.

Rule of thumb: **start with a small set; promote to dedicated tools as you need control.** Write
descriptions that state *when* to call the tool, list only truly-required params, and use enums for
fixed value sets. Too many tools confuses the model — keep the set focused, or load tools on demand.

## Managing context in long-running agents

Agents accumulate history fast (every tool result is tokens). Plan for this from the start:

- **Compaction** — summarize earlier turns when nearing the context limit; keeps the thread going.
- **Context editing / pruning** — clear stale tool results and old reasoning without summarizing.
- **External memory** — let the agent read/write files (or a store) so state survives beyond one
  session; give it a format and tell it when to consult it.
- **Prompt caching** — cache the stable prefix (system prompt, tool defs, long context) so repeated
  turns are cheap. Keep the prefix byte-stable; put volatile content (timestamps, ids) at the end.

## Model choice

- **Match the model to the job.** Use a strong model for the reasoning/orchestration loop; a
  cheaper, faster model for narrow sub-tasks or high-volume classification.
- **Don't switch models mid-conversation** if you rely on prompt caching (caches are per-model) —
  spawn a sub-agent on the cheaper model instead.
- **Control reasoning depth** with the provider's thinking/effort controls rather than prompt
  hacks. Concrete Claude settings: `claude-reference.md`.

## RAG (retrieval-augmented generation)

When the agent needs knowledge it wasn't trained on: retrieve relevant chunks and put them in
context, rather than fine-tuning. Keep it simple — chunk sensibly, retrieve by semantic similarity,
cite sources, and cache the retrieved context where it's stable. Retrieval quality dominates
outcome quality; invest there before prompt-tuning.

## Multi-agent

Use multiple agents only when the work genuinely fans out or needs isolated contexts:

- **Orchestrator + workers** — a coordinator delegates independent sub-tasks to workers and
  integrates results. Good for parallel, independent workstreams.
- **Give each sub-agent its own focused context and tools.** They don't share conversation history
  by default — the orchestrator must pass what a worker needs.
- **Prefer one agent + workflow** until a real boundary (parallelism, isolation, distinct tools)
  justifies the coordination overhead.
