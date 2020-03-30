@testable import CrudKit
import XCTVapor

final class IndexAllChildrenTests: ApplicationXCTestCase {
    func testEmptyIndexAll() throws {
        try routes()
        try Todo.seed(on: app.db) // Seed only Todos
        
        try app.test(.GET, "/todos/1/tags") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            XCTAssertContent([Tag].self, res) {
                XCTAssertEqual($0.count, 0)
            }
        }
    }
    
    func testIndexAllContainingAllElements() throws {
        try seed()
        try routes()
        
        try app.test(.GET, "/todos/1/tags") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            XCTAssertContent([Tag.Public].self, res) {
                XCTAssertGreaterThan($0.count, 0)
                XCTAssertEqual($0.count, 1)
                XCTAssertNotEqual($0.count, 2)
                XCTAssertEqual($0[0].title, "Important")
            }
        }
    }
}
