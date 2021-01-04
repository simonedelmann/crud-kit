@testable import CRUDKit
import XCTVapor
import Fluent

final class RoutingTests: ApplicationXCTestCase {
    func testNoRoutesRegistered() throws {
        try app.test(.GET, "/todos", afterResponse: { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        })
    }
    
    func testRouteRegistrationAtGivenPath() throws {
        try routes()
        
        try app.test(.GET, "/todos", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
        })
    }
    
    func testCustomRouteRegistration() throws {
        try routes()
        
        try app.test(.GET, "/todos/1/hello", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            XCTAssertContains(res.body.string, "Hello World")
        })
    }

    static var allTests = [
        ("testNoRoutesRegistered", testNoRoutesRegistered),
        ("testRouteRegistrationAtGivenPath", testRouteRegistrationAtGivenPath),
    ]
}
