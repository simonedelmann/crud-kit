@testable import CrudAPI
import XCTVapor
import Fluent

final class RoutingTests: ApplicationXCTestCase {
    func testNoRoutesRegistered() throws {
        try app.test(.GET, "/todos") { res in
            XCTAssertEqual(res.status, .notFound)
        }
    }
    
    func testRouteRegistrationAtGivenPath() throws {
        try routes()
        
        try app.test(.GET, "/todos") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }

    static var allTests = [
        ("testNoRoutesRegistered", testNoRoutesRegistered),
        ("testRouteRegistrationAtGivenPath", testRouteRegistrationAtGivenPath),
    ]
}
