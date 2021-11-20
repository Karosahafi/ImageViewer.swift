// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ImageViewer_swift",
	platforms: [
		.iOS(.v12)
	],
    products: [
        .library(
            name: "ImageViewer_swift",
            targets: ["ImageViewer_swift"])
	],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
	targets: [
		.target(
			name: "ImageViewer_swift",
			dependencies: [],
			path: "Sources/ImageViewer_swift")
	]
)
