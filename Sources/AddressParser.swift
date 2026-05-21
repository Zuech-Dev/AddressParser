//
//  AddressParser.swift
//  AddressParser
//
//  Created by Anthony Zuech on 3/27/25.
//

import Foundation

public class AddressParser {
    /// Ordered list of address-shape patterns, tried first-match-wins.
    /// More specific patterns must precede more general ones, otherwise a
    /// general pattern will swallow inputs intended for a later, stricter one.
    private static let addressRegexList: [NSRegularExpression] = {
        let P = Patterns.self

        // 1) PO Box: "PO Box 279 Staley, NC 27355"
        let poBoxPattern =
            #"^\#(P.whitespace)\#(P.poBox)\#(P.space)\#(P.unitNumber)\#(P.comma)\#(P.city)\#(P.comma)\#(P.state)\#(P.optComma)\#(P.zipcode)\#(P.zipExtension)\#(P.optComma)\#(P.country)\#(P.whitespace)$"#

        // 2) Street with trailing directional: "555 Allen St E, Boise, ID 83709"
        // toString() normalizes the trailing directional back to leading position.
        let altStreetPattern =
            #"^\#(P.whitespace)\#(P.streetNumber)\#(P.space)\#(P.streetName)\#(P.space)\#(P.streetSuffix)\#(P.comma)\#(P.trailingDirection)\#(P.comma)\#(P.combinedUnit)\#(P.city)\#(P.comma)\#(P.state)\#(P.optComma)\#(P.zipcode)\#(P.zipExtension)\#(P.optComma)\#(P.country)\#(P.whitespace)$"#

        // 3) Street with optional leading directional and unit: "3605 Maldon Way, Apt 25, High Point, NC 27260"
        let streetPattern =
            #"^\#(P.whitespace)\#(P.streetNumber)\#(P.space)\#(P.leadingDirection)\#(P.optSpace)\#(P.streetName)\#(P.space)\#(P.streetSuffix)\#(P.comma)\#(P.combinedUnit)\#(P.city)\#(P.comma)\#(P.state)\#(P.optComma)\#(P.zipcode)\#(P.zipExtension)\#(P.optComma)\#(P.country)\#(P.whitespace)$"#

        // 4) Street with no suffix (numbered streets, etc.)
        let streetNoSuffixPattern =
            #"^\#(P.whitespace)\#(P.streetNumber)\#(P.space)\#(P.streetName)\#(P.comma)\#(P.combinedUnit)\#(P.city)\#(P.comma)\#(P.state)\#(P.optComma)\#(P.zipcode)\#(P.zipExtension)\#(P.optComma)\#(P.country)\#(P.whitespace)$"#

        // 5) Simple street with no directional or unit
        let simpleStPattern =
            #"^\#(P.whitespace)\#(P.streetNumber)\s+\#(P.streetName)\s+\#(P.streetSuffix),\s+\#(P.city),\s+\#(P.state)\s+\#(P.zipcode)\#(P.zipExtension)\#(P.optComma)\#(P.country)\#(P.whitespace)$"#

        return [
            poBoxPattern,
            altStreetPattern,
            streetPattern,
            streetNoSuffixPattern,
            simpleStPattern,
        ].compactMap {
            try? NSRegularExpression(
                pattern: $0,
                options: [.allowCommentsAndWhitespace, .caseInsensitive]
            )
        }
    }()

    public static func parseAddress(_ address: String) -> AddressComponents {
        let sanitized = address.replacingOccurrences(of: ".", with: "")
        let range = NSRange(sanitized.startIndex..<sanitized.endIndex, in: sanitized)

        for regex in addressRegexList {
            if let match = regex.firstMatch(in: sanitized, options: [], range: range) {
                return ComponentExtractor.extract(from: match, in: sanitized)
            }
        }
        return AddressComponents()
    }
}
