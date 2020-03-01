@testable import CrudKit
import XCTVapor
import Fluent

final class RoutingTests: ApplicationXCTestCase {
    func testNoRoutesRegistered() throws {
        try app.test(.GET, "/todos") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }
    }
    
    func testRouteRegistrationAtGivenPath() throws {
        try routes()
        
        try app.test(.GET, "/todos") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
        }
    }

    static var allTests = [
        ("testNoRoutesRegistered", testNoRoutesRegistered),
        ("testRouteRegistrationAtGivenPath", testRouteRegistrationAtGivenPath),
    ]
}
