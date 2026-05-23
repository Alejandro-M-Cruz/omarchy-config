---
applyTo: '**'
---
When performing a pull request review, try to analyze if all edge cases are correctly tested.

When writing new code or changing existing code, always take care of test coverage and try to understand if new tests should be written or existing tests should be fixed.

Use this checklist during code reviews to ensure UI-facing strings follow our English style conventions. 
- Focus only on strings that will be visible in the user interface (e.g., button text, tooltips, error messages, translations, js and jsx files)
- Ignore the Backoffice section of the Vantage / N2EOS project, as it is for internal use only.
- Use American English.
- Use sentence case (only the first word and proper nouns capitalized).
- Use the Oxford comma in lists.
- Avoid gerunds ("-ing" words). Use direct verbs instead.
- Be clear and concise. Avoid filler words.
- Use specific action verbs for buttons (e.g., "Save," not "Go").
- Avoid idioms, slang, or casual expressions.
- For tooltips and messages, explain the action or outcome.
- For error messages, state the problem and suggest a next step.
- Use ISO 8601 for dates (e.g., 2025-10-10) and 24-hour time with timezone if needed (e.g., 14:00 UTC).

If a string doesn't meet these rules, leave a review comment suggesting a clear and correct alternative.