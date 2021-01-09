@testable import CRUDKit
import XCTVapor

final class CreateTests: ApplicationXCTestCase {
    func testCreateWithValidData() throws {
        try routes()

        try app.test(.GET, "/todos/1", afterResponse: { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }).test(.POST, "/todos", body: Todo(title: "Run tests")) { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)

            XCTAssertContent(Todo.Public.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Run tests")
                XCTAssertTrue($0.isPublic)
                XCTAssertEqual($0.tagCount, 0)
            }
        }.test(.GET, "/todos/1", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            
            XCTAssertContent(Todo.Public.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Run tests")
                XCTAssertTrue($0.isPublic)
                XCTAssertEqual($0.tagCount, 0)
            }
        })
    }
    
    func testCreateNonCreatableWithValidData() throws {
        try routes()

        try app.test(.GET, "/simpletodos/1", afterResponse: { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }).test(.POST, "/simpletodos", body: SimpleTodo(title: "Run tests")) { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)

            XCTAssertContent(SimpleTodo.Public.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Run tests")
            }
        }.test(.GET, "/simpletodos/1", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            
            XCTAssertContent(SimpleTodo.Public.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Run tests")
            }
        })
    }
    
    func testCreateWithoutData() throws {
        struct Empty: Content {}

        try routes()
        
        try app.test(.GET, "/todos/1", afterResponse: { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }).test(.POST, "/todos", body: Empty()) { res in
            XCTAssertEqual(res.status, .badRequest)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.GET, "/todos/1", afterResponse: { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        })
    }
    
    func testCreateWithInvalidData() throws {
        struct Empty: Content {}

        try routes()
        
        try app.test(.GET, "/todos/1", afterResponse: { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }).test(.POST, "/todos", body: Todo(title: "Sh")) { res in
            XCTAssertEqual(res.status, .badRequest)
            XCTAssertContains(res.body.string, "title is less than minimum of 3 character(s)")
            XCTAssertNotEqual(res.status, .ok)
        }.test(.GET, "/todos/1", afterResponse: { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        })
    }
}
