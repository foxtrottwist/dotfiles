# Foundation Models: Performance

Optimization techniques for faster, more responsive AI features.

## Token Economics

Understanding tokens helps optimize performance:

- **Tokens** are small text fragments (typically 3-4 characters or a word)
- **Input tokens**: instructions + prompt + tool definitions + @Generable schema
- **Output tokens**: generated response
- **Key insight**: Model reads fast, writes slow—summarization is faster than generation

| Factor | Impact |
|--------|--------|
| Long instructions | More input processing time |
| Long prompts | More input processing time |
| Long outputs | Much more generation time |
| Complex @Generable | Schema adds input tokens |
| Verbose field names | More output tokens in JSON |
| Tool descriptions | Added to input tokens |

**Token variation**: Simple words like "banana" = 1 token. Complex text like dates, phone numbers, or symbols = many tokens. Plain words process faster than characters of symbols.

## Pre-warming

Load model before user action to eliminate cold-start latency:

```swift
// Basic—load model into memory
try await session.prewarm()

// Better—include expected prompt prefix
try await session.prewarm(promptPrefix: Prompt {
    "Generate a recipe for"
})
```

**When to prewarm:**
- `onAppear` of views with AI features
- After user selects an option that will need AI
- During loading screens or transitions
- When navigating to a detail view

```swift
.task {
    try? await session.prewarm()
}

// Or with prompt prefix for faster first response
.task {
    try? await session.prewarm(promptPrefix: Prompt {
        "Create a \(duration)-minute workout for"
    })
}
```

### What Pre-warming Does

Without pre-warming, first request triggers:
1. Asset loading (model loaded from storage)
2. Vocabulary preparation
3. Then inference begins

With pre-warming, these happen before user action—response starts immediately.

## Reduce Schema Tokens

When using one-shot examples, the schema is redundant:

```swift
let prompt = Prompt {
    "Create a recipe for \(userInput)"
    "Example format:"
    Recipe.exampleRecipe  // Already demonstrates structure
}

let response = try await session.respond(
    to: prompt,
    generating: Recipe.self,
    includeSchemaInPrompt: false  // Don't duplicate schema
)
```

**When to use `includeSchemaInPrompt: false`:**
- Your one-shot example fully demonstrates the structure
- You want to reduce input token count
- Session already has prior successful generations of the type

Saves tokens when your example fully demonstrates the structure.

## Optimize @Generable Types

Field names become JSON keys—shorter names = fewer tokens:

```swift
// More tokens (avoid)
@Generable struct Recipe {
    var recipeName: String
    var cookingTimeInMinutes: Int
    var listOfIngredients: [String]
}

// Fewer tokens (preferred)
@Generable struct Recipe {
    var name: String
    var time: Int
    var ingredients: [String]
}
```

**Additional tips:**
- Keep `@Guide` descriptions concise—they add to input tokens
- Use short but distinct field names (helps model decode faster)
- Flatten type hierarchies when possible

## Sampling Options

```swift
// Deterministic (testing, consistent tool calls)
let options = GenerationOptions(sampling: .greedy)

// Less creative (more focused)
let options = GenerationOptions(sampling: .random(temperature: 0.3))

// Default creativity
let options = GenerationOptions(sampling: .random(temperature: 0.7))

// More creative (varied outputs)
let options = GenerationOptions(sampling: .random(temperature: 0.9))

let response = try await session.respond(to: prompt, options: options)
```

Use `.greedy` for:
- Unit tests (deterministic output)
- Tool calling (consistent behavior)
- Debugging (reproducible results)
- Demos that should be repeatable

**Note**: Greedy sampling gives same output for same input within a model version. OS updates may change output even with greedy sampling.

## Limit Output Length

Shorter outputs generate faster. Guide via instructions:

```swift
let session = LanguageModelSession(instructions: """
    Keep responses under 50 words.
    Use bullet points, not paragraphs.
    Each paragraph should be no more than two sentences.
    """)
```

Or constrain in @Generable:

```swift
@Generable struct Summary {
    @Guide(description: "Summary in 2-3 sentences max")
    var text: String
}
```

## Session Reuse

Creating sessions has overhead. Reuse when possible:

```swift
// ❌ New session each request
func ask(_ question: String) async throws -> String {
    let session = LanguageModelSession(instructions: "...")
    return try await session.respond(to: question).content
}

// ✅ Reuse session
@Observable
class Assistant {
    private let session = LanguageModelSession(instructions: "...")
    
    func ask(_ question: String) async throws -> String {
        try await session.respond(to: question).content
    }
}
```

Reset only when context grows too large or topic changes completely.

### New Session for New Conversations

```swift
// Store instructions separately
let instructions = InstructionsBuilder {
    "You are a helpful travel agent"
    "Be friendly and concise"
}

// Initial session
@State private var session: LanguageModelSession?

init() {
    session = LanguageModelSession(instructions: instructions)
}

// Reset for new conversation
func newChat() {
    session = LanguageModelSession(instructions: instructions)
}
```

## Streaming for Perceived Performance

Even if total time is same, streaming feels faster:

```swift
// User sees progress immediately
let stream = session.streamResponse(to: prompt)
for try await partial in stream {
    withAnimation {
        responseText = partial.content
    }
}
```

Benefits:
- User sees first tokens in milliseconds
- Content appears progressively
- Feels more responsive than waiting for complete response

## Profiling with Instruments

Xcode Instruments has a Foundation Models template:

1. Product > Profile (⌘I) or hold Run button > Profile
2. Choose blank template, add "Foundation Models" instrument
3. Record and interact with your app
4. Analyze:
   - **Asset Loading**: Time to load model (target with prewarm)
   - **Inference**: Token counts, generation time
   - **Response timeline**: First token latency

### Key Metrics to Watch

| Metric | What It Tells You |
|--------|-------------------|
| Asset loading time | Benefit from pre-warming |
| Max token count | Prompt/schema complexity |
| Time to first token | User-perceived latency |
| Total inference time | End-to-end performance |

### Debugging Rendering Performance

For SwiftUI views showing AI content:

1. Debug > View Debugging > Rendering > Flash Updated Regions
2. Yellow flashes show re-rendering areas
3. Identify unnecessary re-renders during streaming

## Performance Checklist

1. **Pre-warm** on view appear or user navigation
2. **Use prompt prefix** in pre-warm when possible
3. **Short field names** in @Generable types
4. **Concise instructions** and @Guide descriptions
5. **Stream responses** for perceived performance
6. **Reuse sessions** for related queries
7. **Use greedy sampling** for testing/debugging
8. **Disable schema** when using one-shot examples
9. **Profile with Instruments** to find bottlenecks
10. **Limit output length** via instructions or guides

## First-Request Latency

The very first request after app launch is slowest because:
1. Model assets load from storage into memory
2. This happens once per app session
3. Subsequent requests are faster

**Mitigation**: Pre-warm during splash screen or view transitions.
