# Writing style

Good technical writing is invisible: the reader gets what they need and moves on. Optimize for
skimming, clarity, and correctness.

## Voice and tense

- **Imperative for instructions**: "Run the migration", not "You should run the migration" or "The
  migration should be run".
- **Present tense, active voice**: "The service returns 404", not "A 404 will be returned".
- **Second person** ("you") for the reader; avoid "we" for instructions.
- **Consistent terminology** — pick one term per concept and use it everywhere. Don't alternate
  "job / task / run".

## Structure for skimming

- **Most important first** — readers scan the top, then leave. Front-load the answer.
- **Descriptive headings** that state content, so a reader can jump. Nest shallowly.
- **Lists for steps and options**; short paragraphs for concepts. Numbered lists for sequences,
  bullets for sets.
- **One idea per paragraph.** If a paragraph has three ideas, make three paragraphs or a list.
- **Tables** for anything with parallel structure (options, comparisons, parameters).

## Concision

- **Cut words that don't change meaning.** "In order to" → "to". "At this point in time" → "now".
  "It is important to note that" → delete.
- **Prefer short, concrete sentences.** One clause is often clearer than three.
- **Delete throat-clearing** intros. Start with the substance.
- **Don't restate the code** in prose — comment/document the *why*, not the *what*.

## Examples

- **Every concept earns an example.** A runnable command or a real snippet beats a paragraph of
  description.
- **Show input and output** so the reader knows what success looks like.
- **Make examples copy-pasteable** and correct — test them. A broken example destroys trust.
- Use realistic-but-safe values; never real secrets.

## Formatting

- Code, commands, filenames, and identifiers in `monospace`.
- Fenced code blocks with a language for syntax highlighting.
- **Bold** for the one key term or warning; don't over-bold.
- Call out prerequisites and warnings before the step they affect, not after.

## Before you ship

- [ ] A reader in the target audience can complete their task from this alone.
- [ ] Every command/example is tested and correct.
- [ ] The most important information is at the top.
- [ ] No unexplained jargon; terms are consistent.
- [ ] Nothing that doesn't serve the reader's goal remains.
