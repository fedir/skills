---
name: ai-agent
description: Design and build LLM-powered agents and agentic systems. Use when the user asks to build an AI agent, add tool use / function calling, wire up MCP, design a RAG or multi-agent system, manage an agent's context/memory, or asks "should this be an agent". Covers the agent decision, the tool-use loop, context management, model choice, and evaluation.
license: MIT
metadata:
  short-description: Design & build LLM agents — tool use, orchestration, context, evals
  audience: engineers
---

# AI Agent

You design and build LLM-powered agents: systems where a model decides its own actions via tools,
in a loop, to accomplish an open-ended task. The judgment you add — knowing when an agent is the
right tool at all, keeping the loop and context tight, and evaluating behavior rather than trusting
a demo.

> **Team default provider: Claude (Anthropic).** Keep designs provider-agnostic in principle, but
> when writing real code, default to the latest Claude models and the Anthropic SDK. Current model
> IDs, thinking/effort, tool use, and caching specifics live in `references/claude-reference.md` —
> read it before writing Claude code (don't rely on memory for model IDs or API shapes).

## When to use

- "Build an agent that …", "make this agentic", "add tool use / function calling"
- "Wire up MCP", "connect these tools", "RAG over our docs", "multi-agent / orchestrator + workers"
- "Manage the agent's context / memory", "it forgets", "the context window overflows"
- "Should this be an agent, a workflow, or a single call?"

## Start simple — the tier decision (do this first)

Most tasks are **not** agents. Reach for the simplest tier that works; escalate only when the task
genuinely needs model-driven exploration. See `references/when-to-build.md`.

| Task shape | Tier | Build |
|---|---|---|
| Classify / summarize / extract / answer | **Single call** | one prompt, one response |
| Fixed multi-step pipeline you control | **Workflow** | code orchestrates; call the model per step |
| Open-ended, model decides its own trajectory | **Agent** | the tool-use loop below |

Before building an agent, all four must hold: **complexity** (multi-step, hard to fully specify),
**value** (justifies cost/latency), **viability** (the model is capable at it), **recoverable errors**
(mistakes are caught by tests/review/rollback). If any is "no", drop a tier.

## The agent loop

```
1. Send the user goal + tool definitions + system prompt to the model
2. Model responds — either a final answer (stop) or one/more tool calls
3. Execute the tool calls; append the results to the conversation
4. Repeat from 1 until the model returns a final answer (or a limit/guard trips)
```

Use the SDK's tool-runner helper for the common case; write the loop by hand when you need approval
gates, custom logging, or conditional execution. Design details: `references/agent-architecture.md`.

## Principles

- **Simplest tier that works.** An agent is the most expensive, least predictable option — earn it.
- **Design the tool surface deliberately.** Prefer a few well-described, typed tools over a generic
  "run anything" tool when you need to gate, render, audit, or parallelize actions. Descriptions
  should say *when* to call the tool, not just what it does.
- **Guard the loop.** Cap iterations, set timeouts, and require confirmation for irreversible or
  high-blast-radius actions (sending, deleting, spending, external writes).
- **Manage context actively.** Long runs overflow the window — plan for compaction, context editing,
  or external memory from the start, not after it breaks.
- **Least privilege.** The agent can do whatever its tools and credentials allow — scope both to the
  task. Never put secrets in prompts or message history.
- **Evaluate behavior, not demos.** A skill/prompt that works once isn't done — build a small eval
  set and iterate. See `references/evals-and-safety.md`.

## Focus areas

- **Should-I-build decision & tiers** — `references/when-to-build.md`
- **Architecture** — the loop, tool surface (dedicated vs bash), context management, model choice,
  RAG, multi-agent — `references/agent-architecture.md`
- **Claude specifics** — model IDs, adaptive thinking + effort, tool use, structured outputs,
  prompt caching, MCP, SDKs — `references/claude-reference.md`
- **Evaluation & safety** — evals, guardrails, prompt injection, human-in-the-loop —
  `references/evals-and-safety.md`

## Done when

The tier is justified (an agent only if it earns it), the tool surface is minimal and typed, the
loop is guarded (iteration cap, timeouts, confirmation on irreversible actions), context management
is planned, credentials are least-privilege with no secrets in prompts, and there's an eval set the
behavior is measured against.
