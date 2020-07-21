// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "crud-kit",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "CRUDKit", targets: ["CRUDKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "CRUDKit",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent")
        ]),
        .testTarget(
            name: "CRUDKitTests",
            dependencies: [
                .target(name: "CRUDKit"),
                .product(name: "XCTVapor", package: "vapor"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver")
        ]),
    ]
)
