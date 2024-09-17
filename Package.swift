// swift-tools-version:5.10
/**
* Copyright IBM Corporation 2017-2019
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
**/

import PackageDescription

let package = Package(
  name: "SwiftMetrics",
  products: [
        .library(
            name: "SwiftMetrics",
            targets: ["SwiftMetrics",
                "SwiftMetricsKitura",
                "SwiftBAMDC",
                "SwiftMetricsBluemix",
                "SwiftMetricsDash",
                "SwiftMetricsREST",
                "SwiftMetricsPrometheus"]),

        .executable(name: "SwiftMetricsEmitSample", targets: ["SwiftMetricsEmitSample"]),
        .executable(name: "SwiftMetricsCommonSample", targets: ["SwiftMetricsCommonSample"]),
    ],
  dependencies: [
    .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "2.3.0"),
    .package(url: "https://github.com/StyleShoots/Kitura-WebSocket-NIO.git", branch: "master"),
    .package(url: "https://github.com/IBM-Swift/Swift-cfenv.git", from: "6.0.0"),
    .package(url: "https://github.com/RuntimeTools/omr-agentcore", .exact("3.2.4-swift4")),
    .package(url: "https://github.com/IBM-Swift/BlueCryptor.git", from: "2.0.0"),
  ],
  targets: [
      .target(name: "SwiftMetrics", dependencies: [.product(name: "agentcore", package: "omr-agentcore"),
                                                  .product(name: "hcapiplugin", package: "omr-agentcore"),
                                                  .product(name: "envplugin", package: "omr-agentcore"),
                                                  .product (name: "cpuplugin", package: "omr-agentcore"),
                                                  .product(name: "memplugin", package: "omr-agentcore"),
                                                  .product(name: "CloudFoundryEnv", package: "Swift-cfenv")]),
      .target(name: "SwiftMetricsKitura", dependencies: ["SwiftMetrics", "Kitura"]),
      .target(name: "SwiftBAMDC", dependencies: ["SwiftMetricsKitura", .product(name: "Kitura-WebSocket", package: "Kitura-WebSocket-NIO"), .product(name: "Cryptor", package: "BlueCryptor")]),
      .target(name: "SwiftMetricsBluemix", dependencies: ["SwiftMetricsKitura","SwiftBAMDC"]),
      .target(name: "SwiftMetricsDash", dependencies: ["SwiftMetricsBluemix"]),
      .target(name: "SwiftMetricsREST", dependencies: ["SwiftMetricsKitura"]),
      .target(name: "SwiftMetricsPrometheus", dependencies:["SwiftMetricsKitura"]),
      .target(name: "SwiftMetricsCommonSample", dependencies: ["SwiftMetrics"],
            path: "commonSample/Sources"),
      .target(name: "SwiftMetricsEmitSample", dependencies: ["SwiftMetrics"],
            path: "emitSample/Sources"),
      .testTarget(name: "CoreSwiftMetricsTests", dependencies: ["SwiftMetrics"]),
      .testTarget(name: "SwiftMetricsRESTTests", dependencies: ["SwiftMetricsREST"])
   ]
)
