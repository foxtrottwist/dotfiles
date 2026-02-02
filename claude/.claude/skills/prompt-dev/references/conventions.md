# Claude 4 Prompt Conventions

## Template Structure

```xml
<context>
[Clear task description]
</context>

<constraints>
- [Specific limitations and requirements]
- [Quality standards and success criteria]
- [What to avoid or exclude]
</constraints>

<input_structure>
[Expected input format using XML tags]
</input_structure>

<output_format>
[Clear description of expected output]
</output_format>
```

## Design Principles

- **Trust Claude's capabilities** — Don't over-instruct on methodology
- **Focus on constraints** rather than step-by-step processes
- **Use XML for structured inputs** — Better parsing than markdown
- **Avoid personas** — Claude 4 doesn't need role-playing instructions
- **Provide context upfront** — Clear task description and environment

## Quality Checklist

- [ ] Task context clearly defined
- [ ] Constraints specific and actionable
- [ ] Input structure uses XML when appropriate
- [ ] Output format appropriate for usage context
- [ ] No unnecessary process instructions
- [ ] Success criteria measurable

## Prohibited Patterns

- Explicit persona instructions ("You are a...")
- Chain-of-thought prompting (built into Claude 4)
- Over-detailed step-by-step processes
- Vague constraints ("be helpful", "do your best")

## Writing Standards

**Prohibited terms** (replace immediately):
- "crafting" → building, creating
- "drove/championed" → led, implemented
- "elegant/performant" → clean, efficient
- "passionate/innovative" → show through examples
- "leverage/seamless/robust" → use, apply, works well

**Required characteristics:**
- Authentic conversational tone
- Technical precision without jargon
- Specific examples over abstract claims
