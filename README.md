# swift-rampart

[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg?style=flat-square)](https://github.com/apple/swift-package-manager)

A Swift implementation of [Rampart](https://github.com/tfausak/rampart) that determines how intervals relate to each other.

```swift
import Rampart

(2 ... 4).relate(to: 3 ... 5) // => overlaps
```

## Installation

### Swift Package Manager

```swift
.package(url: "https://github.com/woxtu/swift-rampart.git", from: "1.0.0")
```

## License

Licensed under the MIT license.
