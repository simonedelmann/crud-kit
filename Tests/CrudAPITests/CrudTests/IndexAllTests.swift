@testable import CrudAPI
import XCTVapor

final class IndexAllTests: ApplicationXCTestCase {
    func testEmptyIndexAll() throws {
        try routes()
        
        try app.test(.GET, "/todos") { res in
            XCTAssertContent([Todo].self, res) {
                XCTAssertEqual($0.count, 0)
            }
        }
    }
    
    func testIndexAllContainingAllElements() throws {
        try seed()
        try routes()
        
        try app.test(.GET, "/todos") { res in
            XCTAssertContent([Todo.Public].self, res) {
                XCTAssertGreaterThan($0.count, 0)
                XCTAssertEqual($0.count, 3)
                XCTAssertNotEqual($0.count, 2)
                XCTAssertEqual($0[0].title, Todo(title: "Wash clothes").title)
                XCTAssertTrue($0[0].isPublic)
            }
        }
    }

    static var allTests = [
        ("testEmptyIndexAll", testEmptyIndexAll),
        ("testIndexAllContainingAllElements", testIndexAllContainingAllElements),
    ]
}
