import Testing

@testable import AddressParser

@MainActor let eMain = AddressComponents(
    streetNumber: "123",
    streetName: "E Main",
    streetSuffix: "St",
    direction: "",
    unitType: "",
    unitNumber: "",
    city: "Springfield",
    state: "NY",
    zipcode: "12345"
)

@MainActor let eAllen = AddressComponents(
    streetNumber: "555",
    streetName: "E Allen",
    streetSuffix: "St",
    direction: "",
    unitType: "",
    unitNumber: "",
    city: "Boise",
    state: "ID",
    zipcode: "83709"
)

@MainActor let poBox = AddressComponents(
    streetNumber: "",
    streetName: "",
    streetSuffix: "",
    direction: "",
    unitType: "PO Box",
    unitNumber: "279",
    city: "Staley",
    state: "NC",
    zipcode: "27355"
)

@MainActor let broadstone = AddressComponents(
    streetNumber: "3504",
    streetName: "Broadstone Village",
    streetSuffix: "Dr",
    direction: "",
    unitType: "",
    unitNumber: "",
    city: "High Point",
    state: "NC",
    zipcode: "27260"
)

@MainActor let way = AddressComponents(
    streetNumber: "3605",
    streetName: "Maldon",
    streetSuffix: "Way",
    direction: "",
    unitType: "",
    unitNumber: "",
    city: "High Point",
    state: "NC",
    zipcode: "27260"
)

@MainActor let wendover = AddressComponents(
    streetNumber: "1703",
    streetName: "E Wendover",
    streetSuffix: "Ave",
    direction: "",
    unitType: "",
    unitNumber: "",
    city: "Greensboro",
    state: "NC",
    zipcode: "27403"
)

@MainActor let mlk = AddressComponents(
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
@MainActor let github = AddressComponents(
    streetNumber: "88",
    streetName: "Colin P Kelly Jr",
    streetSuffix: "St",
    direction: "",
    unitType: "",
    unitNumber: "",
    city: "San Franciso",
    state: "CA",
    zipcode: "94107"
)

@MainActor let addresses = [
    eMain,
    eAllen,
    poBox,
    broadstone,
    way,
    wendover,
    mlk
]


@MainActor @Test func parseListOfAddresses() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    for address in addresses {
        printAndTest(address)
    }
}

@MainActor @Test func parseeMain() {
    printAndTest(eMain)
}

@MainActor @Test func parseeAllen() {
    printAndTest(eAllen)
}

@MainActor @Test func parsePoBox() {
    printAndTest(poBox)
}

@MainActor @Test func parseBroadstone() {
    printAndTest(broadstone)
}

@MainActor @Test func parseWay() {
    printAndTest(way)
}

@MainActor @Test func parseWendover() {
    printAndTest(wendover)
}

@MainActor @Test func parseMlk() {
    printAndTest(mlk)
}

@MainActor @Test func parseGithub() {
    printAndTest(github)
}

func printAndTest(_ address: AddressComponents) {
    print("Original: \(address.ToString())")
    
    let parsed = AddressParser.parseAddress(address.ToString())
    
    if (parsed != nil) {
        print("  Number:      \(parsed!.streetNumber)")
        print("  Name:        \(parsed!.streetName)")
        print("  Suffix:      \(parsed!.streetSuffix)")
        print("  Direction:   \(parsed!.direction)")
        print("  Unit Type:   \(parsed!.unitType)")
        print("  Unit Number: \(parsed!.unitNumber)")
        print("  City:        \(parsed!.city)")
        print("  State:       \(parsed!.state)")
        print("  ZIP:         \(parsed!.zipcode)")
        
        #expect(address.streetNumber == parsed?.streetNumber)
        #expect(address.streetName == parsed?.streetName)
        #expect(address.streetSuffix == parsed?.streetSuffix)
        #expect(address.direction == parsed?.direction)
        #expect(address.unitType == parsed?.unitType)
        #expect(address.unitNumber == parsed?.unitNumber)
        #expect(address.city == parsed?.city)
        #expect(address.state == parsed?.state)
        #expect(address.zipcode == parsed?.zipcode)
    }
    
    #expect(address == parsed)
    
    print("")
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
