//
//  AddressParser.swift
//  AddressParser
//
//  Created by Anthony Zuech on 3/27/25.
//

import Foundation

public class AddressParser {
    private static let streetSuffixPatterns = [
        "ALLEE": "ALY",
        "ALLEY": "ALY",
        "ALLY": "ALY",
        "ANEX": "ANX",
        "ANNEX": "ANX",
        "ANNX": "ANX",
        "ARCADE": "ARC",
        "AV": "AVE",
        "AVEN": "AVE",
        "AVENU": "AVE",
        "AVENUE": "AVE",
        "AVN": "AVE",
        "AVNUE": "AVE",
        "BAYOO": "BYU",
        "BAYOU": "BYU",
        "BEACH": "BCH",
        "BEND": "BND",
        "BLUF": "BLF",
        "BLUFF": "BLF",
        "BLUFFS": "BLFS",
        "BOT": "BTM",
        "BOTTM": "BTM",
        "BOTTOM": "BTM",
        "BOUL": "BLVD",
        "BOULEVARD": "BLVD",
        "BOULV": "BLVD",
        "BRANCH": "BR",
        "BRDGE": "BRG",
        "BRIDGE": "BRG",
        "BRNCH": "BR",
        "BROOK": "BRK",
        "BROOKS": "BRKS",
        "BURG": "BG",
        "BURGS": "BGS",
        "BYPA": "BYP",
        "BYPAS": "BYP",
        "BYPASS": "BYP",
        "BYPS": "BYP",
        "CAMP": "CP",
        "CANYN": "CYN",
        "CANYON": "CYN",
        "CAPE": "CPE",
        "CAUSEWAY": "CSWY",
        "CAUSWAY": "CSWY",
        "CEN": "CTR",
        "CENT": "CTR",
        "CENTER": "CTR",
        "CENTERS": "CTRS",
        "CENTR": "CTR",
        "CENTRE": "CTR",
        "CIRC": "CIR",
        "CIRCL": "CIR",
        "CIRCLE": "CIR",
        "CIRCLES": "CIRS",
        "CK": "CRK",
        "CLIFF": "CLF",
        "CLIFFS": "CLFS",
        "CLUB": "CLB",
        "CMP": "CP",
        "CNTER": "CTR",
        "CNTR": "CTR",
        "CNYN": "CYN",
        "COMMON": "CMN",
        "CORNER": "COR",
        "CORNERS": "CORS",
        "COURSE": "CRSE",
        "COURT": "CT",
        "COURTS": "CTS",
        "COVE": "CV",
        "COVES": "CVS",
        "CR": "CRK",
        "CRCL": "CIR",
        "CRCLE": "CIR",
        "CRECENT": "CRES",
        "CREEK": "CRK",
        "CRESCENT": "CRES",
        "CRESENT": "CRES",
        "CREST": "CRST",
        "CROSSING": "XING",
        "CROSSROAD": "XRD",
        "CRSCNT": "CRES",
        "CRSENT": "CRES",
        "CRSNT": "CRES",
        "CRSSING": "XING",
        "CRSSNG": "XING",
        "CRT": "CT",
        "CURVE": "CURV",
        "DALE": "DL",
        "DAM": "DM",
        "DIV": "DV",
        "DIVIDE": "DV",
        "DRIV": "DR",
        "DRIVE": "DR",
        "DRIVES": "DRS",
        "DRV": "DR",
        "DVD": "DV",
        "ESTATE": "EST",
        "ESTATES": "ESTS",
        "EXP": "EXPY",
        "EXPR": "EXPY",
        "EXPRESS": "EXPY",
        "EXPRESSWAY": "EXPY",
        "EXPW": "EXPY",
        "EXTENSION": "EXT",
        "EXTENSIONS": "EXTS",
        "EXTN": "EXT",
        "EXTNSN": "EXT",
        "FALLS": "FLS",
        "FERRY": "FRY",
        "FIELD": "FLD",
        "FIELDS": "FLDS",
        "FLAT": "FLT",
        "FLATS": "FLTS",
        "FORD": "FRD",
        "FORDS": "FRDS",
        "FOREST": "FRST",
        "FORESTS": "FRST",
        "FORG": "FRG",
        "FORGE": "FRG",
        "FORGES": "FRGS",
        "FORK": "FRK",
        "FORKS": "FRKS",
        "FORT": "FT",
        "FREEWAY": "FWY",
        "FREEWY": "FWY",
        "FRRY": "FRY",
        "FRT": "FT",
        "FRWAY": "FWY",
        "FRWY": "FWY",
        "GARDEN": "GDN",
        "GARDENS": "GDNS",
        "GARDN": "GDN",
        "GATEWAY": "GTWY",
        "GATEWY": "GTWY",
        "GATWAY": "GTWY",
        "GLEN": "GLN",
        "GLENS": "GLNS",
        "GRDEN": "GDN",
        "GRDN": "GDN",
        "GRDNS": "GDNS",
        "GREEN": "GRN",
        "GREENS": "GRNS",
        "GROV": "GRV",
        "GROVE": "GRV",
        "GROVES": "GRVS",
        "GTWAY": "GTWY",
        "HARB": "HBR",
        "HARBOR": "HBR",
        "HARBORS": "HBRS",
        "HARBR": "HBR",
        "HAVEN": "HVN",
        "HAVN": "HVN",
        "HEIGHT": "HTS",
        "HEIGHTS": "HTS",
        "HGTS": "HTS",
        "HIGHWAY": "HWY",
        "HIGHWY": "HWY",
        "HILL": "HL",
        "HILLS": "HLS",
        "HIWAY": "HWY",
        "HIWY": "HWY",
        "HLLW": "HOLW",
        "HOLLOW": "HOLW",
        "HOLLOWS": "HOLW",
        "HOLWS": "HOLW",
        "HRBOR": "HBR",
        "HT": "HTS",
        "HWAY": "HWY",
        "INLET": "INLT",
        "ISLAND": "IS",
        "ISLANDS": "ISS",
        "ISLES": "ISLE",
        "ISLND": "IS",
        "ISLNDS": "ISS",
        "JCTION": "JCT",
        "JCTN": "JCT",
        "JCTNS": "JCTS",
        "JUNCTION": "JCT",
        "JUNCTIONS": "JCTS",
        "JUNCTN": "JCT",
        "JUNCTON": "JCT",
        "KEY": "KY",
        "KEYS": "KYS",
        "KNOL": "KNL",
        "KNOLL": "KNL",
        "KNOLLS": "KNLS",
        "LA": "LN",
        "LAKE": "LK",
        "LAKES": "LKS",
        "LANDING": "LNDG",
        "LANE": "LN",
        "LANES": "LN",
        "LDGE": "LDG",
        "LIGHT": "LGT",
        "LIGHTS": "LGTS",
        "LNDNG": "LNDG",
        "LOAF": "LF",
        "LOCK": "LCK",
        "LOCKS": "LCKS",
        "LODG": "LDG",
        "LODGE": "LDG",
        "LOOPS": "LOOP",
        "MANOR": "MNR",
        "MANORS": "MNRS",
        "MEADOW": "MDW",
        "MEADOWS": "MDWS",
        "MEDOWS": "MDWS",
        "MILL": "ML",
        "MILLS": "MLS",
        "MISSION": "MSN",
        "MISSN": "MSN",
        "MNT": "MT",
        "MNTAIN": "MTN",
        "MNTN": "MTN",
        "MNTNS": "MTNS",
        "MOTORWAY": "MTWY",
        "MOUNT": "MT",
        "MOUNTAIN": "MTN",
        "MOUNTAINS": "MTNS",
        "MOUNTIN": "MTN",
        "MSSN": "MSN",
        "MTIN": "MTN",
        "NECK": "NCK",
        "ORCHARD": "ORCH",
        "ORCHRD": "ORCH",
        "OVERPASS": "OPAS",
        "OVL": "OVAL",
        "PARKS": "PARK",
        "PARKWAY": "PKWY",
        "PARKWAYS": "PKWY",
        "PARKWY": "PKWY",
        "PASSAGE": "PSGE",
        "PATHS": "PATH",
        "PIKES": "PIKE",
        "PINE": "PNE",
        "PINES": "PNES",
        "PK": "PARK",
        "PKWAY": "PKWY",
        "PKWYS": "PKWY",
        "PKY": "PKWY",
        "PLACE": "PL",
        "PLAIN": "PLN",
        "PLAINES": "PLNS",
        "PLAINS": "PLNS",
        "PLAZA": "PLZ",
        "PLZA": "PLZ",
        "POINT": "PT",
        "POINTS": "PTS",
        "PORT": "PRT",
        "PORTS": "PRTS",
        "PRAIRIE": "PR",
        "PRARIE": "PR",
        "PRK": "PARK",
        "PRR": "PR",
        "RAD": "RADL",
        "RADIAL": "RADL",
        "RADIEL": "RADL",
        "RANCH": "RNCH",
        "RANCHES": "RNCH",
        "RAPID": "RPD",
        "RAPIDS": "RPDS",
        "RDGE": "RDG",
        "REST": "RST",
        "RIDGE": "RDG",
        "RIDGES": "RDGS",
        "RIVER": "RIV",
        "RIVR": "RIV",
        "RNCHS": "RNCH",
        "ROAD": "RD",
        "ROADS": "RDS",
        "ROUTE": "RTE",
        "RVR": "RIV",
        "SHOAL": "SHL",
        "SHOALS": "SHLS",
        "SHOAR": "SHR",
        "SHOARS": "SHRS",
        "SHORE": "SHR",
        "SHORES": "SHRS",
        "SKYWAY": "SKWY",
        "SPNG": "SPG",
        "SPNGS": "SPGS",
        "SPRING": "SPG",
        "SPRINGS": "SPGS",
        "SPRNG": "SPG",
        "SPRNGS": "SPGS",
        "SPURS": "SPUR",
        "SQR": "SQ",
        "SQRE": "SQ",
        "SQRS": "SQS",
        "SQU": "SQ",
        "SQUARE": "SQ",
        "SQUARES": "SQS",
        "STATION": "STA",
        "STATN": "STA",
        "STN": "STA",
        "STR": "ST",
        "STRAV": "STRA",
        "STRAVE": "STRA",
        "STRAVEN": "STRA",
        "STRAVENUE": "STRA",
        "STRAVN": "STRA",
        "STREAM": "STRM",
        "STREET": "ST",
        "STREETS": "STS",
        "STREME": "STRM",
        "STRT": "ST",
        "STRVN": "STRA",
        "STRVNUE": "STRA",
        "SUMIT": "SMT",
        "SUMITT": "SMT",
        "SUMMIT": "SMT",
        "TERR": "TER",
        "TERRACE": "TER",
        "THROUGHWAY": "TRWY",
        "TPK": "TPKE",
        "TR": "TRL",
        "TRACE": "TRCE",
        "TRACES": "TRCE",
        "TRACK": "TRAK",
        "TRACKS": "TRAK",
        "TRAFFICWAY": "TRFY",
        "TRAIL": "TRL",
        "TRAILS": "TRL",
        "TRK": "TRAK",
        "TRKS": "TRAK",
        "TRLS": "TRL",
        "TRNPK": "TPKE",
        "TRPK": "TPKE",
        "TUNEL": "TUNL",
        "TUNLS": "TUNL",
        "TUNNEL": "TUNL",
        "TUNNELS": "TUNL",
        "TUNNL": "TUNL",
        "TURNPIKE": "TPKE",
        "TURNPK": "TPKE",
        "UNDERPASS": "UPAS",
        "UNION": "UN",
        "UNIONS": "UNS",
        "VALLEY": "VLY",
        "VALLEYS": "VLYS",
        "VALLY": "VLY",
        "VDCT": "VIA",
        "VIADCT": "VIA",
        "VIADUCT": "VIA",
        "VIEW": "VW",
        "VIEWS": "VWS",
        "VILL": "VLG",
        "VILLAG": "VLG",
        "VILLAGE": "VLG",
        "VILLAGES": "VLGS",
        "VILLE": "VL",
        "VILLG": "VLG",
        "VILLIAGE": "VLG",
        "VIST": "VIS",
        "VISTA": "VIS",
        "VLLY": "VLY",
        "VST": "VIS",
        "VSTA": "VIS",
        "WALKS": "WALK",
        "WELL": "WL",
        "WELLS": "WLS",
        "WY": "WAY",
    ]

    private static let directionPatterns = [
        "NORTH": "N",
        "NORTHEAST": "NE",
        "EAST": "E",
        "SOUTHEAST": "SE",
        "SOUTH": "S",
        "SOUTHWEST": "SW",
        "WEST": "W",
        "NORTHWEST": "NW",
    ]

    private static let unitTypePatterns = [
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

    private static let statePatterns = [
        "ALABAMA": "AL",
        "ALASKA": "AK",
        "ARIZONA": "AZ",
        "ARKANSAS": "AR",
        "CALIFORNIA": "CA",
        "COLORADO": "CO",
        "CONNECTICUT": "CT",
        "DELAWARE": "DE",
        "FLORIDA": "FL",
        "GEORGIA": "GA",
        "HAWAII": "HI",
        "IDAHO": "ID",
        "ILLINOIS": "IL",
        "INDIANA": "IN",
        "IOWA": "IA",
        "KANSAS": "KS",
        "KENTUCKY": "KY",
        "LOUISIANA": "LA",
        "MAINE": "ME",
        "MARYLAND": "MD",
        "MASSACHUSETTS": "MA",
        "MICHIGAN": "MI",
        "MINNESOTA": "MN",
        "MISSISSIPPI": "MS",
        "MISSOURI": "MO",
        "MONTANA": "MT",
        "NEBRASKA": "NE",
        "NEVADA": "NV",
        "NEW HAMPSHIRE": "NH",
        "NEW JERSEY": "NJ",
        "NEW MEXICO": "NM",
        "NEW YORK": "NY",
        "NORTH CAROLINA": "NC",
        "NORTH DAKOTA": "ND",
        "OHIO": "OH",
        "OKLAHOMA": "OK",
        "OREGON": "OR",
        "PENNSYLVANIA": "PA",
        "RHODE ISLAND": "RI",
        "SOUTH CAROLINA": "SC",
        "SOUTH DAKOTA": "SD",
        "TENNESSEE": "TN",
        "TEXAS": "TX",
        "UTAH": "UT",
        "VERMONT": "VT",
        "VIRGINIA": "VA",
        "WASHINGTON": "WA",
        "WEST VIRGINIA": "WV",
        "WISCONSIN": "WI",
        "WYOMING": "WY",
    ]

    private static let directionalPatternRegex: String = {
        let keys = directionPatterns.keys
            .map { NSRegularExpression.escapedPattern(for: $0.uppercased()) }
            .sorted { $0.count > $1.count }
        let values = directionPatterns.values
            .map { NSRegularExpression.escapedPattern(for: $0.uppercased()) }
            .sorted { $0.count > $1.count }
        let pattern =
            keys.joined(separator: "|") + "|"
            + values.joined(separator: "|")
        return pattern
    }()

    private static let knownUnitTypeRegex: String = {
        let keys = unitTypePatterns.keys
            .map { NSRegularExpression.escapedPattern(for: $0.uppercased()) }
            .sorted { $0.count > $1.count }
        let values = unitTypePatterns.values
            .map { NSRegularExpression.escapedPattern(for: $0.uppercased()) }
            .sorted { $0.count > $1.count }
        let pattern =
            keys.joined(separator: "|") + "|"
            + values.joined(separator: "|")
        return pattern
    }()

    // PO Box & Unit regex
    private static let poBoxRegex = #"(?<unitType>P.?O.?\s+Box)"#
    private static let unitTypeRegex = #"(?<unitType>[A-Za-z]+)"#
    private static let unitNumberRegex = #"(?<unitNumber>(?:\w+\-?){0,4})?"#
    private static let combinedUnitRegex =
        #"(\#(unitTypeRegex)\#(optSpaceRegex)\#(unitNumberRegex),)?"#

    // Street Regex
    private static let streetNumberRegex = #"(?<streetNumber>\d+-?\w)"#
    private static let streetNameRegex = #"(?<streetName>[A-Za-z\s]+)"#
    private static let streetSuffixRegex = #"(?<streetSuffix>\w+\s*\w?)"#

    // Directional Regex
    private static let leadingDirectionRegex = #"(?:\s*(?<leadingDir>SOUTH\-?\s?WEST|NORTH\-?\s?WEST|NORTH\-?\s?EAST|SOUTH\-?\s?EAST|SOUTH|NORTH|EAST|WEST|SW|NW|NE|SE|S|N|E|W)\s+)?(?:[\s]*)?"#
    private static let trailingDirectionRegex =
    #"(?:\s+(?<trailingDir>SOUTH\-?\s?WEST|NORTH\-?\s?WEST|NORTH\-?\s?EAST|SOUTH\-?\s?EAST|SOUTH|NORTH|EAST|WEST|SW|NW|NE|SE|S|N|E|W)\s+)?(?:[\s]*)?"#

    // City, State, Zip Regex
    private static let cityRegex = #"(?<city>[A-Za-z\-?\s*]+){1,5}"#
    private static let stateRegex = #"(?<state>[A-Za-z]{2})"#
    private static let zipcodeRegex = #"(?<zip>\d{5})"#
    private static let zipExtensionRegex =
        #"\#(dashRegex)(?<zipExtension>\d{4}?)?"#
    
    // Country
    private static let countryRegex = #"(?<country>[A-Za-z\s]{0,5})"#

    // Non-Capturing Regex
    private static let whitespaceRegex = #"(?:[\s]*)"#
    private static let spaceRegex = #"(?:[\s]+)"#
    private static let optSpaceRegex = #"(?:[\s]*)"#
    private static let commaRegex = #"(?:[\s]*[,][\s]*)"#
    private static let optCommaRegex = #"(?:[\s]*[,]?[\s]*)"#
    private static let periodRegex = #"(?:\.)?"#
    private static let dashRegex = #"(?:\-)?"#
    

    // List of patterns to attempt to parse address with
    private static let addressRegexList: [NSRegularExpression] = {
        var regexList: [NSRegularExpression] = []
        
        // 1) PO Box style: "PO Box 279 Staley, NC 27355"
        // Captures city, state, zip after the box.
        let poBoxPattern =
            #"^\#(whitespaceRegex)\#(poBoxRegex)\#(spaceRegex)\#(unitNumberRegex)\#(commaRegex)\#(cityRegex)\#(commaRegex)\#(stateRegex)\#(optCommaRegex)\#(zipcodeRegex)\#(zipExtensionRegex)\#(optCommaRegex)\#(countryRegex)\#(whitespaceRegex)$"#

        if let poBoxRegex = try? NSRegularExpression(
            pattern: poBoxPattern,
            options: [.allowCommentsAndWhitespace, .caseInsensitive])
        {
            regexList.append(poBoxRegex)
        }

        // 2) Street address with optional unit and trailing directional: 555 Allen St E, Boise, ID 83709.
        // Standardized toString() method moves trailing directionals to leading directional.
        let altStreetPattern =
            #"^\#(whitespaceRegex)\#(streetNumberRegex)\#(spaceRegex)\#(streetNameRegex)\#(spaceRegex)\#(streetSuffixRegex)\#(commaRegex)\#(trailingDirectionRegex)\#(commaRegex)\#(combinedUnitRegex)\#(cityRegex)\#(commaRegex)\#(stateRegex)\#(optCommaRegex)\#(zipcodeRegex)\#(zipExtensionRegex)\#(optCommaRegex)\#(countryRegex)\#(whitespaceRegex)$"#

        if let altStreetRegex = try? NSRegularExpression(
            pattern: altStreetPattern,
            options: [.allowCommentsAndWhitespace, .caseInsensitive]
        ) {
            regexList.append(altStreetRegex)
        }

        // 3) Street address with optional unit: "3605 Maldon Way, Apt 25, High Point, NC 27260"
        // This pattern tries to handle direction, suffix, and an optional unit.
        let streetPattern =
            #"^\#(whitespaceRegex)\#(streetNumberRegex)\#(spaceRegex)\#(leadingDirectionRegex)\#(optSpaceRegex)\#(streetNameRegex)\#(spaceRegex)\#(streetSuffixRegex)\#(commaRegex)\#(combinedUnitRegex)\#(cityRegex)\#(commaRegex)\#(stateRegex)\#(optCommaRegex)\#(zipcodeRegex)\#(zipExtensionRegex)\#(optCommaRegex)\#(countryRegex)\#(whitespaceRegex)$"#

        if let streetRegex = try? NSRegularExpression(
            pattern: streetPattern,
            options: [.allowCommentsAndWhitespace, .caseInsensitive]
        ) {
            regexList.append(streetRegex)
        }

        // 4) Simple street address with no directionals or units
        let simpleStPattern =
            #"^\#(whitespaceRegex)\#(streetNumberRegex)\s+\#(streetNameRegex)\s+\#(streetSuffixRegex),\s+\#(cityRegex),\s+\#(stateRegex)\s+\#(zipcodeRegex)\#(zipExtensionRegex)\#(optCommaRegex)\#(countryRegex)\#(whitespaceRegex)$"#

        if let simpleStRegex = try? NSRegularExpression(
            pattern: simpleStPattern,
            options: [.allowCommentsAndWhitespace, .caseInsensitive]
        ) {
            regexList.append(simpleStRegex)
        }

        return regexList
    }()

//    public func addCustomRegex(_ regex: NSRegularExpression) {
//        AddressParser.regexList.append(regex)
//    }

    public static func parseAddress(_ address: String)
        -> AddressComponents
    {
        for regex in addressRegexList {
            let range = NSRange(
                address.startIndex..<address.endIndex, in: address)
            if let match = regex.firstMatch(
                in: address, options: [], range: range)
            {
                print(regex)
                return extractComponents(from: match, in: address, with: regex)
            }
            continue
        }
        return AddressComponents()
    }

    private static func extractComponents(
        from match: NSTextCheckingResult,
        in address: String,
        with regex: NSRegularExpression
    ) -> AddressComponents {
        // Street
        let rawStreetNumber = capture("streetNumber")
        let rawStreetName = capture("streetName").capitalized
        let rawSuffix = capture("streetSuffix").uppercased()

        // Directional
        let leadingDir = capture("leadingDir").uppercased()
        let trailingDir = capture("trailingDir").uppercased()

        // Unit
        let rawUnitType = capture("unitType").uppercased()
        let unitNumber = capture("unitNumber")

        // Municipal
        let rawCity = capture("city").capitalized
        let rawState = capture("state").uppercased()
        let zipcode = capture("zip")
        let zipcodeExtension = capture("zipExtension")
        
        // Country
        let country = capture("country").uppercased()

        // Normalize fields:
        let directionPart = [leadingDir, trailingDir].filter { !$0.isEmpty }
            .joined(separator: " ")
        let direction =
            directionPatterns[directionPart.uppercased()]?.capitalized
            ?? directionPart

        let streetSuffix =
            streetSuffixPatterns[rawSuffix.uppercased()]?.capitalized
            ?? rawSuffix.capitalized

        var unitType = ""
        if !rawUnitType.isEmpty {
            let found = unitTypePatterns.first {
                let (keyRegex, _) = $0
                return rawUnitType.range(
                    of: keyRegex, options: .regularExpression) != nil
                    ? true : false
            }
            if let match = found {
                unitType =
                    match.value.capitalized
            }
        }

        let normalizedState = statePatterns[rawState.uppercased()] ?? rawState

        if !rawUnitType.isEmpty && rawUnitType == "PO BOX" {
            let unitType = capture("unitType").capitalized
            
            return AddressComponents(
                streetNumber: "",
                streetName: "",
                streetSuffix: "",
                direction: "",
                unitType: unitType == "Po Box"
                    ? "PO Box" : unitType.capitalized,
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
            streetName: rawStreetName.trimmingCharacters(
                in: .whitespacesAndNewlines),
            streetSuffix: streetSuffix,
            direction: direction.trimmingCharacters(
                in: .whitespacesAndNewlines),
            unitType:
                unitType
                .trimmingCharacters(in: .whitespacesAndNewlines).capitalized,
            unitNumber:
                unitNumber
                .trimmingCharacters(in: .whitespacesAndNewlines),
            city: rawCity.trimmingCharacters(in: .whitespacesAndNewlines),
            state: normalizedState,
            zipcode: zipcode,
            zipcodeExtension: zipcodeExtension,
            country: country
        )

        func capture(_ name: String) -> String {
            let nsRange = match.range(withName: name)
            guard nsRange.location != NSNotFound,
                let range = Range(nsRange, in: address)
            else {
                return ""
            }
            return String(address[range])
        }
    }
}


// Create a method for breaking into larger parts rather than individually.
// 1. Break into full st, municipal
// 2a. full st into primary and secondary
// 2b. primary into st num, st, directional
// 2c. st into name and suffix
// 2d. secondary into unit and number
// 3a. municipal into city, state, zip, country
// 4. assign all found pieces to the components
// 5. return any founds components instead of an empty components when it fails.
