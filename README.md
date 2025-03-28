#  Address Parser

This is library is for parseing physical mailing addresses into address components when:
1. Internet connection is unavailable
2. New addresses not yet listed in online services (Google Places Autocomplete)
3. Or for addresses not found by online searches.

AddressParser uses regular expressions to break-down a full address `"88 Colin P Kelly Jr St, San Franciso, CA 94107"` into address components.
This project came about from a need at my place of employment, but I am happy to accept contributors to make this more robust. For now it's a very simple library with minimal tests. Please feel free to create issues with addresses that don't work with ideas for altering regular expressions for the address.

## Usage

```
if let parsed = AddressParser.parseAddress() {
    // do what you wish with the address components here
}
```
