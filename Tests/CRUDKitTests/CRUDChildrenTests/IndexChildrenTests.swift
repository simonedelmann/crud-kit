@testable import CRUDKit
import XCTVapor

final class IndexChildrenTests: ApplicationXCTestCase {
    func testIndexWithoutID() throws {
        try routes()
        try seed()
        
        try app.test(.GET, "/todos/1/tags/") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            // By design fallback to IndexAll
        }
    }
    
    func testIndexForGivenID() throws {
        try seed()
        try routes()

        let id = 1
        try app.test(.GET, "/todos/1/tags/\(id)") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            XCTAssertContent(Tag.Public.self, res) {
                XCTAssertEqual($0.id, id)
                XCTAssertNotEqual($0.id, 2)
                XCTAssertEqual($0.title, "Important")
            }
        }
    }
    
    func testIndexForFakeID() throws {
        try seed()
        try routes()
        
        let fakeId1 = 150
        try app.test(.GET, "/todos/1/tags/\(fakeId1)") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }
        
        let fakeId2 = "1a"
        try app.test(.GET, "/todos/1/tags/\(fakeId2)") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }
    }
}
