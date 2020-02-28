@testable import CrudAPI
import XCTVapor

final class ReplaceTests: ApplicationXCTestCase {
    func testReplaceForNonExistingObject() throws {
        try routes()
        
        try app.test(.PUT, "/todos/1", json: Todo(title: "Run tests")) { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }
    }
    
    func testReplaceWithValidData() throws {
        try routes()
        try seed()
        
        try app.test(.PUT, "/todos/1", json: Todo(title: "Run other tests")) { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            
            XCTAssertContent(Todo.Public.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Run other tests")
                XCTAssertTrue($0.isPublic)
            }
        }.test(.GET, "/todos/1") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            
            XCTAssertContent(Todo.Public.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Run other tests")
                XCTAssertTrue($0.isPublic)
            }
        }
    }
    
    func testReplaceWithInvalidData() throws {
        try routes()
        try seed()
        
        try app.test(.PUT, "/todos/1", json: Todo(title: "Ru")) { res in
            XCTAssertEqual(res.status, .badRequest)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.GET, "/todos/1") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            
            XCTAssertContent(Todo.Public.self, res) {
                XCTAssertEqual($0.id, 1)
                XCTAssertNotEqual($0.id, 2)
                XCTAssertEqual($0.title, "Wash clothes")
                XCTAssertTrue($0.isPublic)
            }
        }
    }
    
    static var allTests = [
        ("testReplaceForNonExistingObject", testReplaceForNonExistingObject),
        ("testReplaceWithValidData", testReplaceWithValidData),
        ("testReplaceWithInvalidData", testReplaceWithInvalidData),
    ]
}
