@testable import CrudAPI
import XCTVapor
import Vapor
import Fluent
import FluentSQLiteDriver

class ApplicationXCTestCase: XCTestCase {
    var app: Application!
    
    override func setUp() {
        app = Application(.testing)
        
        // Setup database
        app.databases.use(.sqlite(.memory), as: .sqlite)
        app.migrations.add(Todo.migration())
        try! app.autoMigrate().wait()
    }

    override func tearDown() {
        app.shutdown()
    }
    
    func seed() throws {
        try Todo.seed(on: app.db)
    }
    
    func routes() throws {
        app.group("todos") { routes in
            routes.crud(model: Todo.self)
        }
        app.group("simpletodos") { routes in
            routes.crud(model: SimpleTodo.self)
        }
    }
}
