@testable import CrudKit
import XCTVapor

final class ReplaceChildrenTests: ApplicationXCTestCase {
    func testReplaceForNonExistingObject() throws {
        try routes()
        try Todo.seed(on: app.db)
        
        try app.test(.PUT, "/todos/1/tags/1", body: Tag(title: "Foo", todo_id: 1)) { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }
    }
    
    func testReplaceWithValidData() throws {
        struct ReplaceTag: Content {
            var title: String
        }
        
        try routes()
        try seed()
        
        try app.test(.PUT, "/todos/1/tags/1", body: ReplaceTag(title: "Foo")) { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            
            XCTAssertContent(Tag.Public.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Foo")
            }
        }.test(.GET, "/todos/1/tags/1") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            
            XCTAssertContent(Tag.Public.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Foo")
            }
        }
    }
}
