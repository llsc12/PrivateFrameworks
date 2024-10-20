// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let sourcesDirectory = URL(fileURLWithPath: #file)
    .deletingLastPathComponent()
    .appendingPathComponent("Sources")

func tbd(for name: String) -> String {
  sourcesDirectory
    .appending(path: "CFrameworks")
    .appending(path: "tbds")
    .appending(component: "\(name).tbd")
    .path()
}

let products: [PackageDescription.Product] = {
  let dir = try! FileManager.default.contentsOfDirectory(at: sourcesDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
  let folders = dir.map(\.lastPathComponent)
  let products = folders.filter { $0 != "CFrameworks" && $0 != "ObjCShims" }
  return products.map { .library(name: $0, targets: [$0]) }
}()

let targets: [PackageDescription.Target] = {
  var targets = [PackageDescription.Target]()
  let dir = try! FileManager.default.contentsOfDirectory(at: sourcesDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
  let folders = dir.map(\.lastPathComponent)
  let foundTargets = folders.filter { $0 != "CFrameworks" && $0 != "ObjCShims" }
  
  // add cframeworks and test first
  targets.append(contentsOf: [
    .systemLibrary(name: "CFrameworks", path: nil, pkgConfig: nil, providers: nil),
    .target(name: "ObjCShims", dependencies: ["CFrameworks"], publicHeadersPath: "include"),
    .testTarget(
      name: "PrivateFrameworksTests",
      dependencies: [.byName(name: "CFrameworks"), .byName(name: "ObjCShims")] + foundTargets.map { .byName(name: $0) }
    )
  ])
  
  // now add known targets, and link tbd if exists
  targets.append(
    contentsOf:
      foundTargets.map({ target in
        if FileManager.default.fileExists(atPath: tbd(for: target)) {
          return .target(
            name: target, dependencies: ["CFrameworks", "ObjCShims"],
            linkerSettings: [.unsafeFlags([tbd(for: target)])]
          )
        } else {
          return .target(name: target, dependencies: ["CFrameworks", "ObjCShims"])
        }
      })
  )
  
  return targets
}()

let package = Package(
  name: "PrivateFrameworks",
  products: products,
  targets: targets
)
