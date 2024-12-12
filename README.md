# Ch-Ch-Changes

Watch for file system changes on MacOS from your Swift app!

> Requires MacOS v13+.

Include the package in your app:

```swift
// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "YourApp",
  platforms: [.macOS(.v13)],
  dependencies: [
    .package(url: "https://github.com/jarrodtaylor/ch-ch-changes.git", from: "1.0.0")
  ],
  targets: [
    .executableTarget(
      name: "YourApp", dependencies: [
        .product(name: "ChChChanges", package: "ch-ch-changes")
      ]
    )
  ]
)
```

Watch a directory for changes:

```swift
import Foundation
import ChChChanges

URL(string: "path/to/watch")!.watchForChChChanges { urls in
  print(urls) // Do something here...
}

RunLoop.current.run()
```
