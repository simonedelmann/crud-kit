// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "crud-api",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "CrudAPI", targets: ["CrudAPI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-beta"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0-beta"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.0-beta")
    ],
    targets: [
        .target(
            name: "CrudAPI",
            dependencies: ["Fluent", "Vapor"]),
        .testTarget(
            name: "CrudAPITests",
            dependencies: ["FluentSQLiteDriver", "CrudAPI", "XCTVapor"]),
    ]
)
