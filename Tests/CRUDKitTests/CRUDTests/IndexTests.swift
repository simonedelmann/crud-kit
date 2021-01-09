@testable import CRUDKit
import XCTVapor

final class IndexTests: ApplicationXCTestCase {
    func testIndexWithoutID() throws {
        try routes()
        
        try app.test(.GET, "/todos/", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            // By design fallback to IndexAll
        })
    }
    
    func testIndexForGivenID() throws {
        try seed()
        try routes()

        let id = 1
        try app.test(.GET, "/todos/\(id)", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            XCTAssertContent(Todo.Public.self, res) {
                XCTAssertEqual($0.id, id)
                XCTAssertNotEqual($0.id, 2)
                XCTAssertEqual($0.title, "Wash clothes")
                XCTAssertTrue($0.isPublic)
                XCTAssertEqual($0.tagCount, 1)
            }
        })
    }
    
    func testIndexForFakeID() throws {
        try seed()
        try routes()
        
        let fakeId1 = 150
        try app.test(.GET, "/todos/\(fakeId1)", afterResponse: { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        })
        
        let fakeId2 = "1a"
        try app.test(.GET, "/todos/\(fakeId2)", afterResponse: { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        })
    }
}
