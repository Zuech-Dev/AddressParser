//
//  ComponentExtractor.swift
//  AddressParser
//
//  Pulls named captures from a regex match and normalizes each field through
//  the Lookups tables. Callers in AddressParser only invoke `extract`.
//

import Foundation

enum ComponentExtractor {
    static func extract(
        from match: NSTextCheckingResult,
        in address: String
    ) -> AddressComponents {
        func capture(_ name: String) -> String {
            let nsRange = match.range(withName: name)
            guard nsRange.location != NSNotFound,
                  let range = Range(nsRange, in: address)
            else {
                return ""
            }
            return String(address[range])
        }

        // Street
        let rawStreetNumber = capture("streetNumber")
        let rawStreetName = capture("streetName").uppercased()
        let rawSuffix = capture("streetSuffix").uppercased()

        // Directional
        let leadingDir = capture("leadingDir").uppercased()
        let trailingDir = capture("trailingDir").uppercased()

        // Unit
        let rawUnitType = capture("unitType").uppercased()
        let unitNumber = capture("unitNumber")

        // Municipal
        let rawCity = capture("city").uppercased()
        let rawState = capture("state").uppercased()
        let zipcode = capture("zip")
        let zipcodeExtension = capture("zipExtension")
        let country = capture("country").uppercased()

        // Normalize directional (combine leading + trailing, then map to abbreviation).
        let directionPart = [leadingDir, trailingDir]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
        let direction = Lookups.directions[directionPart] ?? directionPart

        // Normalize suffix and state via direct dictionary lookup.
        let streetSuffix = Lookups.streetSuffixes[rawSuffix] ?? rawSuffix
        let normalizedState = Lookups.states[rawState] ?? rawState

        // Unit-type keys are regex fragments — match the raw input against each key.
        let unitType: String = {
            guard !rawUnitType.isEmpty else { return "" }
            let found = Lookups.unitTypes.first { key, _ in
                rawUnitType.range(of: key, options: .regularExpression) != nil
            }
            return found?.value.uppercased() ?? ""
        }()

        // PO Box addresses have no street fields — return early.
        if rawUnitType == "PO BOX" {
            return AddressComponents(
                streetNumber: "",
                streetName: "",
                streetSuffix: "",
                direction: "",
                unitType: "PO BOX",
                unitNumber: unitNumber,
                city: rawCity.trimmingCharacters(in: .whitespacesAndNewlines),
                state: normalizedState,
                zipcode: zipcode,
                zipcodeExtension: zipcodeExtension,
                country: country
            )
        }

        return AddressComponents(
            streetNumber: rawStreetNumber,
            streetName: rawStreetName.trimmingCharacters(in: .whitespacesAndNewlines),
            streetSuffix: streetSuffix,
            direction: direction.trimmingCharacters(in: .whitespacesAndNewlines),
            unitType: unitType.trimmingCharacters(in: .whitespacesAndNewlines),
            unitNumber: unitNumber.trimmingCharacters(in: .whitespacesAndNewlines),
            city: rawCity.trimmingCharacters(in: .whitespacesAndNewlines),
            state: normalizedState,
            zipcode: zipcode,
            zipcodeExtension: zipcodeExtension,
            country: country
        )
    }
}
