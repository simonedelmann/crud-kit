import XCTVapor

extension XCTApplicationTester {
    @discardableResult public func test<Body>(
        _ method: HTTPMethod,
        _ path: String,
        body: Body,
        afterResponse: (XCTHTTPResponse) throws -> () = { _ in }
    ) throws -> XCTApplicationTester where Body: Content {
        try test(method, path, beforeRequest: { req in
            try req.content.encode(body)
        }, afterResponse: afterResponse)
    }
}
