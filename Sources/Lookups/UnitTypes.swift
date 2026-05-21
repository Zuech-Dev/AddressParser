//
//  UnitTypes.swift
//  AddressParser
//

import Foundation

extension Lookups {
    /// Keys are regex fragments (not literal strings) so that misspellings
    /// like "APARTMNT" or "BLDGN" still normalize to the USPS abbreviation.
    static let unitTypes: [String: String] = [
        "SU?I?TE": "STE",
        "(?:AP)(?:AR)?T(?:ME?NT)?": "APT",
        "(?:DEP)(?:AR)?T(?:ME?NT)?": "DEPT",
        "RO*M": "RM",
        "FLO*R?": "FL",
        "UNI?T": "UNIT",
        "BU?I?LDI?N?G": "BLDG",
        "HA?NGA?R": "HNGR",
        "KEY": "KEY",
        "LO?T": "LOT",
        "PIER": "PIER",
        "SLIP": "SLIP",
        "SPA?CE?": "SPACE",
        "STOP": "STOP",
        "TRA?I?LE?R": "TRLR",
        "PO BOX": "PO BOX",
        "P.O. BOX": "PO BOX",
        "BOX": "BOX",
        "BA?SE?ME?N?T": "BSMT",
        "FRO?NT": "FRNT",
        "LO?BBY": "LBBY",
        "LOWE?R": "LOWR",
        "OFF?I?CE?": "OFC",
        "PE?N?T?HO?U?S?E?": "PH",
        "REAR": "REAR",
        "SIDE": "SIDE",
        "UPPE?R": "UPPR",
    ]
}
