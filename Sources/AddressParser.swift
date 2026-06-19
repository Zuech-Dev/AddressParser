//
//  AddressParser.swift
//  AddressParser
//
//  Created by Anthony Zuech on 3/27/25.
//

import Foundation

/// Identifies which ordered pattern in `AddressParser` matched an input.
/// The raw values double as stable, human-readable labels for diagnostics.
public enum AddressPattern: String, Sendable, CaseIterable {
    case poBox
    case streetNoSuffixTrailingDir
    case altStreet
    case street
    case streetNoSuffixLeadingDir
    case streetNoSuffix
    case simpleStreet
    /// No pattern matched; `parseAddress` returns an empty `AddressComponents`.
    case none
}

public class AddressParser {
    /// Ordered list of address-shape patterns, tried first-match-wins.
    /// More specific patterns must precede more general ones, otherwise a
    /// general pattern will swallow inputs intended for a later, stricter one.
    private static let addressRegexList: [(kind: AddressPattern, regex: NSRegularExpression)] = {
        let P = Patterns.self

        // 1) PO Box: "PO Box 279 Staley, NC 27355"
        let poBoxPattern =
            #"^\#(P.whitespace)\#(P.poBox)\#(P.space)\#(P.unitNumber)\#(P.comma)\#(P.city)\#(P.comma)\#(P.state)\#(P.optComma)\#(P.zipcode)\#(P.zipExtension)\#(P.optComma)\#(P.country)\#(P.whitespace)$"#

        // 2) Single-token street with a trailing directional and NO suffix:
        // "283 Nc-49 S, Asheboro, NC 27205" → streetName "NC-49", direction "S".
        // Must precede altStreetPattern, which would otherwise read the bare "S"
        // as a streetSuffix. The single-token name (no internal space) is what
        // keeps multi-word "Main St N" out — there the name grabs only "Main",
        // and "St" is not a directional, so it falls through to altStreetPattern.
        let streetNoSuffixTrailingDirPattern =
            #"^\#(P.whitespace)\#(P.streetNumber)\#(P.space)\#(P.streetNameSingleToken)\#(P.trailingDirectionRequired)\#(P.comma)\#(P.combinedUnit)\#(P.city)\#(P.comma)\#(P.state)\#(P.optComma)\#(P.zipcode)\#(P.zipExtension)\#(P.optComma)\#(P.country)\#(P.whitespace)$"#

        // 3) Street with trailing directional: "555 Allen St E, Boise, ID 83709"
        // toString() normalizes the trailing directional back to leading position.
        let altStreetPattern =
            #"^\#(P.whitespace)\#(P.streetNumber)\#(P.space)\#(P.streetName)\#(P.space)\#(P.streetSuffix)\#(P.comma)\#(P.trailingDirection)\#(P.comma)\#(P.combinedUnit)\#(P.city)\#(P.comma)\#(P.state)\#(P.optComma)\#(P.zipcode)\#(P.zipExtension)\#(P.optComma)\#(P.country)\#(P.whitespace)$"#

        // 4) Street with optional leading directional and unit: "3605 Maldon Way, Apt 25, High Point, NC 27260"
        let streetPattern =
            #"^\#(P.whitespace)\#(P.streetNumber)\#(P.space)\#(P.leadingDirection)\#(P.optSpace)\#(P.streetName)\#(P.space)\#(P.streetSuffix)\#(P.comma)\#(P.combinedUnit)\#(P.city)\#(P.comma)\#(P.state)\#(P.optComma)\#(P.zipcode)\#(P.zipExtension)\#(P.optComma)\#(P.country)\#(P.whitespace)$"#

        // 5) Street with leading directional but no suffix: "283 S Nc-49, Asheboro, NC 27205"
        // Must precede streetNoSuffixPattern: with a dash now allowed in streetName,
        // that pattern would otherwise greedily swallow the leading "S" into the street name.
        let streetNoSuffixLeadingDirPattern =
            #"^\#(P.whitespace)\#(P.streetNumber)\#(P.space)\#(P.leadingDirection)\#(P.optSpace)\#(P.streetName)\#(P.comma)\#(P.combinedUnit)\#(P.city)\#(P.comma)\#(P.state)\#(P.optComma)\#(P.zipcode)\#(P.zipExtension)\#(P.optComma)\#(P.country)\#(P.whitespace)$"#

        // 6) Street with no suffix and no directional: "283 Nc-49, Asheboro, NC 27205".
        // Fallthrough target once the directional patterns (5, then 2) decline.
        let streetNoSuffixPattern =
            #"^\#(P.whitespace)\#(P.streetNumber)\#(P.space)\#(P.streetName)\#(P.comma)\#(P.combinedUnit)\#(P.city)\#(P.comma)\#(P.state)\#(P.optComma)\#(P.zipcode)\#(P.zipExtension)\#(P.optComma)\#(P.country)\#(P.whitespace)$"#

        // 7) Simple street with no directional or unit
        let simpleStPattern =
            #"^\#(P.whitespace)\#(P.streetNumber)\s+\#(P.streetName)\s+\#(P.streetSuffix),\s+\#(P.city),\s+\#(P.state)\s+\#(P.zipcode)\#(P.zipExtension)\#(P.optComma)\#(P.country)\#(P.whitespace)$"#

        let entries: [(AddressPattern, String)] = [
            (.poBox, poBoxPattern),
            (.streetNoSuffixTrailingDir, streetNoSuffixTrailingDirPattern),
            (.altStreet, altStreetPattern),
            (.street, streetPattern),
            (.streetNoSuffixLeadingDir, streetNoSuffixLeadingDirPattern),
            (.streetNoSuffix, streetNoSuffixPattern),
            (.simpleStreet, simpleStPattern),
        ]

        return entries.compactMap { kind, pattern in
            (try? NSRegularExpression(
                pattern: pattern,
                options: [.allowCommentsAndWhitespace, .caseInsensitive]
            )).map { (kind, $0) }
        }
    }()

    public static func parseAddress(_ address: String) -> AddressComponents {
        parseAddressWithPattern(address).components
    }

    /// Like `parseAddress`, but also reports which ordered pattern matched.
    /// Returns `.none` (with an empty `AddressComponents`) when nothing matches.
    public static func parseAddressWithPattern(
        _ address: String
    ) -> (components: AddressComponents, pattern: AddressPattern) {
        let sanitized = address.replacingOccurrences(of: ".", with: "")
        let range = NSRange(sanitized.startIndex..<sanitized.endIndex, in: sanitized)

        for entry in addressRegexList {
            if let match = entry.regex.firstMatch(in: sanitized, options: [], range: range) {
                return (ComponentExtractor.extract(from: match, in: sanitized), entry.kind)
            }
        }
        return (AddressComponents(), .none)
    }
}
