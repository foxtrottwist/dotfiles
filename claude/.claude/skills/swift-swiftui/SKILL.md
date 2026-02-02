---
name: swift-swiftui
description: Modern Swift 6.2 and SwiftUI coding standards for iOS 26.0+. Use when generating or reviewing Swift code, SwiftUI views, SwiftData models, Foundation Models (on-device AI), or any Apple platform development. Covers API preferences, concurrency patterns, view architecture, and common pitfalls to avoid.
---

# Swift and SwiftUI Standards

## Target

- iOS 26.0+, Swift 6.2+
- SwiftUI with `@Observable` for shared data
- No third-party frameworks without asking
- Avoid UIKit unless requested

## Swift

- Mark `@Observable` classes with `@MainActor`
- Assume strict concurrency
- Prefer Swift-native string methods: `replacing(_:with:)` over `replacingOccurrences(of:with:)`
- Prefer modern Foundation: `URL.documentsDirectory`, `appending(path:)`
- Number formatting: `Text(value, format: .number.precision(.fractionLength(2)))` — never `String(format:)`
- Prefer static member lookup: `.circle` over `Circle()`, `.borderedProminent` over `BorderedProminentButtonStyle()`
- Modern concurrency only — no `DispatchQueue.main.async()`
- Use `localizedStandardContains()` for user-input text filtering
- Avoid force unwraps and force `try` unless unrecoverable

## SwiftUI

- `foregroundStyle()` not `foregroundColor()`
- `clipShape(.rect(cornerRadius:))` not `cornerRadius()`
- `Tab` API not `tabItem()`
- `@Observable` not `ObservableObject`
- `onChange` with two parameters or zero — never one-parameter variant
- `Button` for taps — `onTapGesture()` only when tap location/count needed
- `Task.sleep(for:)` not `Task.sleep(nanoseconds:)`
- Never use `UIScreen.main.bounds` for available space
- Extract subviews into `View` structs, not computed properties
- Use Dynamic Type — no hardcoded font sizes
- `NavigationStack` with `navigationDestination(for:)` — not `NavigationView`
- Button images need text: `Button("Action", systemImage: "plus", action: handler)`
- `ImageRenderer` over `UIGraphicsImageRenderer`
- `bold()` not `fontWeight(.bold)` unless specific weight needed
- Prefer `containerRelativeFrame()` or `visualEffect()` over `GeometryReader`
- `ForEach(x.enumerated(), id: \.element.id)` — don't wrap in `Array()`
- `.scrollIndicators(.hidden)` not `showsIndicators: false`
- Place logic in reducers/state structs — views focus on presentation
- Avoid `AnyView` unless required
- Avoid hardcoded padding/spacing values
- Avoid UIKit colors

## SwiftData with CloudKit

- Never use `@Attribute(.unique)`
- Properties need defaults or be optional
- All relationships optional

## Framework References

- `references/foundation-models.md` — Core API, availability, sessions, errors
- `references/foundation-models-generable.md` — `@Generable`, `@Guide`, structured output
- `references/foundation-models-tools.md` — Tool protocol, custom integrations
- `references/foundation-models-performance.md` — Pre-warming, sampling, optimization

## Project Structure

- Folder layout by feature
- One type per file
- Unit tests for core logic; UI tests only when unit tests impossible
- Document as needed
- Never commit secrets
- SwiftLint clean before commits
