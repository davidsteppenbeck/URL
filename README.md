# URL

`#URL` is a freestanding Swift macro that provides an unwrapped `Foundation URL` for the string literal argument.
The macro checks the validity of the literal and throws an error if it does not represent a valid `Foundation URL`.

## Usage

```swift
import URL

let url = #URL("https://www.apple.com")
```

This will automatically generate the following code:

```swift
URL(string: "https://www.apple.com")!
```

## Installation

The package can be installed using [Swift Package Manager](https://swift.org/package-manager/). To add EnumIdentifiable to your Xcode project, select *File > Add Package Dependancies...* and search for the repository URL: `https://github.com/davidsteppenbeck/URL.git`.

## License

EnumCasePropertyGenerator is available under the MIT license. See the LICENSE file for more info.

## Acknowledgements

The `URL` macro example is described in detail in Antoine v.d. Lee's [blog post](https://www.avanderlee.com/swift/macros).
