// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "swift-adjust-dependency",
	platforms: [.iOS(.v15)],
	products: [
		// Products define the executables and libraries a package produces, making them visible to other
		// packages.
		.library(
			name: "AdjustDependency",
			targets: ["AdjustDependency"]
		),
		.library(
			name: "AdjustDependencyLive",
			targets: ["AdjustDependencyLive"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/adjust/ios_sdk.git", from: "4.33.4"),
		.package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "0.6.0"),
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "AdjustDependency",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
			]
		),
		.target(
			name: "AdjustDependencyLive",
			dependencies: [
				.product(name: "Adjust", package: "ios_sdk"),
				"AdjustDependency",
			]
		),
		.testTarget(
			name: "AdjustDependencyTests",
			dependencies: ["AdjustDependency"]
		),
	]
)
