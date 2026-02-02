# Foundation Models: Guided Generation

Generate structured Swift types instead of raw text using `@Generable`.

## Basic Usage

```swift
@Generable
struct Recipe: Identifiable {
    let id = UUID()
    
    @Guide(description: "Name of the dish")
    var name: String
    
    @Guide(description: "Cooking time in minutes", .range(5...120))
    var cookingTime: Int
    
    @Guide(description: "List of ingredients")
    var ingredients: [String]
}

let recipe = try await session.respond(
    to: "Create a pasta recipe",
    generating: Recipe.self
).content  // Recipe instance
```

## How Constrained Decoding Works

Generable uses **constrained decoding** to guarantee structural correctness:

1. Framework generates a schema from your `@Generable` type at compile time
2. During token generation, invalid tokens are masked out
3. Model can only pick tokens valid according to the schema
4. Result: No parsing errors, guaranteed type-safe output

The model generates JSON under the hood, automatically parsed into your Swift type.

## @Guide Constraints

| Constraint | Type | Example |
|------------|------|---------|
| `.range(min...max)` | Numeric | `@Guide(.range(1...100))` |
| `.count(n)` | Array | `@Guide(.count(5))` — exactly 5 |
| `.count(min...max)` | Array | `@Guide(.count(3...10))` |
| `.anyOf([...])` | String | `@Guide(.anyOf(["red", "blue"]))` |
| `.regex(pattern)` | String | `@Guide(.regex(/^[A-Z]{3}$/))` |

Combine description with constraint:

```swift
@Guide(description: "Rating out of 5", .range(1...5))
var rating: Int
```

## Generable Enums

Enums with `String` raw values work with `@Generable`:

```swift
@Generable
enum Difficulty: String {
    case easy, medium, hard
}

@Generable
enum WineType: String {
    case red, white, rosé, sparkling
}

@Generable
struct Challenge {
    var title: String
    var difficulty: Difficulty  // Constrained to enum cases
}
```

**Important**: All nested types (including enums) must also be `@Generable`.

## Nested Structures

All nested types must also be `@Generable`:

```swift
@Generable
struct Ingredient {
    var name: String
    @Guide(description: "Amount", .range(0.1...1000))
    var quantity: Double
    var unit: String
}

@Generable
struct Recipe {
    var name: String
    @Guide(description: "Required ingredients", .count(1...20))
    var ingredients: [Ingredient]
}
```

## Generating Arrays

Generate multiple items by specifying array type:

```swift
@Generable
struct Exercise: Identifiable {
    let id = UUID()
    
    @Guide(description: "Name of the exercise")
    var name: String
    
    @Guide(description: "Instructions to perform")
    var instructions: String
    
    @Guide(description: "Number of repetitions", .range(1...10))
    var repetitions: Int
}

// Generate array of exercises
let exercises = try await session.respond(
    to: "Create 5 exercises for lower back",
    generating: [Exercise].self
).content  // [Exercise] array
```

## Property Generation Order

Properties generate in **declaration order**. This matters for:
- Streaming (earlier properties arrive first)
- Dependencies (later properties can reference earlier ones contextually)

```swift
@Generable
struct Article {
    var title: String       // Generated first
    var summary: String     // Generated second, can relate to title
    var body: String        // Generated last, can relate to both
}
```

## Streaming Structured Content

`PartiallyGenerated` mirrors your struct with all properties optional:

```swift
@State private var partialRecipe: Recipe.PartiallyGenerated?

let stream = session.streamResponse(to: prompt, generating: Recipe.self)
for try await partial in stream {
    withAnimation {
        partialRecipe = partial.content
    }
}

// In view:
if let name = partialRecipe?.name {
    Text(name)  // Shows as soon as name is generated
}
if let ingredients = partialRecipe?.ingredients {
    ForEach(ingredients, id: \.self) { ingredient in
        Text(ingredient)
    }
}
```

### Streaming Arrays

For streaming arrays, each element arrives as a `PartiallyGenerated` version:

```swift
@State private var exercises: [Exercise.PartiallyGenerated] = []

let stream = session.streamResponse(to: prompt, generating: [Exercise].self)
for try await partial in stream {
    withAnimation {
        exercises = partial.content
    }
}
```

## One-Shot Examples

Improve output quality by providing a gold-standard example directly in the prompt:

```swift
extension Recipe {
    static let example = Recipe(
        name: "Classic Margherita",
        cookingTime: 25,
        ingredients: ["dough", "tomato sauce", "mozzarella", "basil"]
    )
}

let prompt = Prompt {
    "Create a recipe for \(userInput)"
    "Here is an example of the desired format (don't copy its content):"
    Recipe.example
}

// When using examples, consider disabling schema in prompt
let response = try await session.respond(
    to: prompt,
    generating: Recipe.self,
    includeSchemaInPrompt: false  // Schema redundant with example
)
```

**Key benefits of one-shot examples:**
- Teaches tone and style, not just structure
- Shows relationship between properties
- Can significantly improve quality and consistency
- Allows disabling schema to save tokens

## Dynamic Schemas

For runtime-defined structures (e.g., user-created forms):

```swift
// Define schema at runtime
let answerSchema = DynamicGenerationSchema(
    name: "Answer",
    properties: [
        .init(name: "text", schema: .string),
        .init(name: "isCorrect", schema: .boolean)
    ]
)

let riddleSchema = DynamicGenerationSchema(
    name: "Riddle",
    properties: [
        .init(name: "question", schema: .string),
        .init(name: "answers", schema: .array(of: answerSchema))
    ]
)

// Validate and use
let validated = try ValidatedGenerationSchema(schemas: [riddleSchema, answerSchema])
let result = try await session.respond(
    to: "Create a riddle about coffee",
    generating: validated
)

// Access dynamic content
if let question = result.content["question"] as? String {
    print(question)
}
```

Use when structure isn't known at compile time.

## Supported Types

`@Generable` supports:
- `String`, `Int`, `Double`, `Bool`
- `Optional<T>` where T is generable
- `Array<T>` where T is generable
- Enums with `String` raw values
- Nested `@Generable` structs
- `UUID`, `Date` (with appropriate guides)

Properties without `var` (like `let id = UUID()`) are excluded from generation.

## Performance Tip: Shorter Field Names

Field names become JSON keys—shorter names = fewer tokens:

```swift
// More tokens (avoid)
@Generable struct Recipe {
    var recipeName: String
    var cookingTimeInMinutes: Int
}

// Fewer tokens (preferred)
@Generable struct Recipe {
    var name: String
    var time: Int
}
```

Also: Keep `@Guide` descriptions concise—they add to input tokens.

## Complete Example: Fitness App

```swift
@Generable
enum FitnessLevel: String {
    case beginner, intermediate, advanced
}

@Generable
enum AgeGroup: String {
    case youth = "Under 18"
    case youngAdult = "18-35"
    case adult = "36-55"
    case senior = "Over 55"
}

@Generable
struct Exercise: Identifiable {
    let id = UUID()
    
    @Guide(description: "Name of the exercise")
    var name: String
    
    @Guide(description: "How to perform the exercise")
    var instructions: String
    
    @Guide(description: "Benefits of this exercise")
    var benefits: String
    
    var fitnessLevel: FitnessLevel
    var ageGroup: AgeGroup
    
    @Guide(description: "Number of repetitions", .range(1...20))
    var repetitions: Int
}

// Usage
let session = LanguageModelSession(instructions: InstructionsBuilder {
    "You are an experienced fitness trainer"
    "Create safe, effective exercises"
})

let prompt = Prompt {
    "Create exercises for a \(totalMinutes)-minute workout"
    "Client is \(ageGroup.rawValue)"
    "Fitness level: \(fitnessLevel.rawValue)"
}

let exercises = try await session.respond(
    to: prompt,
    generating: [Exercise].self
).content
```
