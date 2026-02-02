# Foundation Models: Tool Calling

Extend the model with custom data sources, APIs, or device capabilities.

## Why Tools?

The on-device model has limitations:
- Frozen training data (can't access real-time info)
- No access to user data (calendars, contacts, databases)
- No network access to APIs

Tools let you provide this data while preserving privacy—all processing stays on-device.

## Tool Protocol

A tool requires:
- `name: String` — short, verb-based identifier
- `description: String` — explains when to use (added to prompt)
- `Arguments` — `@Generable` struct defining inputs
- `call(arguments:)` — async function that **returns String or GeneratedContent**

```swift
struct WeatherTool: Tool {
    let name = "getWeather"
    let description = "Get current weather for a location"
    
    @Generable
    struct Arguments {
        @Guide(description: "City name")
        var city: String
    }
    
    // Returns String—plain text for model to incorporate
    func call(arguments: Arguments) async throws -> String {
        let weather = await weatherAPI.fetch(city: arguments.city)
        return "Weather in \(arguments.city): \(weather.temp)°F, \(weather.condition)"
    }
}
```

## Return Type: String

**The `call` function returns `String`**—plain text added to the session transcript for the model to incorporate into its response.

```swift
func call(arguments: Arguments) async throws -> String {
    // Fetch your data
    let results = database.query(arguments.searchTerm)
    
    // Return descriptive string the model can use
    return "Found \(results.count) items: \(results.map(\.name).joined(separator: ", "))"
}
```

The model reads this string and weaves the information into its final response. You're providing context, not the final answer.

## Alternative: GeneratedContent

For structured key-value data, return `GeneratedContent`:

```swift
func call(arguments: Arguments) async throws -> GeneratedContent {
    let wines = fetchWines(variety: arguments.variety)
    let inStock = wines.filter { $0.inStock > 0 }
    
    return GeneratedContent(properties: [
        "totalFound": "\(wines.count)",
        "inStock": "\(inStock.count)",
        "wineries": wines.map(\.winery).joined(separator: ", ")
    ])
}
```

Both `String` and `GeneratedContent` conform to `PromptRepresentable`.

## Attaching Tools to Session

```swift
let session = LanguageModelSession(
    instructions: "You help with weather and travel planning",
    tools: [WeatherTool(), FlightTool()]
)
```

The model autonomously decides which tool(s) to call based on the prompt.

## Tool with Injected Data

Pass local data at initialization:

```swift
struct WineCellarTool: Tool {
    let name = "cellarTool"
    let description = "Find information from your wine cellar"
    
    let wines: [Wine]  // Injected from database
    
    @Generable
    struct Arguments {
        @Guide(description: "Wine variety to search for")
        var variety: String
    }
    
    func call(arguments: Arguments) async throws -> String {
        let found = wines.filter { 
            $0.variety.localizedStandardContains(arguments.variety) 
        }
        let inStock = found.filter { $0.inStock > 0 }
        let wineries = Set(found.map(\.winery))
        
        return """
            Found \(found.count) wines of \(arguments.variety)
            \(inStock.count) bottles in stock
            From wineries: \(wineries.joined(separator: ", "))
            """
    }
}

// Usage
let tool = WineCellarTool(wines: myWineDatabase)
let session = LanguageModelSession(
    instructions: InstructionsBuilder {
        "You are a wine expert"
        "Use the cellarTool when asked about the user's wine collection"
    },
    tools: [tool]
)
```

## Instructing Tool Usage

Guide the model on when to use tools via instructions:

```swift
let session = LanguageModelSession(
    instructions: InstructionsBuilder {
        "You work in a tourist information center"
        "Always use searchInventory to check stock before answering"
        "Use getWeather for any weather-related queries"
        "Only answer questions about travel topics"
    },
    tools: [InventoryTool(products: db), WeatherTool()]
)
```

## Tool Behavior

**Multiple calls**: Model may call the same tool multiple times in one response.

**Parallel calls**: Multiple tool calls can execute concurrently—ensure thread safety.

**Call sequence**: Tool calls and outputs appear in `session.transcript`:

```swift
case .toolCall(let call):
    // Model requested tool: call.toolName, call.arguments
case .toolOutput(let output):
    // Tool returned: output.content
```

**Model decides**: The model chooses when/whether to call tools. Strong instructions help:

```swift
"Always use the cellarTool when the user asks about wines in their collection"
```

## Arguments Struct

Must be `@Generable`. Use `@Guide` for clarity:

```swift
@Generable
struct Arguments {
    @Guide(description: "The city to search")
    var city: String
    
    @Guide(description: "Maximum results", .range(1...50))
    var limit: Int
    
    @Guide(description: "Category filter", .anyOf(["restaurant", "hotel", "attraction"]))
    var category: String
}
```

## Complete Example: Wine Type Tool

Tool that uses local data and lets model determine wine type:

```swift
@Generable
struct GeneratedWine: Identifiable {
    let id = UUID()
    var variety: String
    @Guide(description: "Type of wine: red, white, rosé, sparkling")
    var type: String
}

struct WineTypeTool: Tool {
    let name = "wineType"
    let description = "Determine the type of wine varieties"
    
    let varieties: [String]  // Available varieties
    
    @Generable
    struct Arguments {
        @Guide(description: "Number of varieties to select")
        var varietyCount: Int
    }
    
    func call(arguments: Arguments) async throws -> GeneratedContent {
        let sample = varieties.shuffled().prefix(arguments.varietyCount)
        return GeneratedContent(properties: [
            "wines": Array(sample)
        ])
    }
}

// Usage
let tool = WineTypeTool(varieties: cellar.varieties)
let session = LanguageModelSession(tools: [tool])

let wines = try await session.respond(
    to: "Use the wineType tool to fetch \(count) varieties and determine their type",
    generating: [GeneratedWine].self
).content
```

## Best Practices

| Aspect | Recommendation |
|--------|----------------|
| Name | Short, verb-based: `getWeather`, `searchProducts` |
| Description | One sentence—it's added to prompt tokens |
| Return | Descriptive string the model can paraphrase |
| Arguments | Only what's needed; fewer = faster |
| Instructions | Tell model when to use each tool |
| Errors | Throw errors—they surface as generation errors |
| Data injection | Pass databases/APIs at tool initialization |

## External API Example

```swift
struct StockPriceTool: Tool {
    let name = "getStockPrice"
    let description = "Get current stock price by ticker symbol"
    
    @Generable
    struct Arguments {
        @Guide(description: "Stock ticker symbol like AAPL")
        var symbol: String
    }
    
    func call(arguments: Arguments) async throws -> String {
        let url = URL(string: "https://api.stocks.com/price/\(arguments.symbol)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let price = try JSONDecoder().decode(StockPrice.self, from: data)
        return "\(arguments.symbol) is currently trading at $\(price.current)"
    }
}
```

## Privacy Advantage

Tools run entirely on-device:
- User's calendar data never leaves device
- Contact queries stay local
- Database searches are private
- No cloud API calls unless your tool explicitly makes them

This enables features that would be privacy-concerning with cloud-based models.
