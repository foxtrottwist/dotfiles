# Template Examples

## Example 1: Code Review

### Task Context
Review code focusing on production readiness, accessibility, and modern development practices.

### Input Structure
```xml
<code_submission>
language: [typescript|javascript|react|swift|etc.]
focus: [performance|accessibility|security|maintainability|testing] OR "all"
context: [tech stack details] OR "react-typescript"

[CODE_TO_REVIEW]
</code_submission>
```

### Constraints
- Prioritize issues by severity
- Align suggestions with modern practices
- Address accessibility requirements
- Provide specific, actionable feedback

### Success Criteria
- Issues prioritized by severity
- Suggestions align with modern practices
- Accessibility requirements addressed
- Feedback specific and actionable

### Output Format
Code review with strengths, prioritized issues, actionable recommendations, and next steps.

---

## Example 2: Research Synthesis

### Task Context
Integrate multiple sources into actionable insights with clear attribution.

### Input Structure
```xml
<research_topic>
[Subject to research]
</research_topic>

<parameters>
analysis_type: [comparative|trend|technical|market|competitive]
output_format: [executive-summary|detailed|bullets]
focus_context: [constraints] OR "none"
</parameters>
```

### Constraints
- Use authoritative sources only
- Cite without excessive quotation
- Acknowledge conflicting viewpoints
- Provide actionable recommendations

### Output Format
Research findings with key insights, analysis, recommendations, and source attribution.

---

## Example 3: Proofreading

### Task Context
Correct errors while preserving original voice and intent.

### Input Structure
```xml
<content>
type: [email|document|message|code-comment|note]
preserve: [tone|format|style] OR "all"

[TEXT_TO_PROOFREAD]
</content>
```

### Constraints
- Fix spelling, grammar, and punctuation errors
- Preserve original tone and formatting
- Maintain technical accuracy
- Never alter quoted material
- Keep corrections minimal for casual content

### Success Criteria
- All errors corrected
- Original voice preserved
- Formatting maintained
- Ready for immediate use

### Output Format
Corrected text only, preserving original voice and formatting.

---

## Pattern Summary

Each template follows the same structure:
1. **Task Context** — What Claude is being asked to do
2. **Input Structure** — XML format for user inputs
3. **Constraints** — Boundaries and requirements
4. **Success Criteria** — Measurable outcomes
5. **Output Format** — Expected deliverable format
