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

    private static let streetSuffixRegex: String = {
        let keys = streetSuffixPatterns.keys
            .map { NSRegularExpression.escapedPattern(for: $0.uppercased()) }
            .sorted { $0.count > $1.count }
        let values = streetSuffixPatterns.values
            .map { NSRegularExpression.escapedPattern(for: $0.uppercased()) }
            .sorted { $0.count > $1.count }
        let pattern =
            keys.joined(separator: "|") + "|"
            + values.joined(separator: "|")
        //        print("\nStreet: " + pattern)
        return pattern
    }()

    private static let directionRegex: String = {
        let keys = directionPatterns.keys
            .map { NSRegularExpression.escapedPattern(for: $0.uppercased()) }
            .sorted { $0.count > $1.count }
        let values = directionPatterns.values
            .map { NSRegularExpression.escapedPattern(for: $0.uppercased()) }
            .sorted { $0.count > $1.count }
        let pattern =
            keys.joined(separator: "|") + "|"
            + values.joined(separator: "|")
        //        print("\nDirection: " + pattern)
        return pattern
    }()

    private static let unitTypeRegex: String = {
        let keys = unitTypePatterns.keys
            .map { NSRegularExpression.escapedPattern(for: $0.uppercased()) }
            .sorted { $0.count > $1.count }
        let values = unitTypePatterns.values
            .map { NSRegularExpression.escapedPattern(for: $0.uppercased()) }
            .sorted { $0.count > $1.count }
        let pattern =
            keys.joined(separator: "|") + "|"
            + values.joined(separator: "|")
        //        print("\nUnit: " + pattern)
        return pattern
    }()

    private static let stateRegex: String = {
        let keys = statePatterns.keys
            .map { NSRegularExpression.escapedPattern(for: $0.uppercased()) }
            .sorted { $0.count > $1.count }
        let values = statePatterns.values
            .map { NSRegularExpression.escapedPattern(for: $0.uppercased()) }
            .sorted { $0.count > $1.count }
        let pattern =
            keys.joined(separator: "|") + "|"
            + values.joined(separator: "|")
        //        print("\nState: " + pattern + "\n")
        return pattern
    }()

    // Regex that can match either a PO Box or a street address format,
    // with optional direction, suffix, unit type, city, state, and ZIP.
    // Note: Real-world addresses can be more complex than this example.
    private static let addressRegexList: [NSRegularExpression] = {
        var list: [NSRegularExpression] = []

        // 1) PO Box style: "PO Box 279 Staley, NC 27355"
        // Captures city, state, zip after the box.
        let poBoxPattern = #"^(?<unitType>P.?O.?\s+Box)\s+(?<unitNumber>\d+-?\w{1,5}?),\s(?<city>[A-Za-z\s]+),\s+(?<state>[A-Za-z\s]{2})\s+(?<zip>\d{5})$"#
        if let poBoxRegex = try? NSRegularExpression(
            pattern: poBoxPattern,
            options: [.allowCommentsAndWhitespace, .caseInsensitive])
        {
            list.append(poBoxRegex)
        }
        
        let simpleStPattern = #"^(?<streetNumber>\d+[-?\s?\w])\s+(?<streetName>[A-Za-z\s]+)\s+(?<streetSuffix>\w+\s?\w?),\s+(?<city>[A-Za-z\s]+){1,5},\s+(?<state>[A-Z]{2})\s+(?<zip>\d{5})$"#
//        print(simpleStPattern)
        if let simpleStRegex = try? NSRegularExpression(
            pattern: simpleStPattern,
            options: [.allowCommentsAndWhitespace, .caseInsensitive]
        ) {
            list.append(simpleStRegex)
        }

        // 2) Street address with optional unit: "3605 Maldon Way, Apt 25, High Point, NC 27260"
        // This pattern tries to handle direction, suffix, and an optional unit.
        let streetPattern = #"^(?<streetNumber>\d+[-?\s?\w])\s+(?<streetName>[A-Za-z\s]+){1,8}\s+(?<streetSuffix>\w+\s?\w?)(?<trailingDir>\#(directionRegex))?,(?:\s+(?<unitType>[A-Za-z\s]+)\s*(?<unitNumber>\w+))?,?\s+(?<city>[A-Za-z\s]+),\s+(?<state>[A-Z]{2})\s+(?<zip>\d{5})$"#
//        print(streetPattern)
        if let streetRegex = try? NSRegularExpression(
            pattern: streetPattern,
            options: [.allowCommentsAndWhitespace, .caseInsensitive]
        ) {
            list.append(streetRegex)
        }

        return list
    }()

    public static func parseAddress(_ address: String) -> AddressComponents {
        for regex in addressRegexList {
//            print(regex.pattern)
            let range = NSRange(
                address.startIndex..<address.endIndex, in: address)
            if let match = regex.firstMatch(
                in: address, options: [], range: range)
            {
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

        func capture(_ name: String) -> String {
            let nsRange = match.range(withName: name)
            guard nsRange.location != NSNotFound,
                let range = Range(nsRange, in: address)
            else {
                return ""
            }
            return String(address[range])
        }

        // Distinguish if it's a PO Box
        let boxNumber = capture("unitNumber")
        if !boxNumber.isEmpty {
            // We have a PO Box match
            let unitType = capture("unitType").capitalized
            let boxCity = capture("city")
            let rawState = capture("state").uppercased()
            let normalizedState = statePatterns[rawState] ?? rawState
            let zipCode = capture("zip")

            return AddressComponents(
                streetNumber: "",
                streetName: "",
                streetSuffix: "",
                direction: "",
                unitType: unitType == "Po Box" ? "PO Box" : unitType,
                unitNumber: boxNumber,
                city: boxCity.trimmingCharacters(in: .whitespacesAndNewlines),
                state: normalizedState,
                zipcode: zipCode
            )
        }

        // Or a street match
        let rawStreetNumber = capture("streetNumber")
        let leadingDir = capture("leadingDir").uppercased()
        let rawStreetName = capture("streetName")
        let rawSuffix = capture("streetSuffix")
        let trailingDir = capture("trailingDir").uppercased()

        let rawUnitType = capture("unitType").uppercased()
        let unitNumber = capture("unitNumber")

        let rawCity = capture("city")
        let rawState = capture("state").uppercased()
        let zipCode = capture("zip")

        // Normalize fields:
        let directionPart = [leadingDir, trailingDir].filter { !$0.isEmpty }
            .joined(separator: " ")
        let direction = directionPatterns[directionPart] ?? directionPart

        let streetSuffix = streetSuffixPatterns[rawSuffix] ?? rawSuffix

        var unitType = ""
        if !rawUnitType.isEmpty {
            // Attempt dictionary lookup for rawUnitType (regex-based pattern)
            // but with an already uppercase rawUnitType
            let found = unitTypePatterns.first {
                let (keyRegex, _) = $0
                // If the raw unit string matches the key regex, return the mapped value
                return rawUnitType.range(
                    of: keyRegex, options: .regularExpression) != nil
                    ? true : false
            }
            if let match = found {
                unitType =
                    match.value + (unitNumber.isEmpty ? "" : " \(unitNumber)")
            }
        }

        let normalizedState = statePatterns[rawState] ?? rawState

        return AddressComponents(
            streetNumber: rawStreetNumber,
            streetName: rawStreetName.trimmingCharacters(
                in: .whitespacesAndNewlines),
            streetSuffix: streetSuffix,
            direction: direction.trimmingCharacters(
                in: .whitespacesAndNewlines),
            unitType: unitType.trimmingCharacters(in: .whitespacesAndNewlines),
            unitNumber:
                unitNumber
                .trimmingCharacters(in: .whitespacesAndNewlines),
            city: rawCity.trimmingCharacters(in: .whitespacesAndNewlines),
            state: normalizedState,
            zipcode: zipCode
        )
    }
}
