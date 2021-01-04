@testable import CRUDKit
import XCTVapor

final class DeleteChildrenTests: ApplicationXCTestCase {
    func testDeleteWithValidId() throws {
        try routes()
        try seed()

        try app.test(.GET, "/todos/1/tags/1", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            XCTAssertContent(Tag.Public.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
            }
        }).test(.DELETE, "/todos/1/tags/1", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
        }).test(.GET, "/todos/1/tags/1", afterResponse: { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        })
    }
    
    func testDeleteWithInvalidId() throws {
        try routes()
        try seed()

        try app.test(.GET, "/todos/1/tags", afterResponse: { res in
            XCTAssertContent([Tag.Public].self, res) {
                XCTAssertEqual($0.count, 1)
            }
        }).test(.DELETE, "/todos/1/tags/10", afterResponse: { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }).test(.GET, "/todos/1/tags", afterResponse: { res in
            XCTAssertContent([Tag.Public].self, res) {
                XCTAssertEqual($0.count, 1)
            }
        })
    }
    
    func testDeleteWithInvalidParentId() throws {
        try routes()
        try seed()

        try app.test(.GET, "/todos/1/tags", afterResponse: { res in
            XCTAssertContent([Tag.Public].self, res) {
                XCTAssertEqual($0.count, 1)
            }
        }).test(.DELETE, "/todos/2/tags/10", afterResponse: { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }).test(.GET, "/todos/1/tags", afterResponse: { res in
            XCTAssertContent([Tag.Public].self, res) {
                XCTAssertEqual($0.count, 1)
            }
        })
    }
}
