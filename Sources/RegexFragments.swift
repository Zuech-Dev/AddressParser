//
//  RegexFragments.swift
//  AddressParser
//
//  Named-capture regex fragments composed into the full address patterns in
//  AddressParser. Group names (e.g. `streetName`, `unitType`) are part of the
//  contract with ComponentExtractor — keep them stable across patterns.
//

import Foundation

enum Patterns {
    // MARK: - PO Box & Unit

    static let poBox = #"(?<unitType>P.?O.?\s+Box)"#
    static let unitType = #"(?<unitType>[A-Za-z]+)"#
    static let unitNumber = #"(?<unitNumber>(?:\w+\-?){0,4})?"#
    static let combinedUnit =
        #"(\#(unitType)\#(optSpace)\#(unitNumber),)?"#

    // MARK: - Street

    static let streetNumber = #"(?<streetNumber>\d+-?\w?)"#
    static let streetName = #"(?<streetName>[[\d]\w(&)\s\/\\\-]+)"#
    static let streetSuffix = #"(?<streetSuffix>\w+\s*\w?)"#

    /// Single-token street name (no internal whitespace) — used to recognize a
    /// highway-style name immediately followed by a trailing directional, e.g.
    /// the "NC-49" in "283 Nc-49 S". The no-space constraint is what keeps
    /// multi-word "Main St N" out of the trailing-directional pattern.
    static let streetNameSingleToken = #"(?<streetName>[\w&\/\\\-]+)"#

    // MARK: - Directional

    static let leadingDirection = #"(?:\s*(?<leadingDir>SOUTH\-?\s?WEST|NORTH\-?\s?WEST|NORTH\-?\s?EAST|SOUTH\-?\s?EAST|SOUTH|NORTH|EAST|WEST|SW|NW|NE|SE|S|N|E|W)\s+)?(?:[\s]*)?"#
    static let trailingDirection = #"(?:\s+(?<trailingDir>SOUTH\-?\s?WEST|NORTH\-?\s?WEST|NORTH\-?\s?EAST|SOUTH\-?\s?EAST|SOUTH|NORTH|EAST|WEST|SW|NW|NE|SE|S|N|E|W)\s+)?(?:[\s]*)?"#

    /// A required trailing directional that ends the street portion (no trailing
    /// whitespace required — the following comma terminates it). Used by the
    /// trailing-directional no-suffix pattern to force the token into the
    /// direction field rather than letting it be read as a street suffix.
    static let trailingDirectionRequired = #"\s+(?<trailingDir>SOUTH\-?\s?WEST|NORTH\-?\s?WEST|NORTH\-?\s?EAST|SOUTH\-?\s?EAST|SOUTH|NORTH|EAST|WEST|SW|NW|NE|SE|S|N|E|W)"#

    // MARK: - City / State / Zip / Country

    static let city = #"(?<city>[A-Za-z\-?\s*]+){1,5}"#
    static let state = #"(?<state>[A-Za-z]{2})"#
    static let zipcode = #"(?<zip>\d{5})?"#
    static let zipExtension = #"\#(dash)(?<zipExtension>\d{4}?)?"#
    static let country = #"(?<country>[A-Za-z\s]{0,5})"#

    // MARK: - Non-capturing punctuation/whitespace

    static let whitespace = #"(?:[\s]*)"#
    static let space = #"(?:[\s]+)"#
    static let optSpace = #"(?:[\s]*)"#
    static let comma = #"(?:[\s]*[,][\s]*)"#
    static let optComma = #"(?:[\s]*[,]?[\s]*)"#
    static let period = #"(?:\.)?"#
    static let dash = #"(?:\-)?"#

    // MARK: - Derived alternation patterns

    /// Alternation of every known direction key and value (e.g. `NORTH|N|...`),
    /// longest-first to prevent partial matches.
    static let directionalAlternation: String = {
        let keys = Lookups.directions.keys
            .map { NSRegularExpression.escapedPattern(for: $0.uppercased()) }
            .sorted { $0.count > $1.count }
        let values = Lookups.directions.values
            .map { NSRegularExpression.escapedPattern(for: $0.uppercased()) }
            .sorted { $0.count > $1.count }
        return keys.joined(separator: "|") + "|" + values.joined(separator: "|")
    }()

    /// Alternation of every known unit-type key (already regex fragments) and value,
    /// longest-first to prevent partial matches.
    static let unitTypeAlternation: String = {
        let keys = Lookups.unitTypes.keys
            .map { NSRegularExpression.escapedPattern(for: $0.uppercased()) }
            .sorted { $0.count > $1.count }
        let values = Lookups.unitTypes.values
            .map { NSRegularExpression.escapedPattern(for: $0.uppercased()) }
            .sorted { $0.count > $1.count }
        return keys.joined(separator: "|") + "|" + values.joined(separator: "|")
    }()
}
