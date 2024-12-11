// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "ChChChanges",
  platforms: [.macOS(.v13)],
  products: [.library(name: "ChChChanges", targets: ["ChChChanges"])],
  targets: [.target(name: "ChChChanges")]
)
