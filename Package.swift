// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "swift-rampart",
  products: [
    .library(name: "Rampart", targets: ["Rampart"]),
  ],
  targets: [
    .target(name: "Rampart"),
    .testTarget(name: "RampartTests", dependencies: ["Rampart"]),
  ]
)
