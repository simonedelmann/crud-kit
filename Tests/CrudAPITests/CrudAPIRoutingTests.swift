@testable import CrudAPI
import XCTVapor

final class CrudAPIRoutingTests: XCTestCase {
    func testRouteRegistrationAtGivenPath() throws {
        struct Todo: Crudable {
            static var path: String = "todos"
        }

        let app = Application(.testing)
        defer { app.shutdown() }
        
        try! crud(app, model: Todo.self)
        
        try app.testable().test(.GET, "/todos") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string!, "Hello, World")
        }
    }

    static var allTests = [
        ("testRouteRegistrationAtGivenPath", testRouteRegistrationAtGivenPath),
    ]
}
