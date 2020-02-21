@testable import CrudAPI
import XCTVapor
import Fluent
import FluentSQLiteDriver

final class IndexAllTests: ApplicationXCTestCase {
    func testEmptyIndexAll() throws {
        try crud(app, model: Todo.self)
        
        try app.test(.GET, "/todos") { res in
            XCTAssertContent([Todo].self, res) {
                XCTAssertEqual($0.count, 0)
            }
        }
    }
    
    func testIndexAllContainingAllElements() throws {
        app.migrations.add(Todo.seeder())
        try app.autoMigrate().wait()
        
        try crud(app, model: Todo.self)
        
        try app.test(.GET, "/todos") { res in
            XCTAssertContent([Todo].self, res) {
                XCTAssertGreaterThan($0.count, 0)
                XCTAssertEqual($0.count, 3)
                XCTAssertEqual($0[0].title, Todo(title: "Wash clothes").title)
            }
        }
    }

    static var allTests = [
        ("testEmptyIndexAll", testEmptyIndexAll),
        ("testIndexAllContainingAllElements", testIndexAllContainingAllElements),
    ]
}
