@testable import CRUDKit
import XCTVapor

final class CreateChildrenTests: ApplicationXCTestCase {
    func testCreateWithValidData() throws {
        try routes()
        try Todo.seed(on: app.db)

        try app.test(.GET, "/todos/1/tags/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.POST, "/todos/1/tags", body: Tag(title: "Foo", todo_id: 1)) { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)

            XCTAssertContent(Tag.Public.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.$todo.id, 1)
                XCTAssertEqual($0.title, "Foo")
            }
        }.test(.GET, "/todos/1/tags/1") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)

            XCTAssertContent(Tag.Public.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.$todo.id, 1)
                XCTAssertEqual($0.title, "Foo")
            }
        }
    }
    
    func testCreateWithValidDataButWithoutId() throws {
        struct PublicTag: Content {
            var title: String
        }
        
        try routes()
        try Todo.seed(on: app.db)

        try app.test(.GET, "/todos/1/tags/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.POST, "/todos/1/tags", body: PublicTag(title: "Foo")) { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)

            XCTAssertContent(Tag.Public.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.$todo.id, 1)
                XCTAssertEqual($0.title, "Foo")
            }
        }.test(.GET, "/todos/1/tags/1") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)

            XCTAssertContent(Tag.Public.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.$todo.id, 1)
                XCTAssertEqual($0.title, "Foo")
            }
        }
    }

    func testCreateWithoutData() throws {
        struct Empty: Content {}
        try Todo.seed(on: app.db)

        try routes()

        try app.test(.GET, "/todos/1/tags/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.POST, "/todos/1/tags", body: Empty()) { res in
            XCTAssertEqual(res.status, .badRequest)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.GET, "/todos/1/tags/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }
    }
}
