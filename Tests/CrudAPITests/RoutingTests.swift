@testable import CrudAPI
import XCTVapor
import Fluent

final class RoutingTests: XCTestCase {
    func testRouteRegistrationAtGivenPath() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        
        try! crud(app, model: Todo.self)
        
        try app.testable().test(.GET, "/todos") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }

    static var allTests = [
        ("testRouteRegistrationAtGivenPath", testRouteRegistrationAtGivenPath),
    ]
}
