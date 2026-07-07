# Understanding a codebase before you edit

The most common cause of bad changes is editing before understanding. Spend the time up front.

## Orient

- **Read the entry points** and the module(s) you'll touch, plus their immediate callers/callees.
- **Find the conventions**: how are errors handled? how is logging done? how are things named? how
  are modules laid out? how are tests structured? Your change must look like it belongs.
- **Find the reusable pieces**: search for existing helpers, utilities, types, and patterns that do
  what you need. Reinventing an existing utility is a review-blocking smell.
- **Read the tests** near your change — they document intended behavior and the testing style.

## Trace before you touch

For anything non-trivial, follow the real path the data/control takes end to end. Note the seams
(interfaces, boundaries) where your change fits with least disruption. Prefer to work *along* an
existing seam rather than cutting a new one.

## Find the smallest correct change

- What is the minimum edit that fully satisfies the request?
- Which existing abstraction should this hang off of?
- What will the diff look like — is it localized, or does it ripple? Ripple means you may have the
  wrong seam.

## Signals you don't understand it yet

- You can't explain what the current code does in one sentence.
- You're copy-pasting a pattern without knowing why it's shaped that way.
- Your change needs edits scattered across many unrelated files.

When you hit these, read more (or ask) before writing. Understanding is cheaper than a wrong diff.
