@testable import CRUDKit
import XCTVapor

final class PatchTests: ApplicationXCTestCase {
    func testPatchForNonExistingObject() throws {
        try routes()
        
        try app.test(.PATCH, "/todos/1", body: Todo(title: "Run tests")) { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }
    }

    func testPatchWithValidData() throws {
        try routes()
        try seed()
        
        try app.test(.PATCH, "/todos/1", body: Todo(title: "Run other tests")) { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            
            XCTAssertContent(Todo.Public.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Run other tests")
                XCTAssertTrue($0.isPublic)
                XCTAssertEqual($0.tagCount, 1)
            }
        }.test(.GET, "/todos/1", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            
            XCTAssertContent(Todo.Public.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Run other tests")
                XCTAssertTrue($0.isPublic)
                XCTAssertEqual($0.tagCount, 1)
            }
        })
    }
    
    func testPatchWithInvalidData() throws {
        try routes()
        try seed()
        
        try app.test(.PATCH, "/todos/1", body: Todo(title: "Ru")) { res in
            XCTAssertEqual(res.status, .badRequest)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.GET, "/todos/1", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            
            XCTAssertContent(Todo.Public.self, res) {
                XCTAssertEqual($0.id, 1)
                XCTAssertNotEqual($0.id, 2)
                XCTAssertEqual($0.title, "Wash clothes")
                XCTAssertTrue($0.isPublic)
                XCTAssertEqual($0.tagCount, 1)
            }
        })
    }
}
