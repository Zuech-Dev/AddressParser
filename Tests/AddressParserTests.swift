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

// 88 Colin P Kelly Jr St, San Francisco, CA 94107
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

// MARK: - String-input Tests

@Test func parseLexington() {
    testFromString("606 W 2nd Ave, Lexington, NC 27295", lexington)
}

@Test func parsePleasantGardenRd() {
    let expected = AddressComponents(
        streetNumber: "4615",
        streetName: "PLEASANT GARDEN",
        streetSuffix: "RD",
        direction: "",
        unitType: "",
        unitNumber: "",
        city: "PLEASANT GARDEN",
        state: "NC",
        zipcode: "27313"
    )
    testFromString("4615 Pleasant Garden Rd., Pleasant Garden, NC 27313", expected)
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

@Test func parseUglyPo() {
    let expected = AddressComponents(
        streetNumber: "",
        streetName: "",
        streetSuffix: "",
        direction: "",
        unitType: "PO BOX",
        unitNumber: "222",
        city: "GIBSONVILLE",
        state: "NC",
        zipcode: "27349"
    )
    testFromString("po box 222 , gibsonville , nc , 27349", expected)
}

@Test func parseFake() {
    let expected = AddressComponents(
        streetNumber: "123",
        streetName: "HHH",
        streetSuffix: "H",
        direction: "",
        unitType: "",
        unitNumber: "",
        city: "HHH",
        state: "NC",
        zipcode: "27278"
    )
    testFromString("123 hhh h, hhh, NC 27278", expected)
}

@Test func parseBAndGCourt() {
    let expected = AddressComponents(
        streetNumber: "8216",
        streetName: "B & G",
        streetSuffix: "CT",
        direction: "",
        unitType: "",
        unitNumber: "",
        city: "STOKESDALE",
        state: "NC",
        zipcode: "27357",
        zipcodeExtension: "8279"
    )
    testFromString("8216 B & G Court, STOKESDALE, NC 27357-8279", expected)
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
