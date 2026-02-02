# Foundation Models Framework

On-device LLM access via Swift. Private by design, offline-capable, no API costs.

## Core Pattern

```swift
import FoundationModels

let session = LanguageModelSession(instructions: "You are a helpful assistant")
let response = try await session.respond(to: "Your prompt")
print(response.content) // String response
```

## Availability Check

Always verify before showing AI features:

```swift
switch SystemLanguageModel.default.availability {
case .available:
    // Ready to use
case .unavailable(let reason):
    switch reason {
    case .deviceNotEligible:
        // Requires iPhone 15 Pro+, Apple Silicon Mac
    case .appleIntelligenceNotEnabled:
        // User needs to enable in Settings
    case .modelNotReady:
        // Still downloading, temporary state
    @unknown default:
        break
    }
}
```

Check on scene activation to catch state changes:

```swift
.onChange(of: scenePhase) { _, newPhase in
    if newPhase == .active {
        checkAvailability()
    }
}
```

Check language support proactively:

```swift
if !SystemLanguageModel.default.supportsLanguage(of: locale) {
    // Show unsupported language message
}
```

### Testing Availability in Simulator

Use Xcode scheme settings to simulate different availability states:

1. Edit Scheme → Run → Options
2. "Simulated Foundation Models Availability"
3. Select: Available, Apple Intelligence Not Enabled, Device Not Eligible, or Model Not Ready

## Instructions vs Prompts

**Critical security distinction:**

| Aspect | Instructions | Prompts |
|--------|--------------|---------|
| Source | Developer-defined | User input |
| Priority | Higher (model obeys) | Lower |
| Persistence | Entire session | Single request |
| Security | Safe from injection | User-controlled |

```swift
// Instructions: static, trusted, developer-controlled
let session = LanguageModelSession(instructions: InstructionsBuilder {
    "You are a travel agent"
    "Only answer travel-related questions"
    "Keep responses under 100 words"
})

// Prompts: dynamic, can include user input
let prompt = Prompt {
    "Plan a trip to \(userDestination)"
    if familyFriendly {
        "Make it family-friendly"
    }
}
```

**Security**: Instructions take priority. User prompt injection like "ignore previous instructions" won't override your instructions.

## Prompt Builder

Build dynamic prompts with conditionals and multiple statements:

```swift
let prompt = Prompt {
    "Create a \(duration)-minute workout"
    "Focus on \(muscleGroup)"
    if kidFriendly {
        "Make it suitable for children"
    }
}

let response = try await session.respond(to: prompt)
```

## Instructions Builder

Define session-wide behavior:

```swift
let session = LanguageModelSession(instructions: InstructionsBuilder {
    "You are an experienced fitness trainer"
    "Specialize in rehabilitation exercises"
    "Always include warm-up recommendations"
})
```

## Streaming Text

```swift
let stream = session.streamResponse(to: prompt)
for try await partial in stream {
    withAnimation {
        responseText = partial.content
    }
}
```

## Session State

```swift
// Check if currently generating (for UI: disable buttons, show spinner)
if session.isResponding {
    ProgressView()
}

// Disable submit while responding
Button("Send") { ... }
    .disabled(session.isResponding)
```

**Important**: Make session a `@State` property for SwiftUI to observe `isResponding`:

```swift
@State private var session = LanguageModelSession(instructions: "...")
```

## Session Transcript

Sessions maintain full conversation history:

```swift
for entry in session.transcript {
    switch entry {
    case .instruction(let text):
        // Initial instructions (always first entry)
    case .prompt(let prompt):
        // User prompts
        let text = prompt.segments.first?.description ?? ""
    case .response(let response):
        // Model responses
        let text = response.segments.first?.description ?? ""
    case .toolCall(let call):
        // Tool invocation
    case .toolOutput(let output):
        // Tool result
    @unknown default:
        break
    }
}
```

Transcript count: 1 (instruction) + 2 per exchange (prompt + response).

### Building Chat UI from Transcript

```swift
ForEach(session.transcript) { entry in
    switch entry {
    case .prompt(let prompt):
        ChatBubble(text: prompt.segments.first?.description ?? "", isUser: true)
    case .response(let response):
        ChatBubble(text: response.segments.first?.description ?? "", isUser: false)
    default:
        EmptyView()
    }
}
```

## Error Handling

```swift
do {
    let response = try await session.respond(to: prompt)
} catch let error as LanguageModelSession.GenerationError {
    switch error {
    case .guardrailViolation(let context):
        // Content policy triggered
        showAlert(context.debugDescription)
    case .exceededContextWindowSize:
        // Context full—start new session or trim
    case .decodingError(let context):
        // Structured generation failed to parse
    case .rateLimited:
        // Too many requests, retry later
    case .unsupportedLanguageOrLocale:
        // Language not supported
    @unknown default:
        break
    }
}
```

Access additional error details:

```swift
if let failureReason = error.failureReason {
    message += "\n\(failureReason)"
}
if let recoverySuggestion = error.recoverySuggestion {
    message += "\n\(recoverySuggestion)"
}
```

## Context Window Management

Sessions have finite context. When `exceededContextWindowSize` occurs:

```swift
// Option 1: Fresh session (loses history)
session = LanguageModelSession(instructions: originalInstructions)

// Option 2: Carry over key entries
let instructions = session.transcript.first
let lastExchange = session.transcript.suffix(2)  // Last prompt + response
session = LanguageModelSession(
    instructions: originalInstructions,
    transcript: [instructions] + Array(lastExchange)
)

// Option 3: Summarize history with model, start fresh with summary
```

## SwiftUI Integration Patterns

### Observable Session Manager

```swift
@Observable
class FoundationModelManager {
    var notAvailableReason: String = "Checking availability..."
    
    var isModelAvailable: Bool {
        notAvailableReason.isEmpty
    }
    
    init() {
        checkAvailability()
    }
    
    func checkAvailability() {
        switch SystemLanguageModel.default.availability {
        case .available:
            notAvailableReason = ""
        case .unavailable(let reason):
            switch reason {
            case .appleIntelligenceNotEnabled:
                notAvailableReason = "Enable Apple Intelligence in Settings"
            case .deviceNotEligible:
                notAvailableReason = "Device not supported"
            case .modelNotReady:
                notAvailableReason = "Model downloading..."
            @unknown default:
                notAvailableReason = "Unavailable"
            }
        }
    }
}
```

### View with Availability Check

```swift
struct AIFeatureView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var manager = FoundationModelManager()
    @State private var session = LanguageModelSession(instructions: "...")
    
    var body: some View {
        Group {
            if manager.isModelAvailable {
                // AI-powered content
            } else {
                ContentUnavailableView(
                    "AI Unavailable",
                    systemImage: "apple.intelligence",
                    description: Text(manager.notAvailableReason)
                )
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                manager.checkAvailability()
            }
        }
    }
}
```

## Testing

- Use Xcode scheme → Run → Options → "Simulated Foundation Models Availability" to test different availability states
- Use `.greedy` sampling for deterministic, repeatable output

## Quick Reference

| API | Purpose |
|-----|---------|
| `LanguageModelSession` | Main session class |
| `session.respond(to:)` | Single text response |
| `session.streamResponse(to:)` | Streaming text |
| `session.isResponding` | Bool for UI state |
| `session.transcript` | Conversation history |
| `session.prewarm()` | Preload model |
| `SystemLanguageModel.default.availability` | Check availability |
| `Prompt { }` | Build dynamic prompts |
| `InstructionsBuilder { }` | Build session instructions |
