@testable import CRUDKit
import XCTVapor

final class PatchChildrenTests: ApplicationXCTestCase {
    func testPatchForNonExistingObject() throws {
        try routes()
        try Todo.seed(on: app.db)

        try app.test(.PATCH, "/todos/1/tags/1", body: Tag(title: "Run tests", todo_id: 1)) { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }
    }

    func testPatchWithValidData() throws {
        struct PatchTag: Content {
            var title: String
        }

        try routes()
        try seed()

        try app.test(.PATCH, "/todos/1/tags/1", body: PatchTag(title: "Foo")) { res in
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
