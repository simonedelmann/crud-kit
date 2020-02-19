import XCTVapor
import Vapor

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
}
