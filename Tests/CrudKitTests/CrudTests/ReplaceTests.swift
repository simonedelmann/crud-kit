@testable import CrudKit
import XCTVapor

final class ReplaceTests: ApplicationXCTestCase {
    func testReplaceForNonExistingObject() throws {
        try routes()
        
        try app.test(.PUT, "/todos/1", body: Todo(title: "Run tests")) { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }
    }
    
    func testReplaceNonReplaceableForNonExistingObject() throws {
        try routes()
        
        try app.test(.PUT, "/simpletodos/1", body: SimpleTodo(title: "Run tests")) { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }
    }
    
    func testReplaceWithValidData() throws {
        try routes()
        try seed()
        
        try app.test(.PUT, "/todos/1", body: Todo(title: "Run other tests")) { res in
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
    
    func testReplaceNonReplaceableWithValidData() throws {
        try routes()
        try seed()
        
        try app.test(.PUT, "/simpletodos/1", body: SimpleTodo(title: "Run other tests")) { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            
            XCTAssertContent(SimpleTodo.Public.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Run other tests")
            }
        }.test(.GET, "/simpletodos/1") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            
            XCTAssertContent(SimpleTodo.Public.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Run other tests")
            }
        }
    }
    
    func testReplaceWithInvalidData() throws {
        try routes()
        try seed()
        
        try app.test(.PUT, "/todos/1", body: Todo(title: "Ru")) { res in
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
}
