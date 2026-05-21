# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

AddressParser is a Swift Package Manager library that parses US mailing addresses into structured `AddressComponents` using regular expressions. It is intentionally offline — it does **not** validate that an address exists. Minimum toolchain is Swift 6.0 (per `Package.swift`); CI runs against Swift 6.0 and 6.1 on both Linux and macOS.

## Commands

- Build: `swift build`
- Run all tests: `swift test`
- Run a single test (Swift Testing framework, by function name): `swift test --filter parseeAllen`
- Run tests matching a substring: `swift test --filter parsePo`

Tests use the `Testing` framework (`@Test` + `#expect`), not XCTest.

## Architecture

The library is two files under `Sources/`:

### `AddressParser.swift` — the regex engine

The public surface is a single static entry point: `AddressParser.parseAddress(_ address: String) -> AddressComponents`. Internally:

1. **Lookup tables** (`streetSuffixPatterns`, `directionPatterns`, `unitTypePatterns`, `statePatterns`) map verbose variants ("STREET", "BOULEVARD", "NORTH CAROLINA") to USPS abbreviations ("ST", "BLVD", "NC"). The `unitTypePatterns` keys are themselves regex fragments (e.g. `"SU?I?TE"`, `"(?:AP)(?:AR)?T(?:ME?NT)?"`) so misspellings normalize too.

2. **Sub-pattern fragments** (`streetNumberRegex`, `streetNameRegex`, `cityRegex`, etc.) are private string constants. They use named capture groups (`(?<streetNumber>…)`, `(?<city>…)`). These are composed by string interpolation into the top-level patterns — keep group names consistent across patterns so `extractComponents` can pull them by name regardless of which pattern matched.

3. **`addressRegexList`** is an ordered array of compiled `NSRegularExpression`s, tried in sequence until one matches. **Order matters** — more specific patterns must precede more general ones:
   1. PO Box (`"PO Box 279 Staley, NC 27355"`)
   2. Street with trailing directional (`"555 Allen St E, Boise, ID 83709"`)
   3. Street with leading directional and optional unit (`"3605 Maldon Way, Apt 25, …"`)
   4. Street with no suffix (numbered streets, etc.)
   5. Simple street with no directional or unit

   When adding a new pattern, place it where its specificity warrants — a too-general pattern inserted early will swallow inputs intended for later patterns.

4. **`parseAddress` flow**: strips `.` from the input (so "P.O." → "PO"), then walks `addressRegexList` and calls `extractComponents` on the first match. Returns an empty `AddressComponents()` if nothing matches.

5. **`extractComponents`** pulls each named capture, then normalizes via the lookup tables (suffix → USPS, direction parts → joined and abbreviated, state → 2-letter, unit type → regex-matched against `unitTypePatterns`). PO Box matches return early with empty street fields.

### `AddressComponents.swift` — the value type

Plain struct (`Equatable`, `Codable`, `Sendable`) with empty-string defaults. Convenience accessors: `getStreetAddress()`, `getSecondaryAddress()`, `getFullStreetAddress()`, `getMunicipal()`, `toString()`. `toString()` is the canonical/standardized rendering — the test suite frequently round-trips through `parseAddress(component.toString())` to verify normalization.

### Testing pattern

`Tests/AddressParserTests.swift` defines fixture `AddressComponents` at the top of the file (e.g. `eMain`, `eAllen`, `poBox`, `way`), then `@Test` functions feed string variants into `parseAddress` and compare against the fixtures, often via the helper `testFromString(_ address: String, _ expected: AddressComponents)`. When adding support for a new address shape, add both a fixture and a `@Test` that exercises several string variations (with/without punctuation, capitalization, directional position).

## When working on parser changes

- Regex patterns use `.allowCommentsAndWhitespace` and `.caseInsensitive` — whitespace inside the raw-string patterns is ignored, so format for readability.
- Input is uppercased during normalization (most captures get `.uppercased()`), so lookup-table **keys must be uppercase**.
- The lookup tables include common misspellings (e.g. `"SAN FRANCISO"` appears in tests as-is) — do not "fix" misspellings in fixtures unless you're verifying that the parser preserves the user's input rather than correcting it.
- If a new pattern can't match an address the older patterns also can't match, the loop falls through to `return AddressComponents()` (all empty strings). There is no partial-match fallback yet — the comment block at the bottom of `AddressParser.swift` sketches a planned piecewise approach.
