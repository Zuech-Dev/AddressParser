import Testing

@testable import AddressParser

let eMain = AddressComponents(
    streetNumber: "123",
    streetName: "Main",
    streetSuffix: "St",
    direction: "E",
    unitType: "",
    unitNumber: "",
    city: "Franklin",
    state: "NY",
    zipcode: "12345"
)

let eAllen = AddressComponents(
    streetNumber: "555",
    streetName: "Allen",
    streetSuffix: "St",
    direction: "E",
    unitType: "Apt",
    unitNumber: "7",
    city: "Huntington",
    state: "ID",
    zipcode: "83709"
)

let poBox = AddressComponents(
    streetNumber: "",
    streetName: "",
    streetSuffix: "",
    direction: "",
    unitType: "PO Box",
    unitNumber: "279",
    city: "Stanley",
    state: "AZ",
    zipcode: "52074"
)

let broadstone = AddressComponents(
    streetNumber: "909",
    streetName: "Broadstone Village",
    streetSuffix: "Pkwy",
    direction: "",
    unitType: "",
    unitNumber: "",
    city: "High Point",
    state: "NC",
    zipcode: "27260"
)

let way = AddressComponents(
    streetNumber: "3605",
    streetName: "Maldon",
    streetSuffix: "Way",
    direction: "",
    unitType: "",
    unitNumber: "",
    city: "Seattle",
    state: "WA",
    zipcode: "98105"
)

let ave = AddressComponents(
    streetNumber: "123",
    streetName: "Andover",
    streetSuffix: "Ave",
    direction: "E",
    unitType: "",
    unitNumber: "",
    city: "Greensboro",
    state: "NC",
    zipcode: "27403"
)

let mlk = AddressComponents(
    streetNumber: "2222",
    streetName: "Martin Luther King Jr",
    streetSuffix: "Dr",
    direction: "",
    unitType: "",
    unitNumber: "",
    city: "Chapel Hill",
    state: "NC",
    zipcode: "27278"
)

//88 Colin P Kelly Jr St, San Francisco, CA 94107
let github = AddressComponents(
    streetNumber: "88-A",
    streetName: "Colin P Kelly Jr",
    streetSuffix: "St",
    direction: "",
    unitType: "",
    unitNumber: "",
    city: "San Franciso",
    state: "CA",
    zipcode: "94107"
)

let lexington = AddressComponents(
    streetNumber: "124",
    streetName: "Forest Hill",
    streetSuffix: "Rd",
    direction: "",
    unitType: "",
    unitNumber: "",
    city: "Lexington",
    state: "NC",
    zipcode: "27295"
)

let addresses = [
    eMain,
    eAllen,
    poBox,
    broadstone,
    way,
    ave,
    mlk,
]

@Test func parseListOfAddresses() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    for address in addresses {
        printAndTest(address)
    }
}

@Test func parseeMain() {
    printAndTest(eMain)
}

@Test func parseeAllen() {
    printAndTest(eAllen)
}

@Test func parsePoBox() {
    printAndTest(poBox)
}

@Test func parseBroadstone() {
    printAndTest(broadstone)
}

@Test func parseBraodstoneParkway() {
    let expected = AddressComponents(
        streetNumber: "3504",
        streetName: "Broadstone Village",
        streetSuffix: "Pkwy",
        direction: "",
        unitType: "",
        unitNumber: "",
        city: "High Point",
        state: "NC",
        zipcode: "27260",
        zipcodeExtension: "",
        country: "USA"
    )
    
    testFromString("3504 Broadstone Village Parkway, High Point, NC 27260, USA", expected)
}

@Test func parseWay() {
    printAndTest(way)
}

@Test func parseWendover() {
    printAndTest(ave)
}

@Test func parseMlk() {
    printAndTest(mlk)
}

@Test func parseGithub() {
    printAndTest(github)
}

@Test func testStreet() {
    let parsed = AddressParser.parseAddress(github.toString())
    
    let st = "\(github.streetNumber) \(github.streetName) \(github.streetSuffix)"
    
    #expect(st == parsed.getStreetAddress())
    
    #expect(
        "\(github.unitType) \(github.unitNumber)".trimmingCharacters(
            in: .whitespacesAndNewlines
        ) ==
        parsed.getSecondaryAddress()
    )
    
    #expect(st == parsed.getFullStreetAddress())
    
    #expect("\(github.city), \(github.state) \(github.zipcode)" == parsed.getMunicipal())
}

func printAndTest(_ address: AddressComponents) {
    let parsed = printAndTestString(address.toString())
    
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

func printAndTestString(_ address: String) -> AddressComponents {
    print("Original: \(address)")
    
    let parsed = AddressParser.parseAddress(address)
    
    print("  Number:      \(parsed.streetNumber)")
    print("  Name:        \(parsed.streetName)")
    print("  Suffix:      \(parsed.streetSuffix)")
    print("  Direction:   \(parsed.direction)")
    print("  Unit Type:   \(parsed.unitType)")
    print("  Unit Number: \(parsed.unitNumber)")
    print("  City:        \(parsed.city)")
    print("  State:       \(parsed.state)")
    print("  Zipcode:     \(parsed.zipcode)")
    print("  Parsed:      \(parsed.toString())")
    print("")
    
    return parsed
}

func testFromString(_ address: String, _ expected: AddressComponents) {
    let parsed = printAndTestString(address)
    
    #expect(parsed == expected)
    
    #expect(parsed.toString() == expected.toString())
    
}

// BREAK THE STRING INTO LARGER COMPONENTS FIRST
// STEP 1 - IDENTIFY FULL STREET ADDRESS, CITY, STATE, ZIP
// STEP 2 - BREAK FULL STREET ADDRESS INTO PRIMARY AND SECONDARY STREET ADDRESSESs
// STEP 3 -
// if full street matches known patterns:
//      <number> <streetName> <suffix>                                  123 Carr Rd
//      <number>-<unit> <streetName> <suffix>                           123-A Carr Rd
//      <poUnit> <number>                                               PO Box 123
//      <number> <suffix> <number>                                      123 Highway 70
//      <number> <streetName> <postDir> <suffix>                        1703 Wendover E Ave
//      <number> <streetName> <suffix> <postDir>                        1703 Wendover Ave E
//      <number> <preDir> <streetName> <suffix>                         1703 E Wendover Ave
//   SECONDARY
//      <number> <streetName> <suffix> <unitType> <unitId>              123 Carr Rd Unit 1
//      <number>-<unit> <streetName> <suffix> <unitType> <unitId>       123-A Carr Rd Unit A3
//      <poUnit> <number> <unitType> <unitId>                           PO Box 123 Unit 1
//      <number> <suffix> <number> <unitType> <unitId>                  123 Highway 70 Suite F1
//      <number> <streetName> <postDir> <suffix> <unitType> <unitId>    1703 Wendover E Ave Apt 5
//      <number> <streetName> <suffix> <postDir> <unitType> <unitId>    1703 Wendover Ave E Building 1
//      <number> <preDir> <streetName> <suffix> <unitType> <unitId>     1703 E Wendover Ave Basement
