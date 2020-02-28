@testable import CrudAPI
import XCTVapor

final class CreateTests: ApplicationXCTestCase {
    func testCreateWithValidData() throws {
        try routes()

        try app.test(.GET, "/todos/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.POST, "/todos", json: Todo(title: "Run tests")) { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)

            XCTAssertContent(Todo.Public.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Run tests")
                XCTAssertTrue($0.isPublic)
            }
        }.test(.GET, "/todos/1") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            
            XCTAssertContent(Todo.Public.self, res) { 
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Run tests")
                XCTAssertTrue($0.isPublic)
            }
        }
    }
    
    func testCreateWithoutData() throws {
        struct Empty: Content {}

        try routes()
        
        try app.test(.GET, "/todos/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.POST, "/todos", json: Empty()) { res in
            XCTAssertEqual(res.status, .badRequest)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.GET, "/todos/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }
    }
    
    func testCreateWithInvalidData() throws {
        struct Empty: Content {}

        try routes()
        
        try app.test(.GET, "/todos/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.POST, "/todos", json: Todo(title: "Sh")) { res in
            XCTAssertEqual(res.status, .badRequest)
            XCTAssertContains(res.body.string, "title is less than minimum of 3 character(s)")
            XCTAssertNotEqual(res.status, .ok)
        }.test(.GET, "/todos/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }
    }

    static var allTests = [
        ("testCreateWithValidData", testCreateWithValidData),
        ("testCreateWithoutData", testCreateWithoutData),
        ("testCreateWithInvalidData", testCreateWithInvalidData),
    ]
}
