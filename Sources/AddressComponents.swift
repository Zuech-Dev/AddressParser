//
//  AddressComponents.swift
//  AddressParser
//
//  Created by Anthony Zuech on 3/27/25.
//

import Foundation

public struct AddressComponents : Equatable, Codable, Sendable {
    public var streetNumber: String
    public var streetName: String
    public var streetSuffix: String
    public var direction: String
    public var unitType: String
    public var unitNumber: String
    public var city: String
    public var state: String
    public var zipcode: String
    public var zipcodeExtension: String
    public var country: String
    
    public init() {
        self.streetNumber = ""
        self.streetName = ""
        self.streetSuffix = ""
        self.direction = ""
        self.unitType = ""
        self.unitNumber = ""
        self.city = ""
        self.state = ""
        self.zipcode = ""
        self.zipcodeExtension = ""
        self.country = ""
    }

    public init(
        streetNumber: String,
        streetName: String,
        streetSuffix: String,
        direction: String,
        unitType: String,
        unitNumber: String,
        city: String,
        state: String,
        zipcode: String,
        zipcodeExtension: String = "",
        country: String = ""
    ) {
        self.streetNumber = streetNumber
        self.streetName = streetName
        self.streetSuffix = streetSuffix
        self.direction = direction
        self.unitType = unitType
        self.unitNumber = unitNumber
        self.city = city
        self.state = state
        self.zipcode = zipcode
        self.zipcodeExtension = zipcodeExtension
        self.country = country
    }

    public func getStreetAddress() -> String {
        return "\(streetNumber) \(direction.isEmpty ? "" : "\(direction) ")\(streetName) \(streetSuffix)".trimmingCharacters(
            in: .whitespacesAndNewlines
        )
    }
    
    public func getSecondaryAddress() -> String {
        return "\(unitType) \(unitNumber)".trimmingCharacters(
            in: .whitespacesAndNewlines
        )
    }
    
    public func getFullStreetAddress() -> String {
        return "\(getStreetAddress())\(getSecondaryAddress().isEmpty ? "" : ", \(getSecondaryAddress())")"
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public func getMunicipal() -> String {
        "\(city), \(state) \(zipcode)".trimmingCharacters(
            in: .whitespacesAndNewlines
        )
    }
    
    public func toString() -> String {
        let streetAddress = "\(streetNumber) \(direction.isEmpty ? "" : "\(direction) ")\(streetName) \(streetSuffix)".trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        let secondaryAddress = "\(unitType) \(unitNumber)".trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        let municipal = "\(city), \(state) \(zipcode)".trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        if (!streetAddress.isEmpty && !secondaryAddress.isEmpty) {
            return "\(streetAddress), \(secondaryAddress), \(municipal)"
        }
        else if (streetAddress.isEmpty) {
            return "\(secondaryAddress), \(municipal)"
        }
        else if (secondaryAddress.isEmpty) {
            return "\(streetAddress), \(municipal)"
        }

        return ""
    }
}

// Helper Methods to create
// isEmpty - if no properties are set
// isComplete - regex was able to account for all characters into regex, even if some properties are still empty (the majority of cases)
// toString with formatting options, defaulting to US standard

