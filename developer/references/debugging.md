# Systematic debugging

Guessing is slow and unreliable. Debug like a scientist: reproduce, isolate, hypothesize, test.

## The method

1. **Reproduce reliably.** Find the smallest, most consistent way to trigger the bug. A bug you can
   reproduce on demand is half solved; one you can't, you can't verify fixed. Capture exact inputs,
   environment, and the observed vs expected behavior.
2. **Isolate.** Narrow where the fault lives: bisect the input, the code path, or history
   (`git bisect`). Add instrumentation/logging at the boundaries to see where reality diverges from
   expectation. Cut the search space in half repeatedly.
3. **Form one hypothesis** about the root cause, stated so it's falsifiable ("the timestamp is UTC
   here but parsed as local there"). Predict what you'd observe if it's true.
4. **Test the hypothesis** with the minimal change or probe. If wrong, discard it and form the next
   — don't pile speculative fixes on top of each other.
5. **Fix the root cause, not the symptom.** Suppressing the symptom (swallowing the error, adding a
   special case) leaves the bug alive. Ask "why did this happen" until you reach the real cause.
6. **Verify and lock it in.** Confirm the reproduction now passes, run the wider suite for
   regressions, and add a test that would have caught it.

## Heuristics

- **Question assumptions.** The bug is usually in what you're *sure* is correct. Verify, don't
  assume.
- **Read the actual error and stack trace** fully before theorizing — it often names the cause.
- **Recent change first.** If it worked before, diff what changed.
- **Binary search beats staring.** Halving the problem space is faster than reading every line.
- **One change at a time** while diagnosing, so you know what did what.
- **Rubber-duck it.** Explaining the flow out loud surfaces the wrong assumption.

## When stuck

Re-read the code as if you've never seen it. Reproduce in isolation, outside the big system. Check
the boring causes: config, environment, versions, caching, stale build. Widen the logging.
