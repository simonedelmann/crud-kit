@testable import CrudAPI
import XCTVapor

final class IndexTests: ApplicationXCTestCase {
    func testIndexWithoutID() throws {
        try routes()
        
        try app.test(.GET, "/todos/") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            // By design fallback to IndexAll
        }
    }
    
    func testIndexForGivenID() throws {
        try seed()
        try routes()

        let id = 1
        try app.test(.GET, "/todos/\(id)") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            XCTAssertContent(Todo.Public.self, res) {
                XCTAssertEqual($0.id, id)
                XCTAssertNotEqual($0.id, 2)
                XCTAssertEqual($0.title, "Wash clothes")
                XCTAssertTrue($0.isPublic)
            }
        }
    }
    
    func testIndexForFakeID() throws {
        try seed()
        try routes()
        
        let fakeId1 = 150
        try app.test(.GET, "/todos/\(fakeId1)") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }
        
        let fakeId2 = "1a"
        try app.test(.GET, "/todos/\(fakeId2)") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }
    }
    
    static var allTests = [
        ("testIndexWithoutID", testIndexWithoutID),
        ("testIndexForGivenID", testIndexForGivenID),
        ("testIndexForFakeID", testIndexForFakeID),
    ]
}
