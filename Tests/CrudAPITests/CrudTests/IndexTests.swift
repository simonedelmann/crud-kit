@testable import CrudAPI
import XCTVapor

final class IndexTests: ApplicationXCTestCase {
    func testIndexWithoutID() throws {
        try routes()
        
        try app.test(.GET, "/todos/") { res in
            XCTAssertEqual(res.status, .ok)
            // By design fallback to IndexAll
        }
    }
    
    func testIndexForGivenID() throws {
        try seed()
        try routes()

        let id = 1
        try app.test(.GET, "/todos/\(id)") { res in
            XCTAssertContent(Todo.Public.self, res) {
                XCTAssertEqual($0.id, id)
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
        }
        
        let fakeId2 = "1a"
        try app.test(.GET, "/todos/\(fakeId2)") { res in
            XCTAssertEqual(res.status, .notFound)
        }
    }
    
    static var allTests = [
        ("testIndexWithoutID", testIndexWithoutID),
        ("testIndexForGivenID", testIndexForGivenID),
        ("testIndexForFakeID", testIndexForFakeID),
    ]
}
