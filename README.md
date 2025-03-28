#  Address Parser

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FZuech-Dev%2FAddressParser%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/Zuech-Dev/AddressParser)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FZuech-Dev%2FAddressParser%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/Zuech-Dev/AddressParser)

This library is for parsing physical mailing addresses into address components when:
1. Internet connection is unavailable
2. A new addresses is not yet listed in online services (i.e. Google Places Autocomplete)
3. Or for addresses not otherwise found.

It does NOT validate that an address exists. Other services should be used for that purpose. 

## Contributing

This project came about from a need at my place of employment, but I welcome additional contributors to make this more robust. For now it's a very simple library with minimal tests. Please feel free to create issues with addresses that don't work with ideas for altering regular expressions for the address.

## Usage

AddressParser uses regular expressions to break-down a full address like `"88 Colin P Kelly Jr St, San Franciso, CA 94107"` into address components. The current tests cover very limited addresses, but I plan to expand the coverage for other address formats. Currently, I'm working on US address formats with the intention of expanding to international formats if there is enough interest. 

```
if let parsed = AddressParser.parseAddress() {
    // do what you wish with the address components here
}
```
