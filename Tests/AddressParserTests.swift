import Testing

@testable import AddressParser

// MARK: - Fixtures

let eMain = AddressComponents(
    streetNumber: "123",
    streetName: "MAIN",
    streetSuffix: "ST",
    direction: "E",
    unitType: "",
    unitNumber: "",
    city: "FRANKLIN",
    state: "NY",
    zipcode: "12345"
)

let eAllen = AddressComponents(
    streetNumber: "555",
    streetName: "ALLEN",
    streetSuffix: "ST",
    direction: "E",
    unitType: "APT",
    unitNumber: "7",
    city: "WINSTON-SALEM",
    state: "ID",
    zipcode: "83709"
)

let poBox = AddressComponents(
    streetNumber: "",
    streetName: "",
    streetSuffix: "",
    direction: "",
    unitType: "PO BOX",
    unitNumber: "279",
    city: "STANLEY",
    state: "AZ",
    zipcode: "52074"
)

let broadstone = AddressComponents(
    streetNumber: "909",
    streetName: "BROADSTONE VILLAGE",
    streetSuffix: "PKWY",
    direction: "",
    unitType: "",
    unitNumber: "",
    city: "HIGH POINT",
    state: "NC",
    zipcode: "27260"
)

let way = AddressComponents(
    streetNumber: "3605",
    streetName: "WALDON",
    streetSuffix: "WAY",
    direction: "N",
    unitType: "UNIT",
    unitNumber: "2-C",
    city: "HIGH POINT",
    state: "NC",
    zipcode: "98105"
)

let ave = AddressComponents(
    streetNumber: "123",
    streetName: "ANDOVER",
    streetSuffix: "AVE",
    direction: "E",
    unitType: "",
    unitNumber: "",
    city: "GREENSBORO",
    state: "NC",
    zipcode: "27403"
)

let mlk = AddressComponents(
    streetNumber: "2222",
    streetName: "MARTIN LUTHER KING JR",
    streetSuffix: "DR",
    direction: "",
    unitType: "",
    unitNumber: "",
    city: "CHAPEL HILL",
    state: "NC",
    zipcode: "27278"
)

let github = AddressComponents(
    streetNumber: "88-A",
    streetName: "COLIN P KELLY JR",
    streetSuffix: "ST",
    direction: "",
    unitType: "",
    unitNumber: "",
    city: "SAN FRANCISO",
    state: "CA",
    zipcode: "94107"
)

let lexington = AddressComponents(
    streetNumber: "606",
    streetName: "2ND",
    streetSuffix: "AVE",
    direction: "W",
    unitType: "",
    unitNumber: "",
    city: "LEXINGTON",
    state: "NC",
    zipcode: "27295"
)

let singleDigit = AddressComponents(
    streetNumber: "6B",
    streetName: "VERDANA",
    streetSuffix: "CT",
    direction: "",
    unitType: "",
    unitNumber: "",
    city: "GREENSBORO",
    state: "NC",
    zipcode: "27455"
)

// MARK: - Round-trip Tests

@Test func parseMain() {
    testRoundTrip(eMain)
    testFromString("123 e Main St, Franklin, NY 12345", eMain)
}

@Test func parseAllen() {
    testRoundTrip(eAllen)
}

@Test func parsePoBox() {
    testRoundTrip(poBox)
}

@Test func parseBroadstone() {
    testRoundTrip(broadstone)
}

@Test func parseWay() {
    testRoundTrip(way)
}

@Test func parseWendover() {
    testRoundTrip(ave)
}

@Test func parseMlk() {
    testRoundTrip(mlk)
}

@Test func parseGithub() {
    testRoundTrip(github)
}

@Test func parseSingleDigitStNum() {
    testRoundTrip(singleDigit)
    testFromString("6B Verdana Ct, Greensboro, NC 27455", singleDigit)
}

// MARK: - PO Box

@Test func parseLargePoBox() {
    testFromString(
        "PO BOX 1234, New York, NY 10001",
        addr(unitType: "PO BOX", unitNumber: "1234", city: "NEW YORK", state: "NY", zipcode: "10001")
    )
}

@Test func parsePoBoxWithPeriods() {
    testFromString("P.O. Box 279, Stanley, AZ 52074", poBox)
}

@Test func parsePoBoxLowercase() {
    testFromString(
        "po box 222 , gibsonville , nc , 27349",
        addr(unitType: "PO BOX", unitNumber: "222", city: "GIBSONVILLE", state: "NC", zipcode: "27349")
    )
}

@Test func parsePoBoxHyphenatedCity() {
    testFromString(
        "PO Box 55, Winston-Salem, NC 27101",
        addr(unitType: "PO BOX", unitNumber: "55", city: "WINSTON-SALEM", state: "NC", zipcode: "27101")
    )
}

// MARK: - Leading Directionals (parameterized)
//
// Inputs with a leading direction word/abbreviation.
// The parser normalizes all full words (North, Northeast…) to USPS 1-2 letter codes.

let leadingDirectionalInputs = [
    "123 N Main St, Franklin, NY 12345",
    "123 S Main St, Franklin, NY 12345",
    "123 E Main St, Franklin, NY 12345",
    "123 W Main St, Franklin, NY 12345",
    "123 NE Main St, Franklin, NY 12345",
    "123 SE Main St, Franklin, NY 12345",
    "123 SW Main St, Franklin, NY 12345",
    "123 NW Main St, Franklin, NY 12345",
    "123 North Main St, Franklin, NY 12345",
    "123 South Main St, Franklin, NY 12345",
    "123 East Main St, Franklin, NY 12345",
    "123 West Main St, Franklin, NY 12345",
    "123 Northeast Main St, Franklin, NY 12345",
    "123 Southeast Main St, Franklin, NY 12345",
    "123 Southwest Main St, Franklin, NY 12345",
    "123 Northwest Main St, Franklin, NY 12345",
]
let leadingDirectionalExpected = ["N", "S", "E", "W", "NE", "SE", "SW", "NW",
                                   "N", "S", "E", "W", "NE", "SE", "SW", "NW"]

@Test(arguments: zip(leadingDirectionalInputs, leadingDirectionalExpected))
func parseLeadingDirectional(input: String, expectedDir: String) {
    let parsed = AddressParser.parseAddress(input)
    #expect(parsed.streetNumber == "123")
    #expect(parsed.streetName == "MAIN")
    #expect(parsed.streetSuffix == "ST")
    #expect(parsed.direction == expectedDir)
    #expect(parsed.city == "FRANKLIN")
    #expect(parsed.state == "NY")
    #expect(parsed.zipcode == "12345")
}

// MARK: - Trailing Directionals (parameterized)
//
// When the direction follows the suffix with only a comma as separator
// (e.g. "123 Main St E, City, ST 12345"), the parser folds it into the
// street name + suffix fields rather than the direction field. The direction
// field will be empty and the token appears as the streetSuffix.
// toString() therefore produces "123 MAIN ST E, …" (stable round-trip).

let trailingDirectionalInputs = [
    "123 Main St N, Franklin, NY 12345",
    "123 Main St S, Franklin, NY 12345",
    "123 Main St E, Franklin, NY 12345",
    "123 Main St W, Franklin, NY 12345",
    "123 Main St NE, Franklin, NY 12345",
    "123 Main St SE, Franklin, NY 12345",
    "123 Main St SW, Franklin, NY 12345",
    "123 Main St NW, Franklin, NY 12345",
]
let trailingDirectionalSuffixes = ["N", "S", "E", "W", "NE", "SE", "SW", "NW"]

@Test(arguments: zip(trailingDirectionalInputs, trailingDirectionalSuffixes))
func parseTrailingDirectional(input: String, expectedSuffix: String) {
    let parsed = AddressParser.parseAddress(input)
    #expect(parsed.streetNumber == "123")
    #expect(parsed.streetName == "MAIN ST")
    #expect(parsed.streetSuffix == expectedSuffix)
    #expect(parsed.direction == "")
    #expect(parsed.city == "FRANKLIN")
}

// MARK: - Street Suffix Normalization (parameterized)
//
// Full English words must normalize to USPS abbreviations.

let suffixInputs = [
    "123 Main Street, Franklin, NY 12345",
    "123 Main Avenue, Franklin, NY 12345",
    "123 Main Boulevard, Franklin, NY 12345",
    "123 Main Drive, Franklin, NY 12345",
    "123 Main Road, Franklin, NY 12345",
    "123 Main Court, Franklin, NY 12345",
    "123 Main Lane, Franklin, NY 12345",
    "123 Main Place, Franklin, NY 12345",
    "123 Main Circle, Franklin, NY 12345",
    "123 Main Parkway, Franklin, NY 12345",
    "123 Main Trail, Franklin, NY 12345",
    "123 Main Highway, Franklin, NY 12345",
    "123 Main Turnpike, Franklin, NY 12345",
    "123 Main Freeway, Franklin, NY 12345",
    "123 Main Expressway, Franklin, NY 12345",
]
let suffixExpected = [
    "ST", "AVE", "BLVD", "DR", "RD", "CT", "LN", "PL", "CIR", "PKWY",
    "TRL", "HWY", "TPKE", "FWY", "EXPY",
]

@Test(arguments: zip(suffixInputs, suffixExpected))
func parseSuffixNormalization(input: String, expectedSuffix: String) {
    let parsed = AddressParser.parseAddress(input)
    #expect(parsed.streetName == "MAIN")
    #expect(parsed.streetSuffix == expectedSuffix)
    #expect(parsed.city == "FRANKLIN")
}

// MARK: - Unit Type Normalization (parameterized)
//
// Unit types normalize through a regex-key lookup table that handles
// common misspellings. Types without a unit number (Basement, Front,
// Rear, etc.) produce an empty unitNumber.

let unitTypeInputs = [
    "123 Main St, Apt 4, Franklin, NY 12345",
    "123 Main St, Apartment 4, Franklin, NY 12345",
    "123 Main St, Ste 100, Franklin, NY 12345",
    "123 Main St, Suite 100, Franklin, NY 12345",
    "123 Main St, Unit 2B, Franklin, NY 12345",
    "123 Main St, Bldg A, Franklin, NY 12345",
    "123 Main St, Building A, Franklin, NY 12345",
    "123 Main St, Fl 3, Franklin, NY 12345",
    "123 Main St, Floor 3, Franklin, NY 12345",
    "123 Main St, Rm 201, Franklin, NY 12345",
    "123 Main St, Room 201, Franklin, NY 12345",
    "123 Main St, Lot 7, Franklin, NY 12345",
    "123 Main St, Space 12, Franklin, NY 12345",
    "123 Main St, Stop 5, Franklin, NY 12345",
    "123 Main St, Pier 4, Franklin, NY 12345",
    "123 Main St, Slip 3, Franklin, NY 12345",
    "123 Main St, Ph 3, Franklin, NY 12345",
    "123 Main St, Penthouse 3, Franklin, NY 12345",
    "123 Main St, Trlr 5, Franklin, NY 12345",
    "123 Main St, Trailer 5, Franklin, NY 12345",
    "123 Main St, Hangar 4, Franklin, NY 12345",
    "123 Main St, Key 12, Franklin, NY 12345",
    "123 Main St, Dept 3, Franklin, NY 12345",
    "123 Main St, Department 3, Franklin, NY 12345",
    "123 Main St, Office 4, Franklin, NY 12345",
    "123 Main St, Box 5, Franklin, NY 12345",
    "123 Main St, Basement, Franklin, NY 12345",
    "123 Main St, Front, Franklin, NY 12345",
    "123 Main St, Rear, Franklin, NY 12345",
    "123 Main St, Side, Franklin, NY 12345",
    "123 Main St, Lobby, Franklin, NY 12345",
    "123 Main St, Upper, Franklin, NY 12345",
    "123 Main St, Lower, Franklin, NY 12345",
]
let unitTypeExpected = [
    "APT", "APT", "STE", "STE", "UNIT", "BLDG", "BLDG", "FL", "FL",
    "RM", "RM", "LOT", "SPACE", "STOP", "PIER", "SLIP", "PH", "PH",
    "TRLR", "TRLR", "HNGR", "KEY", "DEPT", "DEPT", "OFC", "BOX",
    "BSMT", "FRNT", "REAR", "SIDE", "LBBY", "UPPR", "LOWR",
]

@Test(arguments: zip(unitTypeInputs, unitTypeExpected))
func parseUnitTypeNormalization(input: String, expectedUnitType: String) {
    let parsed = AddressParser.parseAddress(input)
    #expect(parsed.streetNumber == "123")
    #expect(parsed.streetSuffix == "ST")
    #expect(parsed.unitType == expectedUnitType)
    #expect(parsed.city == "FRANKLIN")
}

// MARK: - Street Number Variants

@Test func parseAlphaHyphenStreetNumber() {
    testFromString(
        "88-A Main St, Franklin, NY 12345",
        addr(streetNumber: "88-A", streetName: "MAIN", streetSuffix: "ST", city: "FRANKLIN", state: "NY", zipcode: "12345")
    )
}

@Test func parseAlphaPrefixStreetNumber() {
    testFromString(
        "6B Verdana Ct, Greensboro, NC 27455",
        singleDigit
    )
}

@Test func parseFourDigitStreetNumber() {
    testFromString(
        "1200 Elm Ave, Raleigh, NC 27601",
        addr(streetNumber: "1200", streetName: "ELM", streetSuffix: "AVE", city: "RALEIGH", state: "NC", zipcode: "27601")
    )
}

// MARK: - Street Name Variants

@Test func parseMultiWordStreetName() {
    testRoundTrip(mlk)
}

@Test func parseAmpersandStreetName() {
    testFromString(
        "8216 B & G Court, STOKESDALE, NC 27357-8279",
        addr(streetNumber: "8216", streetName: "B & G", streetSuffix: "CT", city: "STOKESDALE", state: "NC", zipcode: "27357", zipcodeExtension: "8279")
    )
}

@Test func parseNumberedStreetName() {
    testFromString("606 W 2nd Ave, Lexington, NC 27295", lexington)
}

@Test func parseJrInStreetName() {
    testFromString(
        "88 Colin P Kelly Jr St, San Francisco, CA 94107",
        addr(streetNumber: "88", streetName: "COLIN P KELLY JR", streetSuffix: "ST", city: "SAN FRANCISCO", state: "CA", zipcode: "94107")
    )
}

// MARK: - City Variants

@Test func parseHyphenatedCity() {
    testFromString(
        "123 Main St, Winston-Salem, NC 27101",
        addr(streetNumber: "123", streetName: "MAIN", streetSuffix: "ST", city: "WINSTON-SALEM", state: "NC", zipcode: "27101")
    )
}

@Test func parseTwoWordCity() {
    testFromString(
        "123 Main St, High Point, NC 27260",
        addr(streetNumber: "123", streetName: "MAIN", streetSuffix: "ST", city: "HIGH POINT", state: "NC", zipcode: "27260")
    )
}

@Test func parseThreeWordCity() {
    testFromString(
        "123 Main St, New York, NY 10001",
        addr(streetNumber: "123", streetName: "MAIN", streetSuffix: "ST", city: "NEW YORK", state: "NY", zipcode: "10001")
    )
}

// MARK: - ZIP Code Variants

@Test func parseZipPlusFour() {
    testFromString(
        "123 Main St, Franklin, NY 12345-6789",
        addr(streetNumber: "123", streetName: "MAIN", streetSuffix: "ST", city: "FRANKLIN", state: "NY", zipcode: "12345", zipcodeExtension: "6789")
    )
}

@Test func parseZipPlusFourWithUnit() {
    testFromString(
        "8216 B & G Court, STOKESDALE, NC 27357-8279",
        addr(streetNumber: "8216", streetName: "B & G", streetSuffix: "CT", city: "STOKESDALE", state: "NC", zipcode: "27357", zipcodeExtension: "8279")
    )
}

// MARK: - Input Normalization

@Test func parseAllLowercase() {
    testFromString(
        "123 main st, franklin, ny 12345",
        addr(streetNumber: "123", streetName: "MAIN", streetSuffix: "ST", city: "FRANKLIN", state: "NY", zipcode: "12345")
    )
}

@Test func parseAllUppercase() {
    testFromString(
        "123 MAIN ST, FRANKLIN, NY 12345",
        addr(streetNumber: "123", streetName: "MAIN", streetSuffix: "ST", city: "FRANKLIN", state: "NY", zipcode: "12345")
    )
}

// Extra whitespace after commas and at boundaries is handled;
// spaces BEFORE commas get absorbed into the preceding field (known limitation).
@Test func parseExtraWhitespace() {
    testFromString(
        "  123 Main St,  Franklin,  NY  12345  ",
        addr(streetNumber: "123", streetName: "MAIN", streetSuffix: "ST", city: "FRANKLIN", state: "NY", zipcode: "12345")
    )
}

@Test func parsePeriodInSuffix() {
    testFromString(
        "4615 Pleasant Garden Rd., Pleasant Garden, NC 27313",
        addr(streetNumber: "4615", streetName: "PLEASANT GARDEN", streetSuffix: "RD", city: "PLEASANT GARDEN", state: "NC", zipcode: "27313")
    )
}

// MARK: - Combined / Composite

@Test func parseLeadingDirectionalWithUnit() {
    testFromString("3605 N Waldon Way, Unit 2-C, High Point, NC 98105", way)
}

@Test func parseTrailingDirectionalWithUnit() {
    testFromString(
        "555 Allen St E, Apt 7, Winston-Salem, ID 83709",
        addr(streetNumber: "555", streetName: "ALLEN ST", streetSuffix: "E", unitType: "APT", unitNumber: "7", city: "WINSTON-SALEM", state: "ID", zipcode: "83709")
    )
}

@Test func parseMultiWordCityWithUnit() {
    testFromString(
        "123 Main St, Apt 4, High Point, NC 27260",
        addr(streetNumber: "123", streetName: "MAIN", streetSuffix: "ST", unitType: "APT", unitNumber: "4", city: "HIGH POINT", state: "NC", zipcode: "27260")
    )
}

@Test func parseHyphenatedCityWithUnit() {
    testFromString(
        "123 Main St, Apt 4, Winston-Salem, NC 27101",
        addr(streetNumber: "123", streetName: "MAIN", streetSuffix: "ST", unitType: "APT", unitNumber: "4", city: "WINSTON-SALEM", state: "NC", zipcode: "27101")
    )
}

@Test func parseAlphanumericUnitNumber() {
    testFromString(
        "123 Main St, Apt 2-C, Franklin, NY 12345",
        addr(streetNumber: "123", streetName: "MAIN", streetSuffix: "ST", unitType: "APT", unitNumber: "2-C", city: "FRANKLIN", state: "NY", zipcode: "12345")
    )
}

@Test func parseMultiWordStreetWithDirection() {
    testRoundTrip(mlk)
    testFromString(
        "2222 Martin Luther King Jr Dr, Chapel Hill, NC 27278",
        mlk
    )
}

// MARK: - Existing String-input Tests

@Test func parseLexington() {
    testFromString("606 W 2nd Ave, Lexington, NC 27295", lexington)
}

@Test func parsePleasantGardenRd() {
    testFromString(
        "4615 Pleasant Garden Rd., Pleasant Garden, NC 27313",
        addr(streetNumber: "4615", streetName: "PLEASANT GARDEN", streetSuffix: "RD", city: "PLEASANT GARDEN", state: "NC", zipcode: "27313")
    )
}

@Test func parseHalfStreet() {
    let expected = AddressComponents(
        streetNumber: "701",
        streetName: "25 1/2",
        streetSuffix: "ST",
        direction: "W",
        unitType: "",
        unitNumber: "",
        city: "WINSTON SALEM",
        state: "NC",
        zipcode: "27105"
    )
    testFromString("701 W 25 1/2 St, Winston Salem, NC 27105", expected)
}

@Test func parseFake() {
    testFromString(
        "123 hhh h, hhh, NC 27278",
        addr(streetNumber: "123", streetName: "HHH", streetSuffix: "H", city: "HHH", state: "NC", zipcode: "27278")
    )
}

@Test func parseBAndGCourt() {
    testFromString(
        "8216 B & G Court, STOKESDALE, NC 27357-8279",
        addr(streetNumber: "8216", streetName: "B & G", streetSuffix: "CT", city: "STOKESDALE", state: "NC", zipcode: "27357", zipcodeExtension: "8279")
    )
}

@Test func parseDashHwyWithLeadingDir()
{
    testFromString(
        "283 S Nc-49, Asheboro, NC 27205",
        addr(
            streetNumber: "283",
            streetName: "NC-49",
            direction: "S",
            city: "ASHEBORO",
            state: "NC",
            zipcode: "27205"
        )
    )
}

@Test func parseDashHwyWithTrailingDir()
{
    testFromString(
        "283 Nc-49 S, Asheboro, NC 27205",
        addr(
            streetNumber: "283",
            streetName: "NC-49",
            direction: "S",
            city: "ASHEBORO",
            state: "NC",
            zipcode: "27205"
        )
    )
}

@Test func parseDashHwy()
{
    testFromString(
        "283 Nc-49, Asheboro, NC 27205",
        addr(
            streetNumber: "283",
            streetName: "NC-49",
            direction: "",
            city: "ASHEBORO",
            state: "NC",
            zipcode: "27205"
        )
    )
}

// MARK: - Single-token name + trailing directional (deliberate asymmetry)
//
// A single-token street name immediately followed by a directional and NO
// suffix routes through `.streetNoSuffixTrailingDir`, so the trailing token is
// read as the DIRECTION. Contrast with the multi-word convention above
// (`parseTrailingDirectional`), where "123 Main St N" folds the trailing token
// into the streetSuffix and leaves direction empty. These tests pin that
// asymmetry so a future change can't silently flip it.

let singleTokenTrailingInputs = [
    "100 Park N, Denver, CO 80014",
    "100 Park S, Denver, CO 80014",
    "100 Park E, Denver, CO 80014",
    "100 Park W, Denver, CO 80014",
    "100 Park NE, Denver, CO 80014",
    "100 Park SE, Denver, CO 80014",
    "100 Park SW, Denver, CO 80014",
    "100 Park NW, Denver, CO 80014",
]
let singleTokenTrailingDirs = ["N", "S", "E", "W", "NE", "SE", "SW", "NW"]

@Test(arguments: zip(singleTokenTrailingInputs, singleTokenTrailingDirs))
func parseSingleTokenTrailingDirectional(input: String, expectedDir: String) {
    let (parsed, pattern) = AddressParser.parseAddressWithPattern(input)
    #expect(parsed.streetNumber == "100")
    #expect(parsed.streetName == "PARK")
    #expect(parsed.streetSuffix == "")
    #expect(parsed.direction == expectedDir)
    #expect(parsed.city == "DENVER")
    #expect(parsed.state == "CO")
    #expect(parsed.zipcode == "80014")
    #expect(pattern == .streetNoSuffixTrailingDir)
}

@Test func parseMultiWordTrailingDirectionalStaysSuffix() {
    // The other side of the asymmetry: with a real suffix present ("St"), the
    // trailing directional is folded into the suffix, NOT the direction field.
    let (parsed, pattern) = AddressParser.parseAddressWithPattern(
        "123 Main St N, Franklin, NY 12345"
    )
    #expect(parsed.streetName == "MAIN ST")
    #expect(parsed.streetSuffix == "N")
    #expect(parsed.direction == "")
    #expect(pattern != .streetNoSuffixTrailingDir)
}

// MARK: - Matched-pattern reporting
//
// `parseAddressWithPattern` exposes which ordered rule fired. These cases lock
// the routing for representative shapes; the verified mapping was obtained by
// probing the parser directly.

let patternInputs = [
    "PO BOX 1234, New York, NY 10001",
    "283 Nc-49 S, Asheboro, NC 27205",
    "100 Park S, Denver, CO 80014",
    "123 N Main St, Franklin, NY 12345",
    "283 S Nc-49, Asheboro, NC 27205",
    "283 Nc-49, Asheboro, NC 27205",
    "",
]
let patternExpected: [AddressPattern] = [
    .poBox,
    .streetNoSuffixTrailingDir,
    .streetNoSuffixTrailingDir,
    .street,
    .streetNoSuffixLeadingDir,
    .streetNoSuffixLeadingDir,
    .none,
]

@Test(arguments: zip(patternInputs, patternExpected))
func parseReportsMatchedPattern(input: String, expected: AddressPattern) {
    #expect(AddressParser.parseAddressWithPattern(input).pattern == expected)
}

// MARK: - Accessor Tests

@Test func parseGithubAccessors() {
    let parsed = AddressParser.parseAddress(github.toString())
    let st = "\(github.streetNumber) \(github.streetName) \(github.streetSuffix)"

    #expect(st == parsed.getStreetAddress())
    #expect(
        "\(github.unitType) \(github.unitNumber)".trimmingCharacters(in: .whitespacesAndNewlines) ==
            parsed.getSecondaryAddress()
    )
    #expect(st == parsed.getFullStreetAddress())
    #expect("\(github.city), \(github.state) \(github.zipcode)" == parsed.getMunicipal())
}

// MARK: - Helpers

/// Convenience factory so inline expected values only specify the non-empty fields.
func addr(
    streetNumber: String = "",
    streetName: String = "",
    streetSuffix: String = "",
    direction: String = "",
    unitType: String = "",
    unitNumber: String = "",
    city: String = "",
    state: String = "",
    zipcode: String = "",
    zipcodeExtension: String = ""
) -> AddressComponents {
    AddressComponents(
        streetNumber: streetNumber, streetName: streetName,
        streetSuffix: streetSuffix, direction: direction,
        unitType: unitType, unitNumber: unitNumber,
        city: city, state: state, zipcode: zipcode,
        zipcodeExtension: zipcodeExtension
    )
}

func testRoundTrip(_ address: AddressComponents) {
    let parsed = AddressParser.parseAddress(address.toString())

    #expect(address.streetNumber == parsed.streetNumber)
    #expect(address.streetName == parsed.streetName)
    #expect(address.streetSuffix == parsed.streetSuffix)
    #expect(address.direction == parsed.direction)
    #expect(address.unitType == parsed.unitType)
    #expect(address.unitNumber == parsed.unitNumber)
    #expect(address.city == parsed.city)
    #expect(address.state == parsed.state)
    #expect(address.zipcode == parsed.zipcode)
    #expect(address == parsed)
    #expect(address.toString() == parsed.toString())
}

func testFromString(_ address: String, _ expected: AddressComponents) {
    let parsed = AddressParser.parseAddress(address)
    #expect(parsed == expected)
    #expect(parsed.toString() == expected.toString())
}
