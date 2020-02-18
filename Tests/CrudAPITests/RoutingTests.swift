@testable import CrudAPI
import XCTVapor
import Fluent

final class RoutingTests: XCTestCase {
    func testRouteRegistrationAtGivenPath() throws {
        final class Todo: Crudable, Model {
            static var schema = "todos"
            static var path = "todos"
            
            init() { }
            
            @ID(key: "id")
            var id: Int?
            
            init(id: Int? = nil) {
                self.id = id
            }
        }

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
