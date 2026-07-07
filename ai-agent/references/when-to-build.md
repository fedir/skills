# Should you build an agent?

The most valuable decision in agent work is *not building one*. Agents are powerful and expensive:
higher latency, higher token cost, and non-deterministic behavior that is harder to test and debug.
Reach for the simplest tier that meets the need.

## The three tiers

| Tier | What it is | Use when | Cost |
|---|---|---|---|
| **Single call** | One prompt → one response | Classification, summarization, extraction, Q&A, rewriting | Lowest, deterministic-ish, trivial to test |
| **Workflow** | Your code orchestrates a fixed sequence of model calls (and tools) | The steps are known in advance and you control the flow | Moderate; you own the control flow, so it's debuggable |
| **Agent** | The model decides its own next action via tools, in a loop | The path can't be fully specified up front; the model must explore/adapt | Highest; least predictable |

Default to **single call**. Escalate to a **workflow** when you need multiple steps but can name
them. Escalate to an **agent** only when the trajectory genuinely can't be scripted.

## The four gates for an agent

Build an agent only when **all four** hold. If any is "no", drop a tier.

1. **Complexity** — the task is multi-step and hard to fully specify in advance. ("Turn this design
   doc into a working PR" is agent-shaped; "extract the title from this PDF" is a single call.)
2. **Value** — the outcome justifies the added cost and latency. Don't spend agent money on a task a
   single call handles.
3. **Viability** — the model is actually capable at this task type. If it can't do the task
   reliably even with help, an agent just fails more expensively.
4. **Cost of error is recoverable** — mistakes are caught and reversible (tests, human review,
   rollback, sandboxes). Autonomy over irreversible, high-stakes actions needs strong guardrails or
   a human in the loop.

## Common mistakes

- **Agent for a workflow.** If you can draw the flowchart, write the workflow — you get determinism,
  cheaper runs, and real debuggability.
- **One giant agent for everything.** Scope each agent to a coherent job; compose workflows around
  them rather than one mega-agent with 50 tools.
- **Skipping the single-call check.** Many "agent" requests are one well-prompted call with
  structured output.

## Managed vs self-hosted loop

Once you've decided on an agent, decide who runs the loop:

- **You run the loop** (SDK tool-runner or a hand-written loop) — maximum control over tools,
  approval gates, logging, and where compute runs. Default for most cases.
- **A managed agent runtime runs the loop** and hosts a sandboxed workspace for tool execution —
  good for stateful, long-running agents with file mounts and a per-session container, when you'd
  rather not operate the loop and sandbox yourself.

See `claude-reference.md` for the concrete surfaces this maps onto with Claude.
